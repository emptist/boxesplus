# D01 学科建设与专科发展 - 直接用 CoffeeScript 编写
# 用法: coffee Demo/generate-d01.coffee

PptxGenJS = require "pptxgenjs"
{ titleSlide, listSlide, cardSlide, tableSlide, quoteSlide, sectionSlide, chartSlide, THEME } = require "../api/boxesplus-artist.coffee"

pres = new PptxGenJS()

# ============ 封面 ============
titleSlide pres,
  title: "医院学科建设与专科发展"
  subtitle: "D01 学科建设课程"
  gradient: "blue"

# ============ 课程信息 ============
listSlide pres,
  title: "课程信息"
  items: [
    "课程名称：医院学科建设与专科发展"
    "课程定位：医院管理核心模块课程"
    "课程时长：12小时（2天）"
    "课程对象：院长、医务部主任、学科带头人"
    "教学方法：理论讲授、案例分析、实操练习"
  ]

# ============ 课程目标 ============
cardSlide pres,
  title: "课程目标"
  columns: 3
  cards: [
    { title: "知识目标", content: "掌握学科建设理论\n熟悉专科建设要点\n了解评估体系", color: THEME.accent }
    { title: "能力目标", content: "制定学科规划\n组织专科申报\n建设人才梯队", color: THEME.success }
    { title: "素质目标", content: "培养战略思维\n提升专业化水平", color: THEME.warning }
  ]

# ============ 第一章：学科建设概述 ============
sectionSlide pres,
  number: "第一章"
  title: "学科建设概述"
  gradient: "green"

# 1.1 学科建设的重要性
sectionSlide pres,
  number: "1.1"
  title: "学科建设的重要性"
  gradient: "purple"

quoteSlide pres,
  quote: "学科建设是医院发展的核心动力，是医疗质量和服务水平的根本保障。"
  author: "学科建设定义"

cardSlide pres,
  title: "学科建设价值"
  columns: 2
  cards: [
    { title: "医院发展", content: "核心竞争力\n可持续发展", color: THEME.accent }
    { title: "患者服务", content: "技术水平\n服务质量", color: THEME.success }
    { title: "人才培养", content: "梯队建设\n学科带头人", color: THEME.warning }
    { title: "科研教学", content: "学术地位\n教学基地", color: THEME.danger }
  ]

# 1.2 学科建设原则
listSlide pres,
  title: "学科建设原则"
  items: [
    "以患者为中心 - 提升医疗服务能力"
    "以人才为根本 - 建设高水平人才梯队"
    "以技术为支撑 - 培育特色诊疗技术"
    "以管理为保障 - 建立健全管理制度"
  ]

# ============ 第二章：重点专科建设 ============
sectionSlide pres,
  number: "第二章"
  title: "重点专科建设"
  gradient: "green"

# 2.1 重点专科选择
sectionSlide pres,
  number: "2.1"
  title: "重点专科选择"
  gradient: "purple"

tableSlide pres,
  title: "重点专科选择要素"
  headers: ["要素", "考量因素"]
  rows: [
    ["市场需求", "疾病谱、发病率、就医需求"]
    ["竞争态势", "区域内竞争医院学科布局"]
    ["自身优势", "现有基础、人才储备、技术能力"]
    ["发展潜力", "成长空间、创新能力"]
  ]

# 2.2 重点专科建设要点
cardSlide pres,
  title: "重点专科建设要点"
  columns: 2
  cards: [
    { title: "人才队伍建设", content: "学科带头人培养\n骨干人才引进\n团队建设", color: THEME.accent }
    { title: "技术能力提升", content: "新技术开展\n疑难病诊治\n危急重症救治", color: THEME.success }
    { title: "科研教学", content: "课题研究\n论文发表\n教学工作", color: THEME.warning }
    { title: "质量管理", content: "制度建设\n流程优化\n持续改进", color: THEME.danger }
  ]

# ============ 第三章：人才梯队建设 ============
sectionSlide pres,
  number: "第三章"
  title: "人才梯队建设"
  gradient: "green"

# 3.1 人才规划
sectionSlide pres,
  number: "3.1"
  title: "人才规划"
  gradient: "purple"

