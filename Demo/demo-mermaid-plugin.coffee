# 测试 reveal.js-mermaid-plugin

fs = require "fs"

htmlContent = """
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>Reveal.js + Mermaid Plugin 测试</title>
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/reveal.css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/theme/white.css">
</head>
<body>
  <div class="reveal">
    <div class="slides">
      
      <section>
        <h3>1. PDCA 循环</h3>
        <div class="mermaid">
flowchart LR
    P[PLAN] --> D[DO] --> C[CHECK] --> A[ACTION]
    A -.-> P
    style P fill:#3182ce,color:#fff
    style D fill:#38a169,color:#fff
    style C fill:#d69e2e,color:#fff
    style A fill:#e53e3e,color:#fff
        </div>
      </section>

      <section>
        <h3>2. 不良事件闭环</h3>
        <div class="mermaid">
flowchart LR
    A[事件报告] --> B[原因分析]
    B --> C[整改措施]
    C --> D[效果评估]
    D --> A
        </div>
      </section>

      <section>
        <h3>3. 数据生命周期</h3>
        <div class="mermaid">
flowchart LR
    A[采集] --> B[存储] --> C[处理] --> D[分析] --> E[应用]
        </div>
      </section>

      <section>
        <h3>4. 饼图</h3>
        <div class="mermaid">
pie title 测试
    "A" : 50
    "B" : 50
        </div>
      </section>

      <section>
        <h3>5. 品牌金字塔</h3>
        <div class="mermaid" data-processed="false">
flowchart TB
    A[文化品牌] --> B[技术品牌]
    A --> C[服务品牌]
    B & C --> D[视觉识别]
        </div>
      </section>

    </div>
  </div>
  <script src="https://cdn.jsdelivr.net/npm/reveal.js@4/dist/reveal.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/mermaid/8.14.0/mermaid.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/reveal.js-mermaid-plugin@11.4.1/plugin/mermaid/mermaid.js"></script>
  <script>
    // 手动初始化 mermaid
    mermaid.initialize({ 
      startOnLoad: false,
      theme: 'default'
    });
    
    // 手动渲染所有图表
    async function renderMermaid() {
      const diagrams = document.querySelectorAll('.mermaid');
      for (const diagram of diagrams) {
        if (!diagram.getAttribute('data-processed')) {
          try {
            const svg = await mermaid.render('mermaid-' + Math.random(), diagram.textContent.trim());
            diagram.innerHTML = svg.svg;
            diagram.setAttribute('data-processed', 'true');
          } catch (e) {
            console.error('Mermaid error:', e);
          }
        }
      }
    }
    
    Reveal.initialize({
      hash: true,
      slideNumber: true,
      transition: 'slide'
    }).then(() => {
      renderMermaid();
    });
  </script>
</body>
</html>
"""

fs.writeFileSync "outputs/mermaid-plugin-test.html", htmlContent
console.log "✅ Created: outputs/mermaid-plugin-test.html"
