# BoxesPlus - 混合生成器
# 整合自 AI 朋友的探索 + 我们的实践
# 简单内容 → PPTX直接生成
# 复杂内容（Mermaid图表）→ HTML生成 → 转换为PDF

fs = require "fs"
path = require "path"
puppeteer = require "puppeteer"
PptxGenJS = require "pptxgenjs"

# ============================================
# 预定义 Mermaid 图表模板
# ============================================

CHARTS =
  pdca: """
flowchart LR
    P[PLAN<br/>计划] --> D[DO<br/>执行]
    D --> C[CHECK<br/>检查]
    C --> A[ACTION<br/>处理]
    A -.->|改进| P
    style P fill:#3182ce,color:#fff
    style D fill:#38a169,color:#fff
    style C fill:#d69e2e,color:#fff
    style A fill:#e53e3e,color:#fff
"""

  pareto: """
pie title 二八法则
    "核心问题" : 80
    "次要问题" : 20
"""

  eventLoop: """
flowchart LR
    A[事件报告] --> B[原因分析]
    B --> C[整改措施]
    C --> D[效果评估]
    D -.->|改进| A
    style A fill:#bee3f8,stroke:#3182ce
    style B fill:#e9d8fd,stroke:#805ad5
    style C fill:#c6f6d5,stroke:#38a169
    style D fill:#feebc8,stroke:#d69e2e
"""

  dataLifecycle: """
flowchart LR
    A[采集] --> B[存储] --> C[处理] --> D[分析] --> E[应用]
    style A fill:#4299e1,color:#fff
    style B fill:#48bb78,color:#fff
    style C fill:#ed8936,color:#fff
    style D fill:#9f7aea,color:#fff
    style E fill:#f56565,color:#fff
"""

  brandPyramid: """
flowchart LR
    A[文化品牌] --> B[技术品牌]
    A --> C[服务品牌]
    B & C --> D[视觉识别]
    style A fill:#805ad5,color:#fff
    style B fill:#3182ce,color:#fff
    style C fill:#38a169,color:#fff
    style D fill:#d69e2e,color:#fff
"""

  # 质量管理体系 - 简化版 LR
  qualitySystem: """
flowchart LR
    方针[质量方针] --> 组织[质量组织]
    目标[质量目标] --> 制度[质量制度]
    文化[质量文化] --> 流程[质量流程]
    组织 --> 控制[质量控制]
    制度 --> 保证[质量保证]
    style 方针,目标,文化 fill:#e6f3ff,stroke:#3182ce
    style 组织,制度,流程 fill:#e6ffed,stroke:#38a169
    style 控制,保证,改进 fill:#fffaf0,stroke:#d69e2e
"""

  # 患者安全目标
  patientSafety: """
flowchart LR
    G1[正确识别] --> G2[手术核查]
    G3[用药安全] --> G4[提升水平]
    G5[院感防控] --> G6[不良报告]
    G7[跌倒预防] --> G8[器械监管]
    style G1,G2 fill:#bee3f8,stroke:#3182ce
    style G3,G4 fill:#c6f6d5,stroke:#38a169
    style G5 fill:#feebc8,stroke:#d69e2e
    style G6,G7,G8 fill:#e9d8fd,stroke:#805ad5
"""

  # SWOT分析
  swot: """
flowchart LR
    S1[技术领先] & S2[专家团队]
    W1[传播不足] & W2[新媒体弱]
    O1[政策支持] & O2[市场需求]
    T1[竞争激烈] & T2[舆论风险]
    style S1,S2 fill:#c6f6d5,stroke:#38a169
    style W1,W2 fill:#fed7d7,stroke:#e53e3e
    style O1,O2 fill:#bee3f8,stroke:#3182ce
    style T1,T2 fill:#feebc8,stroke:#d69e2e
"""

  # 围手术期
  surgery: """
flowchart LR
    P1[手术指征] --> P2[知情同意] --> P3[术前核查]
    I1[安全核查] --> I2[手术操作] --> I3[记录规范]
    A1[术后交接] --> A2[术后访视] --> A3[并发症防治]
    P3 --> I1
    I3 --> A1
    style P1,P2,P3 fill:#bee3f8,stroke:#3182ce
    style I1,I2,I3 fill:#feebc8,stroke:#d69e2e
    style A1,A2,A3 fill:#c6f6d5,stroke:#38a169
"""

  # 学科评估
  evaluation: """
flowchart LR
    评估[学科评估] --> 质量 & 科研 & 人才 & 声誉
    质量 --> 治愈[治愈率] & 感染[感染率]
    科研 --> 论文[论文数量] & 课题[课题]
    人才 --> 学历[学历结构] & 带头[学科带头人]
    声誉 --> 任职[学术任职] & 满意[患者满意度]
    style 评估 fill:#1a365d,color:#fff
    style 质量,科研,人才,声誉 fill:#2c5282,color:#fff
    style 治愈,感染,论文,课题,学历,带头,任职,满意 fill:#f7fafc,stroke:#ccc
"""

# ============================================
# 课程数据生成器
# ============================================

class CourseGenerator
  constructor: (title) ->
    @title = title
    @slides = []
  
  addTitle: (title, subtitle = "") ->
    @slides.push { type: "title", title, subtitle }
    this
  
  addMermaid: (title, chart, scale = "") ->
    @slides.push { type: "mermaid", title, chart, scale }
    this
  
  addList: (title, items) ->
    @slides.push { type: "list", title, items }
    this

# ============================================
# HTML 生成器（用于 Mermaid 图表）
# ============================================

