#!/usr/bin/env coffee

Puppeteer = require 'puppeteer'
path = require 'path'
fs = require 'fs'

输出目录 = path.join __dirname, '../output'
图片目录 = path.join 输出目录, 'images'
PDF输出路径 = path.join 输出目录, "T003-C01医疗质量与安全管理课程-简化版.pdf"
打印HTML输出路径 = path.join 输出目录, "T003-打印HTML.html"

确保输出目录存在 = ->
  unless fs.existsSync 输出目录
    fs.mkdirSync 输出目录, recursive: true

生成打印HTML = ->
  console.log "步骤1: 生成打印HTML..."
  图片文件列表 = fs.readdirSync 图片目录
    .filter (文件) -> 文件.endsWith '.png'
    .sort()
  
  console.log "找到 #{图片文件列表.length} 个图片文件"
  
  htmlParts = []
  htmlParts.push '<!DOCTYPE html><html><head><meta charset="utf-8"><style>'
  htmlParts.push '@page { size: 960px 1000px; margin: 0; }'
  htmlParts.push 'body { margin: 0; padding: 20px; font-family: Arial, sans-serif; }'
  htmlParts.push '.chart-page { page-break-after: always; display: flex; justify-content: center; align-items: center; min-height: 960px; }'
  htmlParts.push '.chart-page:last-child { page-break-after: avoid; }'
  htmlParts.push '.chart-container { display: flex; flex-direction: column; align-items: center; width: 95%; height: 95%; }'
  htmlParts.push '.chart-title { font-size: 24px; font-weight: bold; margin-bottom: 20px; text-align: center; }'
  htmlParts.push '.chart-image { max-width: 100%; max-height: 100%; object-fit: contain; }'
  htmlParts.push '.chart-info { font-size: 12px; color: #666; margin-top: 10px; text-align: center; }'
  htmlParts.push '</style></head><body>'
  
  for 图片文件, 索引 in 图片文件列表
    图片路径 = path.join 图片目录, 图片文件
    htmlParts.push '<div class="chart-page"><div class="chart-container">'
    htmlParts.push '<div class="chart-title">图表' + (索引 + 1) + '</div>'
    htmlParts.push '<img class="chart-image" src="file://' + 图片路径 + '">'
    htmlParts.push '<div class="chart-info">自动缩放以适应页面</div></div></div>'
  
  htmlParts.push '</body></html>'
  打印HTML = htmlParts.join ''
  
  console.log "步骤1.2: 保存打印HTML到 #{打印HTML输出路径}"
  fs.writeFileSync 打印HTML输出路径, 打印HTML
  console.log "✅ 打印HTML已保存"
  
  return 打印HTML

生成PDF = (打印HTML, 输出路径) ->
  try
    console.log "步骤2: 生成PDF..."
    时间戳 = Date.now()
    临时HTML路径 = path.join 输出目录, "temp-print-#{时间戳}.html"
    fs.writeFileSync 临时HTML路径, 打印HTML
    
    browser = await Puppeteer.launch 
      headless: true
      executablePath: '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
    
    page = await browser.newPage()
    await page.goto "file://#{临时HTML路径}", waitUntil: 'domcontentloaded'
    
    await page.pdf
      path: 输出路径
      format: "A4"
      landscape: true
      printBackground: true
      margin: { top: "0.5cm", bottom: "0.5cm", left: "0.5cm", right: "0.5cm" }
    
    await browser.close()
    
    console.log "✅ 临时HTML已保留: #{临时HTML路径}"
    console.log "✅ PDF已生成: #{输出路径}"
  
  catch 错误
    console.error "生成PDF失败:", 错误.message
    process.exit 1

简化流程 = ->
  console.log "=== 方案1简化版：不需要预先测量图片尺寸 ===\n"
  
  打印HTML = 生成打印HTML()
  await 生成PDF 打印HTML, PDF输出路径
  
  console.log "\n✅ 简化流程完成！"
  console.log "\n📋 生成的文件:"
  console.log "  - #{打印HTML输出路径}"
  console.log "  - #{PDF输出路径}"

确保输出目录存在()
简化流程()
