# PptxGenJS 教程

## 环境与基本结构

```javascript
const pptxgen = require("pptxgenjs");

let pres = new pptxgen();
pres.layout = 'LAYOUT_16x9';  // 或 'LAYOUT_16x10'、'LAYOUT_4x3'、'LAYOUT_WIDE'
pres.author = 'Your Name';
pres.title = 'Presentation Title';

let slide = pres.addSlide();
slide.addText("Hello World!", { x: 0.5, y: 0.5, fontSize: 36, color: "363636" });

pres.writeFile({ fileName: "Presentation.pptx" });
```

## 版式尺寸

幻灯片尺寸（坐标单位为英寸）：
- `LAYOUT_16x9`：10" × 5.625"（默认）
- `LAYOUT_16x10`：10" × 6.25"
- `LAYOUT_4x3`：10" × 7.5"
- `LAYOUT_WIDE`：13.3" × 7.5"

---

## 文字与格式

```javascript
// 基础文字
slide.addText("Simple Text", {
  x: 1, y: 1, w: 8, h: 2, fontSize: 24, fontFace: "Arial",
  color: "363636", bold: true, align: "center", valign: "middle"
});

// 字符间距（用 charSpacing；letterSpacing 会被静默忽略）
slide.addText("SPACED TEXT", { x: 1, y: 1, w: 8, h: 1, charSpacing: 6 });

// 富文本数组
slide.addText([
  { text: "Bold ", options: { bold: true } },
  { text: "Italic ", options: { italic: true } }
], { x: 1, y: 3, w: 8, h: 1 });

// 多行（条目间需要 breakLine: true）
slide.addText([
  { text: "Line 1", options: { breakLine: true } },
  { text: "Line 2", options: { breakLine: true } },
  { text: "Line 3" }  // 最后一项可不加 breakLine
], { x: 0.5, y: 0.5, w: 8, h: 2 });

// 文本框边距（内边距）
slide.addText("Title", {
  x: 0.5, y: 0.3, w: 9, h: 0.6,
  margin: 0  // 与形状、图标等对齐到同一 x 时设为 0
});
```

**提示：** 文本框默认有内边距。需要与同 x 位置的形状、线条或图标精确对齐时，设 `margin: 0`。

---

## 列表与项目符号

```javascript
// ✅ 正确：多条列表
slide.addText([
  { text: "First item", options: { bullet: true, breakLine: true } },
  { text: "Second item", options: { bullet: true, breakLine: true } },
  { text: "Third item", options: { bullet: true } }
], { x: 0.5, y: 0.5, w: 8, h: 3 });

// ❌ 错误：不要用 Unicode 项目符号
slide.addText("• First item", { ... });  // 会出现双重符号

// 子项与编号列表
{ text: "Sub-item", options: { bullet: true, indentLevel: 1 } }
{ text: "First", options: { bullet: { type: "number" }, breakLine: true } }
```

---

## 形状

```javascript
slide.addShape(pres.shapes.RECTANGLE, {
  x: 0.5, y: 0.8, w: 1.5, h: 3.0,
  fill: { color: "FF0000" }, line: { color: "000000", width: 2 }
});

slide.addShape(pres.shapes.OVAL, { x: 4, y: 1, w: 2, h: 2, fill: { color: "0000FF" } });

slide.addShape(pres.shapes.LINE, {
  x: 1, y: 3, w: 5, h: 0, line: { color: "FF0000", width: 3, dashType: "dash" }
});

// 透明度
slide.addShape(pres.shapes.RECTANGLE, {
  x: 1, y: 1, w: 3, h: 2,
  fill: { color: "0088CC", transparency: 50 }
});

// 圆角矩形（rectRadius 仅对 ROUNDED_RECTANGLE 有效，对 RECTANGLE 无效）
// ⚠️ 不要与矩形装饰条叠用——盖不住圆角。装饰条场景请用 RECTANGLE。
slide.addShape(pres.shapes.ROUNDED_RECTANGLE, {
  x: 1, y: 1, w: 3, h: 2,
  fill: { color: "FFFFFF" }, rectRadius: 0.1
});

// 阴影
slide.addShape(pres.shapes.RECTANGLE, {
  x: 1, y: 1, w: 3, h: 2,
  fill: { color: "FFFFFF" },
  shadow: { type: "outer", color: "000000", blur: 6, offset: 2, angle: 135, opacity: 0.15 }
});
```

