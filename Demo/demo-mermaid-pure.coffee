# 纯 HTML + Mermaid 测试（不用 Reveal.js）

fs = require "fs"

htmlContent = """
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>纯 Mermaid 测试</title>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/mermaid/8.14.0/mermaid.min.js"></script>
  <style>
    body { font-family: sans-serif; padding: 20px; }
    .slide { margin: 30px 0; padding: 20px; border: 1px solid #ccc; }
    h3 { color: #1a365d; }
  </style>
</head>
<body>
  <h1>纯 Mermaid 测试（无 Reveal.js）</h1>

  <div class="slide">
    <h3>1. 最简单流程图</h3>
    <div class="mermaid">
flowchart LR
    A --> B --> C
    </div>
  </div>

  <div class="slide">
    <h3>2. 带样式</h3>
    <div class="mermaid">
flowchart LR
    A[步骤一] --> B[步骤二]
    style A fill:#bee3f8,stroke:#3182ce
    style B fill:#c6f6d5,stroke:#38a169
    </div>
  </div>

  <div class="slide">
    <h3>3. 不良事件闭环</h3>
    <div class="mermaid">
flowchart LR
    A[事件报告] --> B[原因分析]
    B --> C[整改措施]
    C --> D[效果评估]
    D --> A
    </div>
  </div>

  <div class="slide">
    <h3>4. 数据生命周期（5节点）</h3>
    <div class="mermaid">
flowchart LR
    A[采集] --> B[存储] --> C[处理] --> D[分析] --> E[应用]
    </div>
  </div>

  <div class="slide">
    <h3>5. 饼图</h3>
    <div class="mermaid">
pie title 测试
    "A" : 50
    "B" : 50
    </div>
  </div>

  <div class="slide">
    <h3>6. 品牌金字塔（TB方向）</h3>
    <div class="mermaid">
flowchart TB
    A[文化品牌] --> B[技术品牌]
    A --> C[服务品牌]
    B --> D[视觉识别]
    C --> D
    </div>
  </div>

  <div class="slide">
    <h3>7. PDCA 循环</h3>
    <div class="mermaid">
flowchart LR
    P[PLAN] --> D[DO] --> C[CHECK] --> A[ACTION]
    A -.-> P
    </div>
  </div>

  <script>
    mermaid.initialize({ startOnLoad: true });
  </script>
</body>
</html>
"""

fs.writeFileSync "outputs/mermaid-pure.html", htmlContent
console.log "✅ Created: outputs/mermaid-pure.html"
