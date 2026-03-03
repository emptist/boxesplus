#!/usr/bin/env coffee

# Mermaid图表生成器 - 用户友好API
# 结合"纵横交换"秘籍，让写作课件的人不需要会编程

fs = require "fs"
PptxGenJS = require "pptxgenjs"
Puppeteer = require "puppeteer"
path = require "path"

# ============================================
# 核心秘籍：纵横交换
# ============================================
#
# 问题：flowchart TD（Top-Down）会产生"高瘦离谱"的图表
# 解决：自动转换为flowchart LR（Left-Right）
# 效果：宽而矮，适合宽屏幕
#
# ============================================

# ============================================
# 用户友好API
# ============================================

确保输出目录存在 = (文件名) ->
  目录 = path.dirname 文件名
  unless fs.existsSync 目录
    fs.mkdirSync 目录, recursive: true

当前演示 = null
图表列表 = []

开始绘图 = (标题) ->
  当前演示 = 
    标题: 标题
    图表列表: []
  图表列表 = []
  console.log "📝 开始绘图：#{标题}"
  
  返回对象 =
    添加图表: (描述) ->
      图表列表.push 描述
      当前演示.图表列表.push 描述
      返回对象
    
    完成: (文件名) ->
      if 文件名.endsWith ".html"
        生成HTML 文件名
      else if 文件名.endsWith ".pdf"
        生成PDF 文件名
      else if 文件名.endsWith ".pptx"
        生成PPTX 文件名
      else
        console.log "⚠️  不支持的格式：#{文件名}"
        console.log "   支持的格式：.html, .pdf, .pptx"
  
  返回对象

添加图表 = (描述) ->
  图表列表.push 描述
  当前演示.图表列表.push 描述
  当前演示

完成绘图 = (文件名) ->
  if 文件名.endsWith ".html"
    生成HTML 文件名
  else if 文件名.endsWith ".pdf"
    生成PDF 文件名
  else if 文件名.endsWith ".pptx"
    生成PPTX 文件名
  else
    console.log "⚠️  不支持的格式：#{文件名}"
    console.log "   支持的格式：.html, .pdf, .pptx"

# ============================================
# 图表类型（用户友好）
# ============================================

流程图 = (描述) ->
  类型: "流程图"
  标题: 描述.标题 ? "流程图"
  内容: 描述.内容 ? 描述.步骤 ? []
  说明: 描述.说明 ? ""

时序图 = (描述) ->
  类型: "时序图"
  标题: 描述.标题 ? "时序图"
  内容: 描述.内容 ? 描述.交互 ? []
  说明: 描述.说明 ? ""

类图 = (描述) ->
  类型: "类图"
  标题: 描述.标题 ? "类图"
  内容: 描述.内容 ? 描述.类 ? []
  说明: 描述.说明 ? ""

状态图 = (描述) ->
  类型: "状态图"
  标题: 描述.标题 ? "状态图"
  内容: 描述.内容 ? 描述.状态 ? []
  说明: 描述.说明 ? ""

# ============================================
# 生成Mermaid代码（自动应用纵横交换）
# ============================================

生成Mermaid代码 = (图表) ->
  switch 图表.类型
    when "流程图"
      生成流程图Mermaid 图表
    when "时序图"
      生成时序图Mermaid 图表
    when "类图"
      生成类图Mermaid 图表
    when "状态图"
      生成状态图Mermaid 图表
    else
      ""

生成流程图Mermaid = (图表) ->
  内容 = 图表.内容
  
  # 自动应用纵横交换
  mermaid = "flowchart LR\n"
  
  if Array.isArray 内容
    for 步骤, 索引 in 内容
      if typeof 步骤 == "string"
        节点名 = "步骤#{索引 + 1}"
        mermaid += "  #{节点名}[#{步骤}]\n"
        
        if 索引 > 0
          上一个节点 = "步骤#{索引}"
          mermaid += "  #{上一个节点} --> #{节点名}\n"
      else if typeof 步骤 == "object"
        节点名 = 步骤.名称 ? 步骤.name ? "步骤#{索引 + 1}"
        mermaid += "  #{节点名}[#{节点名}]\n"
        
        if 索引 > 0
          上一个节点 = 步骤.上一个 ? 步骤.from ? "步骤#{索引}"
          mermaid += "  #{上一个节点} --> #{节点名}\n"
  
  mermaid

生成时序图Mermaid = (图表) ->
  内容 = 图表.内容
  
  mermaid = "sequenceDiagram\n"
  
  if Array.isArray 内容
    参与者 = []
    
    for 交互 in 内容
      if typeof 交互 == "object"
        发送者 = 交互.发送者 ? 交互.from ? "用户"
        接收者 = 交互.接收者 ? 交互.to ? "系统"
        消息 = 交互.消息 ? 交互.message ? ""
        
        if 参与者.indexOf(发送者) == -1
          参与者.push 发送者
          mermaid += "  participant #{发送者}\n"
        
        if 参与者.indexOf(接收者) == -1
          参与者.push 接收者
          mermaid += "  participant #{接收者}\n"
        
        mermaid += "  #{发送者}->>#{接收者}: #{消息}\n"
  
  mermaid

