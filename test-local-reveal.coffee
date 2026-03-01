# Reveal.js 本地版本测试

fs = require "fs"

# 使用本地 Reveal.js 的 HTML
html = """
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>医院品牌建设课程 - Reveal.js 本地版</title>
  <link rel="stylesheet" href="reveal.js/css/reveal.css">
  <link rel="stylesheet" href="reveal.js/css/theme/white.css">
  <style>
    .reveal .slides { text-align: left; }
    .reveal h1 { color: #1a365d; font-size: 2em; }
    .reveal h2 { color: #2c5282; }
    .card { 
      background: #f7fafc; 
      border-radius: 8px; 
      padding: 20px; 
      margin: 10px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }
    .card-grid { display: flex; }
    .card > div { flex: 1; padding: 10px; }
    .card-title { font-weight: bold; color: #1a365d; margin-bottom: 10px; }
    .card-content { font-size: 0.7em; color: #4a5568; }
  </style>
</head>
<body>
  <div class="reveal">
    <div class="slides">
      
      <!-- 封面 -->
      <section style="text-align: center;">
        <h1>医院品牌建设</h1>
        <h3>E02 品牌建设课程</h3>
        <p style="color: #718096;">本地 Reveal.js 版本</p>
      </section>
      
      <!-- 课程目标 -->
      <section>
        <h2>课程目标</h2>
        <div class="card">
          <div style="display: flex;">
            <div>
              <div class="card-title">知识目标</div>
              <div class="card-content">
                掌握品牌管理理论<br>
                熟悉品牌建设要素<br>
                了解传播策略
              </div>
            </div>
            <div>
              <div class="card-title">能力目标</div>
              <div class="card-content">
                制定品牌战略<br>
                设计传播方案<br>
                处理品牌危机
              </div>
            </div>
          </div>
        </div>
      </section>
      
      <!-- 主要内容 -->
      <section>
        <h2>主要内容</h2>
        <ul style="font-size: 0.7em;">
          <li>医院品牌管理概述</li>
          <li>品牌战略规划</li>
          <li>品牌传播策略</li>
          <li>品牌危机管理</li>
          <li>品牌建设评估</li>
        </ul>
      </section>
      
      <!-- 结束 -->
      <section style="text-align: center;">
        <h1 style="color: #1a365d;">谢谢!</h1>
        <h3>BoxesPlus + Reveal.js</h3>
      </section>
      
    </div>
  </div>
  <script src="reveal.js/js/reveal.js"></script>
  <script>
    Reveal.initialize({
      hash: true,
      slideNumber: true,
      transition: 'slide',
      center: true,
      keyboard: true
    });
  </script>
</body>
</html>
"""

fs.writeFileSync "outputs/brand-course-local.html", html
console.log "✅ Created: outputs/brand-course-local.html"
console.log ""
console.log "使用方法:"
console.log "1. 用浏览器打开: brand-course-local.html?print-pdf"
console.log "   (注意: 一定要加 ?print-pdf)"
console.log "2. 按 CTRL+P (CMD+P) 打开打印对话框"
console.log "3. 目标选 '另存为 PDF'"
console.log "4. 布局选 '横向'"
console.log "5. 边距选 '无'"
console.log "6. 勾选 '背景图形'"
console.log "7. 保存!"
