# BoxesPlus - Chart Demo
# Using API + PptxGenJS charts combined

PptxGenJS = require "pptxgenjs"
{ titleSlide, cardSlide, tableSlide, THEME } = require "../api/boxesplus-artist.coffee"

pres = new PptxGenJS()

# 1. Title
titleSlide pres,
  title: "图表展示示例"
  subtitle: "PptxGenJS Charts + BoxesPlus API"
  gradient: "blue"

# 2. Bar Chart
slide2 = pres.addSlide()
slide2.addText "柱状图 - 科室质量评分", 
  x: 0.5, y: 0.3, w: 9, h: 0.6
  fontSize: 28, color: THEME.primary, bold: true

barData = [
  { name: "内科", values: [85, 88, 92, 90], labels: ["Q1", "Q2", "Q3", "Q4"] }
  { name: "外科", values: [82, 85, 89, 94] }
  { name: "妇产科", values: [90, 91, 93, 95] }
]

slide2.addChart pres.ChartType.BAR, barData,
  x: 0.5, y: 1, w: 9, h: 4
  title: "各科室季度质量评分"

# 3. Line Chart  
slide3 = pres.addSlide()
slide3.addText "折线图 - 满意度趋势", 
  x: 0.5, y: 0.3, w: 9, h: 0.6
  fontSize: 28, color: THEME.primary, bold: true

lineData = [
  { name: "满意度", values: [75, 78, 82, 85, 88, 90, 92], labels: ["2020", "2021", "2022", "2023", "2024", "2025", "2026"] }
]

slide3.addChart pres.ChartType.LINE, lineData,
  x: 0.5, y: 1, w: 9, h: 4
  title: "患者满意度年度趋势"

# 4. Pie Chart
slide4 = pres.addSlide()
slide4.addText "饼图 - 科室收入占比", 
  x: 0.5, y: 0.3, w: 9, h: 0.6
  fontSize: 28, color: THEME.primary, bold: true

pieData = [
  { name: "收入", labels: ["内科", "外科", "妇产科", "儿科", "其他"], values: [25, 30, 15, 10, 20] }
]

slide4.addChart pres.ChartType.PIE, pieData,
  x: 1.5, y: 1, w: 7, h: 4
  title: "科室收入分布"

# 5. Radar Chart
slide5 = pres.addSlide()
slide5.addText "雷达图 - 综合能力评价", 
  x: 0.5, y: 0.3, w: 9, h: 0.6
  fontSize: 28, color: THEME.primary, bold: true

radarData = [
  { name: "当前", labels: ["医疗质量", "服务效率", "患者满意度", "成本控制", "科研教学", "学科建设"], values: [85, 78, 92, 70, 65, 80] }
  { name: "目标", values: [90, 85, 95, 80, 75, 85] }
]

slide5.addChart pres.ChartType.RADAR, radarData,
  x: 1, y: 1, w: 8, h: 4
  title: "医院综合能力评价"

# 6. Cards + Chart combined
cardSlide pres,
  title: "质量改进方向",
  columns: 2
  cards: [
    { title: "流程优化", content: "精简诊疗环节", color: THEME.accent }
    { title: "培训提升", content: "加强技能训练", color: THEME.success }
    { title: "信息化", content: "完善信息系统", color: THEME.warning }
    { title: "文化建设", content: "培育质量意识", color: THEME.danger }
  ]

# Save
pres.writeFile({ fileName: "outputs/demo-chart.pptx" })
  .then -> console.log "✅ Created: outputs/demo-chart.pptx"
  .catch (err) -> console.error err