生成类图Mermaid = (图表) ->
  内容 = 图表.内容
  
  mermaid = "classDiagram\n"
  
  if Array.isArray 内容
    for 类, 索引 in 内容
      if typeof 类 == "string"
        mermaid += "  class #{类}\n"
      else if typeof 类 == "object"
        类名 = 类.名称 ? 类.name ? "类#{索引 + 1}"
        mermaid += "  class #{类名} {\n"
        
        if 类.属性
          for 属性 in 类.属性
            mermaid += "    #{属性}\n"
        
        if 类.方法
          for 方法 in 类.方法
            mermaid += "    #{方法}()\n"
        
        mermaid += "  }\n"
        
        if 类.关系
          for 关系 in 类.关系
            mermaid += "  #{类名} #{关系}\n"
  
  mermaid

生成状态图Mermaid = (图表) ->
  内容 = 图表.内容
  
  mermaid = "stateDiagram-v2\n"
  
  if Array.isArray 内容
    for 状态, 索引 in 内容
      if typeof 状态 == "string"
        mermaid += "  [*] --> #{状态}\n"
      else if typeof 状态 == "object"
        状态名 = 状态.名称 ? 状态.name ? "状态#{索引 + 1}"
        
        if 状态.初始
          mermaid += "  [*] --> #{状态名}\n"
        
        if 状态.转换
          for 转换 in 状态.转换
            mermaid += "  #{状态名} --> #{转换.目标 ? 转换.to}: #{转换.标签 ? 转换.label ? ''}\n"
  
  mermaid

# ============================================
# 生成HTML（带导航）
# ============================================

生成HTML = (文件名) ->
  确保输出目录存在 文件名
  
  图表HTML = 图表列表.map (图表, 索引) =>
    mermaid代码 = 生成Mermaid代码 图表
    
    """
    <section id="slide-#{索引}">
      <h2>#{图表.标题}</h2>
      #{if 图表.说明 then "<p class='说明'>#{图表.说明}</p>" else ""}
      <div class="mermaid-container">
        <div class="mermaid">
          #{mermaid代码}
        </div>
      </div>
    </section>
    """
  .join "\n"
  
  html = """
  <!DOCTYPE html>
  <html>
  <head>
    <meta charset="utf-8">
    <title>#{当前演示.标题}</title>
    <script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>
    <style>
      body {
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
        max-width: 1200px;
        margin: 0 auto;
        padding: 2em;
      }
      h1 {
        text-align: center;
        color: #2B579A;
      }
      h2 {
        color: #2B579A;
        border-bottom: 2px solid #2B579A;
        padding-bottom: 0.5em;
      }
      .说明 {
        color: #666;
        font-style: italic;
        margin-bottom: 1em;
      }
      .mermaid-container {
        text-align: center;
        margin: 2em 0;
        padding: 1em;
        background: #f9f9f9;
        border-radius: 8px;
        min-width: 1200px;
        min-height: 800px;
      }
      .mermaid {
        transform: scale(2);
        transform-origin: top center;
        display: inline-block;
      }
      
      /* 导航按钮 */
      .nav {
        position: fixed;
        bottom: 20px;
        right: 20px;
        display: flex;
        gap: 10px;
        z-index: 1000;
      }
      .nav button {
        padding: 10px 20px;
        font-size: 16px;
        background: #2B579A;
        color: white;
        border: none;
        border-radius: 5px;
        cursor: pointer;
        transition: background 0.3s;
      }
      .nav button:hover {
        background: #1a3a5a;
      }
      .nav button:disabled {
        background: #ccc;
        cursor: not-allowed;
      }
      
      /* 进度指示器 */
      .progress {
        position: fixed;
        bottom: 20px;
        left: 20px;
        font-size: 14px;
        color: #666;
      }
    </style>
  </head>
  <body>
    <h1>#{当前演示.标题}</h1>
    #{图表HTML}
    
    <!-- 导航按钮 -->
    <div class="nav">
      <button onclick="prevSlide()">← 上一页</button>
      <button onclick="nextSlide()">下一页 →</button>
    </div>
    
    <!-- 进度指示器 -->
    <div class="progress">
      <span id="current-slide">1</span> / <span id="total-slides">#{图表列表.length}</span>
    </div>
    
    <script>
      var slides = document.querySelectorAll('section');
      var currentIndex = 0;
      var totalSlides = slides.length;
      
      function showSlide(index) {
        if (index < 0 || index >= totalSlides) return;
        
        slides.forEach(function(slide, i) {
          slide.style.display = (i === index) ? 'block' : 'none';
        });
        
        currentIndex = index;
        updateProgress();
        
        // 滚动到顶部
        window.scrollTo(0, 0);
        
        // 重新渲染Mermaid图表
        setTimeout(function() {
          mermaid.init(undefined, slides[currentIndex].querySelectorAll('.mermaid'));
        }, 100);
      }
      
      function nextSlide() {
        if (currentIndex < totalSlides - 1) {
          showSlide(currentIndex + 1);
        }
      }
      
      function prevSlide() {
        if (currentIndex > 0) {
          showSlide(currentIndex - 1);
        }
      }
      
      function updateProgress() {
        document.getElementById('current-slide').textContent = currentIndex + 1;
        document.getElementById('total-slides').textContent = totalSlides;
      }
      
      // 键盘导航
      document.addEventListener('keydown', function(e) {
        if (e.key === 'ArrowRight' || e.key === ' ') {
          e.preventDefault();
          nextSlide();
        } else if (e.key === 'ArrowLeft') {
          e.preventDefault();
          prevSlide();
        }
      });
      
      // 初始化
      showSlide(0);
      
      // 初始化Mermaid
      mermaid.initialize({
        startOnLoad: false,
        theme: 'default',
        securityLevel: 'loose',
        flowchart: {
          useMaxWidth: false,
          htmlLabels: true,
          curve: 'basis',
          padding: 20,
          nodeSpacing: 50,
          rankSpacing: 80
        }
      });
      
      // 页面加载完成后渲染第一个图表
      window.addEventListener('load', function() {
        setTimeout(function() {
          mermaid.init(undefined, slides[0].querySelectorAll('.mermaid'));
        }, 100);
      });
    </script>
  </body>
  </html>
  """
  
  fs.writeFileSync 文件名, html, "utf-8"
  console.log "✅ HTML生成完成：#{文件名}"
  console.log "   共 #{图表列表.length} 个图表"

