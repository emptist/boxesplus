# BoxesPlus - 完整演示：ASCII Boxes 对比
# 包含所有复杂图表的 PPTX 版本

PptxGenJS = require "pptxgenjs"
{ titleSlide, listSlide, cardSlide, tableSlide, quoteSlide, sectionSlide, chartSlide, THEME } = require "../api/boxesplus-artist.coffee"

pres = new PptxGenJS()

# ============ 封面 ============
titleSlide pres,
  title: "BoxesPlus 完整演示"
  subtitle: "ASCII Boxes 对比与流程图解决方案"
  gradient: "blue"

# ============ 目录 ============
listSlide pres,
  title: "演示内容"
  items: [
    "PDCA循环 - 流程图"
    "组织架构图 - 层级结构"
    "泳道图 - 多部门流程"
    "时间线 - 项目里程碑"
    "SWOT分析 - 矩阵图"
    "对比表格"
    "图表可视化"
  ]

# ============ 1. PDCA 循环 ============
sectionSlide pres,
  number: "1"
  title: "PDCA 循环"
  gradient: "purple"

# 原始 ASCII
slide = pres.addSlide()
slide.addText "1.1 ASCII 原始图", x: 0.5, y: 0.3, w: 9, h: 0.5, fontSize: 24, bold: true, color: THEME.primary
slide.addText "┌─────────────────────────────────────────┐\n│            PDCA循环                     │\n├─────────────────────────────────────────┤\n│         ┌──────────┐                   │\n│         │   PLAN   │                   │\n│         │   计划    │                   │\n│         └────┬─────┘                   │\n│              │                           │\n│              ▼                           │\n│    ┌─────────────────┐                 │\n│    │     DO         │                   │\n│    │     执行       │                   │\n│    └────────┬────────┘                 │\n│              │                           │\n│              ▼                           │\n│         ┌──────────┐                   │\n│         │   CHECK  │                   │\n│         │   检查    │                   │\n│         └────┬─────┘                   │\n│              │                           │\n│              ▼                           │\n│         ┌──────────┐                   │\n│         │   ACTION │                   │\n│         │   处理    │                   │\n│         └────┬─────┘                   │\n│              │                           │\n│              └───────────────────────────│\n│  特点：大环套小环，不断循环，持续改进    │\n└─────────────────────────────────────────┘",
  x: 0.3, y: 0.9, w: 9.4, h: 4.5, fontSize: 9, fontFace: "Courier New", color: "333333"

# PPTX 实现
cardSlide pres,
  title: "1.2 PPTX 实现 - 卡片组合"
  columns: 4
  cards: [
    { title: "PLAN\n计划", content: "分析现状\n找问题\n分析原因\n制定计划", color: THEME.accent }
    { title: "DO\n执行", content: "实施计划\n落实措施", color: THEME.success }
    { title: "CHECK\n检查", content: "检查效果\n发现问题", color: THEME.warning }
    { title: "ACTION\n处理", content: "总结经验\n标准化\n遗留问题入下轮", color: THEME.danger }
  ]

# ============ 2. 组织架构图 ============
sectionSlide pres,
  number: "2"
  title: "组织架构图"
  gradient: "purple"

# 原始 ASCII
slide = pres.addSlide()
slide.addText "2.1 ASCII 原始图", x: 0.5, y: 0.3, w: 9, h: 0.5, fontSize: 24, bold: true, color: THEME.primary
slide.addText "┌─────────────────────────────────────────┐\n│         各层级质量职责                  │\n├─────────────────────────────────────────┤\n│                                          │\n│  院级层面：                             │\n│  ├─ 制定质量方针目标                   │\n│  ├─ 配置资源保障                       │\n│  └─ 考核评价监督                       │\n│                                          │\n│  职能部门：                             │\n│  ├─ 落实质量制度                       │\n│  ├─ 日常监督检查                       │\n│  └─ 问题分析改进                       │\n│                                          │\n│  科室层面：                             │\n│  ├─ 执行诊疗规范                       │\n│  ├─ 科室自查自纠                       │\n│  └─ 持续改进提高                       │\n│                                          │\n└─────────────────────────────────────────┘",
  x: 0.3, y: 0.9, w: 9.4, h: 4.5, fontSize: 11, fontFace: "Courier New", color: "333333"

# PPTX 实现
tableSlide pres,
  title: "2.2 PPTX 实现 - 表格"
  headers: ["层级", "职责"]
  rows: [
    ["院级", "制定质量方针目标\n配置资源保障\n考核评价监督"]
    ["职能部门", "落实质量制度\n日常监督检查\n问题分析改进"]
    ["科室层面", "执行诊疗规范\n科室自查自纠\n持续改进提高"]
  ]

# ============ 3. 围手术期 ============
sectionSlide pres,
  number: "3"
  title: "围手术期流程"
  gradient: "purple"

