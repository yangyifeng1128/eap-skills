# eap-skills

公开代码仓库地址：[github.com/yangyifeng1128/eap-skills](https://github.com/yangyifeng1128/eap-skills)

## 一、开发指南

### 1.1 准备环境

#### 1.1.1 安装 uv

详见官方文档：[Installation](https://docs.astral.sh/uv/getting-started/installation/)

#### 1.1.2 创建虚拟环境

macOS 用户：

```bash
cd /path/to/eap-skills

uv python install
uv venv
source .venv/bin/activate
uv sync
```

Windows 用户：

```powershell
cd \path\to\eap-skills

uv python install
uv venv
.venv\Scripts\activate
uv sync
```

#### 1.1.3 清理虚拟环境

```bash
make clean
```

#### 1.1.4 安装 Office 开发工具

macOS 用户：

```bash
brew install --cask libreoffice
brew install poppler
```

Windows 用户：

```powershell
winget install -e --id TheDocumentFoundation.LibreOffice
winget install -e --id oschwartz10612.Poppler
```

确认是否安装成功：

```bash
soffice --version
pdftoppm -v
```

## 二、使用指南

### 2.1 安装技能

列举本项目中的技能：

```bash
npx skills add yangyifeng1128/eap-skills --list
```

安装全部技能：

```bash
npx skills add yangyifeng1128/eap-skills
```

安装其中一个技能：

```bash
npx skills add yangyifeng1128/eap-skills --skill eap-ppt
```
