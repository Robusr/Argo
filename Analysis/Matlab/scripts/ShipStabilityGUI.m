function ShipStabilityGUI()
    % --- 创建主界面 ---
    fig = uifigure('Name', '船模定量设计与稳性分析 GUI (3D版)', 'Position', [50, 50, 1200, 750]);
    
    % 主布局: 2x3 网格
    gl = uigridlayout(fig, [2, 3]);
    gl.ColumnWidth = {280, '1x', '1x'};
    gl.RowHeight = {'1x', '1.2x'}; 
    
    % --- 1. 左侧输入面板 ---
    pnlInput = uipanel(gl, 'Title', '设计参数输入');
    pnlInput.Layout.Row = [1 2]; 
    pnlInput.Layout.Column = 1;
    
    glInput = uigridlayout(pnlInput, [10, 2]);
    glInput.RowHeight = repmat({30}, 1, 10);
    
    % 输入控件创建辅助函数
    function ef = createInput(labelStr, defaultVal, row)
        lbl = uilabel(glInput, 'Text', labelStr);
        lbl.Layout.Row = row; lbl.Layout.Column = 1;
        
        ef = uieditfield(glInput, 'numeric', 'Value', defaultVal);
        ef.Layout.Row = row; ef.Layout.Column = 2;
    end

    % 默认参数已更新为一组较优解
    ef_L = createInput('船长 L (m):', 0.4, 1);
    ef_B = createInput('最大船宽 B (m):', 0.24, 2);
    ef_D = createInput('型深 D (m):', 0.15, 3);
    ef_n = createInput('底型参数 n:', 3.5, 4);
    ef_mHull = createInput('船体质量 (kg):', 0.2, 5);
    ef_mLoad = createInput('载重质量 (kg):', 0.8, 6);
    ef_kgLoad = createInput('载重重心高 (m):', 0.045, 7);
    
    % 桅杆说明
    lblMast = uilabel(glInput, 'Text', '桅杆: 铝合金 Φ10x500mm (内嵌至船底)');
    lblMast.Layout.Row = 8; lblMast.Layout.Column = [1 2];
    
    btnCalc = uibutton(glInput, 'Text', '开始三维计算', 'ButtonPushedFcn', @(btn,event) computeStability());
    btnCalc.Layout.Row = 9; btnCalc.Layout.Column = [1 2];
    
    % 状态与结果展示标签
    lblRes = uilabel(glInput, 'Text', '等待计算...', 'WordWrap', 'on');
    lblRes.Layout.Row = 10; lblRes.Layout.Column = [1 2];
    
    % --- 2. 图像面板 ---
    axProfile = uiaxes(gl);
    axProfile.Layout.Row = 1; axProfile.Layout.Column = 2;
    title(axProfile, '舯部横剖面 (x=0)');
    xlabel(axProfile, 'y (m)'); ylabel(axProfile, 'z (m)');
    grid(axProfile, 'on'); hold(axProfile, 'on');
    
    axGZ = uiaxes(gl);
    axGZ.Layout.Row = 1; axGZ.Layout.Column = 3;
    title(axGZ, '静稳性曲线 GZ(\theta)');
    xlabel(axGZ, '横倾角 \theta (度)'); ylabel(axGZ, 'GZ (m)');
    grid(axGZ, 'on'); hold(axGZ, 'on');
    
    ax3D = uiaxes(gl);
    ax3D.Layout.Row = 2; ax3D.Layout.Column = [2 3];
    title(ax3D, '三维船体与水线面模拟');
    xlabel(ax3D, 'x (m)'); ylabel(ax3D, 'y (m)'); zlabel(ax3D, 'z (m)');
    grid(ax3D, 'on'); hold(ax3D, 'on');
    
    drawnow;
    computeStability();
    
    % --- 核心三维计算函数 ---
    function computeStability()
        try
            lblRes.Text = '正在生成 3D 网格并计算...';
            drawnow;
            
            L = ef_L.Value; B = ef_B.Value; D = ef_D.Value; n = ef_n.Value;
            m_hull = ef_mHull.Value; m_load = ef_mLoad.Value; kg_load = ef_kgLoad.Value;
            
            % 1. 桅杆计算
            rho_al = 2700; r_mast = 0.005; L_mast = 0.500;
            v_mast = pi * r_mast^2 * L_mast;
            m_mast = rho_al * v_mast; 
            % 【修改点1】桅杆从船底 z=0 开始，因此重心高度是长度的一半
            kg_mast = L_mast / 2; 
            
            % 2. 3D 离散化体素网格构建
            NX = 80; NY = 80; NZ = 60;
            x_vec = linspace(-L/2, L/2, NX);
            y_vec = linspace(-B/2, B/2, NY);
            z_vec = linspace(0, D, NZ);
            dx = x_vec(2)-x_vec(1); dy = y_vec(2)-y_vec(1); dz = z_vec(2)-z_vec(1);
            dV = dx * dy * dz;
            [X, Y, Z] = ndgrid(x_vec, y_vec, z_vec);
            
            % 真实船体形状约束
            B_local = (B/2) * (1 - (2*X/L).^2); 
            B_local(B_local < 1e-5) = 1e-5; 
            
            hull_logic = (Z >= D .* abs(Y ./ B_local).^n) & (Z <= D) & (abs(Y) <= B_local);
            
            Hx = X(hull_logic); Hy = Y(hull_logic); Hz = Z(hull_logic);
            V_hull_total = length(Hx) * dV;
            
            kg_hull = mean(Hz);
            
            % 3. 总质量与重心
            M_total = m_hull + m_load + m_mast;
            KG = (m_hull * kg_hull + m_load * kg_load + m_mast * kg_mast) / M_total;
            
            rho_water = 1000;
            V_target = M_total / rho_water;
            
            if V_target > V_hull_total
                lblRes.Text = '警告: 排水量超过船体总容积，船模沉没！';
                lblRes.FontColor = 'red';
                cla(axProfile); cla(axGZ); cla(ax3D);
                return;
            end
            
            % 4. 计算各个倾角下的 GZ
            thetas = 0:2:180;
            GZ = zeros(size(thetas));
            yB_0 = 0; zB_0 = 0; d_0 = 0;
            
            target_idx = round(V_target / dV);
            if target_idx < 1, target_idx = 1; end
            
            for i = 1:length(thetas)
                th = thetas(i);
                D_vals = -Hy * sind(th) + Hz * cosd(th);
                [sorted_D, sort_idx] = sort(D_vals);
                
                if target_idx > length(sort_idx), target_idx = length(sort_idx); end
                sub_idx = sort_idx(1:target_idx);
                
                y_B = mean(Hy(sub_idx));
                z_B = mean(Hz(sub_idx));
                
                if th == 0
                    yB_0 = y_B; zB_0 = z_B; 
                    d_0 = sorted_D(target_idx); 
                end
                
                GZ(i) = y_B * cosd(th) + (z_B - KG) * sind(th);
            end
            
            % 5. 初始稳性高 GM 计算
            KB = zB_0;
            B_water_x = (B/2) * (1 - (2*x_vec/L).^2) * (d_0/D)^(1/n);
            I_T = trapz(x_vec, (2/3) * B_water_x.^3); 
            BM = I_T / V_target;
            GM = KB + BM - KG;
            
            % 6. 消失角与最大恢复力矩
            RM = GZ * M_total * 9.81; % N·m
            max_RM = max(RM);
            
            peak_idx = find(GZ == max(GZ), 1);
            cross_idx = find(GZ(peak_idx:end) < 0, 1) + peak_idx - 1;
            
            if isempty(cross_idx)
                AVS = 180;
            else
                AVS = interp1([GZ(cross_idx-1), GZ(cross_idx)], ...
                              [thetas(cross_idx-1), thetas(cross_idx)], 0);
            end
            
            avs_ok = (AVS >= 120 && AVS <= 140);
            rm_ok = (max_RM >= 0.2);
            gm_ok = (GM > 0); % 判断正浮稳定性
            
            if avs_ok; str_avs = '合格'; else; str_avs = '不合格'; end
            if rm_ok;  str_rm  = '合格'; else; str_rm  = '不合格'; end
            if gm_ok;  str_gm  = '稳定'; else; str_gm  = '倾覆危险'; end
            
            resStr = sprintf(['[状态报告]\n' ...
                              '总质量: %.3f kg\n' ...
                              '初稳心高 GM = %.3f m (%s)\n' ...
                              '消失角 AVS = %.1f° (%s)\n' ...
                              '最大恢复力矩 = %.3f N·m (%s)'], ...
                              M_total, GM, str_gm, ...
                              AVS, str_avs, max_RM, str_rm);
                          
            lblRes.Text = resStr;
            if avs_ok && rm_ok && gm_ok; lblRes.FontColor = [0, 0.5, 0]; else; lblRes.FontColor = 'red'; end
            
            % --- 7. 更新图表 ---
            cla(axProfile);
            y_c = linspace(-B/2, B/2, 200);
            z_c = D * abs(y_c / (B/2)).^n;
            plot(axProfile, y_c, z_c, 'k', 'LineWidth', 2); 
            plot(axProfile, [-B/2, B/2], [D, D], 'k', 'LineWidth', 2); 
            
            plot(axProfile, [-B/2, B/2], [d_0, d_0], 'b--', 'LineWidth', 1.5);
            fill(axProfile, [y_c(z_c <= d_0), fliplr(y_c(z_c <= d_0))], ...
                 [z_c(z_c <= d_0), repmat(d_0, 1, sum(z_c <= d_0))], ...
                 'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
                 
            plot(axProfile, 0, KG, 'ro', 'MarkerFaceColor', 'r');
            text(axProfile, 0.01, KG, 'G', 'Color', 'r', 'FontWeight', 'bold');
            plot(axProfile, 0, KB, 'bo', 'MarkerFaceColor', 'b');
            text(axProfile, 0.01, KB, 'B', 'Color', 'b', 'FontWeight', 'bold');
            
            % 【修改点2】剖面图中的桅杆从船底 z=0 画起
            plot(axProfile, [0, 0], [0, L_mast], 'Color', [0.5 0.5 0.5], 'LineWidth', 4); 
            axis(axProfile, 'equal');
            ylim(axProfile, [-0.02, D+0.6]);
            
            cla(axGZ);
            patch(axGZ, [120 140 140 120], [-10 -10 max(GZ)*1.5 max(GZ)*1.5], ...
                  'g', 'FaceAlpha', 0.15, 'EdgeColor', 'none');
            plot(axGZ, thetas, GZ, 'b', 'LineWidth', 2);
            plot(axGZ, [0 180], [0 0], 'k--');
            plot(axGZ, AVS, 0, 'rx', 'MarkerSize', 10, 'LineWidth', 2);
            text(axGZ, AVS-10, max(GZ)*0.1, sprintf('AVS=%.1f°', AVS), 'Color', 'r');
            xlim(axGZ, [0 180]);
            ylim(axGZ, [min(GZ)*1.1 - 0.01, max(GZ)*1.2 + 0.01]);
            
            cla(ax3D);
            [X_surf, Z_surf] = meshgrid(linspace(-L/2, L/2, 60), linspace(0, D, 30));
            B_surf = (B/2) * (1 - (2*X_surf/L).^2);
            Y_surf = B_surf .* (Z_surf / D).^(1/n);
            
            surf(ax3D, X_surf, Y_surf, Z_surf, 'FaceColor', [0.8 0.6 0.2], 'EdgeColor', 'none', 'FaceAlpha', 0.7);
            surf(ax3D, X_surf, -Y_surf, Z_surf, 'FaceColor', [0.8 0.6 0.2], 'EdgeColor', 'none', 'FaceAlpha', 0.7);
            surf(ax3D, X_surf, Y_surf, D*ones(size(Z_surf)), 'FaceColor', [0.6 0.4 0.1], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
            surf(ax3D, X_surf, -Y_surf, D*ones(size(Z_surf)), 'FaceColor', [0.6 0.4 0.1], 'EdgeColor', 'none', 'FaceAlpha', 0.5);
            
            [X_w, Y_w] = meshgrid(linspace(-L/2*1.2, L/2*1.2, 2), linspace(-B/2*1.5, B/2*1.5, 2));
            Z_w = d_0 * ones(size(X_w));
            surf(ax3D, X_w, Y_w, Z_w, 'FaceColor', 'b', 'EdgeColor', 'none', 'FaceAlpha', 0.3);
            
            % 【修改点3】3D图中的桅杆从船底 z=0 画起
            plot3(ax3D, [0, 0], [0, 0], [0, L_mast], 'k', 'LineWidth', 3);
            
            axis(ax3D, 'equal');
            view(ax3D, 35, 25);
            camlight(ax3D, 'headlight');
            lighting(ax3D, 'gouraud');
            
        catch ME
            lblRes.Text = ['计算错误: ', ME.message];
            lblRes.FontColor = 'red';
        end
    end
end