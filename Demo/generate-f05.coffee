# F05 数据资产管理 - 直接用 CoffeeScript 编写
# 用法: coffee Demo/generate-f05.coffee

PptxGenJS = require "pptxgenjs"
{ titleSlide, listSlide, cardSlide, tableSlide, quoteSlide, sectionSlide, chartSlide, THEME } = require "../api/boxesplus-artist.coffee"

pres = new PptxGenJS()

# ============ 封面 ============
titleSlide pres,
  title: "AI时代的数据资产管理"
  subtitle: "F05 数据资产管理课程"
  gradient: "blue"

# ============ 课程信息 ============
listSlide pres,
  title: "课程信息"
  items: [
    "课程名称：AI时代的数据资产管理"
    "课程定位：医院管理保障与支撑板块课程"
    "课程时长：12小时"
    "课程对象：院长、信息中心主任、医务部主任"
    "教学方法：理论讲授、案例分析、实操练习"
  ]

# ============ 课程目标 ============
cardSlide pres,
  title: "课程目标"
  columns: 3
  cards: [
    { title: "知识目标", content: "理解数据资产背景\n掌握管理方法\n了解合规要求", color: THEME.accent }
    { title: "能力目标", content: "规划数据管理\n推动数据应用\n防范合规风险", color: THEME.success }
    { title: "素质目标", content: "数据思维\n安全意识", color: THEME.warning }
  ]

# ============ 第一章：AI时代与数据资产 ============
sectionSlide pres,
  number: "第一章"
  title: "AI时代与数据资产"
  gradient: "green"

# 1.1 AI时代背景
sectionSlide pres,
  number: "1.1"
  title: "AI时代背景"
  gradient: "purple"

quoteSlide pres,
  quote: "数据是21世纪最重要的资产，数据驱动决策是医院管理的必然趋势。"
  author: "数据时代"

cardSlide pres,
  title: "AI时代特征"
  columns: 2
  cards: [
    { title: "数据爆发", content: "医疗数据呈指数增长", color: THEME.accent }
    { title: "计算能力", content: "算力大幅提升", color: THEME.success }
    { title: "算法突破", content: "AI算法日益成熟", color: THEME.warning }
    { title: "应用广泛", content: "场景不断拓展", color: THEME.danger }
  ]

# 1.2 医疗数据资产
sectionSlide pres,
  number: "1.2"
  title: "医疗数据资产"
  gradient: "purple"

tableSlide pres,
  title: "医疗数据类型"
  headers: ["数据类型", "内容"]
  rows: [
    ["诊疗数据", "病历、处方、检验报告"]
    ["运营数据", "门诊量、住院量、财务数据"]
    ["科研数据", "临床试验、研究数据"]
    ["影像数据", "X光、CT、MRI、超声"]
  ]

# ============ 第二章：数据资产管理 ============
sectionSlide pres,
  number: "第二章"
  title: "数据资产管理"
  gradient: "green"

# 2.1 数据治理框架
sectionSlide pres,
  number: "2.1"
  title: "数据治理框架"
  gradient: "purple"

cardSlide pres,
  title: "数据治理要素"
  columns: 2
  cards: [
    { title: "数据标准", content: "统一编码\n数据定义", color: THEME.accent }
    { title: "数据质量", content: "完整性\n准确性", color: THEME.success }
    { title: "数据安全", content: "隐私保护\n访问控制", color: THEME.warning }
    { title: "数据应用", content: "分析挖掘\n辅助决策", color: THEME.danger }
  ]

# 2.2 数据架构
tableSlide pres,
  title: "数据架构层次"
  headers: ["层次", "内容"]
  rows: [
    ["数据源层", "HIS、LIS、PACS、EMR"]
    ["数据仓库", "数据抽取、清洗、存储"]
    ["数据服务层", "API、数据接口"]
    ["应用层", "BI报表、数据大屏"]
  ]

# ============ 第三章：数据应用 ============
sectionSlide pres,
  number: "第三章"
  title: "数据应用创新"
  gradient: "green"

