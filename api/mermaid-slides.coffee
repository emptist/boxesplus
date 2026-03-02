# BoxesPlus - Mermaid 幻灯片生成器

fs = require "fs"

# 页面模板
SLIDE_TEMPLATE = (title, content) -> """
  <div class="slide">
    <h3>#{title}</h3>
    <div class="mermaid-container">
      <pre class="mermaid">
#{content}
      </pre>
    </div>
  </div>
"""

# 生成幻灯片 HTML
generateSlides = (slides) ->
  html = ""
  for slide in slides
    if slide.type is "title"
      html += """
      <div class="slide title-slide">
        <h1>#{slide.title}</h1>
      </div>
      """
    else if slide.type is "mermaid"
      content = slide.content || "graph TD\nA --> B"
      scale = slide.scale || ""
      html += """
      <div class="slide">
        <h3>#{slide.title}</h3>
        <div class="mermaid-container" style="transform: scale(#{scale});">
          <pre class="mermaid">
#{content}
          </pre>
        </div>
      </div>
      """
  html

# 生成完整 HTML
generateHtml = (data, outputPath) ->
  slidesHtml = generateSlides(data.slides || [])
  
  html = """
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>#{data.title || '演示'}</title>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/mermaid/8.14.0/mermaid.min.js"></script>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    @page { size: 1280px 720px; margin: 0; }
    body { font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif; background: white; width: 1280px; height: 720px; overflow: hidden; }
    .slide { width: 1280px; height: 720px; padding: 40px 60px; display: flex; flex-direction: column; border-bottom: 1px dashed #eee; }
    .slide:last-child { border-bottom: none; }
    .title-slide { justify-content: center; align-items: center; background: linear-gradient(135deg, #1a365d, #2c5282); }
    .title-slide h1 { color: white; font-size: 48px; }
    h3 { color: #1a365d; border-bottom: 3px solid #3182ce; padding-bottom: 15px; width: 100%; font-size: 32px; margin-bottom: 30px; }
    .mermaid-container { flex: 1; display: flex; align-items: center; justify-content: center; width: 100%; }
    .mermaid svg { max-width: 100%; max-height: 100%; }
  </style>
</head>
<body>
#{slidesHtml}
  <script>mermaid.initialize({ startOnLoad: true });</script>
</body>
</html>
"""
  
  fs.writeFileSync(outputPath, html)
  console.log "✅ Created: #{outputPath}"

# ============ 预定义图表 ============

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

  qualitySystem: """
flowchart TB
    T1[质量方针] --> T2[质量目标] --> T3[质量文化]
    M1[质量组织] --> M2[质量制度] --> M3[质量流程]
    B1[质量控制] --> B2[质量保证] --> B3[质量改进]
    T1 & T2 & T3 --> M1
    M1 & M2 & M3 --> B1
    style T1,T2,T3 fill:#e6f3ff,stroke:#3182ce
    style M1,M2,M3 fill:#e6ffed,stroke:#38a169
    style B1,B2,B3 fill:#fffaf0,stroke:#d69e2e
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
flowchart TB
    A[文化品牌] --> B[技术品牌]
    A --> C[服务品牌]
    B & C --> D[视觉识别]
    style A fill:#805ad5,color:#fff,stroke:#553c9a
    style B fill:#3182ce,color:#fff
    style C fill:#38a169,color:#fff
    style D fill:#d69e2e,color:#fff
"""

  swot: """
flowchart TB
    S1[技术领先] & S2[专家团队]
    W1[传播不足] & W2[新媒体弱]
    O1[政策支持] & O2[市场需求]
    T1[竞争激烈] & T2[舆论风险]
    style S1,S2 fill:#c6f6d5,stroke:#38a169
    style W1,W2 fill:#fed7d7,stroke:#e53e3e
    style O1,O2 fill:#bee3f8,stroke:#3182ce
    style T1,T2 fill:#feebc8,stroke:#d69e2e
"""

module.exports = { generateHtml, CHARTS }
