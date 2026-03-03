#!/usr/bin/env coffee

# 混合生成器 v2 - 使用PDF转PPTX（不截图）
# 简单内容 → PPTX直接生成
# 复杂内容 → HTML → PDF → PPTX

fs = require "fs"
path = require "path"
puppeteer = require "puppeteer"
PptxGenJS = require "pptxgenjs"
{ exec } = require "child_process"
{ promisify } = require "util"

execAsync = promisify(exec)

# 导入图表类和创建函数
{ 流程图, 时序图, 类图, 状态图, 创建流程图, 创建时序图, 创建类图, 创建状态图 } = require "./mermaid-enhanced.coffee"

# ============================================
# 全局状态（诗式API）
# ============================================

当前演示 = null
图表编号 = 0

# ============================================
# PPTX生成器（用于简单内容）
# ============================================

class PPTX生成器
  constructor: (@标题) ->
    @pptx = new PptxGenJS()
    @pptx.layout = "LAYOUT_16x9"
    @pptx.title = @标题
    @幻灯片列表 = []
  
  添加封面: (标题, 副标题 = "") ->
    slide = @pptx.addSlide()
    slide.background = { color: "2B579A" }
    
    slide.addText 标题,
      x: 0.5, y: 2.5, w: 9, h: 1.2
      fontSize: 44, bold: true, color: "FFFFFF", align: "center"
    
    if 副标题
      slide.addText 副标题,
        x: 0.5, y: 3.8, w: 9, h: 0.6
        fontSize: 24, color: "E0E0E0", align: "center"
  
  添加章节: (标题, 副标题 = "") ->
    slide = @pptx.addSlide()
    slide.background = { color: "F0F4F8" }
    
    slide.addText 标题,
      x: 0.5, y: 2.5, w: 9, h: 1.0
      fontSize: 36, bold: true, color: "2B579A", align: "center"
    
    if 副标题
      slide.addText 副标题,
        x: 0.5, y: 3.6, w: 9, h: 0.5
        fontSize: 20, color: "666666", align: "center"
  
  添加列表: (标题, 列表项) ->
    slide = @pptx.addSlide()
    
    slide.addText 标题,
      x: 0.5, y: 0.3, w: 9, h: 0.6
      fontSize: 28, bold: true, color: "2B579A"
    
    y = 1.2
    for item, i in 列表项
      slide.addText "• #{item}",
        x: 0.5, y: y, w: 9, h: 0.5
        fontSize: 18, color: "333333"
      y += 0.6
  
  添加表格: (标题, 表头, 数据) ->
    slide = @pptx.addSlide()
    
    slide.addText 标题,
      x: 0.5, y: 0.3, w: 9, h: 0.6
      fontSize: 28, bold: true, color: "2B579A"
    
    x = 0.5
    y = 1.2
    colWidth = 9 / 表头.length
    
    for header in 表头
      slide.addText header,
        x: x, y: y, w: colWidth, h: 0.5
        fontSize: 14, bold: true, color: "FFFFFF", align: "center"
        fill: { color: "2B579A" }
      x += colWidth
    
    for row in 数据
      y += 0.5
      x = 0.5
      for cell in row
        slide.addText cell,
          x: x, y: y, w: colWidth, h: 0.5
          fontSize: 12, color: "333333", align: "center"
        x += colWidth
  
  保存: (文件名) ->
    @pptx.writeFile({ fileName: 文件名 })
      .then =>
        console.log "✅ PPTX生成完成：#{文件名}"
        console.log "   共 #{@pptx.slides.length} 个幻灯片"

# ============================================
# HTML生成器（用于复杂内容）
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
        mermaid.initialize({
          startOnLoad: false,
          theme: 'default',
          securityLevel: 'loose'
        });
        
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
        
        Reveal.on('ready', function() {
          mermaid.init();
        });
        
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
    文件名

# ============================================
# HTML到PDF转换器
# ============================================

class HTML转PDF转换器
  constructor: (@htmlPath, @pdfPath) ->
  
  转换: ->
    console.log "📄 正在转换 HTML → PDF..."
    
    launchOptions = { 
      headless: "new"
      args: ['--no-sandbox', '--disable-setuid-sandbox']
    }
    
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
      
      await page.waitForFunction ->
        document.querySelectorAll('.mermaid').length > 0
      , { timeout: 30000 }
      
      await new Promise (resolve) -> setTimeout(resolve, 3000)
      
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
# PDF到PPTX转换器（使用LibreOffice）
# ============================================

