#!/usr/bin/env coffee
fs = require "fs"
path = require "path"
http = require "http"
PptxgenJs = require "pptxgenjs"
puppeteer = require "puppeteer"

htmlFile = process.argv[2] || "outputs/reveal-complete.html"
outputPptx = process.argv[3] || "outputs/reveal-to-pptx.pptx"
port = parseInt(process.argv[4]) || 8765

unless fs.existsSync(htmlFile)
  console.error "HTML file not found: #{htmlFile}"
  process.exit 1

console.log "Starting Reveal.js → PPTX conversion..."
console.log "Input: #{htmlFile}"
console.log "Output: #{outputPptx}"

startServer = (dir) ->
  rootDir = path.dirname(dir)
  
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
      mappedPath = path.join(dir, if url == "/" then "reveal-complete.html" else url)
    
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
      console.log "404: #{mappedPath}"
      res.writeHead(404)
      res.end("Not found")
  
  await new Promise (resolve) ->
    server.listen(port, resolve)
  
  console.log "Server running at http://localhost:#{port}/"
  server

captureSlides = (server) ->
  browser = await puppeteer.launch
    executablePath: "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
    headless: true
    args: ["--no-sandbox", "--disable-setuid-sandbox"]

  page = await browser.newPage()
  await page.setViewport({ width: 1280, height: 720 })
  
  url = "http://localhost:#{port}/"
  console.log "Loading: #{url}"
  
  await page.goto(url, { waitUntil: "networkidle2" })
  
  await new Promise (resolve) -> setTimeout(resolve, 2000)
  
  sections = await page.evaluate(() ->
    return document.querySelectorAll(".reveal .slides > section").length
  )
  console.log "Found #{sections} Reveal.js sections"
  
  screenshots = []
  outputDir = path.resolve("outputs")
  
  if sections > 0
    console.log "Using Reveal.js API..."
    
    for i in [0...sections]
      console.log "Capturing slide #{i + 1}/#{sections}..."
      
      await page.evaluate((slideIndex) ->
        Reveal.slide(slideIndex)
      , i)
      
      await new Promise (resolve) -> setTimeout(resolve, 800)
      
      screenshotPath = path.join(outputDir, "slide-#{String(i+1).padStart(3, '0')}.png")
      await page.screenshot({ path: screenshotPath, fullPage: false })
      screenshots.push(screenshotPath)
  else
    console.log "No Reveal.js sections, using scroll..."
    totalHeight = await page.evaluate(() -> document.body.scrollHeight)
    viewportHeight = 720
    slideNum = 1
    pos = 0
    
    while pos < totalHeight
      console.log "Capturing at #{pos}..."
      y = pos
      await page.evaluate -> window.scrollTo(0, y)
      await new Promise (resolve) -> setTimeout(resolve, 500)
      
      screenshotPath = path.join(outputDir, "slide-#{String(slideNum).padStart(3, '0')}.png")
      await page.screenshot({ path: screenshotPath, fullPage: false })
      screenshots.push(screenshotPath)
      
      pos += viewportHeight
      slideNum++
  
  await browser.close()
  screenshots

createPptx = (screenshots) ->
  return if screenshots.length == 0
  
  console.log "Creating PPTX with #{screenshots.length} slides..."
  
  pres = new PptxgenJs()
  pres.layout = "LAYOUT_16x9"
  
  for screenshot in screenshots
    slide = pres.addSlide()
    absPath = path.resolve(screenshot)
    
    if fs.existsSync(absPath)
      slide.addImage
        path: absPath
        x: 0
        y: 0
        w: "100%"
        h: "100%"
  
  await pres.writeFile({ fileName: path.resolve(outputPptx) })
  console.log "✅ Created: #{outputPptx}"

do ->
  try
    dir = path.dirname(path.resolve(htmlFile))
    server = await startServer(dir)
    
    screenshots = await captureSlides(server)
    
    server.close()
    
    await createPptx(screenshots)
    
    console.log "\nCleaning up..."
    for screenshot in screenshots
      fs.unlinkSync(screenshot) if fs.existsSync(screenshot)
    
    console.log "Done!"
  catch err
    console.error "Error:", err.message
    console.error err.stack
    process.exit 1
