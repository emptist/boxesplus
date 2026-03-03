#!/usr/bin/env coffee

Puppeteer = require 'puppeteer'
path = require 'path'
fs = require 'fs'

HTML文件路径 = path.join __dirname, '../output/C01课程图表-简化测试版.html'
输出目录 = path.join __dirname, '../output'
图片目录 = path.join 输出目录, 'images'
PDF输出路径 = path.join 输出目录, "T002-C01医疗质量与安全管理课程-基于方案1.pdf"
尺寸输出路径 = path.join 输出目录, "T002-图表尺寸.json"
策略输出路径 = path.join 输出目录, "T002-排版策略.json"
打印HTML输出路径 = path.join 输出目录, "T002-打印HTML.html"

确保输出目录存在 = ->
  unless fs.existsSync 输出目录
    fs.mkdirSync 输出目录, recursive: true

获取PNG尺寸 = (图片路径) ->
  buffer = fs.readFileSync 图片路径
  width = buffer.readUInt32BE 16
  height = buffer.readUInt32BE 20
  return { width, height }

获取图表尺寸 = ->
  try
    console.log "步骤1.1: 从图片文件获取尺寸..."
    图片文件列表 = fs.readdirSync 图片目录
      .filter (文件) -> 文件.endsWith '.png'
      .sort()
    
    console.log "找到 #{图片文件列表.length} 个图片文件"
    
    尺寸列表 = []
    for 图片文件, 索引 in 图片文件列表
      图片路径 = path.join 图片目录, 图片文件
      尺寸 = 获取PNG尺寸 图片路径
        
      尺寸列表.push
        索引: 索引
        标题: "图表#{索引 + 1}"
        宽度: 尺寸.width
        高度: 尺寸.height
      console.log "图表 #{索引 + 1}: #{尺寸列表[尺寸列表.length - 1].宽度} x #{尺寸列表[尺寸列表.length - 1].高度}"
    
    console.log "步骤1.2: 保存尺寸数据到 #{尺寸输出路径}"
    fs.writeFileSync 尺寸输出路径, JSON.stringify(尺寸列表, null, 2)
    console.log "✅ 尺寸数据已保存"
    
    return 尺寸列表
  
  catch 错误
    console.error "获取图表尺寸失败:", 错误.message
    process.exit 1

计算排版策略 = (图表尺寸列表, 页面宽度 = 960, 页面高度 = 1000) ->
  策略列表 = []
  
  for 图表, 索引 in 图表尺寸列表
    缩放比例 = Math.min(页面宽度 / 图表.宽度, 页面高度 / 图表.高度)
    
    if 缩放比例 >= 0.8
      策略 = "缩放"
      详情 = 比例: 缩放比例.toFixed(2)
    else if 图表.高度 > 页面高度 * 2
      策略 = "分页"
      页数 = Math.ceil(图表.高度 / 页面高度)
      详情 = 页数: 页数
    else
      策略 = "平铺"
      每行 = Math.floor(页面宽度 / 图表.宽度)
      详情 = 每行: 每行
    
    策略列表.push
      索引: 图表.索引
      标题: 图表.标题
      策略: 策略
      详情: 详情
      尺寸: 图表
    
    console.log "图表 #{索引 + 1}: 策略=#{策略}"
  
  console.log "步骤2.2: 保存排版策略到 #{策略输出路径}"
  fs.writeFileSync 策略输出路径, JSON.stringify(策略列表, null, 2)
  console.log "✅ 排版策略已保存"
  
  return 策略列表

生成打印HTML = (策略列表, 图片目录) ->
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
  
  for 策略, 索引 in 策略列表
    图片文件 = path.join 图片目录, "T001-图表#{策略.索引 + 1}.png"
    
    if 策略.策略 == "缩放"
      缩放宽度 = Math.round(策略.尺寸.宽度 * 策略.详情.比例)
      缩放高度 = Math.round(策略.尺寸.高度 * 策略.详情.比例)
      htmlParts.push '<div class="chart-page"><div class="chart-container">'
      htmlParts.push '<div class="chart-title">' + 策略.标题 + '</div>'
      htmlParts.push '<img class="chart-image" src="file://' + 图片文件 + '" style="width: ' + 缩放宽度 + 'px; height: ' + 缩放高度 + 'px;">'
      htmlParts.push '<div class="chart-info">缩放比例: ' + 策略.详情.比例 + '</div></div></div>'
    else if 策略.策略 == "分页"
      页数 = 策略.详情.页数
      for 页 in [0...页数]
        当前高度 = Math.min(策略.尺寸.高度 - 页 * 920, 920)
        htmlParts.push '<div class="chart-page"><div class="chart-container">'
        htmlParts.push '<div class="chart-title">' + 策略.标题 + ' (第' + (页 + 1) + '/' + 页数 + '页)</div>'
        htmlParts.push '<img class="chart-image" src="file://' + 图片文件 + '" style="width: ' + 策略.尺寸.宽度 + 'px; height: ' + 当前高度 + 'px; object-position: 0 -' + (页 * 920) + 'px;">'
        htmlParts.push '<div class="chart-info">分页显示: 第' + (页 + 1) + '页</div></div></div>'
    else
      htmlParts.push '<div class="chart-page"><div class="chart-container">'
      htmlParts.push '<div class="chart-title">' + 策略.标题 + '</div>'
      htmlParts.push '<img class="chart-image" src="file://' + 图片文件 + '">'
      htmlParts.push '<div class="chart-info">平铺布局</div></div></div>'
  
  htmlParts.push '</body></html>'
  打印HTML = htmlParts.join ''
  
  console.log "步骤3.2: 保存打印HTML到 #{打印HTML输出路径}"
  fs.writeFileSync 打印HTML输出路径, 打印HTML
  console.log "✅ 打印HTML已保存"
  
  return 打印HTML

生成PDF = (打印HTML, 输出路径) ->
  try
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

完整流程 = ->
  console.log "步骤1: 获取图表尺寸..."
  图表尺寸列表 = await 获取图表尺寸()
  
  console.log "\n步骤2: 计算排版策略..."
  策略列表 = 计算排版策略 图表尺寸列表
  
  console.log "\n步骤3: 生成打印HTML..."
  打印HTML = 生成打印HTML 策略列表, 图片目录
  
  console.log "\n步骤4: 生成PDF..."
  await 生成PDF 打印HTML, PDF输出路径
  
  console.log "\n✅ 完整流程完成！"
  console.log "\n📋 生成的文件:"
  console.log "  - #{尺寸输出路径}"
  console.log "  - #{策略输出路径}"
  console.log "  - #{打印HTML输出路径}"
  console.log "  - #{PDF输出路径}"

确保输出目录存在()
完整流程()