# 3.1 临床数据应用
cardSlide pres,
  title: "临床数据应用"
  columns: 2
  cards: [
    { title: "辅助诊断", content: "AI影像诊断\n临床决策支持", color: THEME.accent }
    { title: "风险预测", content: "疾病预测\n患者分型", color: THEME.success }
    { title: "疗效分析", content: "治疗效果评估\n药物反应", color: THEME.warning }
    { title: "精准医疗", content: "个性化治疗\n基因分析", color: THEME.danger }
  ]

# 3.2 运营数据应用
chartSlide pres,
  title: "运营数据分析"
  type: "LINE"
  data: [
    { name: "门诊量", values: [1000, 1100, 1250, 1300, 1450, 1600], labels: ["1月", "2月", "3月", "4月", "5月", "6月"] }
  ]

# 科室效率对比
chartSlide pres,
  title: "科室运营效率"
  type: "BAR"
  data: [
    { name: "内科", values: [85, 88, 92], labels: ["Q1", "Q2", "Q3"] }
    { name: "外科", values: [82, 85, 89] }
    { name: "妇产科", values: [90, 91, 95] }
  ]

# ============ 第四章：数据安全与合规 ============
sectionSlide pres,
  number: "第四章"
  title: "数据安全与合规"
  gradient: "green"

# 4.1 数据安全
listSlide pres,
  title: "数据安全措施"
  items: [
    "访问控制 - 权限分级管理"
    "数据加密 - 传输和存储加密"
    "审计日志 - 操作记录留痕"
    "备份恢复 - 定期备份演练"
  ]

# 4.2 合规要求
tableSlide pres,
  title: "数据合规要求"
  headers: ["法规", "要求"]
  rows: [
    ["个人信息保护法", "患者隐私保护"]
    ["数据安全法", "数据分类分级"]
    ["网络安全法", "网络安全防护"]
    [" HIPAA", "医疗数据跨境"]
  ]

# ============ 第五章：案例研讨 ============
sectionSlide pres,
  number: "第五章"
  title: "案例研讨"
  gradient: "green"

cardSlide pres,
  title: "案例：某医院数据治理实践"
  columns: 1
  cards: [
    { title: "背景", content: "数据分散、标准不一、难以整合", color: THEME.accent }
    { title: "做法", content: "建立数据标准、搭建数据仓库、实现数据共享", color: THEME.success }
    { title: "成效", content: "数据质量提升60%，报表效率提升80%", color: THEME.warning }
  ]

# ============ 图表展示 ============
chartSlide pres,
  title: "数据资产价值"
  type: "RADAR"
  data: [
    { name: "当前", labels: ["完整性", "准确性", "安全性", "可用性", "价值", "合规"], values: [65, 70, 80, 75, 60, 70] }
    { name: "目标", values: [90, 95, 95, 90, 85, 90] }
  ]

# 数据类型分布
chartSlide pres,
  title: "数据类型分布"
  type: "PIE"
  data: [
    { name: "占比", labels: ["诊疗数据", "影像数据", "运营数据", "科研数据"], values: [40, 30, 20, 10] }
  ]

# ============ 课程总结 ============
cardSlide pres,
  title: "核心要点"
  columns: 2
  cards: [
    { title: "数据思维", content: "重视数据\n数据驱动", color: THEME.accent }
    { title: "治理体系", content: "标准先行\n质量为本", color: THEME.success }
    { title: "创新应用", content: "临床+运营\nAI赋能", color: THEME.warning }
    { title: "安全合规", content: "保护隐私\n守住底线", color: THEME.danger }
  ]

# ============ 结束页 ============
titleSlide pres,
  title: "谢谢!"
  subtitle: "AI时代的数据资产管理"
  gradient: "blue"

# ============ 保存 ============
pres.writeFile({ fileName: "outputs/F05数据资产管理.pptx" })
  .then -> console.log "✅ Created: outputs/F05数据资产管理.pptx"
  .catch (err) -> console.error err
