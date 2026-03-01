# BoxesPlus - ASCII Box vs PPTX Implementation Demo
# 对比：ASCII原始图 vs PPTX实现

PptxGenJS = require "pptxgenjs"
{ titleSlide, listSlide, cardSlide, tableSlide, THEME } = require "../api/boxesplus-artist.coffee"

pres = new PptxGenJS()

# ============ 封面 ============
titleSlide pres,
  title: "ASCII Boxes vs PPTX 实现对比"
  subtitle: "流程图/组织架构图解决方案"
  gradient: "blue"

# ============ 示例1: PDCA循环 ============
titleSlide pres,
  title: "示例1: PDCA循环"
  subtitle: "ASCII原始图"
  gradient: "purple"

# 原始ASCII - 作为文本显示
slide2 = pres.addSlide()
slide2.addText "PDCA循环 - ASCII原始图", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 24, bold: true, color: THEME.primary

asciiText = """
┌─────────────────────────────────────────┐
│            PDCA循环                     │
├─────────────────────────────────────────┤
│                                          │
│         ┌──────────┐                   │
│         │   PLAN   │                   │
│         │   计划    │                   │
│         └────┬─────┘                   │
│              │                           │
│              ▼                           │
│    ┌─────────────────┐                 │
│    │                 │                 │
│    │     DO         │                 │
│    │     执行       │                 │
│    │                 │                 │
│    └────────┬────────┘                 │
│              │                           │
│              ▼                           │
│         ┌──────────┐                   │
│         │   CHECK  │                   │
│         │   检查    │                   │
│         └────┬─────┘                   │
│              │                           │
│              ▼                           │
│         ┌──────────┐                   │
│         │   ACTION │                   │
│         │   处理    │                   │
│         └────┬─────┘                   │
│              │                           │
│              └───────────────────────────│
│                                          │
│  特点：大环套小环，不断循环，持续改进    │
│                                          │
└─────────────────────────────────────────┘
"""

slide2.addText asciiText,
  x: 0.5, y: 1, w: 9, h: 4.5
  fontSize: 10
  fontFace: "Courier New"
  color: "333333"

# PPTX实现
titleSlide pres,
  title: "示例1: PDCA循环"
  subtitle: "PPTX实现 - 使用形状组合"
  gradient: "purple"

# PDCA循环 - 使用卡片和箭头模拟
cardSlide pres,
  title: "PDCA循环"
  columns: 4
  cards: [
    { title: "PLAN\n计划", content: "分析现状\n找问题\n分析原因\n制定计划", color: THEME.accent }
    { title: "DO\n执行", content: "实施计划\n落实措施", color: THEME.success }
    { title: "CHECK\n检查", content: "检查效果\n发现问题", color: THEME.warning }
    { title: "ACTION\n处理", content: "总结经验\n标准化\n遗留问题入下轮", color: THEME.danger }
  ]

# ============ 示例2: 质量管理体系架构 ============
titleSlide pres,
  title: "示例2: 质量管理体系架构"
  subtitle: "ASCII原始图"
  gradient: "purple"

slide3 = pres.addSlide()
slide3.addText "质量管理体系架构 - ASCII原始图", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 24, bold: true, color: THEME.primary

asciiText2 = """
┌─────────────────────────────────────────┐
│         医疗质量管理体系架构             │
├─────────────────────────────────────────┤
│                                          │
│         ┌─────────────────┐            │
│         │   质量方针      │            │
│         │   质量目标      │            │
│         │   质量文化      │            │
│         └────────┬────────┘            │
│                  │                      │
│         ┌────────┴────────┐            │
│         │   质量组织      │            │
│         │   质量制度      │            │
│         │   质量流程      │            │
│         └────────┬────────┘            │
│                  │                      │
│         ┌────────┴────────┐            │
│         │   质量控制      │            │
│         │   质量保证      │            │
│         │   质量改进      │            │
│         └─────────────────┘            │
│                                          │
└─────────────────────────────────────────┘
"""

slide3.addText asciiText2,
  x: 0.5, y: 1, w: 9, h: 4.5
  fontSize: 10
  fontFace: "Courier New"
  color: "333333"

# PPTX实现
titleSlide pres,
  title: "示例2: 质量管理体系架构"
  subtitle: "PPTX实现"
  gradient: "purple"

# 使用卡片层级展示
cardSlide pres,
  title: "质量管理体系"
  columns: 1
  cards: [
    { title: "质量方针/目标/文化", content: "顶层设计，理念引领", color: THEME.primary }
  ]

cardSlide pres,
  title: "质量管理体系"
  columns: 1
  cards: [
    { title: "质量组织/制度/流程", content: "体系建设，基础保障", color: THEME.secondary }
  ]

cardSlide pres,
  title: "质量管理体系"
  columns: 1
  cards: [
    { title: "质量控制/保证/改进", content: "持续改进，追求卓越", color: THEME.accent }
  ]

# ============ 示例3: 组织架构 ============
titleSlide pres,
  title: "示例3: 组织架构图"
  subtitle: "ASCII原始图"
  gradient: "purple"

slide4 = pres.addSlide()
slide4.addText "组织架构 - ASCII原始图", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 24, bold: true, color: THEME.primary

asciiText3 = """
┌─────────────────────────────────────────┐
│         各层级质量职责                  │
├─────────────────────────────────────────┤
│                                          │
│  院级层面：                             │
│  ├─ 制定质量方针目标                   │
│  ├─ 配置资源保障                       │
│  └─ 考核评价监督                       │
│                                          │
│  职能部门：                             │
│  ├─ 落实质量制度                       │
│  ├─ 日常监督检查                       │
│  └─ 问题分析改进                       │
│                                          │
│  科室层面：                             │
│  ├─ 执行诊疗规范                       │
│  ├─ 科室自查自纠                       │
│  └─ 持续改进提高                       │
│                                          │
└─────────────────────────────────────────┘
"""