class PDF转PPTX转换器
  constructor: (@pdfPath, @pptxPath) ->
  
  转换: ->
    console.log "📊 正在转换 PDF → PPTX..."
    
    # 检查LibreOffice是否安装
    libreOfficePaths = [
      "/Applications/LibreOffice.app/Contents/MacOS/soffice"
      "/usr/bin/libreoffice"
      "/usr/bin/soffice"
    ]
    
    libreOfficePath = null
    for lp in libreOfficePaths
      if fs.existsSync(lp)
        libreOfficePath = lp
        break
    
    unless libreOfficePath
      console.log "⚠️  未找到LibreOffice，尝试使用替代方案..."
      return await @使用截图方式()
    
    try
      # 使用LibreOffice转换
      outputDir = path.dirname(@pptxPath)
      cmd = "#{libreOfficePath} --headless --convert-to pptx --outdir #{outputDir} #{@pdfPath}"
      
      await execAsync cmd
      
      # LibreOffice会生成同名.pptx文件
      generatedPptx = @pdfPath.replace(".pdf", ".pptx")
      
      # 如果生成的文件名不同，重命名
      if generatedPptx isnt @pptxPath and fs.existsSync(generatedPptx)
        fs.renameSync(generatedPptx, @pptxPath)
      
      console.log "✅ PPTX转换完成：#{@pptxPath}"
      return @pptxPath
      
    catch error
      console.log "⚠️  LibreOffice转换失败：#{error.message}"
      console.log "   使用截图方式作为备选方案..."
      return await @使用截图方式()
  
  使用截图方式: ->
    console.log "🖼️ 使用截图方式转换..."
    
    outputDir = path.join(path.dirname(@pptxPath), ".temp-slides-#{Date.now()}")
    fs.mkdirSync(outputDir, { recursive: true })
    
    launchOptions = { 
      headless: "new"
      args: ['--no-sandbox', '--disable-setuid-sandbox']
    }
    
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
      
      fileUrl = "file://" + path.resolve(@pdfPath)
      await page.goto(fileUrl, { waitUntil: 'networkidle0', timeout: 60000 })
      await new Promise (resolve) -> setTimeout(resolve, 2000)
      
      # 获取PDF页数
      pageCount = await page.evaluate ->
        document.querySelectorAll("body").length
      
      images = []
      for i in [0...pageCount]
        process.stdout.write "\r   截图第 #{i+1}/#{pageCount} 张..."
        
        imgPath = path.join(outputDir, "page-#{i+1}.png")
        await page.screenshot({ 
          path: imgPath
          fullPage: true 
        })
        images.push(imgPath)
      
      console.log "\n   正在生成PPTX..."
      
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
      
      for img in images
        fs.unlinkSync(img) if fs.existsSync(img)
      fs.rmdirSync(outputDir) if fs.existsSync(outputDir)

# ============================================
# 混合生成器（主入口）
# ============================================

class 混合生成器
  constructor: (@标题, @输出路径) ->
    @简单内容列表 = []
    @复杂内容列表 = []
  
  添加简单内容: (内容) ->
    @简单内容列表.push 内容
    this
  
  添加复杂内容: (图表) ->
    @复杂内容列表.push 图表
    this
  
  生成: ->
    console.log "\n========================================"
    console.log "混合生成策略 v2"
    console.log "========================================"
    console.log "简单内容：#{@简单内容列表.length} 个"
    console.log "复杂内容：#{@复杂内容列表.length} 个"
    console.log ""
    
    # 生成简单内容的PPTX
    if @简单内容列表.length > 0
      console.log "步骤1：生成简单内容PPTX..."
      pptx生成器 = new PPTX生成器 @标题
      
      for 内容 in @简单内容列表
        switch 内容.类型
          when "封面"
            pptx生成器.添加封面 内容.标题, 内容.副标题
          when "章节"
            pptx生成器.添加章节 内容.标题, 内容.副标题
          when "列表"
            pptx生成器.添加列表 内容.标题, 内容.列表项
          when "表格"
            pptx生成器.添加表格 内容.标题, 内容.表头, 内容.数据
      
      simplePptxPath = @输出路径.replace(".pptx", "-简单.pptx")
      await pptx生成器.保存 simplePptxPath
    
    # 生成复杂内容的HTML
    if @复杂内容列表.length > 0
      console.log "\n步骤2：生成复杂内容HTML..."
      html生成器 = new HTML生成器 "#{@标题}（复杂内容）"
      
      for 图表 in @复杂内容列表
        html生成器.添加图表 图表
      
      htmlPath = @输出路径.replace(".pptx", "-复杂.html")
      html生成器.保存 htmlPath
      
      # 转换为PDF
      console.log "\n步骤3：转换为PDF..."
      pdfPath = @输出路径.replace(".pptx", "-复杂.pdf")
      await new HTML转PDF转换器(htmlPath, pdfPath).转换()
      
      # 转换为PPTX（使用PDF转PPTX）
      console.log "\n步骤4：转换为PPTX..."
      complexPptxPath = @输出路径.replace(".pptx", "-复杂.pptx")
      await new PDF转PPTX转换器(pdfPath, complexPptxPath).转换()
    
    console.log "\n========================================"
    console.log "✅ 全部完成！"
    console.log "========================================"
    
    if @简单内容列表.length > 0
      console.log "简单内容PPTX: #{simplePptxPath}"
    
    if @复杂内容列表.length > 0
      console.log "复杂内容HTML: #{htmlPath}"
      console.log "复杂内容PDF:  #{pdfPath}"
      console.log "复杂内容PPTX: #{complexPptxPath}"

# ============================================
# 诗式API（极简）
# ============================================

开始混合生成 = (标题, 输出路径) ->
  当前演示 = new 混合生成器 标题, 输出路径
  console.log "🎨 开始混合生成：#{标题}"
  当前演示

完成混合生成 = ->
  if 当前演示
    await 当前演示.生成()
  else
    console.log "⚠️  没有活动的演示"

# ============================================
# 导出
# ============================================

module.exports = {
  开始混合生成
  完成混合生成
  创建流程图
  创建时序图
  创建类图
  创建状态图
  PPTX生成器
  HTML生成器
  HTML转PDF转换器
  PDF转PPTX转换器
  混合生成器
}
