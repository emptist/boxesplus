# C01 医疗质量与安全管理课程 PPTX 生成
# 使用 BoxesPlus API

PptxGenJS = require "pptxgenjs"
{ 
  titleSlide, listSlide, cardSlide, tableSlide, quoteSlide, 
  chartSlide, sectionSlide, THEME
} = require "../api/boxesplus-artist.coffee"

pres = new PptxGenJS()

# ============ 封面 ============
titleSlide pres,
  title: "医院医疗质量与安全管理"
  subtitle: "课程详细教案"
  gradient: "blue"

# ============ 课程信息 ============
listSlide pres,
  title: "课程信息"
  items: [
    "课程名称：医院医疗质量与安全管理"
    "课程定位：医院管理核心模块课程"
    "课程时长：12小时（2天）"
    "课程对象：医院院长、分管副院长、质控部主任等"
    "教学方法：理论讲授，方法演练、案例分析"
  ]

# ============ 课程目标 ============
cardSlide pres,
  title: "课程目标"
  columns: 3
  cards: [
    { 
      title: "知识目标" 
      content: "掌握质量管理体系\n熟悉管理工具\n了解安全目标" 
      color: THEME.accent 
    }
    { 
      title: "能力目标" 
      content: "建立质量管理体系\n运用管理工具\n处理安全事件" 
      color: THEME.success 
    }
    { 
      title: "素质目标" 
      content: "培养安全意识\n提升管理能力" 
      color: THEME.warning 
    }
  ]

# ============ 知识目标详情 ============
listSlide pres,
  title: "知识目标"
  items: [
    "掌握医疗质量管理体系的构成"
    "熟悉质量管理工具与方法"
    "了解患者安全目标与措施"
  ]

# ============ 能力目标详情 ============
listSlide pres,
  title: "能力目标"
  items: [
    "能够建立质量管理体系"
    "能够运用质量管理工具"
    "能够处理质量安全事件"
  ]

# ============ 素质目标详情 ============
listSlide pres,
  title: "素质目标"
  items: [
    "培养质量安全意识"
    "提升质量管理能力"
  ]

# ============ 章节：医疗质量管理概述 ============
sectionSlide pres,
  number: "第一章"
  title: "医疗质量管理概述"
  gradient: "green"

# ============ 教学目标 ============
listSlide pres,
  title: "第一章 教学目标"
  items: [
    "理解医疗质量概念"
    "认识质量管理体系"
    "了解发展趋势"
  ]

# ============ 1.1 医疗质量概念 ============
sectionSlide pres,
  number: "1.1"
  title: "医疗质量概念"
  gradient: "purple"

# 医疗质量内涵 - 作为 quote
quoteSlide pres,
  quote: "医疗质量是指医疗服务在满足患者及其家属健康需求方面所达到的程度，包括医疗技术质量和服务质量。"
  author: "定义"

# 狭义 vs 广义
cardSlide pres,
  title: "医疗质量内涵"
  columns: 2
  cards: [
    { 
      title: "狭义" 
      content: "诊疗质量" 
      color: THEME.accent 
    }
    { 
      title: "广义" 
      content: "技术+服务+管理+环境" 
      color: THEME.success 
    }
  ]

# 质量维度表格
tableSlide pres,
  title: "医疗质量维度"
  headers: ["维度", "内容"]
  rows: [
    ["结构质量", "人员、设备、制度、环境"]
    ["过程质量", "诊疗流程、操作规范"]
    ["结果质量", "诊疗效果、患者结局"]
  ]

# ============ 1.2 医疗质量管理体系 ============
sectionSlide pres,
  number: "1.2"
  title: "医疗质量管理体系"
  gradient: "purple"

# 管理体系要素
cardSlide pres,
  title: "质量管理体系要素"
  columns: 2
  cards: [
    { title: "组织架构", content: "质量管理委员会\n科室质控小组", color: THEME.accent }
    { title: "制度体系", content: "质量管理制度\n操作规范流程", color: THEME.success }
    { title: "监测评价", content: "指标监测\n定期评价", color: THEME.warning }
    { title: "持续改进", content: "PDCA循环\n质量改进项目", color: THEME.danger }
  ]

# ============ 图表展示 - 质量指标趋势 ============
chartSlide pres,
  title: "质量指标趋势"
  type: "LINE"
  data: [
    { 
      name: "病历甲级率"
      values: [75, 78, 82, 85, 88, 90]
      labels: ["2019", "2020", "2021", "2022", "2023", "2024"]
    }
  ]

# 科室对比
chartSlide pres,
  title: "科室质量评分对比"
  type: "BAR"
  data: [
    { name: "内科", values: [85, 88, 92], labels: ["Q1", "Q2", "Q3"] }
    { name: "外科", values: [82, 85, 89] }
    { name: "妇产科", values: [90, 91, 93] }
  ]

# ============ 结束页 ============
titleSlide pres,
  title: "谢谢!"
  subtitle: "医院医疗质量与安全管理"
  gradient: "blue"

# ============ 保存 ============
pres.writeFile({ fileName: "outputs/C01医疗质量与安全管理.pptx" })
  .then -> console.log "✅ Created: outputs/C01医疗质量与安全管理.pptx"
  .catch (err) -> console.error err
