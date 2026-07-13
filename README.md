<div align="center">

# Argo 船设计项目

</div>

## 项目概述
Argo 是华中科技大学科创班定量工程设计方法课程设计项目，核心目标是完成船舰的设计、仿真、开发与建模全流程，涵盖仿真分析、上位机软件、嵌入式硬件及三维建模四大模块，实现船舰相关功能的设计与验证。

本项目基于 GitHub 进行版本管理和团队协作，所有开发活动需严格遵循仓库规范体系，确保代码与文件的规范性、可维护性和可复用性。

## 技术栈
| 模块 | 核心技术/工具          |
|------|------------------|
| 仿真分析（Analysis） | Matlab、Ansys     |
| 上位机软件（Software） | Python、PyQt5     |
| 硬件嵌入式（Hardware） | STM32、树莓派、嘉立创EDA |
| 三维建模（Drawings） | SolidWorks       |

## 快速开始
### 1. 仓库克隆
```bash
git clone [具体仓库地址 细分目录尽可能明确]
cd Argo
```

### 2. 环境配置
- 仿真模块：安装 Matlab 2020b+、Ansys 2021+
- 软件模块：参考 `Software/README.md` 安装 Python 依赖
- 硬件模块：安装 STM32CubeMX、MDK-ARM、树莓派开发环境
- 建模模块：安装 SolidWorks 2020+

### 3. 模块运行
各模块的详细运行步骤请参考对应目录下的 `README.md` 文档。

## 团队协作
- 分支管理：遵循 `COMMIT_SPEC.md` 中的分支命名及dev分支管理规范
- 代码提交：严格按照提交规范执行，确保提交信息清晰
- 问题反馈：通过 GitHub Issue 提交问题，PR 提交需经过审核

## 文档说明
- `COMMIT_SPEC.md`：Git 提交规范、分支管理（含dev分支）及 PR/Issue 规范
- `DEV_SPEC.md`：开发规范、代码风格及命名规则
- `FILE_STRUCTURE.md`：仓库文件结构规范
- 各模块 `README.md`：对应模块的详细说明、环境配置及使用方法

## 许可证
[MIT License](LICENSE)
