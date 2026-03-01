# BoxesPlus - Reveal.js → PDF 离线生成 (整合版)
# 用法: coffee reveal-to-pdf.coffee <html_file> [pdf_output]

fs = require "fs"
path = require "path"
http = require "http"
puppeteer = require "puppeteer"

SLIDE_WIDTH = 1280
SLIDE_HEIGHT = 720

htmlFile = process.argv[2] || "outputs/reveal-complete.html"
pdfFile = process.argv[3] || htmlFile.replace(".html", ".pdf")

convertHtmlToPdf = (inputHtml, outputPdf) ->
  unless fs.existsSync(inputHtml)
    console.error "HTML file not found: #{inputHtml}"
    process.exit 1
  
  dir = path.dirname(path.resolve(inputHtml))
  rootDir = path.dirname(dir)
  port = 8765
  
  console.log "Converting: #{inputHtml}"
  console.log "Output PDF: #{outputPdf}"
  
  # 启动本地服务器
  server = http.createServer (req, res) ->
    url = req.url
    
    mappedPath = null
    
    if url == "/reveal.js/css/reveal.css"
      mappedPath = path.join(rootDir, "node_modules/reveal.js/dist/reveal.css")
    else if url == "/reveal.js/css/theme/white.css"
      mappedPath = path.join(rootDir, "node_modules/reveal.js/dist/theme/white.css")
    else if url == "/reveal.js/js/reveal.js"
      mappedPath = path.join(rootDir, "node_modules/reveal.js/dist/reveal.js")
    else
      mappedPath = path.join(dir, if url == "/" then path.basename(inputHtml) else url)
    
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
  console.log "Server started on port #{port}"
  
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
    console.log "Found #{sections} slides"
    
    # 临时目录
    tempDir = path.join(dir, ".temp-pdf-#{Date.now()}")
    fs.mkdirSync(tempDir, { recursive: true })
    
    # 逐页截图
    for i in [0...sections]
      process.stdout.write "\rCapturing slide #{i + 1}/#{sections}..."
      await page.evaluate("Reveal.slide(#{i})")
      await new Promise (resolve) -> setTimeout(resolve, 800)
      
      screenshotPath = path.join(tempDir, "slide-#{String(i).padStart(3, '0')}.png")
      await page.screenshot({ path: screenshotPath, fullPage: false })
    
    console.log "\nCreating PDF..."
    
    # 创建打印页面
    screenshotFiles = (path.join(tempDir, "slide-#{String(i).padStart(3, '0')}.png") for i in [0...sections])
    
    printHtml = """
    <!DOCTYPE html>
    <html>
    <head>
      <style>
        @page { size: #{SLIDE_WIDTH}px #{SLIDE_HEIGHT}px; margin: 0; }
        body { margin: 0; padding: 0; }
        .slide { page-break-after: always; width: #{SLIDE_WIDTH}px; height: #{SLIDE_HEIGHT}px; }
        .slide:last-child { page-break-after: avoid; }
        img { width: #{SLIDE_WIDTH}px; height: #{SLIDE_HEIGHT}px; object-fit: contain; }
      </style>
    </head>
    <body>
    """
    
    for img in screenshotFiles
      printHtml += "<div class='slide'><img src='file://#{img}'></div>\n"
    
    printHtml += "</body></html>"
    
    printHtmlPath = path.join(tempDir, "print.html")
    fs.writeFileSync(printHtmlPath, printHtml)
    
    # 生成 PDF
    printPage = await browser.newPage()
    await printPage.setViewport({ width: SLIDE_WIDTH, height: SLIDE_HEIGHT })
    await printPage.goto("file://#{printHtmlPath}", { waitUntil: "networkidle0" })
    
    await printPage.pdf({
      path: outputPdf
      printBackground: true
      landscape: false
      width: "#{SLIDE_WIDTH}px"
      height: "#{SLIDE_HEIGHT}px"
      margin: { top: 0, bottom: 0, left: 0, right: 0 }
    })
    
    await printPage.close()
    await browser.close()
    
    # 清理
    for img in screenshotFiles
      fs.unlinkSync(img) if fs.existsSync(img)
    fs.unlinkSync(printHtmlPath) if fs.existsSync(printHtmlPath)
    fs.rmdirSync(tempDir) if fs.existsSync(tempDir)
    
    console.log "✅ PDF created: #{outputPdf}"
    return outputPdf
    
  catch err
    console.error "Error:", err.message
    throw err
    
  finally
    server.close()

# 导出函数
module.exports = { convertHtmlToPdf }

# 直接运行
if require.main is module
  do ->
    await convertHtmlToPdf(htmlFile, pdfFile)
    console.log "Done!"