slide4.addText asciiText3,
  x: 0.5, y: 1, w: 9, h: 4.5
  fontSize: 10
  fontFace: "Courier New"
  color: "333333"

# PPTX实现 - 使用表格
titleSlide pres,
  title: "示例3: 组织架构"
  subtitle: "PPTX实现 - 使用表格"
  gradient: "purple"

tableSlide pres,
  title: "各层级质量职责"
  headers: ["层级", "职责"]
  rows: [
    ["院级", "制定质量方针目标\n配置资源保障\n考核评价监督"]
    ["职能部门", "落实质量制度\n日常监督检查\n问题分析改进"]
    ["科室层面", "执行诊疗规范\n科室自查自纠\n持续改进提高"]
  ]

# ============ 示例4: 流程图 - 围手术期 ============
titleSlide pres,
  title: "示例4: 围手术期流程"
  subtitle: "ASCII原始图"
  gradient: "purple"

slide5 = pres.addSlide()
slide5.addText "围手术期流程 - ASCII原始图", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 24, bold: true, color: THEME.primary

asciiText4 = """
┌─────────────────────────────────────────┐
│         围手术期安全管理                │
├─────────────────────────────────────────┤
│                                          │
│  术前：                                 │
│  ├─ 手术指征评估                       │
│  ├─ 手术知情同意                       │
│  ├─ 术前准备核查                       │
│                                          │
│  术中：                                 │
│  ├─ 手术安全核查                       │
│  ├─ 手术记录规范                       │
│  ├─ 术中应急处理                       │
│                                          │
│  术后：                                 │
│  ├─ 术后交接                           │
│  ├─ 术后访视                           │
│  └─ 并发症防治                         │
│                                          │
└─────────────────────────────────────────┘
"""

slide5.addText asciiText4,
  x: 0.5, y: 1, w: 9, h: 4.5
  fontSize: 10
  fontFace: "Courier New"
  color: "333333"

# PPTX实现
titleSlide pres,
  title: "示例4: 围手术期流程"
  subtitle: "PPTX实现"
  gradient: "purple"

cardSlide pres,
  title: "围手术期管理"
  columns: 3
  cards: [
    { title: "术前", content: "手术指征评估\n手术知情同意\n术前准备核查", color: THEME.accent }
    { title: "术中", content: "手术安全核查\n手术记录规范\n术中应急处理", color: THEME.success }
    { title: "术后", content: "术后交接\n术后访视\n并发症防治", color: THEME.warning }
  ]

# ============ 示例5: 不良事件闭环 ============
titleSlide pres,
  title: "示例5: 不良事件闭环管理"
  subtitle: "ASCII原始图"
  gradient: "purple"

slide6 = pres.addSlide()
slide6.addText "不良事件闭环 - ASCII原始图", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 24, bold: true, color: THEME.primary

asciiText5 = """
┌─────────────────────────────────────────┐
│         不良事件闭环管理                │
├─────────────────────────────────────────┤
│                                          │
│  ┌──────────┐                          │
│  │  事件    │←─┐                       │
│  │  报告    │  │                       │
│  └────┬─────┘  │                       │
│       │        │                       │
│       ▼        │                       │
│  ┌──────────┐  │                       │
│  │  初步    │  │                       │
│  │  调查    │  │                       │
│  └────┬─────┘  │                       │
│       │        │                       │
│       ▼        │                       │
│  ┌──────────┐  │                       │
│  │  根本    │  │                       │
│  │  原因    │──┘                       │
│  │  分析    │                          │
│  └────┬─────┘                          │
│       │                                │
│       ▼                                │
│  ┌──────────┐                          │
│  │  改进    │                          │
│  │  措施    │                          │
│  └────┬─────┘                          │
│       │                                │
│       ▼                                │
│  ┌──────────┐                          │
│  │  效果    │                          │
│  │  评估    │                          │
│  └────┬─────┘                          │
│       │                                │
│       ▼                                │
│  ┌──────────┐                          │
│  │  标准    │                          │
│  │  化      │                          │
│  └──────────┘                          │
│                                          │
└─────────────────────────────────────────┘
"""

slide6.addText asciiText5,
  x: 0.5, y: 1, w: 9, h: 4.5
  fontSize: 10
  fontFace: "Courier New"
  color: "333333"

# PPTX实现 - 卡片流程
titleSlide pres,
  title: "示例5: 不良事件闭环"
  subtitle: "PPTX实现"
  gradient: "purple"

cardSlide pres,
  title: "不良事件闭环管理"
  columns: 3
  cards: [
    { title: "1.事件报告", content: "接收报告\n记录详情", color: THEME.accent }
    { title: "2.调查分析", content: "初步调查\n根因分析", color: THEME.success }
    { title: "3.改进措施", content: "制定措施\n落实执行", color: THEME.warning }
  ]

cardSlide pres,
  title: "不良事件闭环管理"
  columns: 3
  cards: [
    { title: "4.效果评估", content: "评估效果\n验证有效性", color: THEME.accent }
    { title: "5.标准化", content: "制度规范化\n推广执行", color: THEME.success }
    { title: "6.持续改进", content: "PDCA循环\n不断提升", color: THEME.danger }
  ]

# ============ 保存 ============
pres.writeFile({ fileName: "outputs/demo-ascii-vs-pptx.pptx" })
  .then -> console.log "✅ Created: outputs/demo-ascii-vs-pptx.pptx"
  .catch (err) -> console.error err
