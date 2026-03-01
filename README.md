# BoxesPlus - CoffeeScript 驱动演示文稿

## 核心理念

> **CoffeeScript 让写幻灯片像写诗一样自然**

```coffee
课程 = 
  title: "医院品牌建设"
  slides: [
    { type: "title", title: "封面" }
    { type: "cards", title: "目标", cards: [...] }
    { type: "pdca" }
    { type: "swot", strengths: [...], weaknesses: [...] }
    { type: "flowchart", steps: [...] }
    { type: "timeline", events: [...] }
    { type: "end" }
  ]

generateHtml 课程, "output.html"
```

## 快速开始

```bash
cd boxesplus
coffee api/elegant.coffee
open outputs/elegant-demo.html
```

## 工作流

```
编写 CoffeeScript → 生成 Reveal.js HTML → 导出 PDF/PPTX
```

### 本地预览

```bash
# 有网络 - 直接双击打开
open outputs/xxx.html

# 无网络 - 用本地服务器
coffee serve.coffee outputs/xxx.html
```

### 导出 PDF

```bash
coffee api/reveal-to-pdf.coffee outputs/xxx.html outputs/xxx.pdf
```

## 极简 API

### 数据格式

```coffee
课程 = 
  title: "课程标题"
  subtitle: "副标题"
  slides: [
    # 组件...
  ]
```

### 组件列表

| 组件 | 写法 | 说明 |
|------|------|------|
| 封面 | `{ type: "title", title: "标题", subtitle: "副标题" }` | 标题页 |
| 章节 | `{ type: "section", title: "章节标题", subtitle: "副标题" }` | 章节分隔页 |
| 结束 | `{ type: "end", title: "谢谢!" }` | 结束页 |
| 卡片 | `{ type: "cards", title: "标题", cards: [...] }` | 卡片网格 |
| 列表 | `{ type: "list", title: "标题", items: [...] }` | 列表 |
| PDCA | `{ type: "pdca", title: "标题" }` | PDCA循环图 |
| SWOT | `{ type: "swot", title: "标题", strengths: [...], weaknesses: [...], opportunities: [...], threats: [...] }` | SWOT分析 |
| 流程图 | `{ type: "flowchart", title: "标题", steps: [...] }` | 流程步骤 |
| 时间线 | `{ type: "timeline", title: "标题", events: [...] }` | 时间线 |
| 组织架构 | `{ type: "org", title: "标题", levels: [...] }` | 组织结构 |
| 对比表 | `{ type: "comparison", title: "标题", headers: [...], rows: [...] }` | 对比表格 |
| 金句 | `{ type: "quote", title: "标题", quote: "引用", author: "作者" }` | 引用页 |

### 组件详情

#### cards（卡片）
```coffee
{ type: "cards", title: "课程目标", cards: [
  { title: "知识目标", content: "掌握XX理论", color: "#ebf8ff" }
  { title: "能力目标", content: "运用XX工具", color: "#f0fff4" }
  { title: "素质目标", content: "培养XX意识", color: "#fffaf0" }
]}
```

#### swot（SWOT分析）
```coffee
{ type: "swot", title: "SWOT分析",
  strengths: ["优势1", "优势2"]
  weaknesses: ["劣势1", "劣势2"]
  opportunities: ["机会1", "机会2"]
  threats: ["威胁1", "威胁2"]
}
```

#### flowchart（流程图）
```coffee
{ type: "flowchart", title: "流程", steps: [
  { text: "步骤1", color: "#3182ce" }
  { text: "步骤2", color: "#38a169" }
  { text: "步骤3", color: "#d69e2e" }
]}
```

#### timeline（时间线）
```coffee
{ type: "timeline", title: "时间线", events: [
  { title: "第一阶段", desc: "描述", color: "#3182ce" }
  { title: "第二阶段", desc: "描述", color: "#38a169" }
]}
```

#### org（组织架构）
```coffee
{ type: "org", title: "组织架构", levels: [
  { text: "院长", color: "#1a365d" }
  { text: ["副院长1", "副院长2"], color: "#2b6cb0" }
  { text: ["科室1", "科室2", "科室3"], color: "#3182ce" }
]}
```

#### comparison（对比表格）
```coffee
{ type: "comparison", title: "对比",
  headers: ["维度", "方案A", "方案B"],
  rows: [
    ["优点", "免费", "收费"]
    ["缺点", "功能少", "功能全"]
  ]
}
```

## CoffeeScript 极简写法

```coffee
# 不用引号（键名）
title: "标题"

# 不用大括号（对象）
type: "cards"
cards: [
  { title: "A", content: "内容", color: "#fff" }
  { title: "B", content: "内容", color: "#fff" }
]

# 数组换行不用逗号
items: [
  "第一项"
  "第二项"
  "第三项"
]
```

## 文件结构

```
boxesplus/
├── api/
│   ├── elegant.coffee           # 核心 API
│   ├── chart-components.coffee  # 组件库
│   ├── reveal-to-pdf.coffee   # HTML → PDF
│   └── serve.coffee            # 本地服务器
├── Demo/
│   └── generate-*.coffee       # 课程生成
├── outputs/                    # 生成的演示
└── test-*.coffee              # 测试文件
```

## 示例

```bash
# 运行示例
coffee api/elegant.coffee
# 输出: outputs/elegant-demo.html

# 快速测试
coffee test-course.coffee
# 输出: outputs/test-elegant-course.html
```
