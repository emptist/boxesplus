# 修复版 - 固定页面大小

fs = require "fs"

htmlContent = """
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>医疗质量与安全管理 - Mermaid 图表</title>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/mermaid/8.14.0/mermaid.min.js"></script>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    
    @page {
      size: 1280px 720px;
      margin: 0;
    }
    
    body {
      font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif;
      background: white;
      width: 1280px;
      height: 720px;
      overflow: hidden;
    }
    
    .slide {
      width: 1280px;
      height: 720px;
      padding: 40px 60px;
      display: flex;
      flex-direction: column;
      align-items: center;
      page-break-after: always;
      border-bottom: 1px dashed #eee;
    }
    
    .slide:last-child { border-bottom: none; }
    
    h1 { 
      color: #1a365d; 
      font-size: 42px; 
      margin-bottom: 10px;
    }
    
    h3 { 
      color: #1a365d; 
      border-bottom: 3px solid #3182ce; 
      padding-bottom: 15px; 
      width: 100%;
      text-align: left;
      font-size: 32px;
      margin-bottom: 30px;
    }
    
    .mermaid-container {
      flex: 1;
      display: flex;
      align-items: center;
      justify-content: center;
      width: 100%;
    }
    
    .mermaid svg {
      max-width: 100%;
      max-height: 100%;
    }
  </style>
</head>
<body>

  <div class="slide">
    <h1>医疗质量与安全管理</h1>
  </div>

  <div class="slide">
    <h3>1. PDCA 持续改进循环</h3>
    <div class="mermaid-container">
      <pre class="mermaid">
flowchart LR
    P[PLAN<br/>计划] --> D[DO<br/>执行]
    D --> C[CHECK<br/>检查]
    C --> A[ACTION<br/>处理]
    A -.->|持续改进| P
    
    style P fill:#3182ce,color:#fff,stroke:none,rx:30
    style D fill:#38a169,color:#fff,stroke:none,rx:30
    style C fill:#d69e2e,color:#fff,stroke:none,rx:30
    style A fill:#e53e3e,color:#fff,stroke:none,rx:30
      </pre>
    </div>
  </div>

  <div class="slide">
    <h3>2. 柏拉图 - 二八法则</h3>
    <div class="mermaid-container">
      <pre class="mermaid">
pie title 问题分布 - 二八法则
    "核心问题 (20%)" : 80
    "次要问题 (80%)" : 20
      </pre>
    </div>
  </div>

  <div class="slide">
    <h3>3. 医疗质量管理体系</h3>
    <div class="mermaid-container" style="transform: scale(0.85);">
      <pre class="mermaid">
flowchart TB
    T1[质量方针] --> T2[质量目标] --> T3[质量文化]
    M1[质量组织] --> M2[质量制度] --> M3[质量流程]
    B1[质量控制] --> B2[质量保证] --> B3[质量改进]
    T1 & T2 & T3 --> M1
    M1 & M2 & M3 --> B1
    style T1,T2,T3 fill:#e6f3ff,stroke:#3182ce
    style M1,M2,M3 fill:#e6ffed,stroke:#38a169
    style B1,B2,B3 fill:#fffaf0,stroke:#d69e2e
      </pre>
    </div>
  </div>

  <div class="slide">
    <h3>4. 不良事件闭环管理</h3>
    <div class="mermaid-container" style="transform: scale(0.85);">
      <pre class="mermaid">
flowchart LR
    A[事件报告] --> B[原因分析]
    B --> C[整改措施]
    C --> D[效果评估]
    D -.->|改进| A
    style A fill:#bee3f8,stroke:#3182ce
    style B fill:#e9d8fd,stroke:#805ad5
    style C fill:#c6f6d5,stroke:#38a169
    style D fill:#feebc8,stroke:#d69e2e
      </pre>
    </div>
  </div>

  <div class="slide">
    <h3>5. 数据资产生命周期</h3>
    <div class="mermaid-container">
      <pre class="mermaid">
flowchart LR
    A[采集] --> B[存储] --> C[处理] --> D[分析] --> E[应用]
    
    style A fill:#4299e1,color:#fff,rx:10
    style B fill:#48bb78,color:#fff,rx:10
    style C fill:#ed8936,color:#fff,rx:10
    style D fill:#9f7aea,color:#fff,rx:10
    style E fill:#f56565,color:#fff,rx:10
      </pre>
    </div>
  </div>

  <div class="slide">
    <h3>6. 医院品牌金字塔</h3>
    <div class="mermaid-container">
      <pre class="mermaid">
flowchart TB
    A[文化品牌] --> B[技术品牌]
    A --> C[服务品牌]
    B & C --> D[视觉识别]
    
    style A fill:#805ad5,color:#fff,stroke:#553c9a,stroke-width:3,rx:15
    style B fill:#3182ce,color:#fff,stroke:#2c5282,rx:10
    style C fill:#38a169,color:#fff,stroke:#276749,rx:10
    style D fill:#d69e2e,color:#fff,stroke:#b7791f,stroke-width:3,rx:15
      </pre>
    </div>
  </div>

  <div class="slide">
    <h3>7. SWOT 分析</h3>
    <div class="mermaid-container" style="transform: scale(0.85);">
      <pre class="mermaid">
flowchart TB
    优势1[技术领先]
    优势2[专家团队]
    劣势1[传播不足]
    劣势2[新媒体弱]
    机会1[政策支持]
    机会2[市场需求]
    威胁1[竞争激烈]
    威胁2[舆论风险]
    style 优势1,优势2 fill:#c6f6d5,stroke:#38a169
    style 劣势1,劣势2 fill:#fed7d7,stroke:#e53e3e
    style 机会1,机会2 fill:#bee3f8,stroke:#3182ce
    style 威胁1,威胁2 fill:#feebc8,stroke:#d69e2e
      </pre>
    </div>
  </div>

  <div class="slide">
    <h3>8. 围手术期安全管理</h3>
    <div class="mermaid-container">
      <pre class="mermaid">
flowchart LR
    P1[手术指征] --> P2[知情同意] --> P3[术前核查]
    I1[安全核查] --> I2[手术操作] --> I3[记录规范]
    A1[术后交接] --> A2[术后访视] --> A3[并发症防治]
    P3 --> I1
    I3 --> A1
    
    style P1,P2,P3 fill:#bee3f8,stroke:#3182ce,rx:5
    style I1,I2,I3 fill:#feebc8,stroke:#d69e2e,rx:5
    style A1,A2,A3 fill:#c6f6d5,stroke:#38a169,rx:5
      </pre>
    </div>
  </div>

  <div class="slide">
    <h3>9. 患者安全目标</h3>
    <div class="mermaid-container" style="transform: scale(0.85);">
      <pre class="mermaid">
flowchart TB
    识别1[正确识别患者]
    识别2[手术安全核查]
    用药1[确保用药安全]
    用药2[提升用药水平]
    感染[减少院感]
    事件[不良事件报告]
    跌倒[预防跌倒]
    器械[医疗器械监管]
    style 识别1,识别2 fill:#bee3f8,stroke:#3182ce
    style 用药1,用药2 fill:#c6f6d5,stroke:#38a169
    style 感染 fill:#feebc8,stroke:#d69e2e
    style 事件,跌倒,器械 fill:#e9d8fd,stroke:#805ad5
      </pre>
    </div>
  </div>

  <div class="slide">
    <h3>10. 学科评估指标体系</h3>
    <div class="mermaid-container" style="transform: scale(0.75);">
      <pre class="mermaid">
flowchart TB
    top[学科评估] --> 医疗[医疗质量]
    top --> 科研[科研教学]
    top --> 人才[人才队伍]
    top --> 声誉[学科声誉]
    医疗 --> 治愈[治愈率]
    医疗 --> 感染[感染率]
    科研 --> 论文[论文数量]
    科研 --> 课题[课题]
    人才 --> 学历[学历结构]
    人才 --> 带头人[学科带头人]
    声誉 --> 任职[学术任职]
    声誉 --> 满意[患者满意度]
    style top fill:#1a365d,color:#fff
    style 医疗,科研,人才,声誉 fill:#2c5282,color:#fff
    style 治愈,感染,论文,课题,学历,带头人,任职,满意 fill:#f7fafc,stroke:#ccc
      </pre>
    </div>
  </div>

  <script>
    mermaid.initialize({ startOnLoad: true });
  </script>
</body>
</html>
"""

fs.writeFileSync "outputs/mermaid-fixed.html", htmlContent
console.log "✅ Created: outputs/mermaid-fixed.html"
