#!/usr/bin/env coffee

Puppeteer = require 'puppeteer'
path = require 'path'
fs = require 'fs'

HTML文件路径 = path.join __dirname, '../output/C01课程图表-简化测试版.html'
输出目录 = path.join __dirname, '../output/images'

确保输出目录存在 = ->
  unless fs.existsSync 输出目录
    fs.mkdirSync 输出目录, recursive: true

截图图表 = ->
  try
    browser = await Puppeteer.launch 
      headless: true
      executablePath: '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
    
    page = await browser.newPage()
    await page.goto "file://#{HTML文件路径}", waitUntil: 'networkidle0'
    await page.waitForSelector '.mermaid', timeout: 5000
    
    图表容器 = await page.$$('.mermaid-container')
    console.log "找到 #{图表容器.length} 个图表容器"
    
    for 容器, 索引 in 图表容器
      边界框 = await 容器.boundingBox()
      console.log "图表 #{索引 + 1} 尺寸: #{Math.round 边界框.width} x #{Math.round 边界框.height}"
      
      输出文件 = path.join 输出目录, "T001-图表#{索引 + 1}.png"
      await 容器.screenshot
        path: 输出文件
        type: 'png'
        clip: 边界框
      console.log "已保存: #{输出文件}"
    
    await browser.close()
    console.log "截图完成！"
  
  catch 错误
    console.error "执行失败:", 错误.message
    process.exit 1

确保输出目录存在()
截图图表()
