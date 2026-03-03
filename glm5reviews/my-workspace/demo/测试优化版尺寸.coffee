#!/usr/bin/env coffee

# 测试优化版的实际尺寸

Puppeteer = require 'puppeteer'
path = require 'path'
fs = require 'fs'

HTML文件路径 = path.join __dirname, '../output/C01课程图表-优化版.html'
输出目录 = path.join __dirname, '../output'
图片目录 = path.join 输出目录, 'images-优化版'

确保输出目录存在 = ->
  unless fs.existsSync 输出目录
    fs.mkdirSync 输出目录, recursive: true
  unless fs.existsSync 图片目录
    fs.mkdirSync 图片目录, recursive: true

获取PNG尺寸 = (图片路径) ->
  buffer = fs.readFileSync 图片路径
  width = buffer.readUInt32BE 16
  height = buffer.readUInt32BE 20
  return { width, height }

截图测试 = ->
  try
    console.log "正在加载HTML文件..."
    browser = await Puppeteer.launch 
      headless: true
      executablePath: '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
    
    page = await browser.newPage()
    await page.goto "file://#{HTML文件路径}", waitUntil: 'domcontentloaded'
    await page.waitForSelector '.mermaid', timeout: 10000
    
    图表容器 = await page.$$('.mermaid-container')
    console.log "找到 #{图表容器.length} 个图表容器"
    
    尺寸列表 = []
    for 容器, 索引 in 图表容器
      边界框 = await 容器.boundingBox()
      
      输出文件 = path.join 图片目录, "图表#{索引 + 1}.png"
      await 容器.screenshot
        path: 输出文件
        type: 'png'
        clip: 边界框
      
      尺寸 = 获取PNG尺寸 输出文件
      宽高比 = (尺寸.width / 尺寸.height).toFixed(2)
      
      尺寸列表.push
        索引: 索引
        标题: "图表#{索引 + 1}"
        宽度: 尺寸.width
        高度: 尺寸.height
        宽高比: 宽高比
      
      console.log "图表 #{索引 + 1}: #{尺寸.width} x #{尺寸.height}px (宽高比: #{宽高比})"
    
    await browser.close()
    
    console.log "\n尺寸分析："
    最大宽度 = Math.max(...尺寸列表.map((it) -> it.宽度))
    最大高度 = Math.max(...尺寸列表.map((it) -> it.高度))
    宽度总和 = 0
    高度总和 = 0
    尺寸列表.forEach (it) ->
      宽度总和 += it.宽度
      高度总和 += it.高度
    平均宽度 = (宽度总和 / 尺寸列表.length).toFixed(0)
    平均高度 = (高度总和 / 尺寸列表.length).toFixed(0)
    
    console.log "最大宽度: #{最大宽度}px"
    console.log "最大高度: #{最大高度}px"
    console.log "平均宽度: #{平均宽度}px"
    console.log "平均高度: #{平均高度}px"
    
    console.log "\n是否适合A4横向页面（1123x794px）？"
    尺寸列表.forEach (图表) ->
      适合宽度 = 图表.宽度 <= 1123
      适合高度 = 图表.高度 <= 794
      宽高比评估 = if 图表.宽高比 >= 0.8 then "✅" else "⚠️"
      console.log "  #{图表.标题}: 宽度#{if 适合宽度 then '✅' else '❌'} (#{图表.宽度}), 高度#{if 适合高度 then '✅' else '❌'} (#{图表.高度}), 宽高比#{宽高比评估} (#{图表.宽高比})"
    
    return 尺寸列表
  
  catch 错误
    console.error "执行失败:", 错误.message
    process.exit 1

确保输出目录存在()
截图测试()
