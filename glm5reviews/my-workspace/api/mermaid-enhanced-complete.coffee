#!/usr/bin/env coffee

# Mermaid图表生成器 - 完整版（支持HTML、PDF、PPTX）
# 工作流：生成HTML → 转换为PDF/PPTX

fs = require "fs"
path = require "path"
puppeteer = require "puppeteer"
PptxGenJS = require "pptxgenjs"

# 导入图表类和创建函数
{ 流程图, 时序图, 类图, 状态图, 创建流程图, 创建时序图, 创建类图, 创建状态图 } = require "./mermaid-enhanced.coffee"

# ============================================
# 全局状态（诗式API）
# ============================================

当前演示 = null
图表编号 = 0

# ============================================
# HTML生成器（RevealJS）
# ============================================

class HTML生成器
  constructor: (@标题, @配置 = {}) ->
    @图表列表 = []
    @配置.主题 ?= "white"
    @配置.过渡 ?= "slide"
    @配置.控制键 ?= true
    @配置.进度条 ?= true
  
  添加图表: (图表) ->
    @图表列表.push 图表
    this
  
  生成: ->
    幻灯片HTML = @图表列表.map (图表, 索引) =>
      mermaid代码 = 图表.生成Mermaid()
      ascii代码 = 图表.生成ASCII()
      
      """
      <section>
        <h2>#{图表.标题}</h2>
        <div class="mermaid-container">
          <div class="mermaid">
            #{mermaid代码}
          </div>
        </div>
        <div class="ascii">
          <h3>ASCII框图</h3>
          <pre><code>#{ascii代码}</code></pre>
        </div>
      </section>
      """
    .join "\n"
    
    """
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>#{@标题}</title>
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.5.0/reveal.min.css">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.5.0/theme/#{@配置.主题}.min.css">
      <script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>
      <style>
        .reveal h2 {
          text-align: center;
          margin-bottom: 1em;
          color: #2B579A;
        }
        .mermaid-container {
          text-align: center;
          margin: 2em 0;
          padding: 1em;
          background: rgba(255,255,255,0.9);
          border-radius: 8px;
        }
        .mermaid {
          font-size: 0.8em;
          display: inline-block;
        }
        .ascii {
          background: #f5f5f5;
          padding: 1em;
          border-radius: 5px;
          margin-top: 2em;
        }
        .ascii h3 {
          margin: 0 0 1em 0;
          font-size: 1em;
          color: #2B579A;
        }
        .ascii pre {
          margin: 0;
          font-size: 0.6em;
          line-height: 1.2;
          overflow-x: auto;
        }
        .ascii code {
          font-family: 'Courier New', monospace;
        }
      </style>
    </head>
    <body>
      <div class="reveal">
        <div class="slides">
          <section>
            <h1>#{@标题}</h1>
          </section>
          #{幻灯片HTML}
        </div>
      </div>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.5.0/reveal.min.js"></script>
      <script>
        // 先初始化Mermaid
        mermaid.initialize({
          startOnLoad: false,
          theme: 'default',
          securityLevel: 'loose'
        });
        
        // 再初始化RevealJS
        Reveal.initialize({
          controls: #{@配置.控制键},
          progress: #{@配置.进度条},
          transition: '#{@配置.过渡}',
          hash: true,
          slideNumber: true,
          width: 1280,
          height: 720,
          margin: 0.04
        });
        
        // 在RevealJS加载完成后渲染Mermaid图表
        Reveal.on('ready', function() {
          mermaid.init();
        });
        
        // 在幻灯片切换时重新渲染Mermaid
        Reveal.on('slidechanged', function(event) {
          setTimeout(function() {
            mermaid.init(undefined, event.currentSlide.querySelectorAll('.mermaid'));
          }, 100);
        });
      </script>
    </body>
    </html>
    """
  
  保存: (文件名) ->
    html = @生成()
    fs.writeFileSync 文件名, html, "utf-8"
    console.log "✅ HTML生成完成：#{文件名}"
    console.log "   共 #{@图表列表.length} 个图表"
    console.log "   使用RevealJS，支持导航和交互"
    文件名

# ============================================
# HTML到PDF转换器（使用Puppeteer）
# ============================================

class HTML转PDF转换器
  constructor: (@htmlPath, @pdfPath) ->
  
  转换: ->
    console.log "📄 正在转换 HTML → PDF..."
    console.log "   输入: #{@htmlPath}"
    console.log "   输出: #{@pdfPath}"
    
    # 尝试查找可用的浏览器
    launchOptions = { 
      headless: "new"
      args: ['--no-sandbox', '--disable-setuid-sandbox']
    }
    
    # 尝试不同的浏览器路径
    browserPaths = [
      "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
      "/Applications/Chromium.app/Contents/MacOS/Chromium"
    ]
    
    for bp in browserPaths
      if fs.existsSync(bp)
        launchOptions.executablePath = bp
        break
    
    browser = await puppeteer.launch(launchOptions)
    
    try
      page = await browser.newPage()
      await page.setViewport({ width: 1280, height: 720 })
      
      fileUrl = "file://" + path.resolve(@htmlPath)
      await page.goto(fileUrl, { waitUntil: 'networkidle0', timeout: 60000 })
      
      # 等待 mermaid 渲染完成
      await page.waitForFunction ->
        document.querySelectorAll('.mermaid').length > 0
      , { timeout: 30000 }
      
      # 等待额外时间让 mermaid 完全渲染
      await new Promise (resolve) -> setTimeout(resolve, 3000)
      
      # 打印为 PDF
      pdfOptions = {
        path: @pdfPath
        format: "A4"
        landscape: true
        printBackground: true
        margin: { top: "0.5cm", bottom: "0.5cm", left: "0.5cm", right: "0.5cm" }
      }
      
      await page.pdf(pdfOptions)
      
      console.log "✅ PDF转换完成：#{@pdfPath}"
      return @pdfPath
      
    finally
      await browser.close()

