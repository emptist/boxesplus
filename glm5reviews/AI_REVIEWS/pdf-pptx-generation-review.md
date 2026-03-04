# PDF/PPTX 生成方法 - 代码审查报告

## 📋 审查对象

- `/Users/jk/gits/hub/consult_strategy/boxesplus/api/export-pdf.coffee`
- `/Users/jk/gits/hub/consult_strategy/boxesplus/api/reveal-to-pdf.coffee`

## 🎯 核心方法分析

### 方法1: 直接PDF导出 (export-pdf.coffee)

**文件**: `api/export-pdf.coffee`

**核心函数**:
```coffee
exportPdf = (htmlPath, pdfPath) ->
  browser = await puppeteer.launch(launchOptions)
  page = await browser.newPage()
  await page.goto(fileUrl, { waitUntil: 'networkidle0' })
  
  # 等待 mermaid 渲染完成
  await page.waitForFunction ->
    document.querySelectorAll('.mermaid').length > 0
  
  # 打印为 PDF
  await page.pdf({
    path: pdfPath
    format: "A4"
    landscape: true
    printBackground: true
    margin: { top: "0.5cm", bottom: "0.5cm", left: "0.5cm", right: "0.5cm" }
  })
```

**优点**:
- ✅ 简单直接，使用Puppeteer内置的PDF功能
- ✅ 一次生成，不需要中间步骤
- ✅ 支持A4格式，横向/纵向
- ✅ 支持背景色

**缺点**:
- ❌ 无法控制单个图表的缩放
- ❌ 大图表可能被截断或缩小
- ❌ 无法实现平铺布局

**适用场景**: 简单页面，内容适合一页显示

---

### 方法2: 图片导出 + PPTX (export-pdf.coffee)

**核心函数**:
```coffee
exportImages = (htmlPath, outputDir, options = {}) ->
  { width = 1280, height = 720 } = options
  
  browser = await puppeteer.launch(launchOptions)
  page = await browser.newPage()
  await page.setViewport({ width, height })
  
  # 获取总页数
  slideCount = await page.evaluate ->
    document.querySelectorAll('.reveal .slides > section').length
  
  # 逐页截图
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
  
  # 生成 PPTX
  pres = new PptxGenJS()
  for img in images
    slide = pres.addSlide()
    slide.addImage({ 
      path: img
      x: 0, y: 0, w: 10, h: 5.625
    })
  await pres.writeFile({ fileName: pptxPath })
```

**优点**:
- ✅ 可以精确控制每张幻灯片
- ✅ 图片清晰度高
- ✅ 支持PPTX格式
- ✅ 可以自定义尺寸

**缺点**:
- ❌ 需要临时图片文件
- ❌ 需要清理临时文件
- ❌ 依赖pptxgenjs库

**适用场景**: Reveal.js演示文稿，需要PPTX格式

---

### 方法3: Reveal.js转PDF (reveal-to-pdf.coffee)

**核心函数**:
```coffee
convertHtmlToPdf = (inputHtml, outputPdf) ->
  # 启动本地服务器
  server = http.createServer (req, res) -> ...
  await new Promise (resolve) -> server.listen(port, resolve)
  
  browser = await puppeteer.launch(...)
  page = await browser.newPage()
  await page.setViewport({ width: SLIDE_WIDTH, height: SLIDE_HEIGHT })
  
  # 逐页截图
  for i in [0...sections]
    await page.evaluate("Reveal.slide(#{i})")
    await new Promise (resolve) -> setTimeout(resolve, 800)
    
    screenshotPath = path.join(tempDir, "slide-#{String(i).padStart(3, '0')}.png")
    await page.screenshot({ path: screenshotPath, fullPage: false })
  
  # 创建打印页面
  printHtml = """
  <!DOCTYPE html>
  <html>
    <head>
      <style>
        @page { size: #{SLIDE_WIDTH}px #{SLIDE_HEIGHT}px; margin: 0; }
        .slide { page-break-after: always; width: #{SLIDE_WIDTH}px; height: #{SLIDE_HEIGHT}px; }
        img { width: #{SLIDE_WIDTH}px; height: #{SLIDE_HEIGHT}px; object-fit: contain; }
      </style>
    </head>
    <body>
  """
  
  for img in screenshotFiles
    printHtml += "<div class='slide'><img src='file://#{img}'></div>\n"
  
  # 生成 PDF
  await printPage.pdf({
    path: outputPdf
    printBackground: true
    landscape: false
    width: "#{SLIDE_WIDTH}px"
    height: "#{SLIDE_HEIGHT}px"
    margin: { top: 0, bottom: 0, left: 0, right: 0 }
  })
```

**优点**:
- ✅ 精确控制每页尺寸
- ✅ 使用CSS控制分页
- ✅ 支持横向/纵向
- ✅ 图片清晰

**缺点**:
- ❌ 需要启动HTTP服务器
- ❌ 需要临时图片和HTML
- ❌ 需要清理临时文件
- ❌ 流程复杂

**适用场景**: Reveal.js演示文稿，需要精确控制PDF布局

---

## 🔬 测试结果：Puppeteer截图

**测试文件**: `my-workspace/demo/方案1-Puppeteer截图.coffee`

**测试结果**:
```
找到 6 个图表容器
图表 1 尺寸: 670 x 1039
图表 2 尺寸: 670 x 766
图表 3 尺寸: 670 x 2160
图表 4 尺寸: 670 x 564
图表 5 尺寸: 670 x 4577
图表 6 尺寸: 670 x 1869
```

