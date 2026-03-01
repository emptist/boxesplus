# BoxesPlus - Dual Output: PPTX + Reveal.js
# 同时生成 PPTX 和 HTML 演示文稿

PptxGenJS = require "pptxgenjs"
fs = require "fs"
path = require "path"

{ 
  titleSlide, listSlide, cardSlide, tableSlide, quoteSlide, 
  sectionSlide, chartSlide, THEME 
} = require "../api/boxesplus-artist.coffee"

# ============ PPTX 生成 ============

generatePPTX = ->
  pres = new PptxGenJS()
  
  # 封面
  titleSlide pres,
    title: "医院医疗质量与安全管理"
    subtitle: "双平台输出演示"
    gradient: "blue"
  
  # 课程目标
  cardSlide pres,
    title: "课程目标"
    columns: 3
    cards: [
      { title: "知识目标", content: "掌握质量管理体系", color: THEME.accent }
      { title: "能力目标", content: "运用管理工具", color: THEME.success }
      { title: "素质目标", content: "培养安全意识", color: THEME.warning }
    ]
  
  # 图表
  chartSlide pres,
    title: "质量指标趋势"
    type: "LINE"
    data: [
      { name: "病历甲级率", values: [75, 78, 82, 85, 88, 90], labels: ["2019", "2020", "2021", "2022", "2023", "2024"] }
    ]
  
  # 保存 PPTX
  pres.writeFile({ fileName: "outputs/dual-demo.pptx" })
    .then -> console.log "✅ PPTX created"
    .catch (err) -> console.error "PPTX error:", err

# ============ Reveal.js HTML 生成 ============

generateHTML = ->
  # 创建 Reveal.js HTML 演示文稿
  html = """
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>医院医疗质量与安全管理</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/reveal.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/theme/white.css">
  <style>
    .reveal .slides section { text-align: left; }
    .reveal h1 { color: #1a365d; }
    .reveal h2 { color: #2c5282; }
    .card { 
      background: #f7fafc; 
      border-radius: 8px; 
      padding: 20px; 
      margin: 10px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    .card-grid { display: flex; justify-content: space-around; }
    .card-title { font-weight: bold; color: #1a365d; margin-bottom: 10px; }
    .card-content { font-size: 0.8em; color: #4a5568; }
    table { font-size: 0.7em; }
  </style>
</head>
<body>
  <div class="reveal">
    <div class="slides">
      
      <!-- 封面 -->
      <section style="text-align: center;">
        <h1>医院医疗质量与安全管理</h1>
        <h3>双平台输出演示</h3>
        <p style="color: #718096;">Reveal.js + CoffeeScript</p>
      </section>
      
      <!-- 课程目标 -->
      <section>
        <h2>课程目标</h2>
        <div class="card-grid">
          <div class="card" style="flex: 1;">
            <div class="card-title">知识目标</div>
            <div class="card-content">掌握质量管理体系<br>熟悉管理工具<br>了解安全目标</div>
          </div>
          <div class="card" style="flex: 1;">
            <div class="card-title">能力目标</div>
            <div class="card-content">建立质量管理体系<br>运用管理工具<br>处理安全事件</div>
          </div>
          <div class="card" style="flex: 1;">
            <div class="card-title">素质目标</div>
            <div class="card-content">培养安全意识<br>提升管理能力</div>
          </div>
        </div>
      </section>
      
      <!-- 内容列表 -->
      <section>
        <h2>主要内容</h2>
        <ul style="font-size: 0.8em;">
          <li>医疗质量管理概述</li>
          <li>质量管理体系构建</li>
          <li>PDCA 循环应用</li>
          <li>质量管理工具</li>
          <li>案例分析与实践</li>
        </ul>
      </section>
      
      <!-- 表格 -->
      <section>
        <h2>质量指标</h2>
        <table style="font-size: 0.6em;">
          <tr style="background: #1a365d; color: white;">
            <th>指标</th><th>2023年</th><th>2024年</th><th>变化</th>
          </tr>
          <tr><td>病历甲级率</td><td>85%</td><td>90%</td><td>+5%</td></tr>
          <tr><td>核心制度执行率</td><td>95%</td><td>98%</td><td>+3%</td></tr>
          <tr><td>患者满意度</td><td>88%</td><td>92%</td><td>+4%</td></tr>
        </table>
      </section>
      
      <!-- 代码片段 -->
      <section>
        <h2>CoffeeScript 代码</h2>
        <pre style="font-size: 0.5em; background: #1a202c; color: #68d391;">
titleSlide pres,
  title: "医院医疗质量"
  gradient: "blue"

cardSlide pres,
  title: "课程目标"
  cards: [
    { title: "知识", content: "掌握..." }
    { title: "能力", content: "运用..." }
  ]
        </pre>
      </section>
      
      <!-- 结束 -->
      <section style="text-align: center;">
        <h1 style="color: #1a365d;">谢谢!</h1>
        <h3>BoxesPlus - 双平台输出</h3>
        <p>PPTX + Reveal.js</p>
      </section>
      
    </div>
  </div>
  <script src="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/reveal.js"></script>
  <script>
    Reveal.initialize({ hash: true, slideNumber: true });
  </script>
</body>
</html>
"""
  
  fs.writeFileSync "outputs/dual-demo.html", html
  console.log "✅ HTML created"

# 执行生成
console.log "开始生成..."
generatePPTX()
generateHTML()
console.log "完成! 输出文件在 outputs/ 文件夹"