# ============================================
# 生成PDF（使用Puppeteer）
# ============================================

生成PDF = (文件名) ->
  html文件名 = 文件名.replace /\.pdf$/, ".html"
  生成HTML html文件名
  
  try
    browser = await Puppeteer.launch 
      headless: true
      executablePath: '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
    
    page = await browser.newPage()
    await page.goto "file://#{path.resolve html文件名}", waitUntil: 'domcontentloaded'
    
    await page.pdf
      path: 文件名
      format: "A4"
      landscape: true
      printBackground: true
      margin: { top: "0.5cm", bottom: "0.5cm", left: "0.5cm", right: "0.5cm" }
    
    await browser.close()
    
    console.log "✅ PDF生成完成：#{文件名}"
    console.log "   共 #{图表列表.length} 个图表"
  
  catch 错误
    console.error "生成PDF失败:", 错误.message

# ============================================
# 生成PPTX（使用PptxGenJS）
# ============================================

生成PPTX = (文件名) ->
  pptx = new PptxGenJS()
  pptx.layout = "LAYOUT_16x9"
  pptx.title = 当前演示.标题
  
  for 图表 in 图表列表
    slide = pptx.addSlide()
    
    slide.addText 图表.标题,
      x: 0.5, y: 0.3, w: 9, h: 0.6
      fontSize: 28, bold: true, color: "2B579A"
    
    if 图表.说明
      slide.addText 图表.说明,
        x: 0.5, y: 1.0, w: 9, h: 0.4
        fontSize: 14, color: "666666"
    
    mermaid代码 = 生成Mermaid代码 图表
    
    slide.addText "Mermaid代码：",
      x: 0.5, y: 1.5, w: 9, h: 0.4
      fontSize: 14, bold: true, color: "666666"
    
    slide.addText mermaid代码,
      x: 0.5, y: 2.0, w: 9, h: 3.0
      fontSize: 10, color: "333333", align: "left"
    
    slide.addText "注意：PptxGenJS不支持直接渲染Mermaid图表",
      x: 0.5, y: 5.2, w: 9, h: 0.4
      fontSize: 12, color: "FF6B6B", bold: true
    
    slide.addText "如需渲染图表，请使用HTML或PDF版本",
      x: 0.5, y: 5.6, w: 9, h: 0.4
      fontSize: 12, color: "666666"
  
  pptx.writeFile({ fileName: 文件名 })
    .then =>
      console.log "✅ PPTX生成完成：#{文件名}"
      console.log "   共 #{图表列表.length} 个图表"
      console.log "   注意：PptxGenJS不支持直接渲染Mermaid图表，仅显示代码"

# ============================================
# 导出
# ============================================

module.exports = {
  开始绘图
  添加图表
  完成绘图
  流程图
  时序图
  类图
  状态图
}
