# BoxesPlus - Complete API Demo
# Demonstrates all API functions

PptxGenJS = require "pptxgenjs"
{ 
  titleSlide, listSlide, cardSlide, tableSlide, quoteSlide, 
  comparisonSlide, timelineSlide, endSlide, chartSlide, imageSlide,
  THEME, GRADIENTS
} = require "../api/boxesplus-artist.coffee"

pres = new PptxGenJS()

# 1. Title Slide
titleSlide pres,
  title: "BoxesPlus API 完整演示"
  subtitle: "CoffeeScript PPTX 生成器"
  gradient: "blue"

# 2. List Slide
listSlide pres,
  title: "演示内容"
  items: [
    "幻灯片类型: title, list, card, table, quote, comparison, timeline, chart, image"
    "图表类型: BAR, LINE, PIE, RADAR, SCATTER"
    "主题颜色: THEME 对象"
    "图片支持: imageSlide"
    "母版支持: defineMaster + masterSlide"
  ]

# 3. Card Slide
cardSlide pres,
  title: "卡片组件"
  columns: 3
  cards: [
    { title: "质量", content: "质量第一", color: THEME.accent }
    { title: "安全", content: "安全保障", color: THEME.success }
    { title: "效率", content: "效率优先", color: THEME.warning }
  ]

# 4. Table Slide
tableSlide pres,
  title: "表格组件"
  headers: ["指标", "2023", "2024", "变化"]
  rows: [
    ["门诊量", "100万", "120万", "+20%"]
    ["出院人次", "10万", "12万", "+20%"]
    ["手术台次", "3万", "3.5万", "+17%"]
  ]

# 5. Quote Slide
quoteSlide pres,
  quote: "质量是医院的生命线"
  author: "医院管理名言"

# 6. Comparison Slide
comparisonSlide pres,
  title: "对比分析"
  left:
    title: "传统模式"
    items: ["经验驱动", "纸质记录", "被动应对"]
  right:
    title: "现代模式"
    items: ["数据驱动", "系统管理", "主动改进"]

# 7. Timeline Slide
timelineSlide pres,
  title: "项目时间线"
  events: [
    { date: "第1周", title: "调研", desc: "现状分析" }
    { date: "第2周", title: "设计", desc: "方案制定" }
    { date: "第3-4周", title: "实施", desc: "推进执行" }
  ]

# 8. Chart Slides
chartSlide pres,
  title: "柱状图"
  type: "BAR"
  data: [
    { name: "内科", values: [85, 88, 92], labels: ["Q1", "Q2", "Q3"] }
    { name: "外科", values: [82, 85, 89] }
  ]

chartSlide pres,
  title: "折线图"
  type: "LINE"
  data: [
    { name: "满意度", values: [75, 78, 82, 85, 88, 90], labels: ["2020", "2021", "2022", "2023", "2024", "2025"] }
  ]

chartSlide pres,
  title: "饼图"
  type: "PIE"
  data: [
    { name: "收入", labels: ["内科", "外科", "妇产科", "其他"], values: [30, 35, 20, 15] }
  ]

# 9. Image Slide
imageSlide pres,
  title: "图片示例"
  path: "./resourses/1.png"
  x: 0.5, y: 0.8, w: 9, h: 4

# 10. End Slide
endSlide pres,
  title: "谢谢!"
  subtitle: "BoxesPlus - 让 PPTX 生成更简单"

# Save
pres.writeFile({ fileName: "outputs/demo-complete.pptx" })
  .then -> console.log "✅ Created: outputs/demo-complete.pptx"
  .catch (err) -> console.error err