tableSlide pres,
  title: "人才梯队结构"
  headers: ["层级", "定位", "要求"]
  rows: [
    ["学科带头人", "学科领军", "正高、博导、行业影响力"]
    ["学科骨干", "技术支撑", "副高以上、业务骨干"]
    ["主治医师", "临床主力", "中级以上、独立诊疗"]
    ["住院医师", "基础力量", "规范化培训、成长潜力"]
  ]

# 3.2 人才培养
cardSlide pres,
  title: "人才培养策略"
  columns: 3
  cards: [
    { title: "引进", content: "高层次人才\n学科带头人", color: THEME.accent }
    { title: "培养", content: "规范化培训\n进修学习", color: THEME.success }
    { title: "激励", content: "绩效激励\n职业发展", color: THEME.warning }
  ]

# ============ 图表展示 ============
chartSlide pres,
  title: "学科建设发展指数"
  type: "LINE"
  data: [
    { name: "综合指数", values: [65, 70, 75, 80, 85, 90], labels: ["2019", "2020", "2021", "2022", "2023", "2024"] }
  ]

# 学科评估雷达图
chartSlide pres,
  title: "学科建设评估"
  type: "RADAR"
  data: [
    { name: "当前", labels: ["人才", "技术", "科研", "教学", "管理", "服务"], values: [75, 80, 65, 60, 70, 85] }
    { name: "目标", values: [90, 90, 80, 75, 85, 90] }
  ]

# 科室对比
chartSlide pres,
  title: "各学科评估得分"
  type: "BAR"
  data: [
    { name: "心内科", values: [88, 92, 95], labels: ["人才", "技术", "科研"] }
    { name: "骨科", values: [85, 88, 80] }
    { name: "神经内科", values: [82, 85, 75] }
  ]

# ============ 第四章：学科评估 ============
sectionSlide pres,
  number: "第四章"
  title: "学科评估与发展"
  gradient: "green"

# 4.1 评估体系
tableSlide pres,
  title: "学科评估指标体系"
  headers: ["一级指标", "二级指标"]
  rows: [
    ["基础条件", "床位、设备、经费"]
    ["人才队伍", "结构、学历、职称"]
    ["技术水平", "病种、技术难度"]
    ["科研教学", "课题、论文、继教"]
    ["质量管理", "制度、流程、指标"]
    ["服务能力", "门诊量、住院量、手术量"]
  ]

# 4.2 持续改进
listSlide pres,
  title: "学科建设持续改进"
  items: [
    "定期评估 - 年度/季度学科评估"
    "问题诊断 - 发现短板与分析原因"
    "制定计划 - 针对性改进措施"
    "落实执行 - 责任到人、进度跟踪"
    "效果评价 - 评估改进效果"
  ]

# ============ 第五章：案例研讨 ============
sectionSlide pres,
  number: "第五章"
  title: "案例研讨"
  gradient: "green"

# 案例：重点专科成功经验
cardSlide pres,
  title: "案例：某三甲医院重点专科建设"
  columns: 1
  cards: [
    { title: "背景", content: "5年前薄弱学科，发展受限", color: THEME.accent }
    { title: "策略", content: "人才引进+技术提升+科研突破", color: THEME.success }
    { title: "成效", content: "省级重点专科，区域领先", color: THEME.warning }
  ]

# 讨论题
listSlide pres,
  title: "讨论题"
  items: [
    "贵院学科建设的优势与短板？"
    "如何突破学科发展瓶颈？"
    "人才引进与培养如何平衡？"
  ]

# ============ 课程总结 ============
cardSlide pres,
  title: "核心要点"
  columns: 2
  cards: [
    { title: "战略规划", content: "明确学科定位\n制定发展规划", color: THEME.accent }
    { title: "人才为本", content: "引进培养并重\n建设人才梯队", color: THEME.success }
    { title: "技术支撑", content: "培育特色技术\n提升核心能力", color: THEME.warning }
    { title: "管理保障", content: "健全制度流程\n持续改进提高", color: THEME.danger }
  ]

# ============ 结束页 ============
titleSlide pres,
  title: "谢谢!"
  subtitle: "医院学科建设与专科发展"
  gradient: "blue"

# ============ 保存 ============
pres.writeFile({ fileName: "outputs/D01学科建设.pptx" })
  .then -> console.log "✅ Created: outputs/D01学科建设.pptx"
  .catch (err) -> console.error err
