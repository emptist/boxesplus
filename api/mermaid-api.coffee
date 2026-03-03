# BoxesPlus - Mermaid 图表 API
# 用 Mermaid 创建更美的图表

fs = require "fs"

# 生成带 Mermaid 的 Reveal.js HTML
generateMermaidHtml = (data, outputPath) ->
  slides = []
  
  # 封面
  if data.title
    slides.push """
    <section data-background-gradient="linear-gradient(135deg, #1a365d 0%, #2c5282 100%)">
      <h1 style="color: white;">#{data.title}</h1>
      <p style="color: #90cdf4;">#{data.subtitle || ''}</p>
    </section>
    """
  
  # 遍历每一页
  for slide in (data.slides || [])
    type = slide.type
    
    switch type
      when "title" then slides.push titleSlide(slide)
      when "section" then slides.push sectionSlide(slide)
      when "end" then slides.push endSlide(slide)
      when "mermaid" then slides.push mermaidSlide(slide)
      when "list" then slides.push listSlide(slide)
      when "cards" then slides.push cardsSlide(slide)
      when "box" then slides.push boxSlide(slide)
  
  html = """
  <!doctype html>
  <html>
  <head>
    <meta charset="utf-8">
    <title>#{data.title || '演示'}</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/reveal.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/theme/white.css">
    <script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>
    <style>
      .reveal .slides section { text-align: center; }
      .reveal { font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif; }
      .mermaid { display: flex; justify-content: center; margin: 20px 0; }
      .reveal .mermaid svg { max-width: 100%; height: auto; }
    </style>
  </head>
  <body>
    <div class="reveal">
      <div class="slides">
        #{slides.join("\n")}
      </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/reveal.js"></script>
    <script>
      mermaid.initialize({ 
        startOnLoad: true,
        theme: 'base',
        themeVariables: {
          primaryColor: '#3182ce',
          edgeLabelBackground: '#ffffff',
          tertiaryColor: '#f7fafc'
        }
      });
      Reveal.initialize({
        hash: true,
        slideNumber: true,
        transition: 'slide',
        center: true,
        width: 1280,
        height: 720
      });
    </script>
  </body>
  </html>
  """
  
  fs.writeFileSync(outputPath, html)
  console.log "✅ Created: #{outputPath}"

# ============ 组件函数 ============

titleSlide = (opts = {}) ->
  { title, subtitle, gradient } = opts
  gradient = gradient || "linear-gradient(135deg, #1a365d 0%, #2c5282 100%)"
  
  """
  <section style="background: #{gradient};">
    <h1 style="color: white;">#{title || '标题'}</h1>
    <h3 style="color: #90cdf4;">#{subtitle || ''}</h3>
  </section>
  """

sectionSlide = (opts = {}) ->
  { title, subtitle } = opts
  
  """
  <section data-background-gradient="linear-gradient(135deg, #1a365d 0%, #2c5282 100%)">
    <h1 style="color: white;">#{title || '章节'}</h1>
    <h2 style="color: #90cdf4;">#{subtitle || ''}</h2>
  </section>
  """

endSlide = (opts = {}) ->
  { title } = opts
  
  """
  <section data-background-gradient="linear-gradient(135deg, #38a169 0%, #276749 100%)">
    <h1 style="color: white; font-size: 3em;">#{title || '谢谢!'}</h1>
  </section>
  """

mermaidSlide = (opts = {}) ->
  { title, diagram, theme } = opts
  
  """
  <section>
    <h3 style="color: #1a365d; margin-bottom: 20px;">#{title || ''}</h3>
    <div class="mermaid" style="font-size: 24px;">
#{diagram || 'graph TD\\nA[A] --> B[B]'}
    </div>
  </section>
  """

listSlide = (opts = {}) ->
  { title, items } = opts
  items = items || ["要点1", "要点2", "要点3"]
  
  itemsHtml = items.map((item, i) -> 
    """
    <div style="display: flex; align-items: flex-start; margin-bottom: 15px;">
      <div style="background: #3182ce; color: white; width: 30px; height: 30px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 14px; margin-right: 15px; flex-shrink: 0;">#{i + 1}</div>
      <div style="text-align: left; padding-top: 5px;">#{item}</div>
    </div>
    """
  ).join("")
  
  """
  <section>
    <h2 style="color: #1a365d;">#{title || '内容'}</h2>
    <div style="margin-top: 30px; padding: 0 100px; text-align: left;">
      #{itemsHtml}
    </div>
  </section>
  """