阴影选项：

| 属性      | 类型   | 范围                         | 说明 |
| --------- | ------ | ---------------------------- | ---- |
| `type`    | string | `"outer"`、`"inner"`         |      |
| `color`   | string | 6 位十六进制，如 `"000000"`  | 不要 `#` 前缀，不要 8 位色——见「常见陷阱」 |
| `blur`    | number | 0–100 pt                     |      |
| `offset`  | number | 0–200 pt                     | **必须非负**——负值会损坏文件 |
| `angle`   | number | 0–359 度                     | 阴影方向（135 = 右下，270 = 向上） |
| `opacity` | number | 0.0–1.0                      | 透明度用此项，不要写进颜色字符串 |

要让阴影向上（例如页脚条），用 `angle: 270` 且 `offset` 为正——**不要用负 offset**。

**说明：** 原生不支持渐变填充。请改用渐变图片作背景。

---

## 图片

### 图片来源

```javascript
// 本地路径
slide.addImage({ path: "images/chart.png", x: 1, y: 1, w: 5, h: 3 });

// URL
slide.addImage({ path: "https://example.com/image.jpg", x: 1, y: 1, w: 5, h: 3 });

// base64（更快，无磁盘 I/O）
slide.addImage({ data: "image/png;base64,iVBORw0KGgo...", x: 1, y: 1, w: 5, h: 3 });
```

### 图片选项

```javascript
slide.addImage({
  path: "image.png",
  x: 1, y: 1, w: 5, h: 3,
  rotate: 45,              // 0–359 度
  rounding: true,          // 圆形裁切
  transparency: 50,        // 0–100
  flipH: true,             // 水平翻转
  flipV: false,            // 垂直翻转
  altText: "Description",  // 无障碍说明
  hyperlink: { url: "https://example.com" }
});
```

### 图片缩放模式

```javascript
// 包含：放入区域内，保持比例
{ sizing: { type: 'contain', w: 4, h: 3 } }

// 覆盖：填满区域，保持比例（可能裁切）
{ sizing: { type: 'cover', w: 4, h: 3 } }

// 裁切：指定区域
{ sizing: { type: 'crop', x: 0.5, y: 0.5, w: 2, h: 2 } }
```

### 按宽高比计算尺寸

```javascript
const origWidth = 1978, origHeight = 923, maxHeight = 3.0;
const calcWidth = maxHeight * (origWidth / origHeight);
const centerX = (10 - calcWidth) / 2;

slide.addImage({ path: "image.png", x: centerX, y: 1.2, w: calcWidth, h: maxHeight });
```

### 支持格式

- **常用**：PNG、JPG、GIF（动图在 Microsoft 365 中可用）
- **SVG**：现代 PowerPoint / Microsoft 365 支持

---

## 图标

用 react-icons 生成 SVG，再栅格化为 PNG，兼容性最好。

### 准备

```javascript
const React = require("react");
const ReactDOMServer = require("react-dom/server");
const sharp = require("sharp");
const { FaCheckCircle, FaChartLine } = require("react-icons/fa");

function renderIconSvg(IconComponent, color = "#000000", size = 256) {
  return ReactDOMServer.renderToStaticMarkup(
    React.createElement(IconComponent, { color, size: String(size) })
  );
}

async function iconToBase64Png(IconComponent, color, size = 256) {
  const svg = renderIconSvg(IconComponent, color, size);
  const pngBuffer = await sharp(Buffer.from(svg)).png().toBuffer();
  return "image/png;base64," + pngBuffer.toString("base64");
}
```

