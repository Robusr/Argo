function ship_stability_gui_fixed
    % ===== 创建窗口 =====
    fig = figure('Name', '船舶稳性设计工具 - 数值计算版', ...
                 'NumberTitle', 'off', ...
                 'Position', [50, 50, 1300, 750], ...
                 'MenuBar', 'none', 'ToolBar', 'none');
    
    % ===== 左侧参数面板 =====
    left_panel = uipanel('Parent', fig, 'Title', '设计参数', ...
                         'FontSize', 12, 'Position', [0.02, 0.02, 0.28, 0.96]);
    
    base_y = 680;
    step = 38;
    y_pos = base_y;
    
    % --- 船体尺寸参数 ---
    uicontrol('Parent', left_panel, 'Style', 'text', 'String', '【船体尺寸参数】', ...
              'FontWeight', 'bold', 'FontSize', 11, ...
              'Position', [10, y_pos, 140, 25], 'HorizontalAlignment', 'left');
    y_pos = y_pos - step;
    
    uicontrol('Parent', left_panel, 'Style', 'text', 'String', '船长 L (m):', ...
              'Position', [10, y_pos, 80, 25], 'HorizontalAlignment', 'left');
    L_edit = uicontrol('Parent', left_panel, 'Style', 'edit', 'String', '0.50', ...
                       'Position', [100, y_pos, 80, 25]);
    y_pos = y_pos - step;
    
    uicontrol('Parent', left_panel, 'Style', 'text', 'String', '船宽 B (m):', ...
              'Position', [10, y_pos, 80, 25], 'HorizontalAlignment', 'left');
    B_edit = uicontrol('Parent', left_panel, 'Style', 'edit', 'String', '0.22', ...
                       'Position', [100, y_pos, 80, 25]);
    y_pos = y_pos - step;
    
    uicontrol('Parent', left_panel, 'Style', 'text', 'String', '型深 D (m):', ...
              'Position', [10, y_pos, 80, 25], 'HorizontalAlignment', 'left');
    D_edit = uicontrol('Parent', left_panel, 'Style', 'edit', 'String', '0.08', ...
                       'Position', [100, y_pos, 80, 25]);
    y_pos = y_pos - step;
    
    uicontrol('Parent', left_panel, 'Style', 'text', 'String', '形状参数 n:', ...
              'Position', [10, y_pos, 80, 25], 'HorizontalAlignment', 'left');
    n_edit = uicontrol('Parent', left_panel, 'Style', 'edit', 'String', '2.0', ...
                       'Position', [100, y_pos, 80, 25]);
    y_pos = y_pos - step*2;
    
    % --- 重量参数 ---
    uicontrol('Parent', left_panel, 'Style', 'text', 'String', '【重量参数】', ...
              'FontWeight', 'bold', 'FontSize', 11, ...
              'Position', [10, y_pos, 140, 25], 'HorizontalAlignment', 'left');
    y_pos = y_pos - step;
    
    uicontrol('Parent', left_panel, 'Style', 'text', 'String', '船体质量 (kg):', ...
              'Position', [10, y_pos, 90, 25], 'HorizontalAlignment', 'left');
    m_hull_edit = uicontrol('Parent', left_panel, 'Style', 'edit', 'String', '0.30', ...
                            'Position', [110, y_pos, 70, 25]);
    y_pos = y_pos - step;
    
    uicontrol('Parent', left_panel, 'Style', 'text', 'String', '载重质量 (kg):', ...
              'Position', [10, y_pos, 90, 25], 'HorizontalAlignment', 'left');
    m_cargo_edit = uicontrol('Parent', left_panel, 'Style', 'edit', 'String', '0.85', ...
                             'Position', [110, y_pos, 70, 25]);
    y_pos = y_pos - step;
    
    uicontrol('Parent', left_panel, 'Style', 'text', 'String', '载重重心高 (m):', ...
              'Position', [10, y_pos, 100, 25], 'HorizontalAlignment', 'left');
    KG_cargo_edit = uicontrol('Parent', left_panel, 'Style', 'edit', 'String', '0.015', ...
                              'Position', [120, y_pos, 60, 25]);
    y_pos = y_pos - step*2;
    
    % --- 桅杆（固定）---
    uicontrol('Parent', left_panel, 'Style', 'text', 'String', '【桅杆（铝合金）】', ...
              'FontWeight', 'bold', 'FontSize', 11, ...
              'Position', [10, y_pos, 140, 25], 'HorizontalAlignment', 'left');
    y_pos = y_pos - step;
    
    uicontrol('Parent', left_panel, 'Style', 'text', 'String', '直径 10mm, 长 500mm', ...
              'FontSize', 10, 'ForegroundColor', [0.2,0.2,0.8], ...
              'Position', [10, y_pos, 160, 25], 'HorizontalAlignment', 'left');
    y_pos = y_pos - step;
    
    mast_mass_disp = uicontrol('Parent', left_panel, 'Style', 'text', 'String', '质量 = 0.106 kg', ...
                               'FontSize', 10, 'ForegroundColor', [0.2,0.2,0.8], ...
                               'Position', [10, y_pos, 120, 25], 'HorizontalAlignment', 'left');
    y_pos = y_pos - step*2;
    
    % --- 设计目标 ---
    uicontrol('Parent', left_panel, 'Style', 'text', 'String', '【设计目标】', ...
              'FontWeight', 'bold', 'FontSize', 11, ...
              'Position', [10, y_pos, 100, 25], 'HorizontalAlignment', 'left');
    y_pos = y_pos - step;
    
    uicontrol('Parent', left_panel, 'Style', 'text', 'String', '稳性消失角: 120° ~ 140°', ...
              'FontSize', 10, 'ForegroundColor', [0,0.6,0], ...
              'Position', [10, y_pos, 180, 25], 'HorizontalAlignment', 'left');
    y_pos = y_pos - step;
    
    uicontrol('Parent', left_panel, 'Style', 'text', 'String', '最大恢复力矩: ≥ 0.2 N·m', ...
              'FontSize', 10, 'ForegroundColor', [0,0.6,0], ...
              'Position', [10, y_pos, 180, 25], 'HorizontalAlignment', 'left');
    y_pos = y_pos - step*2;
    
    % --- 计算结果 ---
    uicontrol('Parent', left_panel, 'Style', 'text', 'String', '【计算结果】', ...
              'FontWeight', 'bold', 'FontSize', 12, ...
              'Position', [10, y_pos, 100, 30], 'HorizontalAlignment', 'left');
    y_pos = y_pos - step;
    
    KB_label = uicontrol('Parent', left_panel, 'Style', 'text', 'String', 'KB = -- mm', ...
                         'FontSize', 11, ...
                         'Position', [10, y_pos, 150, 25], 'HorizontalAlignment', 'left');
    y_pos = y_pos - step;
    
    KG_label = uicontrol('Parent', left_panel, 'Style', 'text', 'String', 'KG = -- mm', ...
                         'FontSize', 11, ...
                         'Position', [10, y_pos, 150, 25], 'HorizontalAlignment', 'left');
    y_pos = y_pos - step;
    
    GM_label = uicontrol('Parent', left_panel, 'Style', 'text', 'String', 'GM = -- mm', ...
                         'FontSize', 12, 'FontWeight', 'bold', ...
                         'Position', [10, y_pos, 200, 30], 'HorizontalAlignment', 'left');
    y_pos = y_pos - step;
    
    vanishing_label = uicontrol('Parent', left_panel, 'Style', 'text', 'String', '消失角 = -- °', ...
                                'FontSize', 12, 'FontWeight', 'bold', ...
                                'Position', [10, y_pos, 200, 30], 'HorizontalAlignment', 'left');
    y_pos = y_pos - step;
    
    MR_label = uicontrol('Parent', left_panel, 'Style', 'text', 'String', '最大恢复力矩 = -- Nm', ...
                         'FontSize', 12, 'FontWeight', 'bold', ...
                         'Position', [10, y_pos, 230, 30], 'HorizontalAlignment', 'left');
    y_pos = y_pos - step;
    
    status_label = uicontrol('Parent', left_panel, 'Style', 'text', 'String', '', ...
                             'FontSize', 13, 'FontWeight', 'bold', ...
                             'Position', [10, y_pos, 250, 40], 'HorizontalAlignment', 'left');
    
    % 重新计算按钮
    uicontrol('Parent', left_panel, 'Style', 'pushbutton', 'String', '重新计算', ...
              'FontSize', 11, 'FontWeight', 'bold', ...
              'BackgroundColor', [0.8,0.8,1], ...
              'Position', [80, 15, 100, 35], ...
              'Callback', @update_display);
    
    % ===== 右侧：船体形状图 + 稳性曲线图 =====
    ax_shape = axes('Parent', fig, 'Position', [0.33, 0.55, 0.30, 0.40]);
    title(ax_shape, '船体横剖面形状');
    xlabel(ax_shape, '半宽 y (m)'); ylabel(ax_shape, '深度 z (m)');
    grid(ax_shape, 'on'); hold(ax_shape, 'on');
    axis(ax_shape, 'equal');
    
    ax_stability = axes('Parent', fig, 'Position', [0.33, 0.08, 0.64, 0.42]);
    title(ax_stability, '静稳性曲线 GZ(θ)');
    xlabel(ax_stability, '横倾角 θ (度)');
    ylabel(ax_stability, '复原力臂 GZ (mm)');
    grid(ax_stability, 'on'); hold(ax_stability, 'on');
    xlim(ax_stability, [0, 160]);
    
    % ===== 桅杆质量计算 =====
    function mast_mass = calc_mast_mass()
        density_al = 2700;
        length = 0.5;
        diameter = 0.01;
        radius = diameter / 2;
        volume = pi * radius^2 * length;
        mast_mass = density_al * volume;
    end
    
    % ===== 核心：基于课程方法的稳性计算 =====
    function [vanishing_angle, MR_max, GM, KB, KG, GZ_curve, theta_curve] = compute_stability(L, B, D, n, m_hull, m_cargo, KG_cargo)
        % 固定参数
        HB = B / 2;
        m_mast = calc_mast_mass();
        KG_mast = 0.27;
        KG_hull = D / 2;  % 均匀船体，重心在型深一半
        
        % 总质量和总重心
        total_mass = m_hull + m_mast + m_cargo;
        KG = (m_hull*KG_hull + m_mast*KG_mast + m_cargo*KG_cargo) / total_mass;
        
        % ===== 建立网格 =====
        dy = 0.0005;
        dz = 0.0005;
        ys = -HB:dy:HB;
        zs = 0:dz:D;
        [Y, Z] = meshgrid(ys, zs);
        
        % ===== 船体形状逻辑矩阵 =====
        z_hull = D * abs(ys/HB).^n;
        hull = false(size(Z));
        for i = 1:length(ys)
            hull(:, i) = Z(:, i) <= z_hull(i);
        end
        
        % 面积和体积
        cell_area = dy * dz;
        total_area_hull = sum(hull(:)) * cell_area;
        submerged_volume = total_area_hull * L;
        
        % ===== 浮心 KB（正浮时）=====
        KB = sum(hull(:) .* Z(:)) / sum(hull(:));
        
        % ===== 横稳心半径 BM =====
        Ix = L * B^3 / 12;
        BM = Ix / submerged_volume;
        
        % ===== 初稳性高度 GM =====
        KM = KB + BM;
        GM = KM - KG;
        
        % ===== 不同倾斜角下的 GZ =====
        theta_range = 0:2:150;
        GZ = zeros(size(theta_range));
        COB_hist = zeros(length(theta_range), 2);
        
        for idx = 1:length(theta_range)
            theta = theta_range(idx);
            theta_rad = deg2rad(theta);
            
            % 水线方程（倾斜时，吃水保持不变）
            % 假设干舷足够，水线绕船宽中心旋转
            water_z = KB + tan(theta_rad) * Y;
            water = Z < water_z;
            
            % 水下部分 = 船体 ∩ 水
            submerged = hull & water;
            total_cells = sum(submerged(:));
            
            if total_cells == 0
                GZ(idx) = 0;
                COB_hist(idx, :) = [0, 0];
                continue;
            end
            
            % 浮心 COB（当前倾斜角）
            COB_y = sum(submerged(:) .* Y(:)) / total_cells;
            COB_z = sum(submerged(:) .* Z(:)) / total_cells;
            COB_hist(idx, :) = [COB_y, COB_z];
            
            % 复原力臂 GZ = 重心到浮力作用线的水平距离
            % 浮力作用线通过 COB，垂直于水线
            GZ(idx) = abs(COB_y) * cos(theta_rad) + (KG - COB_z) * sin(theta_rad);
            GZ(idx) = max(GZ(idx), 0);
        end
        
        % ===== 寻找稳性消失角 =====
        % 消失角定义为 GZ < 0.5mm 后的角度
        vanishing_angle = 150;
        for idx = 2:length(GZ)
            if GZ(idx) <= 0.0005 && GZ(idx-1) > 0.0005
                vanishing_angle = theta_range(idx);
                break;
            end
            % 如果 GZ 持续大于 0，取 GZ 开始明显下降的点
            if idx > 10 && GZ(idx) < max(GZ)*0.1 && vanishing_angle == 150
                vanishing_angle = theta_range(idx);
            end
        end
        
        % 最大恢复力矩
        MR_max = total_mass * 9.8 * max(GZ);
        
        % 输出
        GZ_curve = GZ;
        theta_curve = theta_range;
    end
    
    % ===== 更新显示 =====
    function update_display(~, ~)
        % 读取参数
        L = str2double(get(L_edit, 'String'));
        B = str2double(get(B_edit, 'String'));
        D = str2double(get(D_edit, 'String'));
        n = str2double(get(n_edit, 'String'));
        m_hull = str2double(get(m_hull_edit, 'String'));
        m_cargo = str2double(get(m_cargo_edit, 'String'));
        KG_cargo = str2double(get(KG_cargo_edit, 'String'));
        
        % 参数有效性检查
        if isnan(L) || L <= 0; L = 0.5; set(L_edit, 'String', '0.50'); end
        if isnan(B) || B <= 0; B = 0.22; set(B_edit, 'String', '0.22'); end
        if isnan(D) || D <= 0; D = 0.08; set(D_edit, 'String', '0.08'); end
        if isnan(n) || n <= 0; n = 2.0; set(n_edit, 'String', '2.0'); end
        if isnan(m_hull) || m_hull <= 0; m_hull = 0.30; set(m_hull_edit, 'String', '0.30'); end
        if isnan(m_cargo) || m_cargo <= 0; m_cargo = 0.85; set(m_cargo_edit, 'String', '0.85'); end
        if isnan(KG_cargo) || KG_cargo <= 0; KG_cargo = 0.015; set(KG_cargo_edit, 'String', '0.015'); end
        
        % 计算稳性
        [vanishing_angle, MR_max, GM, KB, KG, GZ, theta_deg] = ...
            compute_stability(L, B, D, n, m_hull, m_cargo, KG_cargo);
        
        % 更新显示
        set(KB_label, 'String', sprintf('KB = %.1f mm', KB * 1000));
        set(KG_label, 'String', sprintf('KG = %.1f mm', KG * 1000));
        set(GM_label, 'String', sprintf('GM = %.1f mm', GM * 1000));
        set(vanishing_label, 'String', sprintf('消失角 = %.0f °', vanishing_angle));
        set(MR_label, 'String', sprintf('最大恢复力矩 = %.3f N·m', MR_max));
        
        % 达标判断
        if vanishing_angle >= 120 && vanishing_angle <= 140 && MR_max >= 0.2 && GM > 0
            set(status_label, 'String', '??? 满足设计要求 ???', 'ForegroundColor', [0,0.6,0]);
        else
            reason = '';
            if vanishing_angle < 120
                reason = '消失角过小';
            elseif vanishing_angle > 140
                reason = '消失角过大';
            elseif MR_max < 0.2
                reason = '恢复力矩不足';
            elseif GM <= 0
                reason = 'GM为负';
            end
            set(status_label, 'String', sprintf('??? 不满足: %s ???', reason), 'ForegroundColor', [0.8,0,0]);
        end
        
        % ===== 绘制船体形状 =====
        cla(ax_shape);
        HB = B/2;
        ys_shape = linspace(-HB, HB, 200);
        z_shape = D * abs(ys_shape/HB).^n;
        fill(ax_shape, [ys_shape, fliplr(ys_shape)], [z_shape, zeros(size(z_shape))], ...
             [0.6, 0.8, 1], 'EdgeColor', 'b', 'LineWidth', 1.5);
        plot(ax_shape, ys_shape, z_shape, 'b-', 'LineWidth', 2);
        plot(ax_shape, [-HB, HB], [0, 0], 'k--');
        
        % 标注重心和浮心
        line(ax_shape, [0, 0], [0, KG], 'Color', 'r', 'LineWidth', 2, 'Marker', 'o', 'MarkerFaceColor', 'r');
        line(ax_shape, [0, 0], [0, KB], 'Color', 'g', 'LineWidth', 2, 'Marker', 'o', 'MarkerFaceColor', 'g');
        
        xlim(ax_shape, [-HB*1.1, HB*1.1]);
        ylim(ax_shape, [0, D*1.1]);
        xlabel(ax_shape, '半宽 y (m)');
        ylabel(ax_shape, '深度 z (m)');
        title(ax_shape, sprintf('船体横剖面 (n=%.1f), KG=%.0fmm, KB=%.0fmm', n, KG*1000, KB*1000));
        legend(ax_shape, {'船体', 'KG', 'KB'}, 'Location', 'best');
        grid(ax_shape, 'on');
        axis(ax_shape, 'equal');
        
        % ===== 绘制稳性曲线 =====
        cla(ax_stability);
        plot(ax_stability, theta_deg, GZ*1000, 'b-', 'LineWidth', 2);
        hold(ax_stability, 'on');
        
        % 消失点
        v_idx = find(theta_deg >= vanishing_angle, 1);
        if ~isempty(v_idx) && vanishing_angle < 150
            plot(ax_stability, vanishing_angle, GZ(v_idx)*1000, 'ro', ...
                 'MarkerSize', 10, 'MarkerFaceColor', 'r');
        end
        
        % 零线
        plot(ax_stability, [0, 150], [0, 0], 'k--', 'LineWidth', 1);
        
        % 设计要求区域
        ylims = ylim(ax_stability);
        if ylims(2) < 10; ylims(2) = 10; end
        plot(ax_stability, [120, 120], ylims, 'g--', 'LineWidth', 1.5);
        plot(ax_stability, [140, 140], ylims, 'g--', 'LineWidth', 1.5);
        fill(ax_stability, [120, 140, 140, 120], [ylims(1), ylims(1), ylims(2), ylims(2)], ...
             'g', 'FaceAlpha', 0.1, 'EdgeAlpha', 0);
        
        hold(ax_stability, 'off');
        legend(ax_stability, {'GZ(θ)', '稳性消失点'}, 'Location', 'best');
        xlim(ax_stability, [0, 150]);
        ylim(ax_stability, [0, max(GZ*1000)*1.2]);
        xlabel(ax_stability, '横倾角 θ (度)');
        ylabel(ax_stability, '复原力臂 GZ (mm)');
        title(ax_stability, sprintf('静稳性曲线 (消失角=%.0f°, MR=%.3f N·m)', vanishing_angle, MR_max));
        grid(ax_stability, 'on');
    end
    
    % 绑定回调
    set(L_edit, 'Callback', @update_display);
    set(B_edit, 'Callback', @update_display);
    set(D_edit, 'Callback', @update_display);
    set(n_edit, 'Callback', @update_display);
    set(m_hull_edit, 'Callback', @update_display);
    set(m_cargo_edit, 'Callback', @update_display);
    set(KG_cargo_edit, 'Callback', @update_display);
    
    update_display();
end

% 运行
