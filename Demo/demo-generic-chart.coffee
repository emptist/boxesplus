# BoxesPlus - Generic Chart Demo
# Using the generic chartSlide function

PptxGenJS = require "pptxgenjs"
{ titleSlide, chartSlide, cardSlide, THEME } = require "../api/boxesplus-artist.coffee"

pres = new PptxGenJS()

# 1. Title
titleSlide pres,
  title: "通用图表函数演示"
  subtitle: "chartSlide(type: 'BAR|LINE|PIE|RADAR')"
  gradient: "blue"

# 2. BAR
chartSlide pres,
  title: "柱状图"
  type: "BAR"
  data: [
    { name: "内科", values: [85, 88, 92, 90], labels: ["Q1", "Q2", "Q3", "Q4"] }
    { name: "外科", values: [82, 85, 89, 94] }
  ]

# 3. LINE
chartSlide pres,
  title: "折线图"
  type: "LINE"
  data: [
    { name: "满意度", values: [75, 78, 82, 85, 88, 90, 92], labels: ["2020", "2021", "2022", "2023", "2024", "2025", "2026"] }
  ]

# 4. PIE
chartSlide pres,
  title: "饼图"
  type: "PIE"
  data: [
    { name: "收入", labels: ["内科", "外科", "妇产科", "儿科", "其他"], values: [25, 30, 15, 10, 20] }
  ]

# 5. RADAR
chartSlide pres,
  title: "雷达图"
  type: "RADAR"
  data: [
    { name: "当前", labels: ["质量", "效率", "满意", "成本", "科研", "学科"], values: [85, 78, 92, 70, 65, 80] }
    { name: "目标", values: [90, 85, 95, 80, 75, 85] }
  ]

# 6. Cards
cardSlide pres,
  title: "质量改进"
  columns: 2
  cards: [
    { title: "流程", content: "优化环节", color: THEME.accent }
    { title: "培训", content: "技能提升", color: THEME.success }
    { title: "信息", content: "系统完善", color: THEME.warning }
    { title: "文化", content: "质量意识", color: THEME.danger }
  ]

# Save
pres.writeFile({ fileName: "outputs/demo-generic-chart.pptx" })
  .then -> console.log "✅ Created: outputs/demo-generic-chart.pptx"
  .catch (err) -> console.error err
