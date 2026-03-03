# 纯图片方式 - 绕过 Reveal.js CSS 问题

fs = require "fs"

htmlContent = """
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>纯图片测试</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.6.0/reveal.min.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.6.0/theme/white.min.css">
  <style>
    .reveal .slides section { text-align: center; }
    .reveal img { max-width: 100%; }
  </style>
</head>
<body>
  <div class="reveal">
    <div class="slides">
      
      <section>
        <h3>1. PDCA 循环</h3>
        <img src="https://mermaid.ink/img/pie%20title%20test%0A%20%20%20%20%22A%22%20%3A%2050%0A%20%20%20%20%22B%22%20%3A%2050" />
      </section>

      <section>
        <h3>2. 饼图</h3>
        <img src="https://mermaid.ink/img/pie%20title%20test%0A%20%20%20%20%22A%22%20%3A%2050%0A%20%20%20%20%22B%22%20%3A%2050" />
      </section>

    </div>
  </div>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.6.0/reveal.min.js"></script>
  <script>
    Reveal.initialize({ hash: true });
  </script>
</body>
</html>
"""

fs.writeFileSync "outputs/mermaid-img-test.html", htmlContent
console.log "✅ Created: outputs/mermaid-img-test.html"
