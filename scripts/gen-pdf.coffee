# 从纯 HTML 生成 PDF

puppeteer = require "puppeteer"
fs = require "fs"

htmlPath = "outputs/api-demo.html"
pdfPath = "outputs/api-demo.pdf"

run = ->
  console.log "正在生成 PDF..."
  
  browser = await puppeteer.launch({
    headless: "new"
    executablePath: "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
  })
  
  page = await browser.newPage()
  await page.setViewport({ width: 1280, height: 720 })
  
  fileUrl = "file://" + fs.realpathSync(htmlPath)
  await page.goto(fileUrl, { waitUntil: 'networkidle0', timeout: 60000 })
  
  # 等待 mermaid 渲染
  await new Promise (resolve) -> setTimeout(resolve, 5000)
  
  await page.pdf({
    path: pdfPath
    width: "1280px"
    height: "720px"
    printBackground: true
    margin: { top: 0, bottom: 0, left: 0, right: 0 }
  })
  
  await browser.close()
  console.log "✅ PDF 已生成: #{pdfPath}"

run()