### 加到幻灯片

```javascript
const iconData = await iconToBase64Png(FaCheckCircle, "#4472C4", 256);

slide.addImage({
  data: iconData,
  x: 1, y: 1, w: 0.5, h: 0.5  // 单位为英寸
});
```

**说明：** 栅格化建议 size ≥ 256，图标更清晰。`size` 控制导出分辨率；幻灯片上的显示大小由 `w`、`h`（英寸）决定。

### 图标库

安装：`npm install -g react-icons react react-dom sharp`

react-icons 常用包：
- `react-icons/fa` — Font Awesome
- `react-icons/md` — Material Design
- `react-icons/hi` — Heroicons
- `react-icons/bi` — Bootstrap Icons

---

## 幻灯片背景

```javascript
// 纯色
slide.background = { color: "F1F1F1" };

// 带透明度
slide.background = { color: "FF3399", transparency: 50 };

// URL 图片
slide.background = { path: "https://example.com/bg.jpg" };

// base64 图片
slide.background = { data: "image/png;base64,iVBORw0KGgo..." };
```

---

## 表格

```javascript
slide.addTable([
  ["Header 1", "Header 2"],
  ["Cell 1", "Cell 2"]
], {
  x: 1, y: 1, w: 8, h: 2,
  border: { pt: 1, color: "999999" }, fill: { color: "F1F1F1" }
});

// 合并单元格等高级用法
let tableData = [
  [{ text: "Header", options: { fill: { color: "6699CC" }, color: "FFFFFF", bold: true } }, "Cell"],
  [{ text: "Merged", options: { colspan: 2 } }]
];
slide.addTable(tableData, { x: 1, y: 3.5, w: 8, colW: [4, 4] });
```

---

## 图表

```javascript
// 柱状图
slide.addChart(pres.charts.BAR, [{
  name: "Sales", labels: ["Q1", "Q2", "Q3", "Q4"], values: [4500, 5500, 6200, 7100]
}], {
  x: 0.5, y: 0.6, w: 6, h: 3, barDir: 'col',
  showTitle: true, title: 'Quarterly Sales'
});

// 折线图
slide.addChart(pres.charts.LINE, [{
  name: "Temp", labels: ["Jan", "Feb", "Mar"], values: [32, 35, 42]
}], { x: 0.5, y: 4, w: 6, h: 3, lineSize: 3, lineSmooth: true });

// 饼图
slide.addChart(pres.charts.PIE, [{
  name: "Share", labels: ["A", "B", "Other"], values: [35, 45, 20]
}], { x: 7, y: 1, w: 5, h: 4, showPercent: true });
```

### 更美观的图表

默认样式偏旧。可叠加以下选项，得到更现代、干净的外观：

```javascript
slide.addChart(pres.charts.BAR, chartData, {
  x: 0.5, y: 1, w: 9, h: 4, barDir: "col",

  // 自定义颜色（与整稿配色一致）
  chartColors: ["0D9488", "14B8A6", "5EEAD4"],

  // 干净背景
  chartArea: { fill: { color: "FFFFFF" }, roundedCorners: true },

  // 柔和坐标轴标签色
  catAxisLabelColor: "64748B",
  valAxisLabelColor: "64748B",

  // 淡网格（仅数值轴）
  valGridLine: { color: "E2E8F0", size: 0.5 },
  catGridLine: { style: "none" },

  // 柱上数据标签
  showValue: true,
  dataLabelPosition: "outEnd",
  dataLabelColor: "1E293B",

  // 单系列时可隐藏图例
  showLegend: false,
});
```

**常用样式项：**
- `chartColors: [...]` — 系列/扇区用的十六进制色
- `chartArea: { fill, border, roundedCorners }` — 图表区域背景
- `catGridLine` / `valGridLine: { color, style, size }` — 网格线（`style: "none"` 隐藏）
- `lineSmooth: true` — 折线平滑
- `legendPos: "r"` — 图例位置：`"b"`、`"t"`、`"l"`、`"r"`、`"tr"`