**关键发现**:
- ✅ Puppeteer可以成功获取图表的实际尺寸
- ✅ 图表5高度4577px，非常大，需要特殊处理
- ✅ 使用系统Chrome可以避免安装问题

**代码示例**:
```coffee
Puppeteer.launch 
  headless: true
  executablePath: '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
, (错误, browser) ->
  browser.newPage (错误, page) ->
    page.goto "file://#{HTML文件路径}", waitUntil: 'networkidle0'
    page.waitForSelector '.mermaid', timeout: 5000, (错误) ->
      page.$$('.mermaid-container', (错误, 图表容器) ->
        for 容器, 索引 in 图表容器
          容器.boundingBox (错误, 边界框) ->
            console.log "图表 #{索引 + 1}: #{Math.round 边界框.width} x #{Math.round 边界框.height}"
```

---

## 💡 推荐方案

### 对于Mermaid图表生成PDF/PPTX

**推荐流程**:
```
步骤1: 生成HTML（包含Mermaid图表）
   ↓
步骤2: 使用Puppeteer获取图表实际尺寸
   ↓
步骤3: 根据尺寸计算缩放策略
   ↓
步骤4: 生成PDF/PPTX
```

**推荐方法**: 结合方法1和方法3

1. **获取图表尺寸** (使用Puppeteer)
```coffee
获取图表尺寸 = (htmlPath) ->
  browser = await Puppeteer.launch headless: true
  page = await browser.newPage()
  await page.goto "file://#{htmlPath}"
  
  图表容器 = await page.$$('.mermaid-container')
  尺寸列表 = []
  
  for 容器, 索引 in 图表容器
    边界框 = await 容器.boundingBox()
    尺寸列表.push
      索引: 索引
      宽度: Math.round 边界框.width
      高度: Math.round 边界框.height
  
  await browser.close()
  尺寸列表
```

2. **计算排版策略**
```coffee
计算排版策略 = (图表尺寸, 页面尺寸) ->
  {宽度: 图宽, 高度: 图高} = 图表尺寸
  {宽度: 页宽, 高度: 页高} = 页面尺寸
  
  缩放比例 = Math.min(页宽 / 图宽, 页高 / 图高)
  
  if 缩放比例 >= 0.8
    return 策略: "缩放", 比例: 缩放比例
  else if 图高 > 页高 * 2
    return 策略: "分页", 页数: Math.ceil(图高 / 页高)
  else
    return 策略: "平铺", 每行: Math.floor(页宽 / 图宽)
```

3. **生成PDF** (根据策略选择方法)
```coffee
生成PDF = (htmlPath, pdfPath, 策略) ->
  if 策略.策略 == "缩放"
    # 使用方法1：直接PDF导出
    await exportPdf(htmlPath, pdfPath)
  else if 策略.策略 == "分页"
    # 使用方法3：截图+HTML+PDF
    await convertHtmlToPdf(htmlPath, pdfPath)
  else
    # 平铺布局，自定义实现
    await 自定义平铺PDF(htmlPath, pdfPath)
```

---

## 📝 改进建议

### 1. 统一API设计

建议创建统一的导出API：

```coffee
module.exports = {
  # 获取图表尺寸
  getChartSizes: (htmlPath) -> ...
  
  # 计算排版策略
  calculateLayoutStrategy: (chartSizes, pageSize) -> ...
  
  # 生成PDF
  generatePdf: (htmlPath, pdfPath, strategy) -> ...
  
  # 生成PPTX
  generatePptx: (htmlPath, pptxPath, strategy) -> ...
  
  # 完整流程
  generate: (htmlPath, outputPath, options = {}) -> ...
}
```

### 2. 配置化

建议将配置参数化：

```coffee
默认配置 =
  页面尺寸:
    宽度: 1280
    高度: 720
  PDF格式: "A4"
  边距: 
    顶部: 0.5
    底部: 0.5
    左侧: 0.5
    右侧: 0.5
  最小缩放比例: 0.8
  最大分页高度: 2000
```

### 3. 错误处理

建议增强错误处理：

```coffee
try
  await generatePdf(htmlPath, pdfPath, strategy)
catch 错误
  if 错误.message.includes("timeout")
    console.error "渲染超时，可能图表太大"
  else if 错误.message.includes("memory")
    console.error "内存不足，尝试分页"
  else
    console.error "未知错误:", 错误.message
    throw 错误
```

---

## 📊 性能对比

| 方法 | 速度 | 质量 | 灵活性 | 复杂度 |
|------|------|------|----------|--------|
| 直接PDF导出 | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ | ⭐ |
| 图片+PPTX | ⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐ |
| Reveal.js转PDF | ⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ |

---

## 🎯 总结

### 核心发现

1. **Puppeteer是关键工具** - 可以获取图表尺寸、截图、生成PDF
2. **没有万能方案** - 需要根据图表尺寸选择合适的策略
3. **分步骤处理** - 先获取尺寸，再计算策略，最后生成
4. **配置很重要** - 页面尺寸、格式、边距都需要可配置

### 推荐实现

1. ✅ 实现统一的导出API
2. ✅ 支持多种排版策略（缩放/平铺/分页）
3. ✅ 自动选择最佳策略
4. ✅ 完善错误处理
5. ✅ 添加配置文件支持

### 下一步

1. 实现统一的导出API
2. 测试不同尺寸的图表
3. 优化排版策略算法
4. 添加更多输出格式（SVG、EPS等）

---

**审查日期**: 2026-03-02  
**审查者**: AI Assistant  
**版本**: 1.0
