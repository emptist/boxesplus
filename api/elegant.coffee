# BoxesPlus - CoffeeScript 数据驱动幻灯片 (极简诗式版)
# 核心理念：CoffeeScript 让 JSON 更神奇，让写幻灯片像写诗一样自然

fs = require "fs"

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
      when "title" then slides.push titleSlide(slide)
      when "section" then slides.push sectionSlide(slide)
      when "end" then slides.push endSlide(slide)
      when "list" then slides.push listSlide(slide)
      when "cards" then slides.push cardsSlide(slide)
      when "pdca" then slides.push pdcaSlide(slide)
      when "swot" then slides.push swotSlide(slide)
      when "timeline" then slides.push timelineSlide(slide)
      when "flowchart" then slides.push flowchartSlide(slide)
      when "org" then slides.push orgChartSlide(slide)
      when "comparison" then slides.push comparisonSlide(slide)
      when "quote" then slides.push quoteSlide(slide)
      when "box" then slides.push boxSlide(slide)
      when "pyramid" then slides.push pyramidSlide(slide)
      when "verticalFlow" then slides.push verticalFlowSlide(slide)
      when "matrix" then slides.push matrixSlide(slide)
  
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
      
      /* 卡片悬浮效果 */
      .card-hover { transition: transform 0.3s, box-shadow 0.3s; }
      .card-hover:hover { transform: translateY(-5px); box-shadow: 0 8px 25px rgba(0,0,0,0.15); }
      
      /* 表格样式 */
      .reveal table { border-collapse: collapse; width: 100%; }
      .reveal table th { background: #1a365d; color: white; padding: 12px; }
      .reveal table td { padding: 10px; border-bottom: 1px solid #e2e8f0; }
      .reveal table tr:nth-child(even) { background: #f7fafc; }
      
      /* 流程图箭头 */
      .flow-arrow { color: #a0aec0; font-size: 1.5em; }
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
      
      // 自动缩放溢出内容 - 改进版
      function scaleOverflowContent() {
        var slides = document.querySelectorAll('.reveal .slides section');
        slides.forEach(function(slide) {
          // 找到内容区域（通常是有背景色的div）
          var content = slide.querySelector('div[style*="background"]') || slide.querySelector('div');
          if (!content) return;
          
          var slideRect = slide.getBoundingClientRect();
          var contentRect = content.getBoundingClientRect();
          
          // 使用可视区域计算
          var availableHeight = slideRect.height - 60; // 留出边距
          
          // 如果内容超出
          if (contentRect.height > availableHeight) {
            var scale = availableHeight / contentRect.height;
            if (scale < 0.4) scale = 0.4; // 最小40%
            
            // 应用缩放
            content.style.transform = 'scale(' + scale + ')';
            content.style.transformOrigin = 'top left';
            content.style.width = (100 / scale) + '%';
            content.style.maxWidth = '100%';
          }
        });
      }
      
      // 延迟执行，确保 Reveal 完全初始化
      setTimeout(scaleOverflowContent, 500);
      Reveal.on('ready', scaleOverflowContent);
      Reveal.on('slidechanged', function() { setTimeout(scaleOverflowContent, 100); });
      window.addEventListener('resize', scaleOverflowContent);
    </script>
  </body>
  </html>
  """
  
  fs.writeFileSync(outputPath, html)
  console.log "✅ Created: #{outputPath}"

# ============ 组件函数 ============

titleSlide = (opts = {}) ->
  { title, subtitle, gradient } = opts
  gradient = gradient || "linear-gradient(135deg, #1a365d 0%, #2c5282 100%)"
  
  """
  <section style="text-align: center; background: #{gradient};">
    <h1 style="color: white; font-size: 2.2em; margin-bottom: 20px;">#{title || '标题'}</h1>
    <h3 style="color: #90cdf4; font-size: 1.2em;">#{subtitle || ''}</h3>
  </section>
  """

sectionSlide = (opts = {}) ->
  { title, subtitle } = opts
  
  """
  <section style="text-align: center; background: linear-gradient(135deg, #1a365d 0%, #2c5282 100%);">
    <h1 style="color: white; font-size: 2.5em;">#{title || '章节'}</h1>
    <h2 style="color: #90cdf4; margin-top: 20px;">#{subtitle || ''}</h2>
  </section>
  """

endSlide = (opts = {}) ->
  { title, subtitle } = opts
  
  """
  <section style="text-align: center; background: linear-gradient(135deg, #1a365d 0%, #2c5282 100%);">
    <h1 style="color: white; font-size: 3em;">#{title || '谢谢!'}</h1>
    <h3 style="color: #90cdf4; margin-top: 20px;">#{subtitle || ''}</h3>
  </section>
  """

quoteSlide = (opts = {}) ->
  { title, quote, author } = opts
  
  """
  <section>
    <h2 style="color: #1a365d; text-align: center;">#{title || '金句'}</h2>
    <div style="margin: 40px auto; max-width: 800px;">
      <p style="font-size: 1.5em; color: #2c5282; font-style: italic; line-height: 1.6; text-align: center;">"#{quote || '引用内容'}"</p>
      <p style="text-align: right; color: #718096; margin-top: 20px;">— #{author || '作者'}</p>
    </div>
  </section>
  """

listSlide = (opts = {}) ->
  { title, items } = opts
  items = items || ["要点1", "要点2", "要点3"]
  
  itemsHtml = items.map((item, i) -> 
    """
    <div style="display: flex; align-items: flex-start; margin-bottom: 15px;">
      <div style="background: #3182ce; color: white; width: 30px; height: 30px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.7em; margin-right: 15px; flex-shrink: 0;">#{i + 1}</div>
      <div style="font-size: 0.75em; color: #2d3748; padding-top: 5px;">#{item}</div>
    </div>
    """
  ).join("")
  
  """
  <section>
    <h2 style="color: #1a365d;">#{title || '内容'}</h2>
    <div style="margin-top: 30px; padding: 0 20px;">
      #{itemsHtml}
    </div>
  </section>
  """

# 带边框的内容框
boxSlide = (opts = {}) ->
  { title, content, color } = opts
  color = color || "#f7fafc"
  
  # 支持多行内容
  if typeof content is "string"
    contentHtml = "<p style='font-size: 0.6em; color: #2d3748; line-height: 1.6;'>#{content.replace(/\n/g, "<br>")}</p>"
  else if Array.isArray(content)
    contentHtml = content.map((line) -> "<p style='font-size: 0.6em; color: #2d3748; line-height: 1.6; margin: 0 0 8px 0;'>#{line}</p>").join("")
  
  """
  <section>
    <h2 style="color: #1a365d;">#{title || '内容'}</h2>
    <div style="background: #{color}; border-left: 5px solid #2c5282; border-radius: 8px; padding: 15px; margin-top: 15px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
      #{contentHtml}
    </div>
  </section>
  """

cardsSlide = (opts = {}) ->
  { title, cards } = opts
  cards = cards || [
    { title: "卡片1", content: "内容1", color: "#ebf8ff" }
    { title: "卡片2", content: "内容2", color: "#f0fff4" }
    { title: "卡片3", content: "内容3", color: "#fffaf0" }
  ]
  
  cardsHtml = cards.map((card) ->
    """
    <div class="card-hover" style="flex: 1; background: #{card.color}; border-radius: 10px; padding: 20px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); min-width: 200px;">
      <h3 style="margin: 0 0 10px 0; font-size: 0.85em; color: #1a365d;">#{card.title}</h3>
      <p style="margin: 0; font-size: 0.7em; color: #4a5568;">#{card.content}</p>
    </div>
    """
  ).join("")
  
  """
  <section>
    <h2 style="color: #1a365d; text-align: center;">#{title || '特点'}</h2>
    <div style="display: flex; gap: 20px; margin-top: 40px; justify-content: center; flex-wrap: wrap;">
      #{cardsHtml}
    </div>
  </section>
  """

pdcaSlide = (opts = {}) ->
  { title } = opts
  
  # 同心圆 + 箭头
  """
  <section>
    <h2 style="color: #1a365d; text-align: center;">#{title || 'PDCA循环'}</h2>
    <div style="position: relative; width: 380px; height: 380px; margin: 10px auto;">
      
      <!-- 外圈 - 四个扇形 -->
      <svg width="380" height="380" style="position: absolute; top: 0; left: 0; z-index: 1;">
        <path d="M 190 190 L 190 20 A 170 170 0 0 1 360 190 Z" fill="#3182ce" opacity="0.85"/>
        <path d="M 190 190 L 360 190 A 170 170 0 0 1 190 360 Z" fill="#38a169" opacity="0.85"/>
        <path d="M 190 190 L 190 360 A 170 170 0 0 1 20 190 Z" fill="#d69e2e" opacity="0.85"/>
        <path d="M 190 190 L 20 190 A 170 170 0 0 1 190 20 Z" fill="#e53e3e" opacity="0.85"/>
      </svg>
      
      <!-- 箭头 - 美国国旗蓝 -->
      <svg width="380" height="380" style="position: absolute; top: 0; left: 0; z-index: 2;">
        <defs>
          <marker id="arr-p" markerWidth="7" markerHeight="5" refX="7" refY="2.5" orient="auto"><polygon points="0 0, 7 2.5, 0 5" fill="#3C3B6E"/></marker>
        </defs>
        <path d="M 190 35 A 155 155 0 0 1 330 80" stroke="#3C3B6E" stroke-width="2.5" fill="none" marker-end="url(#arr-p)"/>
        <path d="M 345 190 A 155 155 0 0 1 300 345" stroke="#3C3B6E" stroke-width="2.5" fill="none" marker-end="url(#arr-p)"/>
        <path d="M 190 345 A 155 155 0 0 1 50 300" stroke="#3C3B6E" stroke-width="2.5" fill="none" marker-end="url(#arr-p)"/>
        <path d="M 35 190 A 155 155 0 0 1 80 35" stroke="#3C3B6E" stroke-width="2.5" fill="none" marker-end="url(#arr-p)"/>
      </svg>
      
      <!-- 标签 - 靠近中心 -->
      <div style="position: absolute; top: 70px; right: 70px; width: 55px; height: 55px; display: flex; flex-direction: column; align-items: center; justify-content: center; color: white; font-size: 0.5em; z-index: 3;">
        <strong>PLAN</strong><span style="font-size: 0.85em;">计划</span>
      </div>
      <div style="position: absolute; bottom: 70px; right: 70px; width: 55px; height: 55px; display: flex; flex-direction: column; align-items: center; justify-content: center; color: white; font-size: 0.5em; z-index: 3;">
        <strong>DO</strong><span style="font-size: 0.85em;">执行</span>
      </div>
      <div style="position: absolute; bottom: 70px; left: 70px; width: 55px; height: 55px; display: flex; flex-direction: column; align-items: center; justify-content: center; color: white; font-size: 0.5em; z-index: 3;">
        <strong>CHECK</strong><span style="font-size: 0.85em;">检查</span>
      </div>
      <div style="position: absolute; top: 70px; left: 70px; width: 55px; height: 55px; display: flex; flex-direction: column; align-items: center; justify-content: center; color: white; font-size: 0.5em; z-index: 3;">
        <strong>ACT</strong><span style="font-size: 0.85em;">行动</span>
      </div>
      
      <!-- 中心圆 -->
      <div style="position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 120px; height: 120px; background: #1a365d; border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-size: 0.8em; text-align: center; box-shadow: 0 4px 15px rgba(26,54,93,0.5); z-index: 10;">
        持续<br>改进
      </div>
      
    </div>
  </section>
  """

swotSlide = (opts = {}) ->
  { title, strengths, weaknesses, opportunities, threats } = opts
  
  strengths = strengths || ["优势1", "优势2"]
  weaknesses = weaknesses || ["劣势1", "劣势2"]
  opportunities = opportunities || ["机会1", "机会2"]
  threats = threats || ["威胁1", "威胁2"]
  
  listHtml = (items) -> items.map((item) -> "<li style='margin-bottom: 8px;'>#{item}</li>").join("")
  
  """
  <section>
    <h2 style="color: #1a365d; text-align: center;">#{title || 'SWOT分析'}</h2>
    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-top: 30px;">
      <div style="background: linear-gradient(135deg, #c6f6d5, #9ae6b4); padding: 20px; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.1);">
        <h4 style="color: #276749; margin: 0 0 10px 0; font-size: 0.9em;">✅ 优势 Strengths</h4>
        <ul style="font-size: 0.65em; margin: 0; padding-left: 18px; color: #22543d;">#{listHtml(strengths)}</ul>
      </div>
      <div style="background: linear-gradient(135deg, #fed7d7, #feb2b2); padding: 20px; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.1);">
        <h4 style="color: #c53030; margin: 0 0 10px 0; font-size: 0.9em;">⚠️ 劣势 Weaknesses</h4>
        <ul style="font-size: 0.65em; margin: 0; padding-left: 18px; color: #742a2a;">#{listHtml(weaknesses)}</ul>
      </div>
      <div style="background: linear-gradient(135deg, #bee3f8, #90cdf4); padding: 20px; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.1);">
        <h4 style="color: #2b6cb0; margin: 0 0 10px 0; font-size: 0.9em;">🔮 机会 Opportunities</h4>
        <ul style="font-size: 0.65em; margin: 0; padding-left: 18px; color: #2a4365;">#{listHtml(opportunities)}</ul>
      </div>
      <div style="background: linear-gradient(135deg, #feebc8, #fbd38d); padding: 20px; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.1);">
        <h4 style="color: #c05621; margin: 0 0 10px 0; font-size: 0.9em;">🚨 威胁 Threats</h4>
        <ul style="font-size: 0.65em; margin: 0; padding-left: 18px; color: #744210;">#{listHtml(threats)}</ul>
      </div>
    </div>
  </section>
  """

timelineSlide = (opts = {}) ->
  { title, events } = opts
  events = events || [
    { title: "第一阶段", desc: "描述", color: "#3182ce" }
    { title: "第二阶段", desc: "描述", color: "#38a169" }
  ]
  
  eventsHtml = events.map((event, i) ->
    """
    <div style="position: relative; margin-bottom: 25px; padding-left: 40px;">
      <div style="position: absolute; left: 0; top: 0; background: #{event.color}; color: white; width: 30px; height: 30px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.7em; box-shadow: 0 2px 5px rgba(0,0,0,0.2);">#{i + 1}</div>
      <h4 style="margin: 0; color: #1a365d; font-size: 0.9em;">#{event.title}</h4>
      <p style="font-size: 0.65em; color: #718096; margin: 5px 0 0 0;">#{event.desc}</p>
    </div>
    """
  ).join("")
  
  """
  <section>
    <h2 style="color: #1a365d; text-align: center;">#{title || '时间线'}</h2>
    <div style="margin-top: 30px; padding-left: 20px; border-left: 4px solid #3182ce;">
      #{eventsHtml}
    </div>
  </section>
  """

flowchartSlide = (opts = {}) ->
  { title, steps } = opts
  steps = steps || [
    { text: "步骤1", color: "#3182ce" }
    { text: "步骤2", color: "#38a169" }
    { text: "步骤3", color: "#d69e2e" }
    { text: "步骤4", color: "#e53e3e" }
  ]
  
  stepsHtml = steps.map((s, i) -> 
    """
    <div style="background: #{s.color}; color: white; padding: 12px 25px; border-radius: 6px; font-size: 0.75em; box-shadow: 0 2px 5px rgba(0,0,0,0.2);">#{s.text}</div>
    """ + (if i < steps.length - 1 then "<span class='flow-arrow'>→</span>" else "")
  ).join("")
  
  """
  <section>
    <h2 style="color: #1a365d; text-align: center;">#{title || '流程图'}</h2>
    <div style="display: flex; align-items: center; justify-content: center; margin-top: 50px; flex-wrap: wrap; gap: 10px;">
      #{stepsHtml}
    </div>
  </section>
  """

orgChartSlide = (opts = {}) ->
  { title, levels } = opts
  levels = levels || [
    { text: "院长", color: "#1a365d" }
    { text: ["副院长1", "副院长2"], color: "#2b6cb0" }
    { text: ["科室1", "科室2", "科室3"], color: "#3182ce" }
  ]
  
  levelsHtml = levels.map((level, i) ->
    items = if Array.isArray(level.text) then level.text else [level.text]
    itemsHtml = items.map((item) -> 
      "<div style=\"background: #{level.color}; color: white; padding: 10px 25px; border-radius: 6px; font-size: 0.7em; margin: 0 5px; box-shadow: 0 2px 5px rgba(0,0,0,0.2);\">#{item}</div>"
    ).join("")
    
    """
    <div style="display: flex; justify-content: center; gap: 15px; margin: 10px 0;">
      #{itemsHtml}
    </div>
    #{if i < levels.length - 1 then '<div style="width: 3px; height: 25px; background: #cbd5e0; margin: 0 auto;"></div>' else ''}
    """
  ).join("")
  
  """
  <section>
    <h2 style="color: #1a365d; text-align: center;">#{title || '组织架构'}</h2>
    <div style="margin-top: 30px; text-align: center;">
      #{levelsHtml}
    </div>
  </section>
  """

comparisonSlide = (opts = {}) ->
  { title, headers, rows, left, right } = opts
  
  # 如果使用 left/right 格式
  if left or right
    left = left || []
    right = right || []
    
    leftHtml = left.map((col) ->
      itemsHtml = col.items.map((item) -> "<li>#{item}</li>").join("")
      """
      <div style="background: #f7fafc; padding: 15px; border-radius: 8px; margin-bottom: 10px; border-left: 4px solid #3182ce;">
        <div style="font-weight: bold; color: #2c5282; margin-bottom: 8px;">#{col.title}</div>
        <ul style="margin: 0; padding-left: 20px; font-size: 0.75em; color: #4a5568;">#{itemsHtml}</ul>
      </div>
      """
    ).join("")
    
    rightHtml = right.map((col) ->
      itemsHtml = col.items.map((item) -> "<li>#{item}</li>").join("")
      """
      <div style="background: #f7fafc; padding: 15px; border-radius: 8px; margin-bottom: 10px; border-left: 4px solid #38a169;">
        <div style="font-weight: bold; color: #276749; margin-bottom: 8px;">#{col.title}</div>
        <ul style="margin: 0; padding-left: 20px; font-size: 0.75em; color: #4a5568;">#{itemsHtml}</ul>
      </div>
      """
    ).join("")
    
    """
    <section>
      <h2 style="color: #1a365d; text-align: center;">#{title || '对比分析'}</h2>
      <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px; margin-top: 30px; padding: 0 20px;">
        <div>#{leftHtml}</div>
        <div>#{rightHtml}</div>
      </div>
    </section>
    """
  else
    # 使用表格格式
    headers = headers || ["维度", "方案A", "方案B"]
    rows = rows || [
      ["优点", "免费", "稳定"]
      ["缺点", "功能少", "收费"]
    ]
    
    headerHtml = headers.map((h) -> "<th>#{h}</th>").join("")
    rowsHtml = rows.map((row, i) ->
      cells = row.map((cell) -> "<td>#{cell}</td>").join("")
      "<tr>#{cells}</tr>"
    ).join("")
    
    """
    <section>
      <h2 style="color: #1a365d; text-align: center;">#{title || '对比分析'}</h2>
      <table style="width: 90%; margin: 30px auto;">
        <tr>#{headerHtml}</tr>
        #{rowsHtml}
      </table>
    </section>
    """

# 金字塔/层级图
pyramidSlide = (opts = {}) ->
  { title, levels } = opts
  levels = levels || [
    { text: "顶层", color: "#1a365d" }
    { text: "中层", color: "#2c5282" }
    { text: "底层", color: "#3182ce" }
  ]
  
  levelsHtml = levels.map((level, i) ->
    width = 200 - (i * 40)
    """
    <div style="background: #{level.color}; color: white; padding: 15px #{200-width+15}px; border-radius: 5px; margin: 3px auto; text-align: center; font-size: 0.7em;">
      #{level.text}
    </div>
    """
  ).join("")
  
  """
  <section>
    <h2 style="color: #1a365d; text-align: center;">#{title || '金字塔'}</h2>
    <div style="margin-top: 40px;">
      #{levelsHtml}
    </div>
  </section>
  """

# 垂直流程图
verticalFlowSlide = (opts = {}) ->
  { title, steps } = opts
  steps = steps || [
    { text: "步骤1", color: "#3182ce" }
    { text: "步骤2", color: "#38a169" }
    { text: "步骤3", color: "#d69e2e" }
    { text: "步骤4", color: "#e53e3e" }
  ]
  
  stepsHtml = steps.map((step, i) ->
    """
    <div style="display: flex; align-items: center; margin-bottom: 15px;">
      <div style="background: #{step.color}; color: white; width: 30px; height: 30px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 0.7em; margin-right: 15px; flex-shrink: 0;">#{i+1}</div>
      <div style="background: #{step.color}; color: white; padding: 10px 20px; border-radius: 5px; font-size: 0.7em; flex: 1;">#{step.text}</div>
    </div>
    """ + (if i < steps.length - 1 then "<div style='width: 2px; height: 20px; background: #cbd5e0; margin-left: 14px;'></div>" else "")
  ).join("")
  
  """
  <section>
    <h2 style="color: #1a365d;">#{title || '流程'}</h2>
    <div style="margin-top: 30px; padding: 0 50px;">
      #{stepsHtml}
    </div>
  </section>
  """

# 矩阵图
matrixSlide = (opts = {}) ->
  { title, rows } = opts
  # rows: [{topLeft, topRight, bottomLeft, bottomRight}]
  rows = rows || [
    { topLeft: "左上1", topRight: "右上1" }
    { bottomLeft: "左下1", bottomRight: "右下1" }
  ]
  
  cells = rows[0]
  cellHtml = (content, bg) -> "<div style='background: #{bg}; padding: 20px; border-radius: 8px; min-height: 80px;'><div style='font-size: 0.8em; color: #1a365d; font-weight: bold;'>#{content}</div></div>"
  
  """
  <section>
    <h2 style="color: #1a365d; text-align: center;">#{title || '矩阵'}</h2>
    <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-top: 40px; padding: 0 50px;">
      #{cellHtml(cells?.topLeft || "左上", "#c6f6d5")}
      #{cellHtml(cells?.topRight || "右上", "#bee3f8")}
      #{cellHtml(rows[1]?.bottomLeft || "左下", "#feebc8")}
      #{cellHtml(rows[1]?.bottomRight || "右下", "#fed7d7")}
    </div>
  </section>
  """

# 导出
module.exports = { generateFromData, generateHtml }

# 示例
# 示例 - 诗式写法（需要逗号分隔数组元素）
if require.main is module
  课程 = 
    title: "医院品牌建设"
    subtitle: "E02 品牌建设课程"
    slides: [
      { type: "cards", title: "课程目标", cards: [
        { title: "知识目标", content: "掌握品牌管理理论", color: "#ebf8ff" }
        { title: "能力目标", content: "制定品牌战略", color: "#f0fff4" }
        { title: "素质目标", content: "培养品牌思维", color: "#fffaf0" }
      ]}
      { type: "section", title: "第一章", subtitle: "品牌管理概述" }
      { type: "flowchart", title: "品牌建设流程", steps: [
        { text: "调研分析", color: "#2b6cb0" }
        { text: "战略规划", color: "#38a169" }
        { text: "执行落地", color: "#d69e2e" }
        { text: "评估优化", color: "#e53e3e" }
      ]}
      { type: "pdca", title: "PDCA 循环" }
      { type: "swot", title: "SWOT 分析", strengths: ["技术领先", "专家团队"], weaknesses: ["传播不足", "新媒体弱"], opportunities: ["政策支持", "市场需求"], threats: ["竞争激烈", "舆论风险"] }
      { type: "timeline", title: "实施时间线", events: [
        { title: "调研诊断", desc: "1-2月", color: "#3182ce" }
        { title: "战略规划", desc: "3-4月", color: "#38a169" }
        { title: "执行落地", desc: "5-10月", color: "#d69e2e" }
        { title: "评估优化", desc: "11-12月", color: "#e53e3e" }
      ]}
      { type: "org", title: "组织架构", levels: [
        { text: "品牌委员会", color: "#1a365d" }
        { text: ["总监", "市场部", "宣传部"], color: "#2b6cb0" }
        { text: ["策划", "推广", "运营", "公关"], color: "#3182ce" }
      ]}
      { type: "comparison", title: "传统 vs 现代", headers: ["维度", "传统", "现代"], rows: [
        ["渠道", "电视报纸", "微信抖音"]
        ["方式", "单向传播", "双向互动"]
        ["成本", "高", "低"]
        ["效果", "难评估", "精准"]
      ]}
      { type: "quote", title: "金句", quote: "品牌是企业最重要的无形资产", author: "某大师" }
      { type: "end", title: "谢谢!", subtitle: "BoxesPlus - CoffeeScript 驱动" }
    ]
  
  console.log "Slides count:", 课程.slides.length
  generateHtml 课程, "outputs/elegant-demo.html"
  console.log "Done! Open outputs/elegant-demo.html"
