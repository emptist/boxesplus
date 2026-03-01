# E02 品牌建设课程 - 直接用 CoffeeScript 编写
# 用法: coffee Demo/generate-e02.coffee

PptxGenJS = require "pptxgenjs"
{ titleSlide, listSlide, cardSlide, tableSlide, quoteSlide, sectionSlide, chartSlide, THEME } = require "../api/boxesplus-artist.coffee"

pres = new PptxGenJS()

# ============ 封面 ============
titleSlide pres,
  title: "医院品牌建设与传播管理"
  subtitle: "E02 品牌建设课程"
  gradient: "blue"

# ============ 课程信息 ============
listSlide pres,
  title: "课程信息"
  items: [
    "课程名称：医院品牌建设与传播管理"
    "课程定位：医院管理核心模块课程"
    "课程时长：12小时（2天）"
    "课程对象：院长、书记、品牌部门负责人"
    "教学方法：理论讲授、案例分析、实操练习"
  ]

# ============ 课程目标 ============
cardSlide pres,
  title: "课程目标"
  columns: 3
  cards: [
    { title: "知识目标", content: "掌握品牌管理理论\n熟悉品牌建设要素\n了解传播策略", color: THEME.accent }
    { title: "能力目标", content: "制定品牌战略\n设计传播方案\n处理品牌危机", color: THEME.success }
    { title: "素质目标", content: "培养品牌思维\n提升专业化水平", color: THEME.warning }
  ]

# ============ 第一章：品牌管理概述 ============
sectionSlide pres,
  number: "第一章"
  title: "医院品牌管理概述"
  gradient: "green"

# 1.1 品牌的本质与价值
sectionSlide pres,
  number: "1.1"
  title: "品牌的本质与价值"
  gradient: "purple"

quoteSlide pres,
  quote: "品牌是患者对医院医疗技术、服务质量、文化价值的综合感知和认同。"
  author: "品牌定义"

cardSlide pres,
  title: "品牌价值"
  columns: 2
  cards: [
    { title: "患者价值", content: "就医选择\n信任感\n忠诚度", color: THEME.accent }
    { title: "医院价值", content: "竞争力\n溢价能力\n持续发展", color: THEME.success }
  ]

# 1.2 医院品牌的特殊性
sectionSlide pres,
  number: "1.2"
  title: "医院品牌的特殊性"
  gradient: "purple"

cardSlide pres,
  title: "医院品牌特点"
  columns: 2
  cards: [
    { title: "专业性", content: "技术门槛高\n需要专业背书", color: THEME.accent }
    { title: "信任性", content: "生命所系\n信任第一", color: THEME.success }
    { title: "服务性", content: "全程服务\n体验重要", color: THEME.warning }
    { title: "公益性", content: "社会责任\n公众形象", color: THEME.danger }
  ]

# ============ 第二章：品牌战略规划 ============
sectionSlide pres,
  number: "第二章"
  title: "品牌战略规划"
  gradient: "green"

# 2.1 品牌定位
sectionSlide pres,
  number: "2.1"
  title: "品牌定位"
  gradient: "purple"

tableSlide pres,
  title: "品牌定位三要素"
  headers: ["要素", "内容"]
  rows: [
    ["目标市场", "服务对象定位"]
    ["差异化", "独特价值主张"]
    ["品牌承诺", "患者可获得的利益"]
  ]

# 2.2 品牌架构
cardSlide pres,
  title: "品牌架构"
  columns: 2
  cards: [
    { title: "院级品牌", content: "医院整体品牌形象", color: THEME.accent }
    { title: "专科品牌", content: "重点学科、专科中心", color: THEME.success }
    { title: "专家品牌", content: "学科带头人、知名专家", color: THEME.warning }
    { title: "服务品牌", content: "特色服务、护理品牌", color: THEME.danger }
  ]

# ============ 第三章：品牌传播 ============
sectionSlide pres,
  number: "第三章"
  title: "品牌传播策略"
  gradient: "green"

