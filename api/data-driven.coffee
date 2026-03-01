# BoxesPlus - CoffeeScript 数据驱动幻灯片
# 核心理念：CoffeeScript 让 JSON 更神奇

fs = require "fs"
{ titleSlide, sectionSlide, endSlide, listSlide, cardsSlide
  pdcaSlide, swotSlide, timelineSlide, flowchartSlide, orgChartSlide
  comparisonSlide } = require "./chart-components"

# 从 CoffeeScript 数据生成幻灯片
generateFromData = (data) ->
  slides = []
  
  # 封面
  if data.title
    slides.push titleSlide(title: data.title, subtitle: data.subtitle)
  
  # 遍历每一页
  for slide in (data.slides || [])
    type = slide.type
    
    switch type
      when "title"
        slides.push titleSlide(slide)
      
      when "section"
        slides.push sectionSlide(slide)
      
      when "end"
        slides.push endSlide(slide)
      
      when "list"
        slides.push listSlide(slide)
      
      when "cards"
        slides.push cardsSlide(slide)
      
      when "pdca"
        slides.push pdcaSlide(slide)
      
      when "swot"
        slides.push swotSlide(slide)
      
      when "timeline"
        slides.push timelineSlide(slide)
      
      when "flowchart"
        slides.push flowchartSlide(slide)
      
      when "org"
        slides.push orgChartSlide(slide)
      
      when "comparison"
        slides.push comparisonSlide(slide)
  
  slides

# 生成 HTML
generateHtml = (data, outputPath) ->
  slides = generateFromData(data)
  
  html = """
  <!doctype html>
  <html>
  <head>
    <meta charset="utf-8">
    <title>#{data.title || '演示'}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/reveal.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/theme/white.css">
    <style>
      .reveal .slides section { text-align: left; }
      .reveal { font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif; }
    </style>
  </head>
  <body>
    <div class="reveal">
      <div class="slides">
  """
  
  for slide in slides
    html += slide
  
  html += """
      </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/reveal.js"></script>
    <script>
      Reveal.initialize({
        hash: true,
        slideNumber: true,
        transition: 'slide',
        center: true,
        keyboard: true,
        width: 1280,
        height: 720,
        margin: 0.04
      });
    </script>
  </body>
  </html>
  """
  
  fs.writeFileSync(outputPath, html)
  console.log "✅ Created: #{outputPath}"

module.exports = { generateFromData, generateHtml }

# 示例数据文件
if require.main is module
  # 直接写 CoffeeScript 数据 - 像诗一样优雅
  课程数据 = 
    title: "医院品牌建设课程"
    subtitle: "E02 品牌建设"
    slides: [
      {
        type: "cards"
        title: "课程目标"
        cards: [
          { title: "知识目标", content: "掌握品牌管理理论", color: "#ebf8ff" }
          { title: "能力目标", content: "制定品牌战略", color: "#f0fff4" }
          { title: "素质目标", content: "培养品牌思维", color: "#fffaf0" }
        ]
      }
      {
        type: "section"
        title: "第一章"
        subtitle: "医院品牌管理概述"
      }
      {
        type: "flowchart"
        title: "品牌建设流程"
        steps: [
          { text: "调研分析", color: "#2b6cb0" }
          { text: "战略规划", color: "#38a169" }
          { text: "执行落地", color: "#d69e2e" }
          { text: "评估优化", color: "#e53e3e" }
        ]
      }
      {
        type: "pdca"
        title: "PDCA 循环"
      }
      {
        type: "swot"
        title: "SWOT 分析"
        strengths: ["技术领先", "专家团队", "品牌积累"]
        weaknesses: ["传播投入不足", "新媒体弱"]
        opportunities: ["政策支持", "市场需求增长"]
        threats: ["竞争激烈", "舆论风险"]
      }
      {
        type: "timeline"
        title: "实施时间线"
        events: [
          { title: "第一阶段", desc: "调研诊断 1-2月", color: "#3182ce" }
          { title: "第二阶段", desc: "战略规划 3-4月", color: "#38a169" }
          { title: "第三阶段", desc: "执行落地 5-10月", color: "#d69e2e" }
          { title: "第四阶段", desc: "评估优化 11-12月", color: "#e53e3e" }
        ]
      }
      {
        type: "org"
        title: "组织架构"
        levels: [
          { text: "品牌委员会", color: "#1a365d" }
          { text: ["总监", "市场部", "宣传部"], color: "#2b6cb0" }
          { text: ["策划", "推广", "运营"], color: "#3182ce" }
        ]
      }
      {
        type: "comparison"
        title: "传统 vs 现代"
        headers: ["维度", "传统", "现代"]
        rows: [
          ["渠道", "电视报纸", "微信抖音"]
          ["方式", "单向", "互动"]
          ["成本", "高", "低"]
        ]
      }
      {
        type: "end"
        title: "谢谢!"
        subtitle: "BoxesPlus"
      }
    ]
  
  generateHtml 课程数据, "outputs/data-driven.html"
  console.log "Done! Open outputs/data-driven.html"