# ============================================
# HTML到PPTX转换器（使用Puppeteer截图）
# ============================================

class HTML转PPTX转换器
  constructor: (@htmlPath, @pptxPath) ->
  
  转换: ->
    console.log "🖼️ 正在转换 HTML → PPTX..."
    console.log "   输入: #{@htmlPath}"
    console.log "   输出: #{@pptxPath}"
    
    # 临时目录
    outputDir = path.join(path.dirname(@pptxPath), ".temp-slides-#{Date.now()}")
    fs.mkdirSync(outputDir, { recursive: true })
    
    # 尝试查找可用的浏览器
    launchOptions = { 
      headless: "new"
      args: ['--no-sandbox', '--disable-setuid-sandbox']
    }
    
    # 尝试不同的浏览器路径
    browserPaths = [
      "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
      "/Applications/Chromium.app/Contents/MacOS/Chromium"
    ]
    
    for bp in browserPaths
      if fs.existsSync(bp)
        launchOptions.executablePath = bp
        break
    
    browser = await puppeteer.launch(launchOptions)
    
    try
      page = await browser.newPage()
      await page.setViewport({ width: 1280, height: 720 })
      
      fileUrl = "file://" + path.resolve(@htmlPath)
      await page.goto(fileUrl, { waitUntil: 'networkidle0', timeout: 60000 })
      
      # 等待 mermaid 渲染
      await page.waitForFunction ->
        document.querySelectorAll('.mermaid').length > 0
      , { timeout: 30000 }
      
      await new Promise (resolve) -> setTimeout(resolve, 3000)
      
      # 获取总页数
      slideCount = await page.evaluate ->
        document.querySelectorAll('.reveal .slides > section').length
      
      console.log "   发现 #{slideCount} 个幻灯片"
      
      images = []
      for i in [0...slideCount]
        process.stdout.write "\r   截图第 #{i+1}/#{slideCount} 张..."
        
        await page.evaluate((slideIndex) ->
          Reveal.slide(slideIndex)
        , i)
        
        await new Promise (resolve) -> setTimeout(resolve, 800)
        
        imgPath = path.join(outputDir, "slide-#{i+1}.png")
        await page.screenshot({ 
          path: imgPath
          fullPage: false 
        })
        images.push(imgPath)
      
      console.log "\n   正在生成PPTX..."
      
      # 创建PPTX
      pres = new PptxGenJS()
      pres.layout = "LAYOUT_16x9"
      
      for img in images
        slide = pres.addSlide()
        slide.addImage({ 
          path: img
          x: 0, y: 0, w: 10, h: 5.625
        })
      
      await pres.writeFile({ fileName: @pptxPath })
      
      console.log "✅ PPTX转换完成：#{@pptxPath}"
      return @pptxPath
      
    finally
      await browser.close()
      
      # 清理临时图片
      for img in images
        fs.unlinkSync(img) if fs.existsSync(img)
      fs.rmdirSync(outputDir) if fs.existsSync(outputDir)

# ============================================
# 诗式API（极简）
# ============================================

开始绘图HTML = (标题, 配置 = {}) ->
  当前演示 = new HTML生成器 标题, 配置
  图表编号 = 0
  console.log "🎨 开始绘图（HTML）：#{标题}"
  当前演示

完成绘图 = (文件名) ->
  if 当前演示
    return 当前演示.保存 文件名
  else
    console.log "⚠️  没有活动的演示"
    return null

# 快捷函数：生成HTML并转换为PDF
生成PDF = (htmlPath, pdfPath) ->
  转换器 = new HTML转PDF转换器 htmlPath, pdfPath
  await 转换器.转换()

# 快捷函数：生成HTML并转换为PPTX
生成PPTX = (htmlPath, pptxPath) ->
  转换器 = new HTML转PPTX转换器 htmlPath, pptxPath
  await 转换器.转换()

# 快捷函数：生成HTML并转换为PDF和PPTX
生成所有格式 = (htmlPath, pdfPath, pptxPath) ->
  await 生成PDF htmlPath, pdfPath
  await 生成PPTX htmlPath, pptxPath

# ============================================
# 导出
# ============================================

module.exports = {
  开始绘图HTML
  完成绘图
  生成PDF
  生成PPTX
  生成所有格式
  创建流程图
  创建时序图
  创建类图
  创建状态图
  流程图
  时序图
  类图
  状态图
  HTML生成器
  HTML转PDF转换器
  HTML转PPTX转换器
}
