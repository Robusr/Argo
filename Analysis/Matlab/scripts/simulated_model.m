% ==========================================
% 【严格参数定制】真实船模 3D 仿真 (数字孪生级)
% 严格基于参数: L=0.4, B=0.24, D=0.15, n=3.5
% 几何特征: 纯净平甲板，首尾龙骨向中部平滑收束 (真实船体水线特征)
% ==========================================
clc; clear; close all;

% --- 1. 严格锁定用户给定的参数 ---
L = 0.40;       % 船长 (m)
B = 0.24;       % 最大船宽 (m)
D = 0.15;       % 型深 (m)
n = 3.5;        % 底型参数
draft = 0.045;  % 模拟吃水线 (视觉参考)

% --- 2. 创建高级暗色系 CAD 图形窗口 ---
fig = figure('Name', '高保真真实船体仿真 (严格参数)', 'Position', [100, 100, 1100, 800]);
set(fig, 'Color', [0.12, 0.12, 0.14]); 

ax = axes('Parent', fig);
hold(ax, 'on'); grid(ax, 'on');
set(ax, 'Color', [0.12, 0.12, 0.14], 'XColor', [0.5 0.5 0.6], 'YColor', [0.5 0.5 0.6], 'ZColor', [0.5 0.5 0.6]);
ax.GridColor = [0.4 0.4 0.5]; ax.GridAlpha = 0.5;
title(ax, sprintf('高保真真实船模仿真\n(参数: L=%.2f, B=%.2f, D=%.2f, n=%.1f)', L, B, D, n), 'FontSize', 15, 'FontWeight', 'bold', 'Color', 'w');
xlabel(ax, 'X 船长 (m)'); ylabel(ax, 'Y 船宽 (m)'); zlabel(ax, 'Z 型深 (m)');

% --- 3. 核心算法：生成"越往下越往中间收"的真实 3D 曲面网格 ---
nx = 200; % 纵向精度
nz = 80;  % 垂向精度
x_1d = linspace(-L/2, L/2, nx);
z_norm = linspace(0, 1, nz); % 归一化深度 (0=龙骨底, 1=甲板)

X_surf = zeros(nz, nx);
Y_surf = zeros(nz, nx);
Z_surf = zeros(nz, nx);

for i = 1:nx
    xi = x_1d(i);
    X_surf(:, i) = xi;
    
    % 计算局部宽度 bx 和 龙骨上翘高度 z_keel
    if xi > 0.05
        % --- 船首段：破浪艏柱，底部强烈向中部收束 ---
        u = (xi - 0.05) / 0.15;      
        bx = (B/2) * (1 - u^1.8);    % 甲板宽度向船尖收缩
        z_keel = D * u^2.5;          % 【核心】龙骨线向上弯曲，直达船尖甲板。越往下横截面越短！
    elseif xi < -0.10
        % --- 船尾段：减阻收束 ---
        u = abs(xi - (-0.10)) / 0.10;
        bx = (B/2) * (1 - 0.15 * u^2); % 船尾略微收窄
        z_keel = (D * 0.25) * u^2;     % 船尾底部适度上翘，形成巡洋舰尾特征
    else
        % --- 舯部平直段：提供最大浮力与稳性 ---
        bx = B/2;
        z_keel = 0;
    end
    
    if bx < 1e-4; bx = 1e-4; end % 防止除0
    
    local_D = D - z_keel; % 当前截面的实际型深
    
    % 生成截面网格，完美融合 n=3.5 参数
    Z_surf(:, i) = z_keel + local_D * z_norm;
    Y_surf(:, i) = bx * (z_norm).^(1/n);
end

% --- 4. 绘制船壳 (高质感海洋白) ---
hull_color = [0.92, 0.94, 0.96]; 
surf(ax, X_surf, Y_surf, Z_surf, 'FaceColor', hull_color, 'EdgeColor', 'none', 'FaceAlpha', 0.95);
surf(ax, X_surf, -Y_surf, Z_surf, 'FaceColor', hull_color, 'EdgeColor', 'none', 'FaceAlpha', 0.95);

% 为了凸显"横截面"的曲率变化，叠加细微的深色结构线 (肋骨线)
for idx = 1:8:nx
    plot3(ax, X_surf(:,idx), Y_surf(:,idx), Z_surf(:,idx), 'Color', [0.3 0.4 0.5 0.3], 'LineWidth', 0.5);
    plot3(ax, X_surf(:,idx), -Y_surf(:,idx), Z_surf(:,idx), 'Color', [0.3 0.4 0.5 0.3], 'LineWidth', 0.5);
end

% --- 5. 绘制纯净平甲板 ---
[X_deck, Y_deck_norm] = meshgrid(x_1d, linspace(-1, 1, 40));
Y_deck = zeros(size(X_deck));
Z_deck = D * ones(size(X_deck));
for i = 1:nx
    % 甲板宽度随轮廓变化
    Y_deck(:, i) = Y_deck_norm(:, i) * Y_surf(end, i); 
end
surf(ax, X_deck, Y_deck, Z_deck, 'FaceColor', [0.85, 0.86, 0.88], 'EdgeColor', 'none');

% 绘制船尾截面 (方尾板)
idx_stern = 1; 
fill3(ax, [X_surf(1,idx_stern), X_surf(:,idx_stern)', X_surf(end,idx_stern), flip(X_surf(:,idx_stern)')], ...
          [0, Y_surf(:,idx_stern)', 0, flip(-Y_surf(:,idx_stern)')], ...
          [Z_surf(1,idx_stern), Z_surf(:,idx_stern)', D, flip(Z_surf(:,idx_stern)')], ...
          hull_color, 'EdgeColor', 'none');

% --- 6. 固定铝合金桅杆 ---
% Φ10x500mm, 从船底(z=0)向上穿透甲板
[cX, cY, cZ] = cylinder(0.005, 30);
surf(ax, cX, cY, cZ * 0.500, 'FaceColor', [0.75, 0.78, 0.8], 'EdgeColor', 'none', 'SpecularStrength', 1);

% --- 7. 动态深海波浪水面 ---
[X_w, Y_w] = meshgrid(linspace(-L*0.7, L*0.7, 60), linspace(-B*1.5, B*1.5, 60));
Z_w = draft + 0.002 * sin(40 * X_w) .* cos(40 * Y_w);
surf(ax, X_w, Y_w, Z_w, 'FaceColor', [0.1, 0.35, 0.65], 'EdgeColor', 'none', 'FaceAlpha', 0.4);

% --- 8. 电影级真实光照与材质渲染 ---
axis(ax, 'equal');
camproj(ax, 'perspective'); % 透视投影，增强空间立体感
view(ax, 140, 20); % 经典侧后方展示视角

% 多重高级打光
camlight(ax, 'headlight');             
light(ax, 'Position', [1 1 1.5], 'Style', 'local', 'Color', [1 1 1]); % 主光源
light(ax, 'Position', [-1 -1 0.5], 'Style', 'local', 'Color', [0.6 0.7 0.9]); % 冷色环境补光

lighting(ax, 'phong');      % 极限平滑光影
material(ax, 'metal');      % 赋予船体类似高级涂层/复合材料的光泽度

% 锁定视角范围
xlim(ax, [-0.25, 0.25]);
ylim(ax, [-0.2, 0.2]);
zlim(ax, [-0.02, D + 0.4]);