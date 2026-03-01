# BoxesPlus - Mermaid Diagrams Reference
# Mermaid 图表代码参考

PptxGenJS = require "pptxgenjs"
{ titleSlide, listSlide, cardSlide, tableSlide, sectionSlide, THEME } = require "../api/boxesplus-artist.coffee"

pres = new PptxGenJS()

# ============ 封面 ============
titleSlide pres,
  title: "Mermaid 图表"
  subtitle: "diagram-as-code 可视化"
  gradient: "blue"

# ============ Mermaid 简介 ============
sectionSlide pres,
  number: "简介"
  title: "什么是 Mermaid?"
  gradient: "green"

listSlide pres,
  title: "Mermaid 特点"
  items: [
    "diagram-as-code - 用代码写图表"
    "声明式语法 - 简单易学"
    "实时渲染 - 所见即所得"
    "多种图表类型 - 流程图、序列图、类图等"
  ]

# ============ 1. 流程图 ============
sectionSlide pres,
  number: "1"
  title: "流程图 Flowchart"
  gradient: "purple"

cardSlide pres,
  title: "Mermaid 流程图语法"
  columns: 1
  cards: [
    { title: "代码", content: "graph TD\n    A[开始] --> B{判断}\n    B -->|是| C[处理1]\n    B -->|否| D[处理2]", color: THEME.accent }
  ]

cardSlide pres,
  title: "图形形状"
  columns: 2
  cards: [
    { title: "矩形 []", content: "节点文本", color: THEME.success }
    { title: "圆角 ()", content: "圆角矩形", color: THEME.warning }
    { title: "菱形 {}", content: "判断/条件", color: THEME.danger }
    { title: "圆柱 ()", content: "数据/数据库", color: THEME.accent }
  ]

listSlide pres,
  title: "方向"
  items: [
    "TB - 从上到下 (Top-Bottom)"
    "BT - 从下到上"
    "LR - 从左到右 (Left-Right)"
    "RL - 从右到左"
  ]

# ============ 2. 序列图 ============
sectionSlide pres,
  number: "2"
  title: "序列图 Sequence"
  gradient: "purple"

cardSlide pres,
  title: "Mermaid 序列图语法"
  columns: 1
  cards: [
    { title: "代码", content: "sequenceDiagram\n    A->>B: 消息\n    B-->>A: 响应", color: THEME.accent }
  ]

tableSlide pres,
  title: "序列图标记"
  headers: ["标记", "含义"]
  rows: [
    ["→>", "实线箭头(异步)"]
    ["-->>", "虚线箭头(返回)"]
    ["→", "实线(同步)"]
    ["--", "虚线(同步返回)"]
  ]

# ============ 3. 类图 ============
sectionSlide pres,
  number: "3"
  title: "类图 Class Diagram"
  gradient: "purple"

cardSlide pres,
  title: "Mermaid 类图语法"
  columns: 1
  cards: [
    { title: "代码", content: "classDiagram\n    Animal <|-- Duck\n    Animal <|-- Fish\n    class Animal { +name +eat() }", color: THEME.accent }
  ]

# ============ 4. 状态图 ============
sectionSlide pres,
  number: "4"
  title: "状态图 State"
  gradient: "purple"

cardSlide pres,
  title: "Mermaid 状态图语法"
  columns: 1
  cards: [
    { title: "代码", content: "stateDiagram-v2\n    [*] --> A\n    A --> B\n    B --> [*]", color: THEME.accent }
  ]

# ============ 5. ER图 ============
sectionSlide pres,
  number: "5"
  title: "ER 图"
  gradient: "purple"

cardSlide pres,
  title: "Mermaid ER图语法"
  columns: 1
  cards: [
    { title: "代码", content: "erDiagram\n    PATIENT ||--o{ VISIT : has\n    DOCTOR ||--o{ VISIT : conducts", color: THEME.accent }
  ]

# ============ 6. 饼图 ============
sectionSlide pres,
  number: "6"
  title: "饼图 Pie"
  gradient: "purple"

cardSlide pres,
  title: "Mermaid 饼图语法"
  columns: 1
  cards: [
    { title: "代码", content: "pie title 标题\n    \"A\" : 30\n    \"B\" : 70", color: THEME.accent }
  ]

# ============ 实际应用 ============
sectionSlide pres,
  number: "应用"
  title: "在 PPTX 中使用"
  gradient: "green"

listSlide pres,
  title: "工作流程"
  items: [
    "1. 用 Mermaid 写图表代码"
    "2. 用 Mermaid Live Editor 渲染"
    "3. 导出 PNG/SVG"
    "4. 用 imageSlide 嵌入 PPTX"
  ]

# 保存
pres.writeFile({ fileName: "outputs/demo-mermaid-ref.pptx" })
  .then -> console.log "✅ Created: outputs/demo-mermaid-ref.pptx"
  .catch (err) -> console.error err
