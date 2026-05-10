# Argo 项目开发规范
## 1. 通用规范
### 1.1 代码通用要求
1. 代码需具备可读性、可维护性，避免冗余代码，遵循“单一职责”原则
2. 禁止使用中文、空格、特殊符号（如@、#、$）命名文件/文件夹/变量
3. 所有代码需添加必要注释，说明功能、参数、返回值，复杂逻辑需添加步骤注释
4. 禁止提交编译产物、临时文件、敏感信息（密码、密钥）、OS隐藏文件（.DS_Store、Thumbs.db）
5. 超过100MB的文件（如SolidWorks、Ansys项目文件）必须使用Git LFS追踪，参考.gitattributes配置

### 1.2 文档通用要求
1. 所有Markdown文档需格式规范，标题层级清晰（#一级标题、##二级标题...）
2. 文档内容需简洁准确，及时更新（代码修改后同步更新对应文档）
3. 图表、表格需清晰规范，便于阅读；代码片段需使用代码块格式化

### 1.3 团队协作规范
1. 开发前需确认任务分配，避免重复开发
2. 提交代码前需拉取最新分支，解决冲突后再提交
3. 遇到问题及时沟通，通过Issue或团队群反馈，不擅自修改他人代码
4. 遵循COMMIT_SPEC.md的提交规范和分支管理规范，确保提交信息清晰可追溯

### 1.4 学术诚信规范
1. 禁止抄袭他人代码、算法，引用第三方代码/算法需在注释和文档中注明来源
2. 仿真数据、分析结果需真实有效，禁止伪造数据
3. 引用学术文献、技术文档需标注出处

## 2. 代码风格规范
### 2.1 Python代码（Software模块、树莓派代码）
1. 遵循PEP 8规范，缩进使用4个空格，禁止使用Tab
2. 变量命名：snake_case（小写下划线），如data_processing、uart_port
3. 函数命名：snake_case，如get_sensor_data()、draw_line_chart()
4. 类命名：PascalCase（大驼峰），如DataVisualization、SerialCommunication
5. 常量命名：UPPER_SNAKE_CASE（全大写下划线），如BAUD_RATE、MAX_DATA_LEN
6. 注释：单行注释用#，多行注释用"""，说明函数功能、参数含义、异常处理
7. 导入规范：先导入标准库，再导入第三方库，最后导入自定义模块，导入顺序按字母排序

### 2.2 C/C++代码（STM32代码）
1. 缩进使用4个空格，代码块用{}包裹，{}单独占一行
2. 变量命名：snake_case，如uart_handle、motor_speed
3. 函数命名：snake_case，如uart_init()、motor_control()
4. 宏定义、常量：UPPER_SNAKE_CASE，如GPIO_PIN_5、TIM_PERIOD
5. 注释：单行用//，多行用/* */，函数头部需添加注释，说明功能、参数、返回值、作者、日期
6. 头文件保护：使用#ifndef、#define、#endif，避免重复包含
7. 避免全局变量滥用，必要时使用static限制作用域

### 2.3 Matlab代码（Analysis模块）
1. 缩进使用4个空格，脚本文件以.m为后缀
2. 变量命名：snake_case，如hydro_dynamics_model、control_gain
3. 函数命名：snake_case，如simulate_ship_motion()、calculate_drag_force()
4. 注释：单行用%，多行用%{ %}，函数头部添加帮助注释，说明功能、输入输出参数
5. 代码结构清晰，按功能分段，使用%%划分代码块
6. 仿真参数统一定义在脚本开头，便于修改和维护
7. 输出结果按规范存入results目录，文件名清晰（如20240510_hydrodynamics_simulation.mat）

## 3. 命名规范（补充）
### 3.1 文件命名
1. 代码文件：snake_case.后缀（如data_processing.py、uart.c、ship_model.m）
2. 文档文件：snake_case.md（如assembly_guide.md、sensor_datasheet.md）
3. 模型文件：PascalCase.后缀（如Hull.SLDPRT、MainAssembly.SLDASM）
4. 数据文件：清晰描述内容+日期.后缀（如sensor_data_20240510.csv）

### 3.2 文件夹命名
- 主文件夹（根目录下）：PascalCase（如Analysis、Software、Hardware、Drawings）
- 子文件夹：snake_case（如hydrodynamics、data_processing、stm32）

## 4. 各模块专项规范
### 4.1 Analysis模块（Matlab/Ansys）
1. Matlab代码按功能分类存放至对应子目录（hydrodynamics、control等）
2. 仿真输入数据存入data目录，输出结果存入results/figures（图表）、results/logs（日志）
3. Ansys项目文件按流程存放（project_files、meshes、results等），分析报告存入reports目录
4. 仿真参数、算法原理需在docs目录添加文档说明

### 4.2 Software模块（上位机）
1. 源代码按功能模块存放（ui、communication、data_processing等）
2. 资源文件（图标、图片）存入resources目录，按类型分类
3. 单元测试代码存入tests目录，每个功能模块对应单独的测试文件
4. 依赖包版本统一写入requirements.txt，避免版本冲突
5. 打包配置写入setup.py，支持一键打包发布

### 4.3 Hardware模块（STM32/树莓派/PCB）
1. STM32代码按标准工程结构存放（Core、Drivers、Middlewares等）
2. 树莓派代码按功能分类（src、config、scripts）
3. PCB设计文件包含完整工程、原理图、布局、元件库，生产文件存入gerber目录
4. 物料清单（BOM.xlsx）需准确完整，包含元器件型号、数量、封装、供应商
5. 芯片手册、原理图PDF、接线图存入docs目录，便于查阅

### 4.4 Drawings模块（SolidWorks）
1. 零件文件按类别存入parts子目录（hull、propulsion等）
2. 装配体文件存入assemblies目录，总装配体命名为main_assembly.SLDASM
3. 工程图存入drawings目录，导出通用格式（STEP、STL、PDF）至Exported目录
4. 结构件BOM存入docs目录，与SolidWorks中的BOM保持一致
5. 零件、装配体命名规范，清晰描述其功能（如Hull_Main.SLDPRT、Propulsion_Motor.SLDPRT）

## 5. Git LFS使用规范
1. 需追踪的大文件类型：
   - SolidWorks文件（.SLDPRT、.SLDASM、.SLDDRW）
   - Ansys文件（.wbpj、.wbdb、.rst）
   - 大型仿真数据文件（.mat、.csv，超过100MB）
2. 配置方法：
   ```bash
   # 安装Git LFS（已安装可跳过）
   git lfs install
   # 追踪指定类型文件
   git lfs track "*.SLDPRT"
   git lfs track "*.SLDASM"
   git lfs track "*.wbpj"
   # 提交.gitattributes文件
   git add .gitattributes
   ```
3. 提交大文件时，直接按正常提交流程操作，Git LFS会自动处理