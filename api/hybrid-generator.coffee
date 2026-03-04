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

  # 时间线
  timeline: """
gantt
    title 项目时间线
    dateFormat  YYYY-MM-DD
    section 阶段一
    需求分析       :a1, 2024-01-01, 30d
    设计方案       :a2, after a1, 20d
    section 阶段二
    开发实现       :b1, after a2, 45d
    测试验收       :b2, after b1, 15d
    section 阶段三
    部署上线       :c1, after b2, 10d
    培训支持       :c2, after c1, 7d
"""

  # 思维导图
  mindmap: """
mindmap
  root((中心主题))
    分支一
      子主题A
      子主题B
    分支二
      子主题C
      子主题D
    分支三
      子主题E
"""

  # 甘特图简化版
  ganttSimple: """
gantt
    title 工作计划
    dateFormat  HH:mm
    09:00-12:00 : task1, 09:00, 3h
    14:00-17:00 : task2, 14:00, 3h
    18:00-20:00 : task3, 18:00, 2h
"""

  # 流程图 - 决策
  decision: """
flowchart TD
    A[开始] --> B{条件判断}
    B -->|是| C[处理A]
    B -->|否| D[处理B]
    C --> E[输出结果]
    D --> E
    E --> F[结束]
    style A fill:#3182ce,color:#fff
    style B fill:#d69e2e,color:#fff
    style E fill:#38a169,color:#fff
    style F fill:#e53e3e,color:#fff
"""

  # 用户旅程
  userJourney: """
journey
    title 用户旅程
    section 阶段一
      访问网站: 5: 用户1, 用户2
      浏览产品: 4: 用户1, 用户2
    section 阶段二
      加入购物车: 3: 用户1
      填写订单: 3: 用户1
    section 阶段三
      支付: 2: 用户1
      收到商品: 5: 用户1
"""

  # Git图
  gitGraph: """
gitGraph
   commit id: "初始版本"
   branch feature1
   commit id: "功能开发"
   commit id: "功能完成"
   checkout main
   commit id: "合并分支"
   commit id: "发布v1.0"
"""

  # 架构图
  architecture: """
flowchart TB
    subgraph Client[客户端]
        Web[网页端]
        Mobile[移动端]
    end
    
    subgraph Server[服务端]
        API[API网关]
        Auth[认证服务]
        Biz[业务服务]
    end
    
    subgraph Data[数据层]
        DB[(数据库)]
        Cache[(缓存)]
    end
    
    Web --> API
    Mobile --> API
    API --> Auth
    API --> Biz
    Biz --> DB
    Biz --> Cache
    
    style Client fill:#e6ffed,stroke:#38a169
    style Server fill:#bee3f8,stroke:#3182ce
    style Data fill:#feebc8,stroke:#d69e2e
"""

  # 患者安全目标
  patientSafety: """
flowchart LR
    G1[正确识别患者] --> G2[强化手术安全]
    G3[提高用药安全] --> G4[提升护理安全]
    G5[预防院内感染] --> G6[鼓励不良上报]
    G7[预防跌倒] --> G8[加强器械管理]
    style G1,G2 fill:#bee3f8,stroke:#3182ce
    style G3,G4 fill:#c6f6d5,stroke:#38a169
    style G5,G6 fill:#feebc8,stroke:#d69e2e
    style G7,G8 fill:#e9d8fd,stroke:#805ad5
"""

  # 医院等级评审
  hospitalReview: """
flowchart LR
    A[医院自评] --> B[数据收集]
    B --> C[专家评审]
    C --> D{评审结果}
    D -->|通过| E[持续改进]
    D -->|整改| F[限期整改]
    F --> B
    style A fill:#e6f3ff,stroke:#3182ce
    style B fill:#e6ffed,stroke:#38a169
    style C fill:#fffaf0,stroke:#d69e2e
    style D fill:#f5f5f5,stroke:#666666
    style E fill:#e8f5e9,stroke:#2e7d32
    style F fill:#ffebee,stroke:#c62828
"""

  # 医患沟通
  doctorPatient: """
flowchart LR
    A[入院沟通] --> B[诊疗沟通]
    B --> C[手术沟通] 
    C --> D[出院沟通]
    D --> E[随访沟通]
    A -.->|持续| B
    B -.->|持续| C
    C -.->|持续| D
    D -.->|持续| E
    style A fill:#bee3f8,stroke:#3182ce
    style B fill:#c6f6d5,stroke:#38a169
    style C fill:#feebc8,stroke:#d69e2e
    style D fill:#e9d8fd,stroke:#805ad5
    style E fill:#fed7d7,stroke:#e53e3e
"""

  # 绩效管理
  performance: """
flowchart LR
    A[目标设定] --> B[过程管理]
    B --> C[绩效考核]
    C --> D[结果应用]
    D -.->|反馈| A
    style A fill:#3182ce,color:#fff
    style B fill:#38a169,color:#fff
    style C fill:#d69e2e,color:#fff
    style D fill:#e53e3e,color:#fff
"""

  # 教学培训流程
  training: """
flowchart LR
    A[需求分析] --> B[计划制定]
    B --> C[组织实施]
    C --> D[效果评估]
    D --> E[持续改进]
    style A fill:#e6f3ff,stroke:#3182ce
    style B fill:#e6ffed,stroke:#38a169
    style C fill:#fffaf0,stroke:#d69e2e
    style D fill:#f3e5f5,stroke:#805ad5
    style E fill:#ffebee,stroke:#e53e3e
"""

  # 科研项目流程
  research: """
flowchart LR
    A[选题立项] --> B[文献综述]
    B --> C[研究设计]
    C --> D[项目实施]
    D --> E[数据分析]
    E --> F[论文发表]
    style A fill:#bee3f8,stroke:#3182ce
    style B fill:#c6f6d5,stroke:#38a169
    style C fill:#feebc8,stroke:#d69e2e
    style D fill:#e9d8fd,stroke:#805ad5
    style E fill:#fed7d7,stroke:#e53e3e
    style F fill:#e6f3ff,stroke:#3182ce
"""

  # 人才梯队
  talentTeam: """
flowchart TB
    高层[高层管理] --> 中层[中层管理]
    中层 --> 基层[基层员工]
    高层 --- 高层梯队[人才梯队建设]
    中层 --- 中层梯队[储备干部培养]
    基层 --- 基层梯队[技能培训]
    style 高层 fill:#3182ce,color:#fff
    style 中层 fill:#38a169,color:#fff
    style 基层 fill:#d69e2e,color:#fff
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

  addTwoCol: (title, leftTitle, leftItems, rightTitle, rightItems) ->
    @slides.push { type: "two-col", title, leftTitle, leftItems, rightTitle, rightItems }
    this

  addImage: (title, imagePath, caption = "") ->
    @slides.push { type: "image", title, imagePath, caption }
    this

  addCode: (title, code, language = "") ->
    @slides.push { type: "code", title, code, language }
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
      chartHtml = slide.chart?.trim()
      """
      <div class="slide">
        <h3>#{slide.title}</h3>
        <div class="mermaid-container" style="transform: scale(#{scale});">
          <pre class="mermaid">#{chartHtml}</pre>
        </div>
      </div>
      """
    else if slide.type is "list" or slide.type is "content"
      itemsHtml = for item, i in (slide.items ? [])
        "<li>#{item}</li>"
      """
      <div class="slide">
        <h3>#{slide.title}</h3>
        <ul>#{itemsHtml.join('')}</ul>
      </div>
      """
    else if slide.type is "two-col"
      leftHtml = for item in slide.leftItems
        "<li>#{item}</li>"
      rightHtml = for item in slide.rightItems
        "<li>#{item}</li>"
      """
      <div class="slide">
        <h3>#{slide.title}</h3>
        <div class="two-col">
          <div class="col">
            <h4>#{slide.leftTitle}</h4>
            <ul>#{leftHtml.join('')}</ul>
          </div>
          <div class="col">
            <h4>#{slide.rightTitle}</h4>
            <ul>#{rightHtml.join('')}</ul>
          </div>
        </div>
      </div>
      """
    else if slide.type is "image"
      """
      <div class="slide">
        <h3>#{slide.title}</h3>
        <div class="image-container">
          <img src="#{slide.imagePath}" alt="#{slide.title}">
          <p class="caption">#{slide.caption || ''}</p>
        </div>
      </div>
      """
    else if slide.type is "code"
      """
      <div class="slide">
        <h3>#{slide.title}</h3>
        <pre class="code"><code class="language-#{slide.language}">#{slide.code}</code></pre>
      </div>
      """
    else if slide.type is "comparison"
      """
      <div class="slide">
        <h3>#{slide.title}</h3>
        <div class="comparison">
          <div class="comparison-left">
            <h4>#{slide.leftTitle}</h4>
            <p>#{slide.leftContent}</p>
          </div>
          <div class="comparison-vs">VS</div>
          <div class="comparison-right">
            <h4>#{slide.rightTitle}</h4>
            <p>#{slide.rightContent}</p>
          </div>
        </div>
      </div>
      """
    else if slide.type is "quote"
      """
      <div class="slide">
        <h3>#{slide.title}</h3>
        <div class="quote-container">
          <blockquote>"#{slide.quote}"</blockquote>
          <p class="quote-author">— #{slide.author}</p>
        </div>
      </div>
      """
  
  slidesHtmlStr = slidesHtml.join('')
  
  html = """
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>#{data.title}</title>
  <script src="https://cdn.jsdelivr.net/npm/mermaid@9.4.3/dist/mermaid.min.js"></script>
  <script>
    mermaid.initialize({ 
      startOnLoad: true,
      theme: 'default'
    });
  </script>
  <style>
    * { box-sizing: border-box; }
    body { margin: 0; padding: 0; background: #333; }
    .slide { 
      width: 1000px; 
      height: 562px; 
      margin: 10px auto;
      padding: 30px 40px;
      background: white;
      page-break-after: always;
      position: relative;
      overflow: hidden;
    }
    .slide h1 { color: #366092; font-size: 36px; margin: 0 0 20px 0; }
    .slide h3 { color: #366092; font-size: 28px; margin: 0 0 15px 0; }
    .slide h4 { color: #366092; font-size: 20px; margin: 0 0 10px 0; }
    .slide p { font-size: 16px; color: #333; margin: 5px 0; }
    .slide li { font-size: 16px; color: #333; margin: 8px 0; }
    .title-slide { 
      text-align: center; 
      padding-top: 150px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    }
    .title-slide h1 { color: white; font-size: 48px; }
    .title-slide p { color: #e0e0e0; font-size: 24px; }
    ul { padding-left: 25px; }
    .comparison { display: flex; align-items: stretch; justify-content: center; margin-top: 30px; height: 300px; }
    .comparison-left, .comparison-right { flex: 1; padding: 25px; margin: 5px; border-radius: 8px; display: flex; flex-direction: column; }
    .comparison-left { background: #E8F4FD; }
    .comparison-right { background: #FFF4E6; }
    .comparison-left h4, .comparison-right h4 { text-align: center; }
    .comparison-vs { 
      display: flex; align-items: center; 
      font-size: 28px; font-weight: bold; color: #FF6B6B; 
      margin: 0 10px; 
    }
    .quote-container { 
      margin: 80px auto; 
      max-width: 900px; 
      text-align: center; 
      padding: 40px;
      background: #f9f9f9;
      border-left: 5px solid #366092;
      border-radius: 0 10px 10px 0;
    }
    .quote-container blockquote { 
      font-size: 32px; 
      font-style: italic; 
      color: #366092; 
      margin: 20px 0; 
      line-height: 1.4;
    }
    .quote-author { font-size: 20px; color: #666; text-align: right; }
    .mermaid-container { 
      display: flex; 
      justify-content: center; 
      align-items: center; 
      height: 380px; 
    }
    .mermaid-container pre { 
      transform-origin: center center; 
      transform: scale(0.9); 
    }
    .card-container { display: flex; gap: 15px; margin-top: 30px; }
    .card { flex: 1; padding: 20px; background: #f5f5f5; border-radius: 8px; text-align: center; }
    .card h4 { color: #366092; }
  </style>
</head>
<body>
#{slidesHtmlStr}
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
  
  try
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
  catch e
    console.log "   ⚠️ PPTX 生成失败: #{e.message}"
    console.log "   错误详情: #{e.stack}"
    try
      await browser?.close()
      fs.rmSync(outputDir, { recursive: true, force: true })
    catch
      null
    throw e

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
