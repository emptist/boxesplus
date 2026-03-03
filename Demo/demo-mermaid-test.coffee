# 最小测试 - 诊断 Mermaid 问题

fs = require "fs"

htmlContent = """
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Mermaid 测试</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.6.0/reveal.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.6.0/theme/white.min.css">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/mermaid/8.14.0/mermaid.min.js"></script>
  <style>
    .reveal .slides section { text-align: center; }
    .mermaid { display: flex; justify-content: center; margin: 20px; }
  </style>
</head>
<body>
  <div class="reveal">
    <div class="slides">
      
      <section>
        <h3>1. 最简单流程图</h3>
        <div class="mermaid">
flowchart LR
    A --> B --> C
        </div>
      </section>

      <section>
        <h3>2. 带样式</h3>
        <div class="mermaid">
flowchart LR
    A[步骤一] --> B[步骤二]
    style A fill:#bee3f8,stroke:#3182ce
    style B fill:#c6f6d5,stroke:#38a169
        </div>
      </section>

      <section>
        <h3>3. 不良事件闭环</h3>
        <div class="mermaid">
flowchart LR
    A[事件报告] --> B[原因分析]
    B --> C[整改措施]
    C --> D[效果评估]
    D --> A
        </div>
      </section>

      <section>
        <h3>4. 测试 - 简化版5节点</h3>
        <div class="mermaid">
flowchart LR
    A --> B --> C --> D --> E
        </div>
      </section>

      <section>
        <h3>5. 测试 - TB方向</h3>
        <div class="mermaid">
flowchart TB
    A --> B
    A --> C
        </div>
      </section>

      <section>
        <h3>5. 饼图</h3>
        <div class="mermaid">
pie title 测试
    "A" : 50
    "B" : 50
        </div>
      </section>

      <section>
        <h3>6. 品牌金字塔</h3>
        <div class="mermaid">
flowchart TB
    A[文化品牌] --> B[技术品牌]
    A --> C[服务品牌]
    B --> D[视觉识别]
    C --> D
        </div>
      </section>

    </div>
  <script src="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/reveal.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/mermaid@8/dist/mermaid.min.js"></script>
  <script>
    mermaid.initialize({ 
      startOnLoad: true,
      securityLevel: 'loose'
    });
    Reveal.initialize();
  </script>
</body>
</html>
"""

fs.writeFileSync "outputs/mermaid-test.html", htmlContent
console.log "✅ Created: outputs/mermaid-test.html"
