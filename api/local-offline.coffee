# BoxesPlus - 本地离线 HTML 生成
# 用法: coffee local-offline.coffee [slides_coffee_file] [html_output]

fs = require "fs"
path = require "path"

SLIDE_WIDTH = 1280
SLIDE_HEIGHT = 720

htmlFile = process.argv[2] || "outputs/reveal-complete.html"
outputDir = path.dirname(path.resolve(htmlFile))

# 复制本地 Reveal.js 到输出目录
copyRevealFiles = ->
  revealSrc = path.join(__dirname, "..", "node_modules", "reveal.js")
  revealDest = path.join(outputDir, "reveal.js")
  
  if fs.existsSync(path.join(revealDest, "dist", "reveal.js"))
    console.log "Reveal.js already copied"
    return revealDest
  
  console.log "Copying Reveal.js for offline use..."
  
  # 复制 dist 目录
  srcDist = path.join(revealSrc, "dist")
  destDist = path.join(revealDest, "dist")
  
  if fs.existsSync(srcDist)
    copyDirRecursive(srcDist, destDist)
  
  console.log "✅ Reveal.js copied to: #{revealDest}"
  revealDest

copyDirRecursive = (src, dest) ->
  fs.mkdirSync(dest, { recursive: true }) unless fs.existsSync(dest)
  
  entries = fs.readdirSync(src, { withFileTypes: true })
  
  for entry in entries
    srcPath = path.join(src, entry.name)
    destPath = path.join(dest, entry.name)
    
    if entry.isDirectory()
      copyDirRecursive(srcPath, destPath)
    else
      fs.copyFileSync(srcPath, destPath)

# 更新 HTML 使用本地文件
updateHtmlToLocal = (htmlPath) ->
  content = fs.readFileSync(htmlPath, "utf-8")
  
  # 替换 CDN 链接为本地文件
  content = content.replace(
    /https:\/\/cdn\.jsdelivr\.net\/npm\/reveal\.js@4\/dist\/reveal\.css/g,
    "reveal.js/dist/reveal.css"
  )
  content = content.replace(
    /https:\/\/cdn\.jsdelivr\.net\/npm\/reveal\.js@4\/dist\/theme\/white\.css/g,
    "reveal.js/dist/theme/white.css"
  )
  content = content.replace(
    /https:\/\/cdn\.jsdelivr\.net\/npm\/reveal\.js@4\/dist\/reveal\.js/g,
    "reveal.js/dist/reveal.js"
  )
  
  fs.writeFileSync(htmlPath, content)
  console.log "✅ Updated HTML to use local files: #{htmlPath}"

# 主程序
do ->
  if fs.existsSync(htmlFile)
    # 复制 Reveal.js 文件
    copyRevealFiles()
    
    # 更新 HTML 使用本地文件
    updateHtmlToLocal(htmlFile)
    
    console.log ""
    console.log "离线 HTML 已准备好: #{htmlFile}"
    console.log "可以直接双击打开，无需网络！"
  else
    console.error "HTML file not found: #{htmlFile}"
