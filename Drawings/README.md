# Drawings 模块说明文档
## 模块概述
本模块负责 Argo 船设计项目的三维建模与工程图绘制工作，基于 SolidWorks 完成船舰的零件建模、装配体设计、工程图绘制，为仿真分析（Ansys）和硬件制作（PCB、零件加工）提供准确的三维模型和工程图纸。

## 目录结构
```
Drawings/
├── README.md                 # 本文档
├── SolidWorks/               # SolidWorks源文件
│   ├── parts/                # 零件文件（单个零件建模）
│   │   ├── hull/             # 船体零件（船身、甲板等）
│   │   ├── propulsion/       # 推进系统（电机、螺旋桨等）
│   │   ├── electronics/      # 电子安装件（传感器支架、电路板固定件）
│   │   └── structure/        # 结构件（支架、连接件等）
│   ├── assemblies/           # 装配体文件（零件组装）
│   │   ├── main_assembly.SLDASM  # 总装配体（所有零件组装完成）
│   │   └── sub_assemblies/   # 子装配体（局部零件组装，如推进系统装配）
│   ├── drawings/             # 工程图（零件图、装配图，用于加工）
│   └── templates/            # 模板文件（SolidWorks模板、图纸模板）
├── Exported/                 # 导出文件（跨平台通用格式）
│   ├── STEP/                 # STEP通用格式（用于Ansys导入、跨软件编辑）
│   ├── STL/                  # 3D打印文件（零件3D打印）
│   ├── DXF/                  # CAD交换格式（用于其他CAD软件编辑）
│   └── PDF/                  # PDF工程图（便于查阅、打印）
└── docs/                     # 建模相关文档
    ├── assembly_guide.md     # 装配说明（零件装配步骤、注意事项）
    └── bom.xlsx              # 结构件BOM（零件型号、数量、材质）
```

## 环境配置
### 1. 软件安装
- SolidWorks：建议安装 2020 及以上版本，需激活并安装零件建模、装配体、工程图相关模块
- 辅助工具：安装 Adobe Acrobat（用于查看/导出 PDF 工程图）、3D 查看器（用于查看导出的 STL/STEP 文件）

### 2. 模板配置
1. 打开 SolidWorks，进入“选项”->“系统选项”->“文件位置”，添加 `SolidWorks/templates` 目录下的模板文件
2. 配置默认单位（毫米、千克、秒），确保所有建模文件单位统一
3. 配置工程图模板，统一图纸尺寸、标注样式、标题栏格式

## 建模与绘图步骤
### 1. 零件建模
1. 打开 SolidWorks，新建零件文件，选择 `templates` 目录下的零件模板
2. 根据设计要求，使用草图、拉伸、旋转、扫描等特征完成零件建模
3. 零件建模完成后，按规范命名（PascalCase.SLDPRT，如 Hull_Main.SLDPRT），保存至 `SolidWorks/parts` 对应子目录
4. 为零件添加必要的尺寸标注、公差，确保建模精度符合要求

### 2. 装配体设计
1. 新建装配体文件，选择模板，导入需要组装的零件（从 `parts` 目录导入）
2. 按装配顺序添加零件，使用配合关系（重合、平行、垂直等）固定零件位置
3. 子装配体（如推进系统）先单独组装，保存至 `SolidWorks/assemblies/sub_assemblies` 目录，再导入总