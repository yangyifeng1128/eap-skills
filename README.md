# eap-skills

本仓库包含 **Agent Skill**（如 `pptx/`）、配套 **Python 脚本**，以及根目录的 **Node CLI**（`eap-cli`）。下文分为两部分：

1. **第一部分**：本地环境配置、日常开发、测试与发布。  
2. **第二部分**：如何在各类 Agent 中验证 Skill 是否被正确理解与执行。

---

## 第一部分：环境配置、开发、测试与发布

### 环境配置

#### Python（Skill 脚本与 PPTX 工具链）

建议使用 **[uv](https://docs.astral.sh/uv/)** 管理解释器与虚拟环境，避免系统 Python 的 PEP 668 限制。

1. **安装 uv**（详见官方文档：[Installation](https://docs.astral.sh/uv/getting-started/installation/)）  
   - macOS / Linux：安装脚本或包管理器。  
   - Windows：`winget` 或独立安装程序。

2. **在项目根目录创建环境并安装依赖**（Python 采用团队认定的 **CPython LTS** 次版本线：**不在命令行写补丁号或次版本号**）。

   在仓库根目录的 **`.python-version`** 中维护**一行**解释器版本请求（仅 `主版本.次版本`，由维护者随 LTS 策略更新）。`uv python install` / `uv venv` 会自动读取该文件。

   **说明：** `uv` 当前**不支持**用字面量 `lts` 作为 `uv python install` / `--python` 的参数；LTS 约定通过 `.python-version` 落实。

```bash
cd /path/to/eap-skills

uv python install
uv venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate

uv pip install -r requirements.txt
```

不激活虚拟环境时，可在仓库根目录使用 `uv run` 调用已安装依赖（见下文「测试」）。

#### Node / pnpm（根目录 `eap-cli`）

`package.json` 要求 **Node 24.x** 与 **pnpm 10.33.0**（见 `package.json` 的 `engines` 与 `packageManager`）。

```bash
cd /path/to/eap-skills
pnpm install
```

#### PPTX 相关系统依赖（无法用 pip 安装）

`pptx/scripts/thumbnail.py` 与 [`pptx/SKILL.md`](pptx/SKILL.md) 中的 PDF/幻灯片图导出依赖：

- **LibreOffice**（`soffice`）
- **Poppler**（`pdftoppm`）

**macOS（Homebrew）**

```bash
brew install --cask libreoffice
brew install poppler
```

**Windows（winget）**

在 PowerShell 或命令提示符中执行（需 [winget](https://learn.microsoft.com/windows/package-manager/winget/)）：

```powershell
winget install -e --id TheDocumentFoundation.LibreOffice
winget install -e --id oschwartz10612.Poppler
```

也可从官网安装 LibreOffice：[https://www.libreoffice.org/download/download/](https://www.libreoffice.org/download/download/)。若终端找不到 `soffice`，将安装目录下的 `program` 文件夹加入 **PATH**（内含 `soffice.exe`）。

**安装后确认**

```bash
soffice --version
pdftoppm -v
```

（Windows 上若需可改用 `soffice.exe`。）

#### 可选：PptxGenJS（从零生成 `.pptx`）

若按 [`pptx/pptxgenjs.md`](pptx/pptxgenjs.md) 用 Node 生成演示文稿，可全局安装（或按该文档在项目内安装）：

```bash
npm install -g pptxgenjs
```

---

### 开发

- **CLI（`eap-cli`）**  
  - 本地调试：`pnpm dev`  
  - 类型检查：`pnpm ts:check`  
  - 代码风格：`pnpm lint` / `pnpm format`  
  - 构建：`pnpm build`（产物在 `dist/`）

- **PPTX Skill 与 Python 脚本**  
  - 流程与约定见 [`pptx/SKILL.md`](pptx/SKILL.md)、[`pptx/editing.md`](pptx/editing.md)。  
  - 文档中的命令默认在 **`pptx/`** 目录下执行（例如 `python scripts/thumbnail.py …`、`python scripts/office/unpack.py …`）。

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

**Node**

```bash
pnpm ts:check
pnpm lint
```

---

### 发布

- **CLI**：执行 `pnpm build` 后，将 `dist/` 与 `package.json` 按你的分发方式发布（例如私有 npm 注册表或内网制品库）。  
- **Skill**：通常将对应目录（如 `pptx/`）或其中的 `SKILL.md` 按目标平台要求拷贝或注册到 Agent 的 Skill / 规则目录；无需单独「编译」，以各 Agent 文档为准。

---

## 第二部分：在 Agent 中测试 Skill 的使用效果

目标：确认 Agent **真的按 Skill 文档行动**（读对文件、下对命令、做对校验），而不是仅凭常识瞎答。

### 1. 注册 Skill

在所用 Agent（如 Cursor、Claude Code、Codex 等）中，按平台说明挂载本仓库中的 Skill：

- 将 **`pptx/`** 目录（或其中 `SKILL.md` 及引用文档）加入该工具识别的 Skill 路径；或  
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

## 参考索引

- 根目录 **一行** Python 版本请求（`主.次`，供 `uv` 等读取）：[`.python-version`](.python-version)  
- PPTX 脚本入口与 QA：[`pptx/SKILL.md`](pptx/SKILL.md)、[`pptx/editing.md`](pptx/editing.md)  
- Python 依赖说明：[`requirements.txt`](requirements.txt)  
- 从零生成幻灯片：[`pptx/pptxgenjs.md`](pptx/pptxgenjs.md)