cardsSlide = (opts = {}) ->
  { title, cards } = opts
  cards = cards || [
    { title: "卡片1", content: "内容1", color: "#ebf8ff" }
    { title: "卡片2", content: "内容2", color: "#f0fff4" }
  ]
  
  cardsHtml = cards.map((card) ->
    """
    <div style="flex: 1; background: #{card.color}; border-radius: 10px; padding: 20px; margin: 0 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
      <h3 style="margin: 0 0 10px 0; color: #1a365d;">#{card.title}</h3>
      <p style="margin: 0; color: #4a5568;">#{card.content}</p>
    </div>
    """
  ).join("")
  
  """
  <section>
    <h2 style="color: #1a365d;">#{title || '特点'}</h2>
    <div style="display: flex; gap: 20px; margin-top: 40px; justify-content: center;">
      #{cardsHtml}
    </div>
  </section>
  """

boxSlide = (opts = {}) ->
  { title, content, color } = opts
  color = color || "#f7fafc"
  
  if typeof content is "string"
    contentHtml = "<p style='font-size: 18px; line-height: 1.6;'>#{content.replace(/\n/g, "<br>")}</p>"
  else if Array.isArray(content)
    contentHtml = content.map((line) -> "<p style='font-size: 18px; line-height: 1.6; margin: 0 0 8px 0;'>#{line}</p>").join("")
  
  """
  <section>
    <h2 style="color: #1a365d;">#{title || '内容'}</h2>
    <div style="background: #{color}; border-left: 5px solid #2c5282; border-radius: 8px; padding: 20px; margin: 20px auto; max-width: 800px; text-align: left; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
      #{contentHtml}
    </div>
  </section>
  """

# ============ 预定义图表模板 ============

# PDCA 循环 - 横向布局，清晰4步骤
pdcaDiagram = """
flowchart LR
    P[PLAN<br/>计划] --> D[DO<br/>执行]
    D --> C[CHECK<br/>检查]
    C --> A[ACTION<br/>处理]
    A -.->|持续改进| P
    
    style P fill:#3182ce,color:#fff,stroke:none,rx:30
    style D fill:#38a169,color:#fff,stroke:none,rx:30
    style C fill:#d69e2e,color:#fff,stroke:none,rx:30
    style A fill:#e53e3e,color:#fff,stroke:none,rx:30
"""

# 柏拉图 - 二八法则
paretoDiagram = """
pie title 问题分布 - 二八法则
    "核心问题 (20%)" : 80
    "次要问题 (80%)" : 20
"""

# 数据生命周期 - 简洁横向5步
dataLifecycleDiagram = """
flowchart LR
    A[采集] --> B[存储] --> C[处理] --> D[分析] --> E[应用]
    
    style A fill:#4299e1,color:#fff,rx:10
    style B fill:#48bb78,color:#fff,rx:10
    style C fill:#ed8936,color:#fff,rx:10
    style D fill:#9f7aea,color:#fff,rx:10
    style E fill:#f56565,color:#fff,rx:10
"""

# 品牌金字塔
brandPyramidDiagram = """
flowchart TB
    A[文化品牌] --> B[技术品牌]
    A --> C[服务品牌]
    B --> D[视觉识别]
    C --> D
    
    style A fill:#805ad5,color:#fff,stroke:#553c9a,stroke-width:3,rx:10
    style B fill:#3182ce,color:#fff,stroke:#2c5282,rx:8
    style C fill:#38a169,color:#fff,stroke:#276749,rx:8
    style D fill:#d69e2e,color:#fff,stroke:#b7791f,rx:8
"""

# 不良事件闭环
eventLoopDiagram = """
flowchart LR
    A[事件报告] --> B[原因分析]
    B --> C[整改措施]
    C --> D[效果评估]
    D -.->|持续改进| A
    
    style A fill:#bee3f8,stroke:#3182ce,stroke-width:2,rx:8
    style B fill:#e9d8fd,stroke:#805ad5,stroke-width:2,rx:8
    style C fill:#c6f6d5,stroke:#38a169,stroke-width:2,rx:8
    style D fill:#feebc8,stroke:#d69e2e,stroke-width:2,rx:8
"""

# 质量管理体系
qualitySystemDiagram = """
flowchart TB
    T1[质量方针] --> T2[质量目标] --> T3[质量文化]
    M1[质量组织] --> M2[质量制度] --> M3[质量流程]
    B1[质量控制] --> B2[质量保证] --> B3[质量改进]
    
    T1 & T2 & T3 --> M1
    M1 & M2 & M3 --> B1
    
    style T1,T2,T3 fill:#e6f3ff,stroke:#3182ce,rx:5
    style M1,M2,M3 fill:#e6ffed,stroke:#38a169,rx:5
    style B1,B2,B3 fill:#fffaf0,stroke:#d69e2e,rx:5
"""

