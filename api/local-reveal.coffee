# BoxesPlus - 本地离线 HTML 生成 (使用本地 Reveal.js v3)
# 用法: coffee local-reveal.coffee <html_output> [title]

fs = require "fs"
path = require "path"

# Reveal.js v3 本地文件路径
REVEAL_V3_CSS = "node_modules/reveal.js@3.9.2/css/reveal.css"
REVEAL_V3_THEME = "node_modules/reveal.js@3.9.2/css/theme/white.css"
REVEAL_V3_JS = "node_modules/reveal.js@3.9.2/js/reveal.js"

# 检查本地文件是否存在
checkLocalFiles = ->
  files = [REVEAL_V3_CSS, REVEAL_V3_THEME, REVEAL_V3_JS]
  missing = []
  for f in files
    unless fs.existsSync(f)
      missing.push(f)
  missing

# 生成带本地 Reveal.js 的 HTML
generateLocalHtml = (slidesData, htmlPath, opts = {}) ->
  { title } = opts
  
  slidesHtml = ""
  for slide in slidesData
    slidesHtml += slide.html
  
  html = """
  <!doctype html>
  <html>
  <head>
    <meta charset="utf-8">
    <title>#{title || 'Presentation'}</title>
    <link rel="stylesheet" href="reveal.js@3.9.2/css/reveal.css">
    <link rel="stylesheet" href="reveal.js@3.9.2/css/theme/white.css">
    <style>
      .reveal .slides section { text-align: left; }
      .reveal { font-family: 'PingFang SC', 'Microsoft YaHei', sans-serif; }
    </style>
  </head>
  <body>
    <div class="reveal">
      <div class="slides">
        #{slidesHtml}
      </div>
    </div>
    <script src="reveal.js@3.9.2/js/reveal.js"></script>
    <script>
      Reveal.initialize({
        hash: true,
        slideNumber: true,
        transition: 'slide',
        center: true,
        keyboard: true,
        width: 1280,
        height: 720,
        margin04
      });
: 0.    </script>
  </body>
  </html>
  """
  
  fs.writeFileSync(htmlPath, html)
  console.log "✅ Local HTML: #{htmlPath}"
  htmlPath

# 复制 Reveal.js v3 文件到输出目录
copyRevealV3 = (outputDir) ->
  v3Dir = path.join(outputDir, "reveal.js@3.9.2")
  
  if fs.existsSync(v3Dir)
    console.log "Reveal.js v3 already exists"
    return v3Dir
  
  console.log "Copying Reveal.js v3..."
  
  # 需要先下载
  console.log "请运行: npm install reveal.js@3.9.2"
  null

module.exports = { generateLocalHtml, copyRevealV3, checkLocalFiles }

if require.main is module
  htmlPath = process.argv[2] || "outputs/local-presentation.html"
  title = process.argv[3] || "本地演示"
  
  # 示例幻灯片数据
  slidesData = [
    {
      title: "欢迎"
      html: '<section style="text-align: center;"><h1>欢迎</h1><p>BoxesPlus 本地离线版</p></section>'
    }
    {
      title: "特点"
      html: '<section><h2>本地离线</h2><ul><li>无需网络</li><li>随时可用</li></ul></section>'
    }
    {
      title: "谢谢"
      html: '<section style="text-align: center; background: #1a365d;"><h1 style="color:white;">谢谢!</h1></section>'
    }
  ]
  
  # 检查文件
  missing = checkLocalFiles()
  if missing.length > 0
    console.log "Missing files:"
    for f in missing
      console.log "  - #{f}"
    console.log ""
    console.log "请先安装: npm install reveal.js@3.9.2"
  else
    generateLocalHtml(slidesData, htmlPath, { title })
    console.log "Done!"
