# BoxesPlus Dual Output - 同时生成 Reveal.js HTML + PPTX
# 用法: coffee dual-output.coffee <pptx_output> <html_output>
# 示例: coffee dual-output.coffee output.pptx output.html

fs = require "fs"
path = require "path"
http = require "http"
PptxgenJs = require "pptxgenjs"
puppeteer = require "puppeteer"

SLIDE_WIDTH = 1280
SLIDE_HEIGHT = 720

generateDualOutput = (slidesData, pptxPath, htmlPath, opts = {}) ->
  { title, theme } = opts
  
  await generateHtml(slidesData, htmlPath, { title, theme })
  await generatePptx(slidesData, pptxPath)
  await captureAndEmbed(htmlPath, pptxPath)
  
  console.log "✅ Dual output created:"
  console.log "   PPTX: #{pptxPath}"
  console.log "   HTML: #{htmlPath}"

generateHtml = (slidesData, htmlPath, opts = {}) ->
  { title } = opts
  
  slidesHtml = ""
  for slide in slidesData
    slidesHtml += slide.html
  
  html = """
  <!doctype html>
  <html>
  <head>
    <meta charset="utf-8">
    <title>#{title || 'Presentation'}</title>
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
        #{slidesHtml}
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
        width: #{SLIDE_WIDTH},
        height: #{SLIDE_HEIGHT},
        margin: 0.04
      });
    </script>
  </body>
  </html>
  """
  
  fs.writeFileSync(htmlPath, html)
  console.log "✅ HTML: #{htmlPath}"

generatePptx = (slidesData, pptxPath) ->
  pres = new PptxgenJs()
  pres.layout = "LAYOUT_16x9"
  
  for slide in slidesData
    s = pres.addSlide()
    
    if slide.title
      s.addText slide.title,
        x: 0.5, y: 0.3, w: 9, h: 0.6
        fontSize: 28, color: "1a365d", bold: true
    
    if slide.text
      for item in slide.text
        s.addText item.content,
          x: item.x ? 0.5, y: item.y ? 1.2, w: item.w ? 9, h: item.h ? 0.5
          fontSize: item.fontSize ? 18, color: item.color ? "2d3748"
  
  await pres.writeFile({ fileName: path.resolve(pptxPath) })
  console.log "✅ PPTX: #{pptxPath}"

captureAndEmbed = (htmlPath, pptxPath) ->
  port = 8765
  dir = path.dirname(path.resolve(htmlPath))
  
  server = http.createServer (req, res) ->
    url = req.url
    
    mappedPath = null
    
    if url == "/reveal.js/css/reveal.css"
      mappedPath = path.join(path.dirname(dir), "node_modules/reveal.js/dist/reveal.css")
    else if url == "/reveal.js/css/theme/white.css"
      mappedPath = path.join(path.dirname(dir), "node_modules/reveal.js/dist/theme/white.css")
    else if url == "/reveal.js/js/reveal.js"
      mappedPath = path.join(path.dirname(dir), "node_modules/reveal.js/dist/reveal.js")
    else
      mappedPath = path.join(dir, if url == "/" then path.basename(htmlPath) else url)
    
    if mappedPath and fs.existsSync(mappedPath)
      content = fs.readFileSync(mappedPath)
      ext = path.extname(mappedPath)
      contentType = switch ext
        when ".html" then "text/html"
        when ".js" then "application/javascript"
        when ".css" then "text/css"
        else "text/plain"
      res.writeHead(200, { "Content-Type": contentType })
      res.end(content)
    else
      res.writeHead(404)
      res.end("Not found")
  
  await new Promise (resolve) -> server.listen(port, resolve)
  
  try
    browser = await puppeteer.launch
      executablePath: "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
      headless: true
      args: ["--no-sandbox", "--disable-setuid-sandbox"]
    
    page = await browser.newPage()
    await page.setViewport({ width: SLIDE_WIDTH, height: SLIDE_HEIGHT })
    
    await page.goto("http://localhost:#{port}/", { waitUntil: "networkidle2" })
    await new Promise (resolve) -> setTimeout(resolve, 2000)
    
    sections = await page.evaluate(() -> document.querySelectorAll(".reveal .slides > section").length)
    
    pres = new PptxgenJs()
    pres.layout = "LAYOUT_16x9"
    
    for i in [0...sections]
      console.log "Capturing slide #{i + 1}/#{sections}..."
      await page.evaluate("Reveal.slide(#{i})")
      await new Promise (resolve) -> setTimeout(resolve, 1000)
      
      screenshotPath = path.join(dir, ".temp-slide-#{i}.png")
      await page.screenshot({ path: screenshotPath, fullPage: false })
      
      unless fs.existsSync(screenshotPath)
        console.log "Warning: Screenshot not created for slide #{i}"
        continue
      
      slide = pres.addSlide()
      slide.addImage
        path: screenshotPath
        x: 0, y: 0
        w: "100%", h: "100%"
      
      fs.unlinkSync(screenshotPath)
    
    await browser.close()
    await pres.writeFile({ fileName: path.resolve(pptxPath) })
    console.log "✅ Embedded screenshots into: #{pptxPath}"
  finally
    server.close()

module.exports = { generateDualOutput, generateHtml, generatePptx }

if require.main is module
  pptxPath = process.argv[2] || "outputs/dual-output.pptx"
  htmlPath = process.argv[3] || "outputs/dual-output.html"
  title = process.argv[4] || "演示文稿"
  
  slidesData = [
    {
      title: "欢迎"
      html: '<section style="text-align: center;"><h1>欢迎</h1><p>BoxesPlus Dual Output</p></section>'
      text: [{ content: "欢迎使用 BoxesPlus", y: 2 }]
    }
    {
      title: "功能特点"
      html: '<section><h2>功能特点</h2><ul><li>一键生成两种格式</li><li>复杂图表用 Reveal.js</li><li>自动截图嵌入 PPTX</li></ul></section>'
      text: [
        { content: "• 一键生成两种格式", y: 1.2 }
        { content: "• 复杂图表用 Reveal.js", y: 1.7 }
        { content: "• 自动截图嵌入 PPTX", y: 2.2 }
      ]
    }
    {
      title: "谢谢"
      html: '<section style="text-align: center; background: #1a365d;"><h1 style="color:white;">谢谢!</h1></section>'
      text: [{ content: "谢谢!", y: 2, fontSize: 40, color: "ffffff" }]
    }
  ]
  
  do ->
    await generateDualOutput(slidesData, pptxPath, htmlPath, { title })
    console.log "Done!"
