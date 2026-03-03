# 最终测试 - 修复 CSS 尺寸

fs = require "fs"

htmlContent = """
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>最终测试</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.6.0/reveal.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.6.0/theme/white.min.css">
  <style>
    .reveal .slides section { 
      text-align: center; 
    }
    .reveal pre.mermaid {
      display: inline-block;
      text-align: left;
      margin: 10px;
    }
    .reveal .mermaid {
      margin: 20px auto;
      display: block;
    }
    .reveal .mermaid svg {
      max-width: none !important;
      width: 100% !important;
      height: auto !important;
    }
  </style>
</head>
<body>
  <div class="reveal">
    <div class="slides">
      
      <section>
        <h3>1. PDCA 循环</h3>
        <pre class="mermaid">
flowchart LR
    P[PLAN] --> D[DO] --> C[CHECK] --> A[ACTION]
    A -.-> P
    style P fill:#3182ce,color:#fff
    style D fill:#38a169,color:#fff
    style C fill:#d69e2e,color:#fff
    style A fill:#e53e3e,color:#fff
        </pre>
      </section>

      <section>
        <h3>2. 饼图</h3>
        <pre class="mermaid">
pie title 测试
    "A" : 50
    "B" : 50
        </pre>
      </section>

      <section>
        <h3>3. TB 流程图</h3>
        <pre class="mermaid">
flowchart TB
    A[文化] --> B[技术]
    A --> C[服务]
    B & C --> D[视觉]
        </pre>
      </section>

      <section>
        <h3>4. 5节点 LR</h3>
        <pre class="mermaid">
flowchart LR
    A --> B --> C --> D --> E
        </pre>
      </section>

    </div>
  </div>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.6.0/reveal.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/mermaid/8.14.0/mermaid.min.js"></script>
  <script>
    mermaid.initialize({ 
      startOnLoad: false,
      theme: 'default'
    });
    
    // 渲染所有图表
    document.querySelectorAll('pre.mermaid').forEach(function(el) {
      mermaid.render('mermaid-' + Math.random().toString(36).substr(2, 9), el.textContent)
        .then(function(result) {
          var div = document.createElement('div');
          div.className = 'mermaid';
          div.innerHTML = result.svg;
          el.parentNode.replaceChild(div, el);
        })
        .catch(function(err) {
          el.innerHTML = '<div style="color:red">Error: ' + err.message + '</div>';
        });
    });
    
    Reveal.initialize({
      hash: true,
      transition: 'none'
    });
  </script>
</body>
</html>
"""

fs.writeFileSync "outputs/mermaid-final.html", htmlContent
console.log "✅ Created: outputs/mermaid-final.html"