generateHtml = (data, outputPath) ->
  slidesHtml = for slide in data.slides
    if slide.type is "title"
      """
      <div class="slide title-slide">
        <h1>#{slide.title}</h1>
        <p>#{slide.subtitle || ''}</p>
      </div>
      """
    else if slide.type is "mermaid"
      scale = slide.scale || "1.0"
      """
      <div class="slide">
        <h3>#{slide.title}</h3>
        <div class="mermaid-container" style="transform: scale(#{scale});">
          <pre class="mermaid">
#{slide.chart}
          </pre>
        </div>
      </div>
      """
    else if slide.type is "list"
      itemsHtml = for item, i in slide.items
        "<li>#{item}</li>"
      """
      <div class="slide">
        <h3>#{slide.title}</h3>
        <ul>#{itemsHtml.join('')}</ul>
      </div>
      """
  
  html = """
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>#{data.title}</title>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/mermaid/8.14.0/mermaid.min.js"></script>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    @page { size: 1280px 720px; margin: 0; }
    body { font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif; background: white; width: 1280px; height: 720px; overflow: hidden; }
    .slide { width: 1280px; height: 720px; padding: 40px 60px; display: flex; flex-direction: column; border-bottom: 1px dashed #eee; }
    .title-slide { justify-content: center; align-items: center; background: linear-gradient(135deg, #1a365d, #2c5282); }
    .title-slide h1 { color: white; font-size: 48px; }
    .title-slide p { color: #90cdf4; font-size: 24px; margin-top: 20px; }
    h3 { color: #1a365d; border-bottom: 3px solid #3182ce; padding-bottom: 15px; width: 100%; font-size: 32px; margin-bottom: 30px; }
    .mermaid-container { flex: 1; display: flex; align-items: center; justify-content: center; width: 100%; }
    ul { list-style: none; padding: 0; }
    li { font-size: 28px; padding: 15px 0; border-bottom: 1px solid #eee; color: #2d3748; }
    li:before { content: "•"; color: #3182ce; margin-right: 15px; }
  </style>
</head>
<body>
#{slidesHtml.join('\n')}
  <script>
    mermaid.initialize({ 
      startOnLoad: true,
      theme: 'default'
    });
  </script>
</body>
</html>
"""
  
  fs.writeFileSync(outputPath, html)
  console.log "✅ HTML: #{outputPath}"

# ============================================
# PDF 导出
# ============================================

htmlToPdf = (htmlPath, pdfPath) ->
  console.log "📄 生成 PDF..."
  
  browser = await puppeteer.launch({
    headless: "new"
    executablePath: "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
  })
  
  page = await browser.newPage()
  await page.setViewport({ width: 1280, height: 720 })
  
  fileUrl = "file://" + fs.realpathSync(htmlPath)
  await page.goto(fileUrl, { waitUntil: 'networkidle0', timeout: 60000 })
  
  # 等待 Mermaid 渲染完成 (增加超时时间)
  try
    await page.waitForFunction ->
      document.querySelectorAll('.mermaid svg').length > 0
    , { timeout: 60000 }
    console.log "   ✓ Mermaid 渲染完成"
  catch e
    console.log "   ⚠️ Mermaid 渲染超时，尝试截图..."
    # 再等待5秒
    await new Promise (resolve) -> setTimeout(resolve, 5000)
  
  # 额外等待确保渲染完成
  await new Promise (resolve) -> setTimeout(resolve, 3000)
  
  await page.pdf({
    path: pdfPath
    width: "1280px"
    height: "720px"
    printBackground: true
    margin: { top: 0, bottom: 0, left: 0, right: 0 }
  })
  
  await browser.close()
  console.log "✅ PDF: #{pdfPath}"

# ============================================
# PPTX 导出（截图方式）
# ============================================

htmlToPptx = (htmlPath, pptxPath) ->
  console.log "📊 生成 PPTX..."
  
  outputDir = path.join(path.dirname(pptxPath), "temp-slides-#{Date.now()}")
  fs.mkdirSync(outputDir, { recursive: true })
  
  browser = await puppeteer.launch({
    headless: "new"
    executablePath: "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
  })
  
  page = await browser.newPage()
  await page.setViewport({ width: 1280, height: 720 })
  
  fileUrl = "file://" + fs.realpathSync(htmlPath)
  await page.goto(fileUrl, { waitUntil: 'networkidle0', timeout: 60000 })
  await new Promise (resolve) -> setTimeout(resolve, 3000)
  
  slides = await page.$$(".slide")
  console.log "   找到 #{slides.length} 张幻灯片"
  
  pres = new PptxGenJS()
  
  for slide, i in slides
    imgPath = path.join(outputDir, "slide-#{i}.png")
    await slide.screenshot({ path: imgPath, width: 1280, height: 720 })
    
    pptxSlide = pres.addSlide()
    pptxSlide.addImage({ path: imgPath, x: 0, y: 0, w: 10, h: 5.625 })
    console.log "   导出 #{i+1}/#{slides.length}"
  
  await pres.writeFile({ fileName: pptxPath })
  await browser.close()
  
  # 清理临时文件
  fs.rmSync(outputDir, { recursive: true })
  console.log "✅ PPTX: #{pptxPath}"

# ============================================
# 完整工作流
# ============================================

generate = (data, baseName) ->
  htmlPath = "outputs/#{baseName}.html"
  pdfPath = "outputs/#{baseName}.pdf"
  pptxPath = "outputs/#{baseName}.pptx"
  
  generateHtml(data, htmlPath)
  await htmlToPdf(htmlPath, pdfPath)
  await htmlToPptx(htmlPath, pptxPath)
  console.log "🎉 全部完成!"

module.exports = {
  CourseGenerator
  generateHtml, htmlToPdf, htmlToPptx, generate
  CHARTS
}
