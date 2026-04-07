# EAP PPT Template Skill

基于 `eap-ppt-template.pptx` 模板的样式规范，用于创建企业介绍PPT。

---

## 模板基本信息

| 项目 | 值 |
|------|-----|
| 幻灯片尺寸 | 12192000 × 6858000 EMUs (16:9) |
| 主题名称 | 易普斯公司介绍ppt配色 |
| 幻灯片数量 | 104 页 |

---

## 配色方案

| 颜色角色 | HEX值 | 用途 |
|---------|-------|------|
| **primary** (dk1) | `ED6D34` | 橙色，品牌主色 |
| **bg** (lt1) | `FBFBFB` | 近白色背景 |
| **text** (dk2) | `333333` | 深灰色正文 |
| **secondary** (lt2) | `F7A32A` | 金橙色强调 |
| **accent1** | `ED6D34` | 橙色（同主色） |
| **accent2** | `F7A32A` | 金橙色 |
| **accent3** | `73A05E` | 绿色，图表/图标 |
| **accent4** | `394E92` | 蓝色，图表/图标 |
| **accent5** | `FFFFFF` | 纯白色 |
| **accent6** | `D8D8D8` | 浅灰色 |
| hyperlink | `FF0000` | 红色超链接 |
| followed hyperlink | `3EBBF0` | 浅蓝色 |

---

## 字体系统

### 嵌入字体

| 字体 | 用途 |
|------|------|
| OPPOSans B | 中文标题粗体 |
| OPPOSans H | 中文标题 |
| OPPOSans L | 中文细体 |
| OPPOSans M | 中文中黑 |
| OPPOSans R | 中文常规 |
| 微软雅黑 | 中文后备 |
| Arial | 英文 |
| Barlow Medium | 英文 |

### 字体使用规范

| 元素 | 中文字体 | 英文字体 |
|------|----------|----------|
| 页面标题 | OPPOSans B | Arial |
| 正文 | OPPOSans R | Arial |
| 页眉标签 | OPPOSans M | Arial |
| 页脚/页码 | OPPOSans M | Arial |

---

## 文本样式

| 元素 | 字号 | 字重 | 颜色 | 行距 | 对齐 |
|------|------|------|------|------|------|
| **页面标题** | 20pt | Bold | `333333` | 90% | 左对齐 |
| **正文 Level 1** | 28pt | Normal | `333333` | 90% | 左对齐 |
| **正文 Level 2** | 24pt | Normal | `333333` | 90% | 左对齐 |
| **正文 Level 3** | 20pt | Normal | `333333` | 90% | 左对齐 |
| **正文 Level 4+** | 18pt | Normal | `333333` | 90% | 左对齐 |
| **幻灯片编号** | 10.5pt | Normal | `D8D8D8` | - | 居中 |
| **页眉标签** | 9pt | Normal | 75%亮度 | 300 | 左对齐 |

---

## 页面布局规范

### 固定元素位置 (EMUs)

```
幻灯片编号: x=11733112, y=6492875  (右下角)
Logo位置:   x=495758,    y=423108   (左上角)
页眉标签:   x=2009036,  y=366423   (标题左侧)
企业标识:   x=10317291, y=456248   (右上角)
```

### 尺寸换算

- 1 inch = 914400 EMUs
- 幻灯片宽度 12192000 EMUs ≈ 13.33 inches ≈ 33.867 cm
- 幻灯片高度 6858000 EMUs ≈ 7.5 inches ≈ 19.05 cm

### 边距

- 最小边距: 0.5 inch (457200 EMUs)

---

## 章节结构

| 章节 | 幻灯片数 | 内容 |
|------|----------|------|
| 封面 | 2 | 标题页 |
| 关于我们 | 13 | 公司介绍 |
| 产品介绍 | 52 | 产品详情 |
| 案例分享 | 27 | 客户案例 |

---

## 布局类型

### 1. 封面布局 (Cover)
- 全屏背景图
- 居中大标题
- 页码右下角

