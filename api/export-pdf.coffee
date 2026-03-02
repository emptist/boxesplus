# BoxesPlus - PDF/PPTX 导出工具
# 使用 puppeteer 导出 Reveal.js 为 PDF/PPTX

puppeteer = require "puppeteer"
path = require "path"
fs = require "fs"

# 导出 PDF
exportPdf = (htmlPath, pdfPath) ->
  console.log "📄 正在导出 PDF..."
  
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
    if require("fs").existsSync(bp)
      launchOptions.executablePath = bp
      break
  
  browser = await puppeteer.launch(launchOptions)
  
  page = await browser.newPage()
  await page.setViewport({ width: 1280, height: 720 })
  
  fileUrl = "file://" + path.resolve(htmlPath)
  await page.goto(fileUrl, { waitUntil: 'networkidle0', timeout: 60000 })
  
  # 等待 mermaid 渲染完成
  await page.waitForFunction ->
    document.querySelectorAll('.mermaid').length > 0
  , { timeout: 30000 }
  
  # 等待额外时间让 mermaid 完全渲染
  await new Promise (resolve) -> setTimeout(resolve, 3000)
  
  # 打印为 PDF
  pdfOptions = {
    path: pdfPath
    format: "A4"
    landscape: true
    printBackground: true
    margin: { top: "0.5cm", bottom: "0.5cm", left: "0.5cm", right: "0.5cm" }
  }
  
  await page.pdf(pdfOptions)
  await browser.close()
  
  console.log "✅ PDF 已导出: #{pdfPath}"

# 导出所有幻灯片为图片 (可用于 PPTX)
exportImages = (htmlPath, outputDir, options = {}) ->
  { width = 1280, height = 720 } = options
  
  console.log "🖼️ 正在导出图片..."
  
  fs.mkdirSync(outputDir, { recursive: true }) unless fs.existsSync(outputDir)
  
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
  
  page = await browser.newPage()
  await page.setViewport({ width, height })
  
  fileUrl = "file://" + path.resolve(htmlPath)
  await page.goto(fileUrl, { waitUntil: 'networkidle0', timeout: 60000 })
  
  # 等待 mermaid 渲染
  await page.waitForFunction ->
    document.querySelectorAll('.mermaid').length > 0
  , { timeout: 30000 }
  
  await new Promise (resolve) -> setTimeout(resolve, 3000)
  
  # 获取总页数
  slideCount = await page.evaluate ->
    document.querySelectorAll('.reveal .slides > section').length
  
  images = []
  for i in [0...slideCount]
    await page.evaluate((slideIndex) ->
      Reveal.slide(slideIndex)
    , i)
    
    await new Promise (resolve) -> setTimeout(resolve, 500)
    
    imgPath = path.join(outputDir, "slide-#{i+1}.png")
    await page.screenshot({ 
      path: imgPath
      fullPage: false 
    })
    images.push(imgPath)
    console.log "  导出第 #{i+1}/#{slideCount} 张"
  
  await browser.close()
  
  console.log "✅ 图片已导出到: #{outputDir}"
  images

# 快速导出: HTML → PDF
exportHtmlToPdf = (htmlPath, pdfPath) ->
  exportPdf(htmlPath, pdfPath)

# 快速导出: HTML → PPTX (用图片方式)
exportHtmlToPptx = (htmlPath, pptxPath) ->
  PptxGenJS = require "pptxgenjs"
  
  outputDir = path.join(path.dirname(pptxPath), "temp-slides")
  images = await exportImages(htmlPath, outputDir)
  
  pres = new PptxGenJS()
  
  for img in images
    slide = pres.addSlide()
    slide.addImage({ 
      path: img
      x: 0, y: 0, w: 10, h: 5.625
    })
  
  await pres.writeFile({ fileName: pptxPath })
  
  # 清理临时图片
  for img in images
    fs.unlinkSync(img)
  fs.rmdirSync(outputDir)
  
  console.log "✅ PPTX 已导出: #{pptxPath}"

# 完整工作流: 生成 HTML → PDF/PPTX
generateAndExport = (data, outputBase, options = {}) ->
  { pdf = true, pptx = true } = options
  
  htmlPath = "#{outputBase}.html"
  
  # 生成 HTML
  require("./mermaid-api").generateMermaidHtml(data, htmlPath)
  
  # 导出
  if pdf
    await exportPdf(htmlPath, "#{outputBase}.pdf")
  
  if pptx
    await exportHtmlToPptx(htmlPath, "#{outputBase}.pptx")

module.exports = {
  exportPdf, exportImages, exportHtmlToPdf, exportHtmlToPptx, generateAndExport
}
