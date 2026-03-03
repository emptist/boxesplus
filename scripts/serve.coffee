# BoxesPlus - 本地服务器启动器
# 用法: coffee scripts/serve.coffee [html_file] [port]
# 示例: coffee scripts/serve.coffee outputs/hybrid-demo-v2.html 8080

fs = require "fs"
path = require "path"
http = require "http"
{ exec } = require "child_process"

rootDir = path.join(__dirname, "..")
htmlFile = process.argv[2] || path.join(rootDir, "outputs/hybrid-demo-v2.html")
port = parseInt(process.argv[3]) || 8080

unless fs.existsSync(htmlFile)
  console.error "HTML file not found: #{htmlFile}"
  process.exit 1

dir = path.dirname(path.resolve(htmlFile))
fileName = path.basename(htmlFile)

console.log "Serving: #{htmlFile}"
console.log "URL: http://localhost:#{port}/#{fileName}"

# 创建服务器
server = http.createServer (req, res) ->
  url = req.url.replace("/", "")
  
  if url == "" or url == fileName
    content = fs.readFileSync(htmlFile)
    res.writeHead(200, { "Content-Type": "text/html" })
    res.end(content)
  else
    # 尝试当前目录
    localPath = path.join(dir, url)
    if fs.existsSync(localPath)
      content = fs.readFileSync(localPath)
      ext = path.extname(localPath)
      contentType = switch ext
        when ".html" then "text/html"
        when ".js" then "application/javascript"
        when ".css" then "text/css"
        when ".png" then "image/png"
        when ".jpg", ".jpeg" then "image/jpeg"
        else "text/plain"
      res.writeHead(200, { "Content-Type": contentType })
      res.end(content)
    else
      res.writeHead(404)
      res.end("Not found: #{url}")

server.listen port, ->
  console.log ""
  console.log "✅ Server running!"
  console.log ""
  console.log "打开浏览器访问: http://localhost:#{port}/#{fileName}"
  console.log ""
  console.log "按 Ctrl+C 停止服务器"
  
  # 自动打开浏览器
  exec "open http://localhost:#{port}/#{fileName}"

process.on "SIGINT", ->
  console.log "\n\nStopping server..."
  server.close()
  process.exit(0)