# 组织架构图
orgChartDiagram = (orgData) ->
  """
flowchart TB
    #{orgData.root}[#{orgData.root}]
    #{orgData.depts.map((d, i) -> orgData.root + ' --> ' + d).join('\n    ')}
    
    style #{orgData.root} fill:#1a365d,color:#fff,stroke:none,rx:10
    #{orgData.depts.map((d) -> '    style ' + d + ' fill:#2c5282,color:#fff,stroke:none,rx:8').join('\n')}
  """

# 时间线
timelineDiagram = (events) ->
  code = "timeline\n"
  code += "    title #{events.title || '时间线'}\n"
  for e in events.items
    code += "      #{e.date || '阶段'} : #{e.event}\n"
  code

# 流程步骤
flowStepsDiagram = (steps) ->
  code = "flowchart LR\n"
  for s, i in steps
    code += "    S#{i}[#{s.label || s}]"
    if i < steps.length - 1
      code += " --> "
    code += "\n"
  code

# 围手术期管理 - 简化版，不用subgraph
surgeryFlowDiagram = """
flowchart LR
    P1[手术指征] --> P2[知情同意] --> P3[术前核查]
    I1[安全核查] --> I2[手术操作] --> I3[记录规范]
    A1[术后交接] --> A2[术后访视] --> A3[并发症防治]
    P3 --> I1
    I3 --> A1
    
    style P1,P2,P3 fill:#bee3f8,stroke:#3182ce,rx:5
    style I1,I2,I3 fill:#feebc8,stroke:#d69e2e,rx:5
    style A1,A2,A3 fill:#c6f6d5,stroke:#38a169,rx:5
"""

# 患者安全目标 - 简化版
patientSafetyDiagram = """
flowchart TB
    G1[正确识别患者]
    G2[手术安全核查]
    G3[确保用药安全]
    G4[提升用药水平]
    G5[减少院感]
    G6[不良事件报告]
    G7[预防跌倒]
    G8[医疗器械监管]
    
    style G1,G2 fill:#bee3f8,stroke:#3182ce
    style G3,G4 fill:#c6f6d5,stroke:#38a169
    style G5 fill:#feebc8,stroke:#d69e2e
    style G6,G7,G8 fill:#e9d8fd,stroke:#805ad5
"""

# SWOT 分析 - 简化版
swotDiagram = """
flowchart TB
    S1[技术领先]
    S2[专家团队]
    W1[传播不足]
    W2[新媒体弱]
    O1[政策支持]
    O2[市场需求]
    T1[竞争激烈]
    T2[舆论风险]
    
    style S1,S2 fill:#c6f6d5,stroke:#38a169
    style W1,W2 fill:#fed7d7,stroke:#e53e3e
    style O1,O2 fill:#bee3f8,stroke:#3182ce
    style T1,T2 fill:#feebc8,stroke:#d69e2e
"""

# 品牌传播矩阵 - 简化版
brandMatrixDiagram = """
flowchart TB
    T1[电视]
    T2[报纸]
    N1[微信]
    N2[抖音]
    N3[微博]
    
    style T1,T2 fill:#bee3f8,stroke:#3182ce
    style N1,N2,N3 fill:#c6f6d5,stroke:#38a169
"""

# 评估指标体系
evaluationDiagram = """
flowchart TB
    A[学科评估] --> B1[医疗质量]
    A --> B2[科研教学]
    A --> B3[人才队伍]
    A --> B4[学科声誉]
    
    B1 --> C1[治愈率]
    B1 --> C2[感染率]
    B2 --> C3[论文数量]
    B2 --> C4[课题]
    B3 --> C5[学历结构]
    B3 --> C6[学科带头人]
    B4 --> C7[学术任职]
    B4 --> C8[患者满意度]
    
    style A fill:#1a365d,color:#fff,rx:10
    style B1,B2,B3,B4 fill:#2c5282,color:#fff,rx:8
    style C1,C2,C3,C4,C5,C6,C7,C8 fill:#f7fafc,stroke:#ccc,rx:4
"""

# ============ 导出 ============
module.exports = { 
  generateMermaidHtml
  titleSlide, sectionSlide, endSlide, mermaidSlide, listSlide, cardsSlide, boxSlide
  pdcaDiagram, paretoDiagram, dataLifecycleDiagram, brandPyramidDiagram
  eventLoopDiagram, qualitySystemDiagram
  surgeryFlowDiagram, patientSafetyDiagram, swotDiagram, brandMatrixDiagram, evaluationDiagram
}
