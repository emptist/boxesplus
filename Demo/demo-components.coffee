# BoxesPlus - 图表组件演示
# 展示如何使用 chart-components 快速创建幻灯片

fs = require "fs"
{ titleSlide, sectionSlide, endSlide, listSlide, cardsSlide
  pdcaSlide, swotSlide, timelineSlide, flowchartSlide, orgChartSlide
  comparisonSlide } = require "../api/chart-components.coffee"

slides = []

# 封面
slides.push titleSlide(
  title: "医院品牌建设课程"
  subtitle: "E02 品牌建设"
)

# 课程目标 - 使用卡片
slides.push cardsSlide(
  title: "课程目标"
  cards: [
    { title: "知识目标", content: "掌握品牌管理理论", color: "#ebf8ff" }
    { title: "能力目标", content: "制定品牌战略", color: "#f0fff4" }
    { title: "素质目标", content: "培养品牌思维", color: "#fffaf0" }
  ]
)

# 章节页
slides.push sectionSlide(
  title: "第一章"
  subtitle: "医院品牌管理概述"
)

# 流程图
slides.push flowchartSlide(
  title: "品牌建设流程"
  steps: [
    { text: "调研分析", color: "#2b6cb0" }
    { text: "战略规划", color: "#38a169" }
    { text: "执行落地", color: "#d69e2e" }
    { text: "评估优化", color: "#e53e3e" }
  ]
)

# PDCA 循环
slides.push pdcaSlide(
  title: "品牌持续改进 - PDCA循环"
)

# SWOT 分析
slides.push swotSlide(
  title: "品牌战略分析 - SWOT"
  strengths: ["技术领先", "专家团队", "品牌积累"]
  weaknesses: ["传播投入不足", "新媒体弱"]
  opportunities: ["政策支持", "市场需求增长"]
  threats: ["竞争激烈", "舆论风险"]
)

# 时间线
slides.push timelineSlide(
  title: "品牌建设时间线"
  events: [
    { title: "第一阶段：调研诊断", desc: "1-2月，品牌现状调研", color: "#3182ce" }
    { title: "第二阶段：战略规划", desc: "3-4月，品牌定位设计", color: "#38a169" }
    { title: "第三阶段：执行落地", desc: "5-10月，推广活动", color: "#d69e2e" }
    { title: "第四阶段：评估优化", desc: "11-12月，效果评估", color: "#e53e3e" }
  ]
)

# 组织架构
slides.push orgChartSlide(
  title: "品牌管理组织架构"
  levels: [
    { text: "医院品牌委员会", color: "#1a365d" }
    { text: ["品牌总监", "市场部", "宣传部"], color: "#2b6cb0" }
    { text: ["品牌策划", "市场推广", "新媒体运营", "公共关系"], color: "#3182ce" }
  ]
)

# 对比表格
slides.push comparisonSlide(
  title: "传统 vs 现代品牌传播"
  headers: ["维度", "传统模式", "现代模式"]
  rows: [
    ["传播渠道", "电视、报纸", "微信、抖音"]
    ["传播方式", "单向传播", "双向互动"]
    ["成本", "高", "低"]
    ["效果评估", "困难", "精准"]
  ]
)

# 列表页
slides.push listSlide(
  title: "品牌建设要点"
  items: [
    "明确品牌定位和核心价值"
    "建立统一的视觉识别系统"
    "制定长期品牌发展规划"
    "加强全员品牌意识培训"
  ]
)

# 结束页
slides.push endSlide(
  title: "谢谢!"
  subtitle: "BoxesPlus + Reveal.js"
)

# 生成 HTML
html = """
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>BoxesPlus 组件演示</title>
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

fs.writeFileSync "outputs/components-demo.html", html
console.log "✅ Created: outputs/components-demo.html"
console.log "用法: open outputs/components-demo.html"