# 原始 ASCII
slide = pres.addSlide()
slide.addText "3.1 ASCII 原始图", x: 0.5, y: 0.3, w: 9, h: 0.5, fontSize: 24, bold: true, color: THEME.primary
slide.addText "┌─────────────────────────────────────────┐\n│         围手术期安全管理                │\n├─────────────────────────────────────────┤\n│                                          │\n│  术前：                                 │\n│  ├─ 手术指征评估                       │\n│  ├─ 手术知情同意                       │\n│  ├─ 术前准备核查                       │\n│                                          │\n│  术中：                                 │\n│  ├─ 手术安全核查                       │\n│  ├─ 手术记录规范                       │\n│  ├─ 术中应急处理                       │\n│                                          │\n│  术后：                                 │\n│  ├─ 术后交接                           │\n│  ├─ 术后访视                           │\n│  └─ 并发症防治                         │\n│                                          │\n└─────────────────────────────────────────┘",
  x: 0.3, y: 0.9, w: 9.4, h: 4.5, fontSize: 11, fontFace: "Courier New", color: "333333"

# PPTX 实现
cardSlide pres,
  title: "3.2 PPTX 实现 - 卡片"
  columns: 3
  cards: [
    { title: "术前", content: "手术指征评估\n手术知情同意\n术前准备核查", color: THEME.accent }
    { title: "术中", content: "手术安全核查\n手术记录规范\n术中应急处理", color: THEME.success }
    { title: "术后", content: "术后交接\n术后访视\n并发症防治", color: THEME.warning }
  ]

# ============ 4. 不良事件闭环 ============
sectionSlide pres,
  number: "4"
  title: "不良事件闭环"
  gradient: "purple"

# 原始 ASCII
slide = pres.addSlide()
slide.addText "4.1 ASCII 原始图", x: 0.5, y: 0.3, w: 9, h: 0.5, fontSize: 24, bold: true, color: THEME.primary
slide.addText "┌─────────────────────────────────────────┐\n│         不良事件闭环管理                │\n├─────────────────────────────────────────┤\n│  ┌──────────┐                          │\n│  │  事件    │←─┐                       │\n│  │  报告    │  │                       │\n│  └────┬─────┘  │                       │\n│       │        │                       │\n│       ▼        │                       │\n│  ┌──────────┐  │                       │\n│  │  初步    │  │                       │\n│  │  调查    │  │                       │\n│  └────┬─────┘  │                       │\n│       │        │                       │\n│       ▼        │                       │\n│  ┌──────────┐  │                       │\n│  │  根本    │  │                       │\n│  │  原因    │──┘                       │\n│  │  分析    │                          │\n│  └────┬─────┘                          │\n│       │                                │\n│       ▼                                │\n│  ┌──────────┐                          │\n│  │  改进    │                          │\n│  │  措施    │                          │\n│  └────┬─────┘                          │\n│       │                                │\n│       ▼                                │\n│  ┌──────────┐                          │\n│  │  效果    │                          │\n│  │  评估    │                          │\n│  └────┬─────┘                          │\n│       │                                │\n│       ▼                                │\n│  ┌──────────┐                          │\n│  │  标准    │                          │\n│  │  化      │                          │\n│  └──────────┘                          │\n└─────────────────────────────────────────┘",
  x: 0.3, y: 0.9, w: 9.4, h: 4.5, fontSize: 9, fontFace: "Courier New", color: "333333"

# PPTX 实现
cardSlide pres,
  title: "4.2 PPTX 实现 - 卡片流程"
  columns: 3
  cards: [
    { title: "1.事件报告", content: "接收报告\n记录详情", color: THEME.accent }
    { title: "2.调查分析", content: "初步调查\n根因分析", color: THEME.success }
    { title: "3.改进措施", content: "制定措施\n落实执行", color: THEME.warning }
  ]

cardSlide pres,
  title: "4.3 PPTX 实现 - 继续"
  columns: 3
  cards: [
    { title: "4.效果评估", content: "评估效果\n验证有效性", color: THEME.accent }
    { title: "5.标准化", content: "制度规范化\n推广执行", color: THEME.success }
    { title: "6.持续改进", content: "PDCA循环\n不断提升", color: THEME.danger }
  ]

# ============ 5. 图表 ============
sectionSlide pres,
  number: "5"
  title: "图表可视化"
  gradient: "purple"

chartSlide pres,
  title: "5.1 趋势图 - LINE"
  type: "LINE"
  data: [
    { name: "病历甲级率", values: [75, 78, 82, 85, 88, 90], labels: ["2019", "2020", "2021", "2022", "2023", "2024"] }
  ]

chartSlide pres,
  title: "5.2 对比图 - BAR"
  type: "BAR"
  data: [
    { name: "内科", values: [85, 88, 92], labels: ["Q1", "Q2", "Q3"] }
    { name: "外科", values: [82, 85, 89] }
    { name: "妇产科", values: [90, 91, 93] }
  ]

chartSlide pres,
  title: "5.3 占比图 - PIE"
  type: "PIE"
  data: [
    { name: "收入", labels: ["内科", "外科", "妇产科", "其他"], values: [30, 35, 20, 15] }
  ]

# ============ 结束 ============
titleSlide pres,
  title: "谢谢!"
  subtitle: "BoxesPlus - 让 PPTX 更简单"
  gradient: "blue"

# ============ 保存 ============
pres.writeFile({ fileName: "outputs/complete-demo-all.pptx" })
  .then -> console.log "✅ Created: outputs/complete-demo-all.pptx"
  .catch (err) -> console.error err