---

## 幻灯片母版

```javascript
pres.defineSlideMaster({
  title: 'TITLE_SLIDE', background: { color: '283A5E' },
  objects: [{
    placeholder: { options: { name: 'title', type: 'title', x: 1, y: 2, w: 8, h: 2 } }
  }]
});

let titleSlide = pres.addSlide({ masterName: "TITLE_SLIDE" });
titleSlide.addText("My Title", { placeholder: "title" });
```

---

## 常见陷阱

⚠️ 下列问题会导致文件损坏、显示异常或输出错误，务必避免。

1. **十六进制颜色不要加 `#`** — 会损坏文件
   ```javascript
   color: "FF0000"      // ✅ 正确
   color: "#FF0000"     // ❌ 错误
   ```

2. **不要把透明度写进 8 位颜色** — 如 `"00000020"` 会损坏文件。请用 `opacity`。
   ```javascript
   shadow: { type: "outer", blur: 6, offset: 2, color: "00000020" }          // ❌ 损坏文件
   shadow: { type: "outer", blur: 6, offset: 2, color: "000000", opacity: 0.12 }  // ✅ 正确
   ```

3. **列表用 `bullet: true`** — 禁止用「•」等 Unicode（会出现双重符号）

4. **数组项之间用 `breakLine: true`**，否则可能连成一行

5. **列表慎用 `lineSpacing`** — 易出现过大行距；可改用 `paraSpaceAfter`

6. **每次新建演示都要 `new pptxgen()`** — 不要复用实例

7. **不要跨调用复用同一个 options 对象** — PptxGenJS 会原地修改（如把 shadow 转成 EMU）。多处共用同一对象会让第二个形状数据错乱。
   ```javascript
   const shadow = { type: "outer", blur: 6, offset: 2, color: "000000", opacity: 0.15 };
   slide.addShape(pres.shapes.RECTANGLE, { shadow, ... });  // ❌ 第二次已是转换后的值
   slide.addShape(pres.shapes.RECTANGLE, { shadow, ... });

   const makeShadow = () => ({ type: "outer", blur: 6, offset: 2, color: "000000", opacity: 0.15 });
   slide.addShape(pres.shapes.RECTANGLE, { shadow: makeShadow(), ... });  // ✅ 每次新对象
   slide.addShape(pres.shapes.RECTANGLE, { shadow: makeShadow(), ... });
   ```

8. **装饰竖条不要配 `ROUNDED_RECTANGLE`** — 矩形条盖不住圆角。请用 `RECTANGLE`。
   ```javascript
   // ❌ 错误：竖条盖不住圆角
   slide.addShape(pres.shapes.ROUNDED_RECTANGLE, { x: 1, y: 1, w: 3, h: 1.5, fill: { color: "FFFFFF" } });
   slide.addShape(pres.shapes.RECTANGLE, { x: 1, y: 1, w: 0.08, h: 1.5, fill: { color: "0891B2" } });

   // ✅ 正确：用 RECTANGLE 对齐更干净
   slide.addShape(pres.shapes.RECTANGLE, { x: 1, y: 1, w: 3, h: 1.5, fill: { color: "FFFFFF" } });
   slide.addShape(pres.shapes.RECTANGLE, { x: 1, y: 1, w: 0.08, h: 1.5, fill: { color: "0891B2" } });
   ```

---

## 速查

- **形状**：RECTANGLE、OVAL、LINE、ROUNDED_RECTANGLE
- **图表**：BAR、LINE、PIE、DOUGHNUT、SCATTER、BUBBLE、RADAR
- **版式**：LAYOUT_16x9（10"×5.625"）、LAYOUT_16x10、LAYOUT_4x3、LAYOUT_WIDE
- **对齐**：`"left"`、`"center"`、`"right"`
- **图表数据标签位置**：`"outEnd"`、`"inEnd"`、`"center"`