### 2. 白色背景内容页 (White Background)
- 白色/近白色背景
- 左上: Logo
- 左侧: 中文标题(20pt粗体) + 英文大写标签(9pt)
- 右上: 企业标识
- 右下: 页码
- 内容区: 居左

### 3. 图片网格布局 (Image Grid)
- 白色背景
- 左上: Logo
- 标题区: 左侧
- 内容区: 3列等宽图片
- 右下: 页码

### 4. 空白背景布局 (Blank)
- 仅背景图 + 页码
- 适用于自定义内容

---

## 元素制作规范

### Logo
```
尺寸: 485075 × 263219 EMUs
位置: x=495758, y=423108
```

### 页码
```
字号: 10.5pt (1050)
颜色: D8D8D8
字体: OPPOSans M
位置: x=11733112, y=6492875
格式: ‹#› (自动编号)
```

### 标题区块
```
中文标题:
  字号: 20pt (2000)
  字体: OPPOSans B
  颜色: 333333
  位置: x=946042, y=385200

英文标签:
  字号: 9pt (900)
  字体: OPPOSans M
  颜色: 75%亮度 (灰色)
  格式: 全大写 (如 "ABOUT US")
```

### 图片占位符
```
单列宽度: 约 3400000 EMUs
列间距: 约 200000 EMUs
位置: 根据布局排列
```

---

## 配色使用建议

### 主色调
```javascript
primary: "ED6D34"    // 橙色，用于强调、按钮、图标
secondary: "F7A32A"  // 金橙色，用于次要强调
```

### 背景
```javascript
bgWhite: "FBFBFB"    // 近白色，用于内容页背景
bgDark: "333333"     // 深色，用于封面/结尾页
```

### 文字
```javascript
textDark: "333333"   // 深灰，用于正文
textLight: "FFFFFF"   // 白色，用于深色背景
textMuted: "D8D8D8"  // 浅灰，用于辅助信息
```

### 图表配色
```javascript
chartGreen: "73A05E"  // 绿色
chartBlue: "394E92"   // 蓝色
```

---

## 排版规范

### 字号层级
- 大标题: 36-44pt
- 页面标题: 20pt
- 章节标题: 18-20pt
- 正文: 14-16pt (中文28pt效果相当)
- 辅助文字: 10-12pt

### 行距
- 标准行距: 1.5倍 (或 90%)
- 段前间距: 0
- 段后间距: 8-10pt

### 对齐
- 标题: 左对齐
- 正文: 左对齐
- 页码: 居中

---

## 快速参考

```yaml
# 基础配置
slide_width: 12192000
slide_height: 6858000
margin: 914400  # 0.5"

# 颜色
primary: "ED6D34"
secondary: "F7A32A"
text: "333333"
bg: "FBFBFB"

# 字体
title_font: "OPPOSans B"
body_font: "OPPOSans R"

# 元素位置
logo_pos: [495758, 423108]
title_pos: [946042, 385200]
pagenum_pos: [11733112, 6492875]
```

---

## 使用示例

### 创建白色背景内容页

```javascript
const slide = {
  width: 12192000,
  height: 6858000,
  background: { color: "FBFBFB" },
  elements: [
    {
      type: "image",
      src: "logo.png",
      position: { x: 495758, y: 423108 },
      size: { width: 485075, height: 263219 }
    },
    {
      type: "text",
      content: "关于我们",
      font: "OPPOSans B",
      size: 2000,
      color: "333333",
      position: { x: 946042, y: 385200 }
    },
    {
      type: "text",
      content: "ABOUT US",
      font: "OPPOSans M",
      size: 900,
      color: "999999",
      position: { x: 2009036, y: 366423 }
    },
    {
      type: "text",
      content: "‹#›",
      font: "OPPOSans M",
      size: 1050,
      color: "D8D8D8",
      position: { x: 11733112, y: 6492875 }
    }
  ]
};
```
