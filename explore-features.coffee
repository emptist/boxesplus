# Explore PptxGenJS features - Simplified
# Documenting what works and the correct syntax

PptxGenJS = require "pptxgenjs"

pres = new PptxGenJS()

# 1. Title slide
slide1 = pres.addSlide()
slide1.addText "PptxGenJS Features Exploration", 
  x: 0.5, y: 0.3, w: 9, h: 0.8
  fontSize: 32, color: "1a365d", bold: true

# 2. Shapes - various shapes available
slide2 = pres.addSlide()
slide2.addText "Shapes 示例", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true

# Available shapes: rect, roundRect, ellipse, diamond, triangle, rightArrow, etc.
shapes = [
  { type: pres.ShapeType.rect, x: 0.5, y: 1.2 }
  { type: pres.ShapeType.roundRect, x: 2.5, y: 1.2 }
  { type: pres.ShapeType.ellipse, x: 4.5, y: 1.2 }
  { type: pres.ShapeType.diamond, x: 6.5, y: 1.2 }
  { type: pres.ShapeType.triangle, x: 8.5, y: 1.2 }
]

for s in shapes
  slide2.addShape s.type,
    x: s.x, y: s.y, w: 1.5, h: 1.5
    fill: { color: "3182ce" }

# Arrow
slide2.addShape pres.ShapeType.rightArrow,
  x: 3, y: 3.5, w: 4, h: 1
  fill: { color: "38a169" }

# 3. Table - correct format
slide3 = pres.addSlide()
slide3.addText "Table 示例", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true

tableData = [
  ["指标", "2023年", "2024年", "变化"]
  ["门诊量(万人次)", "120", "135", "+12.5%"]
  ["出院人次", "8.5", "9.2", "+8.2%"]
  ["手术台次", "3.2", "3.8", "+18.7%"]
  ["平均住院日", "8.5", "7.9", "-7.1%"]
]

slide3.addTable tableData,
  x: 0.5, y: 1.2, w: 9, h: 3
  fontSize: 14
  color: "2d3748"
  border: { type: "solid", pt: 1, color: "e2e8f0" }
  headerFill: "1e3a5f"
  headerColor: "ffffff"

# 4. Correct Chart format (based on hqcoffee)
# Available: BAR, PIE, LINE, AREA, RADAR, SCATTER, DOUGHNUT
slide4 = pres.addSlide()
slide4.addText "Bar Chart", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true

chartData = [
  {
    name: "2023年"
    values: [85, 95, 88]
    labels: ["病历甲级率", "核心制度执行率", "患者满意度"]
  }
  {
    name: "2024年"
    values: [90, 98, 92]
  }
]

slide4.addChart pres.ChartType.BAR, chartData,
  x: 0.5, y: 1, w: 9, h: 4
  title: "医院质量指标对比"

# 5. Line Chart
slide5 = pres.addSlide()
slide5.addText "Line Chart", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true

lineData = [
  {
    name: "满意度"
    values: [75, 78, 82, 85, 90]
    labels: ["2020", "2021", "2022", "2023", "2024"]
  }
]

slide5.addChart pres.ChartType.LINE, lineData,
  x: 0.5, y: 1, w: 9, h: 4
  title: "患者满意度趋势"

# 6. Pie Chart
slide6 = pres.addSlide()
slide6.addText "Pie Chart", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true

pieData = [
  {
    name: "科室收入"
    labels: ["内科", "外科", "妇产科", "儿科", "其他"]
    values: [30, 35, 15, 10, 10]
  }
]

slide6.addChart pres.ChartType.PIE, pieData,
  x: 1, y: 1, w: 8, h: 4
  title: "科室收入占比"

# 7. Radar Chart
slide7 = pres.addSlide()
slide7.addText "Radar Chart", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true

radarData = [
  {
    name: "科室A"
    labels: ["医疗质量", "服务效率", "患者满意度", "成本控制", "科研教学"]
    values: [85, 90, 88, 75, 80]
  }
  {
    name: "科室B"
    values: [80, 85, 92, 82, 75]
  }
]

slide7.addChart pres.ChartType.RADAR, radarData,
  x: 1, y: 1, w: 8, h: 4
  title: "科室综合评价"

# Save
pres.writeFile({ fileName: "outputs/explore-features.pptx" })
  .then -> console.log "✅ Created: outputs/explore-features.pptx"
  .catch (err) -> console.error err
