# 编辑演示文稿

## 基于模板的工作流

以现有演示为模板时：

1. **分析现有幻灯片**：
   ```bash
   python scripts/thumbnail.py template.pptx
   python -m markitdown template.pptx
   ```
   查看 `thumbnails.jpg` 了解版式，结合 markitdown 输出查看占位文字。

2. **规划幻灯片映射**：每个内容区块对应选用哪一页模板。

   ⚠️ **版式要多样**——全程同一种布局是常见失败模式。不要默认「标题 + 项目符号」。主动选用：
   - 多栏（两栏、三栏）
   - 图 + 文组合
   - 全出血图叠字
   - 引用或强调页
   - 章节分隔页
   - 数字/数据强调
   - 图标网格或「图标 + 文字」行

   **避免：**每一页都用同一种文字-heavy 版式。

   让内容类型匹配版式（例如：要点 → 列表页；团队 → 多栏；证言 → 引用页）。

3. **解包**：`python scripts/office/unpack.py template.pptx unpacked/`

4. **搭建演示结构**（须由你亲自完成，不要用子代理）：
   - 删除不需要的幻灯片（从 `<p:sldIdLst>` 中移除）
   - 需要复用的页用 `add_slide.py` 复制
   - 在 `<p:sldIdLst>` 中调整顺序
   - **第 5 步前完成所有结构变更**

5. **编辑内容**：在各 `slide{N}.xml` 中更新文字。
   **若可用，此处可使用子代理**——每页是独立 XML，可并行编辑。

6. **清理**：`python scripts/clean.py unpacked/`

7. **打包**：`python scripts/office/pack.py unpacked/ output.pptx --original template.pptx`

---

## 脚本

| 脚本           | 用途 |
| -------------- | ---- |
| `unpack.py`    | 解压并美化打印 PPTX |
| `add_slide.py` | 复制幻灯片或从版式新建 |
| `clean.py`     | 删除孤立文件 |
| `pack.py`      | 校验后重新打包 |
| `thumbnail.py` | 生成幻灯片视觉网格图 |

### unpack.py

```bash
python scripts/office/unpack.py input.pptx unpacked/
```

解压 PPTX，美化 XML，转义弯引号。

### add_slide.py

```bash
python scripts/add_slide.py unpacked/ slide2.xml      # 复制幻灯片
python scripts/add_slide.py unpacked/ slideLayout2.xml # 从版式创建
```

会打印需插入 `<p:sldIdLst>` 指定位置的 `<p:sldId>`。

### clean.py

```bash
python scripts/clean.py unpacked/
```

移除不在 `<p:sldIdLst>` 中的幻灯片、未被引用的媒体、孤立关系。

### pack.py

```bash
python scripts/office/pack.py unpacked/ output.pptx --original input.pptx
```

校验、修复、压缩 XML，重新编码弯引号。

### thumbnail.py

```bash
python scripts/thumbnail.py input.pptx [output_prefix] [--cols N]
```

生成带幻灯片文件名的 `thumbnails.jpg`。默认 3 列，每网格最多 12 页。

**仅用于分析模板、挑选版式。** 视觉质检请用 `soffice` + `pdftoppm` 导出高分辨率单页图——见 SKILL.md。

---

## 幻灯片操作

顺序在 `ppt/presentation.xml` 的 `<p:sldIdLst>` 中。

**重排**：调整 `<p:sldId>` 元素顺序。

**删除**：移除对应 `<p:sldId>`，再运行 `clean.py`。

**新增**：使用 `add_slide.py`。不要手动复制幻灯片文件——脚本会处理备注引用、Content_Types.xml 与关系 ID，手工复制容易漏。

---

## 编辑内容

**子代理：**若可用，在完成第 4 步后在此阶段使用。每页独立 XML，可并行。给子代理的提示中应包含：
- 要编辑的幻灯片文件路径
- **「所有修改请使用 Edit 工具」**
- 下文格式规则与常见陷阱

对每一页：
1. 阅读该页 XML
2. 找出**全部**占位内容——文字、图片、图表、图标、说明
3. 逐项替换为最终内容

**使用 Edit 工具，不要用 sed 或临时 Python 脚本。** Edit 工具迫使明确「改什么、在哪改」，可靠性更高。

### 格式规则

- **标题、小标题、行首标签一律加粗**：在 `<a:rPr>` 上设 `b="1"`。包括：
  - 幻灯片标题
  - 页内小节标题
  - 行首标签（如「状态：」「说明：」）
- **禁止使用 Unicode 项目符号（•）**：用 `<a:buChar>` 或 `<a:buAutoNum>` 做列表
- **列表样式一致**：尽量继承版式上的列表；仅在需要时指定 `<a:buChar>` 或 `<a:buNone>`

---

## 常见陷阱

### 模板适配

源内容项数少于模板时：
- **多余元素整段删除**（图、形状、文本框），不要只清空文字
- 清空文字后检查是否留下「孤儿」图形
- 做视觉质检核对数量是否匹配

替换为长短差异较大的文字时：
- **更短**：通常较安全
- **更长**：可能溢出或意外折行
- 改字后做视觉质检
- 必要时截断或拆分到多处以适应版式

**模板槽位 ≠ 源数据条数**：若模板 4 人团队位但源只有 3 人，应删除第 4 人整组（图 + 文），不要只删字。

### 多项内容

若源有多条（编号列表、多小节），应为每条建独立 `<a:p>`——**禁止拼成一长串**。

**❌ 错误**——全挤在一个段落：
```xml
<a:p>
  <a:r><a:rPr .../><a:t>Step 1: Do the first thing. Step 2: Do the second thing.</a:t></a:r>
</a:p>
```

**✅ 正确**——分段，标题加粗：
```xml
<a:p>
  <a:pPr algn="l"><a:lnSpc><a:spcPts val="3919"/></a:lnSpc></a:pPr>
  <a:r><a:rPr lang="en-US" sz="2799" b="1" .../><a:t>Step 1</a:t></a:r>
</a:p>
<a:p>
  <a:pPr algn="l"><a:lnSpc><a:spcPts val="3919"/></a:lnSpc></a:pPr>
  <a:r><a:rPr lang="en-US" sz="2799" .../><a:t>Do the first thing.</a:t></a:r>
</a:p>
<a:p>
  <a:pPr algn="l"><a:lnSpc><a:spcPts val="3919"/></a:lnSpc></a:pPr>
  <a:r><a:rPr lang="en-US" sz="2799" b="1" .../><a:t>Step 2</a:t></a:r>
</a:p>
<!-- 依此类推 -->
```

从原段落复制 `<a:pPr>` 以保留行距。标题用 `b="1"`。

### 弯引号

unpack/pack 会自动处理。但 Edit 工具可能把弯引号变成 ASCII。

**新增带引号的文字时，使用 XML 实体：**

```xml
<a:t>the &#x201C;Agreement&#x201D;</a:t>
```

| 字符 | 名称     | Unicode | XML 实体   |
| ---- | -------- | ------- | ---------- |
| `“`  | 左双引号 | U+201C  | `&#x201C;` |
| `”`  | 右双引号 | U+201D  | `&#x201D;` |
| `‘`  | 左单引号 | U+2018  | `&#x2018;` |
| `’`  | 右单引号 | U+2019  | `&#x2019;` |

### 其他

- **空白**：`<a:t>` 首尾需保留空格时加 `xml:space="preserve"`
- **解析 XML**：使用 `defusedxml.minidom`，不要用 `xml.etree.ElementTree`（会破坏命名空间）
