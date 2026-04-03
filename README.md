# eap-skills

公开仓库：[github.com/yangyifeng1128/eap-skills](https://github.com/yangyifeng1128/eap-skills)

## 一、开发指南

### 1.1 准备环境

#### 1.1.1 安装 uv

详见官方文档：[Installation](https://docs.astral.sh/uv/getting-started/installation/)

#### 1.1.2 创建虚拟环境、安装依赖包

```bash
cd /path/to/eap-skills

uv python install
uv venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate

uv pip install -r requirements.txt
```

如果不希望激活虚拟环境，可以在项目根目录下使用 `uv run` 引入已安装的依赖包（见下文「测试指南」）。

#### 1.1.3 安装 Office 开发工具

macOS 用户执行以下命令：

```bash
brew install --cask libreoffice
brew install poppler
```

Windows 用户执行以下命令：

```powershell
winget install -e --id TheDocumentFoundation.LibreOffice
winget install -e --id oschwartz10612.Poppler
```

执行以下命令，确认是否安装成功：

```bash
soffice --version
pdftoppm -v
```

### 1.2 快速开始

- **PPTX / DOCX Skill 与 Python 脚本**  
  - PPTX：[`pptx/SKILL.md`](pptx/SKILL.md)、[`pptx/editing.md`](pptx/editing.md)；命令默认在 **`pptx/`** 下执行（如 `python scripts/thumbnail.py …`）。  
  - DOCX：[`docx/SKILL.md`](docx/SKILL.md)；命令默认在 **`docx/`** 下执行（如 `python scripts/office/unpack.py …`）。

---

### 测试

**Python（建议作为合并前冒烟）**

在仓库根目录、已安装依赖的前提下：

```bash
uv run python -c "import defusedxml, lxml; from PIL import Image; print('ok')"
uv run python -m markitdown --help
```

针对某一演示文稿（以下以 `pptx/sample.pptx` 为例，请换成你的文件路径），在**仓库根目录**跑通一条最小链路：

```bash
cd /path/to/eap-skills

uv run python -m markitdown pptx/sample.pptx
uv run python pptx/scripts/thumbnail.py pptx/sample.pptx
```

（若已 `activate` 项目 `.venv`，可将 `uv run python` 换成 `python`。文档里写在 `pptx/` 下执行的 `python scripts/...` 命令，等价于在根目录使用上面的路径形式。）

解包 / 打包 / 校验类脚本见 `pptx/editing.md` 与 `pptx/SKILL.md` 中的 **QA** 小节。

### 发布

- **CLI**：执行 `pnpm build` 后，将 `dist/` 与 `package.json` 按你的分发方式发布（例如私有 npm 注册表或内网制品库）。  
- **Skill**：通常将对应目录（如 `pptx/`）或其中的 `SKILL.md` 按目标平台要求拷贝或注册到 Agent 的 Skill / 规则目录；无需单独「编译」，以各 Agent 文档为准。

## 第二部分：在 Agent 中测试 Skill 的使用效果

目标：确认 Agent **真的按 Skill 文档行动**（读对文件、下对命令、做对校验），而不是仅凭常识瞎答。

### 1. 注册 Skill

在所用 Agent（如 Cursor、Claude Code、Codex 等）中，按平台说明挂载本仓库中的 Skill：

- 将 **`pptx/`**、**`docx/`** 目录（或其中的 `SKILL.md` 及引用文档）加入该工具识别的 Skill 路径；或  
- 把 `SKILL.md` 的核心流程写入项目级 **规则 / AGENTS.md**，并指向本仓库脚本路径。

路径需指向**本机克隆后的实际目录**，以便 Agent 能执行 `python scripts/...`。

### 2. 设计探测任务

给 Agent 一个**必须查 Skill 才能完成**的任务，例如：

- 「用本仓库 `pptx` Skill 里的流程，把 `sample.pptx` 导出缩略图网格，并说明用了哪条命令。」  
- 「按 `editing.md` 解包模板、改某一页标题文字、再 `pack` 回 `output.pptx`，并运行校验。」

任务应明确要求：**引用文档中的命令**，而不是自己发明参数。

### 3. 验收要点

对照 Skill 文档检查 Agent 行为，例如：

- 是否优先阅读 **`SKILL.md` / `editing.md`**，而不是跳过直接改二进制。  
- 是否使用文档中的 **`markitdown` / `thumbnail.py` / `unpack` → `clean` → `pack` / `validate`** 等步骤（视任务而定）。  
- 产出物是否通过 **`validate`**（若流程要求）以及是否执行了文档中的 **内容 QA**（如 `markitdown` 查占位符）。  
- 若 Skill 要求 **视觉 QA**（导出幻灯片图 + 审查），Agent 是否安排或说明该步骤。

### 4. 迭代

若 Agent 漏步骤、路径错误或未装依赖，优先在 **Skill 文档** 中补全：前置条件、工作目录、`uv run` 示例、常见报错。再重复 2–3 步做回归。

---

## 第三部分：安装并使用 pptx / docx 技能（面向用户）

公开仓库：**[https://github.com/yangyifeng1128/eap-skills](https://github.com/yangyifeng1128/eap-skills)**。技能由目录内 [`pptx/SKILL.md`](pptx/SKILL.md)、[`docx/SKILL.md`](docx/SKILL.md) 定义（frontmatter 中 `name` 分别为 **`pptx`**、**`docx`**）。

### 1. 用 `skills` CLI 安装（[skills.sh](https://skills.sh/) 生态）

CLI 开源仓库：[vercel-labs/skills](https://github.com/vercel-labs/skills)。安装前可先查看本仓库包含哪些技能：

```bash
npx skills add yangyifeng1128/eap-skills --list
```

**安装全部技能**（按提示选择要写入的 Agent，如 Cursor、Claude Code 等）：

```bash
npx skills add yangyifeng1128/eap-skills
```

**只安装其中一个**：

```bash
npx skills add yangyifeng1128/eap-skills --skill pptx
npx skills add yangyifeng1128/eap-skills --skill docx
```

常用选项（详见 [CLI 文档](https://github.com/vercel-labs/skills)）：

- `-g` / `--global`：安装到用户目录，所有项目可用。  
- `-a cursor` / `-a claude-code` 等：只写入指定 Agent。  
- `-y`：跳过确认（适合脚本）。  
- 完整 URL 写法：`npx skills add https://github.com/yangyifeng1128/eap-skills`

> **说明：** CLI 会把 Skill **说明与流程** 安装到 Agent 的 skills 目录；**运行文档中的 Python 脚本**仍需要你在本机 **克隆仓库** 并完成上文 **第一部分** 中的 Python 依赖（`requirements.txt`）及可选系统工具（LibreOffice、Poppler、pandoc 等）。

### 2. 克隆仓库（运行脚本必做）

```bash
git clone https://github.com/yangyifeng1128/eap-skills.git
cd eap-skills
```

在仓库根目录按第一部分配置 `uv` 与 `uv pip install -r requirements.txt`。Skill 文档里的相对路径以 **`pptx/`** 或 **`docx/`** 为当前工作目录；从仓库根目录调用时，请使用下文「命令示例」中的路径形式。

### 3. 额外依赖速查

| 技能     | 典型用途                       | 除 `requirements.txt` 外常见依赖                                                                                                                                     |
| -------- | ------------------------------ | -------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **pptx** | 读幻灯片、缩略图、模板编辑流程 | `markitdown[pptx]`（已在 requirements）、LibreOffice、`pdftoppm`（Poppler）；从零生成见 [`pptx/pptxgenjs.md`](pptx/pptxgenjs.md)（Node + `pptxgenjs`）               |
| **docx** | 读 Word、解包编辑、校验        | **pandoc**（如 `pandoc --track-changes`）；接受修订 / 转 PDF 等需 **LibreOffice**；用 JS 新建文档需 **`npm install -g docx`**（见 [`docx/SKILL.md`](docx/SKILL.md)） |

### 4. 命令示例（本机终端）

以下假设当前目录为克隆后的 **`eap-skills` 仓库根目录**，且已 `uv venv` 并安装依赖（或使用 `uv run`）。

**pptx — 提取文字、缩略图网格**

```bash
uv run python -m markitdown pptx/你的文件.pptx
uv run python pptx/scripts/thumbnail.py pptx/你的文件.pptx
```

若在 **`pptx/`** 目录内执行（与 SKILL 原文一致）：

```bash
cd pptx
uv run --directory .. python -m markitdown 你的文件.pptx
uv run --directory .. python scripts/thumbnail.py 你的文件.pptx
```

**docx — 转 Markdown（保留修订）、解包、校验**

```bash
pandoc --track-changes=all docx/你的文件.docx -o /tmp/out.md
uv run python docx/scripts/office/unpack.py docx/你的文件.docx docx/unpacked/
uv run python docx/scripts/office/validate.py docx/你的文件.docx
```

若在 **`docx/`** 目录内：

```bash
cd docx
pandoc --track-changes=all 你的文件.docx -o /tmp/out.md
uv run --directory .. python scripts/office/unpack.py 你的文件.docx unpacked/
uv run --directory .. python scripts/office/validate.py 你的文件.docx
```

更多流程（模板编辑、打包回写、QA）见各自 **SKILL.md** 与 **editing** 类文档。

### 5. 在 Agent 里的自然语言示例

安装技能后，可直接用任务描述触发（Agent 应按对应 `SKILL.md` 操作）：

**pptx**

- 「我本地克隆了 `eap-skills`，请按 `pptx/SKILL.md` 用 `markitdown` 提取 `pptx/deck.pptx` 全文，并说明是否还有占位符。」  
- 「用仓库里 `pptx/scripts/thumbnail.py` 给 `pptx/deck.pptx` 生成缩略图网格，工作目录在 `pptx/`。」  
- 「按 `pptx/editing.md` 流程：解包模板、改第 2 页标题、clean、pack，并运行 validate。」

**docx**

- 「按 `docx/SKILL.md`，用 pandoc 把 `docx/report.docx` 导出为 Markdown（`--track-changes=all`）。」  
- 「解包 `docx/report.docx` 到 `docx/unpacked/`，修改正文某段后按文档要求 pack 并 `validate.py`。」  
- 「用 docx-js 生成一份带标题和段落的 `memo.docx`，再用 `docx/scripts/office/validate.py` 校验。」
