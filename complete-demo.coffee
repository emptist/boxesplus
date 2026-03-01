# Complete Demo - Artist + Charts Combined
# Using boxesplus-artist + PptxGenJS charts

PptxGenJS = require "pptxgenjs"
{ titleSlide, listSlide, cardSlide, tableSlide, comparisonSlide, THEME } = require "./api/boxesplus-artist.coffee"

pres = new PptxGenJS()

# 1. Title Slide (using artist)
titleSlide pres,
  title: "医院质量管理与持续改进"
  subtitle: "2024年度质量分析报告"
  gradient: "blue"

# 2. Agenda (using artist)
listSlide pres,
  title: "报告大纲"
  items: [
    "质量指标概览"
    "科室对比分析"
    "趋势分析"
    "改进建议"
  ]

# 3. Quality Metrics Table (using artist)
tableSlide pres,
  title: "核心质量指标"
  headers: ["指标", "2023年", "2024年", "目标", "状态"]
  rows: [
    ["病历甲级率", "85%", "90%", "≥90%", "✅"]
    ["核心制度执行率", "95%", "98%", "100%", "⚠️"]
    ["患者满意度", "88%", "92%", "≥90%", "✅"]
    ["院内感染率", "1.2%", "0.8%", "≤1%", "✅"]
  ]

# 4. Cards (using artist)
cardSlide pres,
  title: "质量改进四大方向",
  columns: 2
  cards: [
    { title: "流程优化", content: "精简诊疗流程", color: THEME.accent }
    { title: "培训提升", content: "加强技能培训", color: THEME.success }
    { title: "信息化", content: "完善信息系统", color: THEME.warning }
    { title: "文化建设", content: "培育质量意识", color: THEME.danger }
  ]

# 5. Comparison (using artist)
comparisonSlide pres,
  title: "传统 vs 现代质量管理"
  left:
    title: "传统模式"
    items: ["经验驱动", "事后检查", "被动应对", "纸质记录"]
  right:
    title: "现代模式"
    items: ["数据驱动", "事前预防", "主动改进", "系统管理"]

# 6. NEW: Bar Chart - Department Comparison
slide6 = pres.addSlide()
slide6.addText "科室质量评分对比", 
  x: 0.5, y: 0.3, w: 9, h: 0.6
  fontSize: 28, color: THEME.primary, bold: true

chartData = [
  {
    name: "内科"
    values: [85, 88, 92, 90]
    labels: ["Q1", "Q2", "Q3", "Q4"]
  }
  {
    name: "外科"
    values: [82, 85, 89, 94]
  }
  {
    name: "妇产科"
    values: [90, 91, 93, 95]
  }
]

slide6.addChart pres.ChartType.BAR, chartData,
  x: 0.5, y: 1, w: 9, h: 4
  title: "各科室季度质量评分"

# 7. NEW: Line Chart - Trend
slide7 = pres.addSlide()
slide7.addText "患者满意度趋势", 
  x: 0.5, y: 0.3, w: 9, h: 0.6
  fontSize: 28, color: THEME.primary, bold: true

trendData = [
  {
    name: "满意度"
    values: [75, 78, 82, 85, 88, 90, 92]
    labels: ["2020", "2021", "2022", "2023", "2024", "2025", "2026"]
  }
]

slide7.addChart pres.ChartType.LINE, trendData,
  x: 0.5, y: 1, w: 9, h: 4
  title: "患者满意度年度趋势"

# 8. NEW: Pie Chart - Department Revenue
slide8 = pres.addSlide()
slide8.addText "科室收入占比", 
  x: 0.5, y: 0.3, w: 9, h: 0.6
  fontSize: 28, color: THEME.primary, bold: true

pieData = [
  {
    name: "收入占比"
    labels: ["内科", "外科", "妇产科", "儿科", "急诊科", "其他"]
    values: [25, 30, 15, 10, 12, 8]
  }
]

slide8.addChart pres.ChartType.PIE, pieData,
  x: 1.5, y: 1, w: 7, h: 4
  title: "科室收入分布"

# 9. NEW: Radar Chart - Quality Dimensions
slide9 = pres.addSlide()
slide9.addText "质量多维评价", 
  x: 0.5, y: 0.3, w: 9, h: 0.6
  fontSize: 28, color: THEME.primary, bold: true

radarData = [
  {
    name: "当前水平"
    labels: ["医疗质量", "服务效率", "患者满意度", "成本控制", "科研教学", "学科建设"]
    values: [85, 78, 92, 70, 65, 80]
  }
  {
    name: "目标水平"
    values: [90, 85, 95, 80, 75, 85]
  }
]

slide9.addChart pres.ChartType.RADAR, radarData,
  x: 1, y: 1, w: 8, h: 4
  title: "医院综合能力评价"

# Save
pres.writeFile({ fileName: "outputs/complete-demo.pptx" })
  .then -> console.log "✅ Created: outputs/complete-demo.pptx"
  .catch (err) -> console.error err
