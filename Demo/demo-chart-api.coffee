# BoxesPlus - Chart Demo (API approach)
# Using boxesplus-artist chart functions

PptxGenJS = require "pptxgenjs"
{ titleSlide, barChartSlide, lineChartSlide, pieChartSlide, radarChartSlide, cardSlide, THEME } = require "../api/boxesplus-artist.coffee"

pres = new PptxGenJS()

# 1. Title
titleSlide pres,
  title: "图表展示示例"
  subtitle: "BoxesPlus API Chart Functions"
  gradient: "blue"

# 2. Bar Chart (using API)
barChartSlide pres,
  title: "柱状图"
  subtitle: "科室质量评分"
  data: [
    { name: "内科", values: [85, 88, 92, 90], labels: ["Q1", "Q2", "Q3", "Q4"] }
    { name: "外科", values: [82, 85, 89, 94] }
    { name: "妇产科", values: [90, 91, 93, 95] }
  ]

# 3. Line Chart (using API)
lineChartSlide pres,
  title: "折线图"
  subtitle: "满意度趋势"
  data: [
    { name: "满意度", values: [75, 78, 82, 85, 88, 90, 92], labels: ["2020", "2021", "2022", "2023", "2024", "2025", "2026"] }
  ]

# 4. Pie Chart (using API)
pieChartSlide pres,
  title: "饼图"
  subtitle: "科室收入占比"
  data: [
    { name: "收入", labels: ["内科", "外科", "妇产科", "儿科", "其他"], values: [25, 30, 15, 10, 20] }
  ]

# 5. Radar Chart (using API)
radarChartSlide pres,
  title: "雷达图"
  subtitle: "综合能力评价"
  data: [
    { name: "当前", labels: ["医疗质量", "服务效率", "患者满意度", "成本控制", "科研教学", "学科建设"], values: [85, 78, 92, 70, 65, 80] }
    { name: "目标", values: [90, 85, 95, 80, 75, 85] }
  ]

# 6. Cards
cardSlide pres,
  title: "质量改进方向"
  columns: 2
  cards: [
    { title: "流程优化", content: "精简诊疗环节", color: THEME.accent }
    { title: "培训提升", content: "加强技能训练", color: THEME.success }
    { title: "信息化", content: "完善信息系统", color: THEME.warning }
    { title: "文化建设", content: "培育质量意识", color: THEME.danger }
  ]

# Save
pres.writeFile({ fileName: "outputs/demo-chart-api.pptx" })
  .then -> console.log "✅ Created: outputs/demo-chart-api.pptx"
  .catch (err) -> console.error err
