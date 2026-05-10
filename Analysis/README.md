# Analysis 模块说明文档
## 模块概述
本模块负责 Argo 船设计项目的仿真分析工作，基于 Matlab 实现船舰水动力学、控制算法、导航算法的仿真验证，基于 Ansys 实现船体结构强度、受力情况的有限元分析，为船舰设计提供理论支撑和数据依据。

## 目录结构
```
Analysis/
├── README.md                 # 本文档
├── Matlab/                   # Matlab仿真代码
│   ├── src/                  # 源代码目录
│   │   ├── hydrodynamics/    # 水动力学仿真（船体受力、运动仿真）
│   │   ├── control/          # 控制算法仿真（PID控制、路径规划等）
│   │   ├── navigation/       # 导航算法仿真（定位、避障等）
│   │   └── utils/            # 工具函数（数据转换、参数计算等）
│   ├── scripts/              # 运行脚本（一键启动仿真、批量处理数据）
│   ├── data/                 # 输入数据文件（船体参数、环境参数等）
│   └── results/              # 仿真结果输出
│       ├── figures/          # 图表文件（仿真曲线、结果可视化图）
│       └── logs/             # 日志文件（仿真过程记录、参数日志）
├── Ansys/                    # Ansys有限元分析（船体强度、结构仿真）
│   ├── project_files/        # Ansys项目文件（.wbpj等）
│   ├── models/               # 导入模型（从SolidWorks导出的STEP文件）
│   ├── meshes/               # 网格文件（网格划分结果）
│   ├── results/              # 分析结果（应力、应变等数据文件）
│   └── reports/              # 分析报告（仿真结论、数据汇总）
└── docs/                     # 仿真相关文档（理论依据、参数说明、算法文档）
```

## 环境配置
### 1. 软件安装
- Matlab：建议安装 2020b 及以上版本，需安装 Control System Toolbox、Simulink、Curve Fitting Toolbox 等插件
- Ansys：建议安装 2021 及以上版本，需安装 Structural Mechanics、Fluid Dynamics 模块

### 2. 环境配置步骤
1. 安装上述软件，完成破解和激活
2. 克隆仓库后，进入 `Analysis/Matlab` 目录，将该目录添加到 Matlab 路径（addpath 函数或手动添加）
3. 确保 Ansys 能正常读取 `Ansys/models` 目录下的 STEP 模型文件（从 Drawings/Exported/STEP 目录复制）
4. 确认 Matlab 可正常读取 `data` 目录下的输入参数文件，输出结果可正常写入 `results` 目录

## 运行步骤
### 1. Matlab 仿真运行
1. 打开 Matlab，切换工作目录至 `Analysis/Matlab/scripts`
2. 根据需求运行对应脚本（如 `run_hydrodynamics_simulation.m` 运行水动力学仿真）
3. 仿真完成后，结果会自动保存至 `results/figures`（图表）和 `results/logs`（日志）目录
4. 可通过 `utils` 目录下的工具函数，对仿真结果进行后续处理和分析

### 2. Ansys 有限元分析运行
1. 打开 Ansys，导入 `Ansys/models` 目录下的船体 STEP 模型
2. 按照 `docs` 目录下的分析文档，进行网格划分、边界条件设置、载荷施加
3. 运行分析，分析结果保存至 `Ansys/results` 目录
4. 根据分析结果，撰写分析报告，保存至 `Ansys/reports` 目录

## 注意事项
1. 仿真参数统一在对应脚本开头定义，修改参数时需同步更新 `docs` 目录下的参数说明文档
2. 仿真结果需按规范命名（如 `日期_仿真类型_结果类型.后缀`），便于追溯
3. Ansys 项目文件较大（超过100MB），需使用 Git LFS 追踪，提交前确保已配置 Git LFS
4. 禁止提交 Matlab 缓存文件（.mat~、.m~）、Ansys 临时文件，避免冗余
5. 引用第三方算法或仿真模型时，需在代码注释和 `docs` 文档中注明来源，遵循学术诚信规范

## 常见问题
1. Matlab 脚本运行报错“函数未定义”：检查是否将 `Matlab/src` 目录添加到 Matlab 路径
2. Ansys 无法导入模型：确认 STEP 文件格式正确，可从 Drawings/Exported/STEP 重新复制
3. 仿真结果异常：检查输入参数是否正确，边界条件设置是否合理，可参考 `docs` 目录下的理论文档