# 3.1 传播渠道
tableSlide pres,
  title: "品牌传播渠道"
  headers: ["渠道类型", "特点"]
  rows: [
    ["院内传播", "环境、标识、服务"]
    ["传统媒体", "报纸、电视、广播"]
    ["新媒体", "微信、抖音、小红书"]
    ["口碑传播", "患者体验、满意度"]
  ]

# 3.2 内容营销
cardSlide pres,
  title: "内容营销策略"
  columns: 2
  cards: [
    { title: "科普内容", content: "健康教育\n疾病预防", color: THEME.accent }
    { title: "技术展示", content: "手术视频\n新技术介绍", color: THEME.success }
    { title: "服务故事", content: "患者案例\n暖心瞬间", color: THEME.warning }
    { title: "专家风采", content: "名医介绍\n团队展示", color: THEME.danger }
  ]

# ============ 图表展示 ============
chartSlide pres,
  title: "品牌影响力趋势"
  type: "LINE"
  data: [
    { name: "品牌指数", values: [60, 65, 72, 78, 85, 90], labels: ["2019", "2020", "2021", "2022", "2023", "2024"] }
  ]

# 科室品牌评分对比
chartSlide pres,
  title: "科室品牌建设评分"
  type: "BAR"
  data: [
    { name: "心内科", values: [85, 88, 92], labels: ["Q1", "Q2", "Q3"] }
    { name: "骨科", values: [82, 85, 89] }
    { name: "妇产科", values: [90, 91, 95] }
    { name: "儿科", values: [78, 82, 86] }
  ]

# ============ 第四章：品牌危机管理 ============
sectionSlide pres,
  number: "第四章"
  title: "品牌危机管理"
  gradient: "green"

listSlide pres,
  title: "危机类型"
  items: [
    "医疗纠纷引发的危机"
    "安全事件引发的危机"
    "舆情炒作引发的危机"
    "诚信问题引发的危机"
  ]

cardSlide pres,
  title: "危机应对原则"
  columns: 2
  cards: [
    { title: "快速响应", content: "第一时间回应\n避免信息真空", color: THEME.accent }
    { title: "诚实透明", content: "实事求是\n不隐瞒不欺骗", color: THEME.success }
    { title: "统一口径", content: "一个声音对外\n避免多头表态", color: THEME.warning }
    { title: "善后跟进", content: "解决问题\n修复形象", color: THEME.danger }
  ]

# ============ 第五章：品牌评估 ============
sectionSlide pres,
  number: "第五章"
  title: "品牌建设评估"
  gradient: "green"

tableSlide pres,
  title: "品牌评估指标"
  headers: ["维度", "指标"]
  rows: [
    ["知名度", "市场认知度、搜索指数"]
    ["美誉度", "患者满意度、口碑"]
    ["忠诚度", "复诊率、转介绍率"]
    ["联想度", "品牌关联、差异化"]
  ]

# 品牌传播效果饼图
chartSlide pres,
  title: "品牌传播渠道效果"
  type: "PIE"
  data: [
    { name: "贡献", labels: ["新媒体", "口碑", "传统媒体", "院内"], values: [40, 30, 15, 15] }
  ]

# ============ 课程总结 ============
cardSlide pres,
  title: "核心要点"
  columns: 2
  cards: [
    { title: "定位", content: "明确品牌定位\n差异化发展", color: THEME.accent }
    { title: "传播", content: "多渠道传播\n内容为王", color: THEME.success }
    { title: "维护", content: "持续建设\n危机应对", color: THEME.warning }
    { title: "评估", content: "数据驱动\n持续改进", color: THEME.danger }
  ]

# ============ 结束页 ============
titleSlide pres,
  title: "谢谢!"
  subtitle: "医院品牌建设与传播管理"
  gradient: "blue"

# ============ 保存 ============
pres.writeFile({ fileName: "outputs/E02品牌建设.pptx" })
  .then -> console.log "✅ Created: outputs/E02品牌建设.pptx"
  .catch (err) -> console.error err
