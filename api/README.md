# BoxesPlus API
# 简单易用的 PPTX 生成库 (基于 CoffeeScript + PptxGenJS)

## 快速开始

```coffee
PptxGenJS = require "pptxgenjs"
{ titleSlide, listSlide, cardSlide, tableSlide, chartSlide, THEME } = require "./api/boxesplus-artist.coffee"

pres = new PptxGenJS()

titleSlide pres, title: "我的演示", subtitle: "副标题"

listSlide pres, title: "目录", items: ["第一项", "第二项"]

cardSlide pres, title: "卡片", cards: [{ title: "标题", content: "内容", color: THEME.accent }]

chartSlide pres, title: "图表", type: "BAR", data: [{ name: "系列", values: [10,20,30] }]

pres.writeFile({ fileName: "output.pptx" })
```

## API 函数

### 幻灯片函数

| 函数 | 用途 |
|------|------|
| `titleSlide(pres, opts)` | 标题页 |
| `listSlide(pres, opts)` | 列表页 |
| `cardSlide(pres, opts)` | 卡片/网格页 |
| `tableSlide(pres, opts)` | 表格页 |
| `quoteSlide(pres, opts)` | 引言页 |
| `comparisonSlide(pres, opts)` | 对比页 |
| `timelineSlide(pres, opts)` | 时间线页 |
| `endSlide(pres, opts)` | 结束页 |
| `sectionSlide(pres, opts)` | 章节/节次页 |
| `chartSlide(pres, opts)` | 通用图表页 |
| `imageSlide(pres, opts)` | 图片页 |
| `mediaSlide(pres, opts)` | 视频/音频页 |
| `defineMaster(pres, opts)` | 定义幻灯片母版 |
| `masterSlide(pres, opts)` | 使用母版创建幻灯片 |

### 图表类型

```coffee
chartSlide pres, title: "图表", type: "BAR", data: [...]
chartSlide pres, title: "图表", type: "LINE", data: [...]
chartSlide pres, title: "图表", type: "PIE", data: [...]
chartSlide pres, title: "图表", type: "RADAR", data: [...]
chartSlide pres, title: "图表", type: "DOUGHNUT", data: [...]
chartSlide pres, title: "图表", type: "SCATTER", data: [...]
```

### 主题颜色

```coffee
THEME.primary   # "1a365d"
THEME.accent   # "3182ce"
THEME.success  # "38a169"
THEME.warning  # "d69se2e"
THEME.danger   # "e53e3e"
THEME.light    # "f7fafc"
THEME.dark     # "1a202c"
```

### 参数说明

#### titleSlide
```coffee
titleSlide pres,
  title: "标题"
  subtitle: "副标题"
  gradient: "blue" | "green" | "purple"
```

#### listSlide
```coffee
listSlide pres,
  title: "标题"
  items: ["项1", "项2", "项3"]
```

#### cardSlide
```coffee
cardSlide pres,
  title: "标题"
  columns: 2  # 列数
  cards: [
    { title: "卡片1", content: "内容", color: THEME.accent }
    { title: "卡片2", content: "内容", color: THEME.success }
  ]
```

#### tableSlide
```coffee
tableSlide pres,
  title: "标题"
  headers: ["列1", "列2", "列3"]
  rows: [
    ["行1", "数据", "数据"]
    ["行2", "数据", "数据"]
  ]
```

#### chartSlide
```coffee
chartSlide pres,
  title: "图表标题"
  subtitle: "副标题"
  type: "BAR"  # BAR, LINE, PIE, RADAR, DOUGHNUT, SCATTER
  data: [
    { name: "系列1", values: [10, 20, 30], labels: ["A", "B", "C"] }
    { name: "系列2", values: [15, 25, 35] }
  ]
```

#### imageSlide
```coffee
imageSlide pres,
  title: "图片标题"
  path: "./images/chart.png"
  x: 0.5, y: 1, w: 9, h: 4
```

#### mediaSlide
```coffee
mediaSlide pres,
  title: "视频标题"
  path: "./video.mp4"
  type: "video"  # or "audio"
  x: 1, y: 1, w: 8, h: 4
```

#### defineMaster + masterSlide
```coffee
# Define master
defineMaster pres,
  name: "MyMaster"
  background: { color: THEME.primary }
  objects: [
    { placeholder: { options: { name: "title", type: "title", x: 0.5, y: 0.3, w: 9, h: 0.8, fontSize: 32 } } }
    { placeholder: { options: { name: "body", type: "body", x: 0.5, y: 1.3, w: 9, h: 4 } } }
  ]

# Use master
masterSlide pres,
  masterName: "MyMaster"
  title: "标题"
  body: "正文内容"
```

## 运行 Demo

```bash
cd boxesplus
coffee Demo/demo-artist.coffee      # 基础演示
coffee Demo/demo-generic-chart.coffee  # 图表演示
```

## 文件结构

```
boxesplus/
├── api/
│   ├── boxesplus-artist.coffee   # 核心 API
│   └── boxesplus-api.coffee     # 旧版 DSL
├── Demo/
│   ├── demo-artist.coffee        # 基础演示
│   └── demo-generic-chart.coffee # 图表演示
├── md_sources/                   # 示例 Markdown
└── outputs/                      # 生成的 PPTX
```
