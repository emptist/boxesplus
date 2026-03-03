# BoxesPlus CLI
# 交互式和监听模式

fs = require "fs"
path = require "path"
readline = require "readline"

{ CourseGenerator, generate, CHARTS } = require "../api/hybrid-generator.coffee"
{ Tool, Slide, Section, Presentation, CHARTS: OO_CHARTS } = require "../api/oo-api.coffee"

# ============================================
# CLI 工具函数
# ============================================

log = (msg) -> console.log "📦 BoxesPlus: #{msg}"
warn = (msg) -> console.log "⚠️  #{msg}"
success = (msg) -> console.log "✅ #{msg}"

# ============================================
# 文件监听模式
# ============================================

watch = (targetPath) ->
  if not fs.existsSync(targetPath)
    warn "路径不存在: #{targetPath}"
    return

  stat = fs.statSync(targetPath)
  
  if stat.isFile()
    watchFile(targetPath)
  else
    watchDir(targetPath)

watchFile = (filePath) ->
  log "监听文件: #{filePath}"
  log "修改文件将自动重新生成..."
  
  generateFromFile(filePath)
  
  fs.watch filePath, (eventType) ->
    if eventType is "change"
      log "检测到变化，重新生成..."
      generateFromFile(filePath)

watchDir = (dirPath) ->
  log "监听目录: #{dirPath}"
  log "修改 .coffee 文件将自动重新生成..."
  
  # 找到第一个 demo*.coffee 文件
  files = fs.readdirSync(dirPath).filter (f) -> f.match(/^demo.*\.coffee$/)
  
  if files.length > 0
    generateFromFile(path.join(dirPath, files[0]))
  
  fs.watch dirPath, (eventType, filename) ->
    if filename and filename.match(/\.coffee$/)
      log "检测到变化: #{filename}"
      generateFromFile(path.join(dirPath, filename))

generateFromFile = (filePath) ->
  try
    ext = path.extname(filePath)
    baseName = path.basename(filePath, ext)
    outputDir = path.dirname(filePath)
    
    if ext is ".coffee"
      # 使用 require 动态加载 CoffeeScript
      delete require.cache[require.resolve(filePath)]
      demo = require(filePath)
      
      if demo and demo.generate
        await demo.generate(baseName)
        success "生成完成: #{baseName}"
      else
        warn "文件未导出 generate 函数"
    else
      warn "不支持的文件类型: #{ext}"
  catch e
    warn "生成失败: #{e.message}"

# ============================================
# 交互式模式
# ============================================

createInterface = ->
  readline.createInterface({
    input: process.stdin
    output: process.stdout
  })

question = (rl, prompt) ->
  new Promise (resolve) ->
    rl.question(prompt, resolve)

runInteractive = ->
  log "欢迎使用 BoxesPlus 交互式创建向导!"
  console.log ""
  
  rl = createInterface()
  
  try
    # 1. 输入演示文稿标题
    title = await question(rl, "📝 请输入演示文稿标题: ")
    console.log ""
    
    # 2. 选择创建方式
    console.log "📋 请选择创建方式:"
    console.log "   1. 使用预定义模板快速创建"
    console.log "   2. 手动添加幻灯片"
    console.log ""
    
    mode = await question(rl, "请输入选项 (1/2): ")
    console.log ""
    
    if mode is "1"
      await createFromTemplate(rl, title)
    else
      await createManual(rl, title)
    
    rl.close()
    success "交互式创建完成!"
    
  catch e
    rl.close()
    warn "创建中断: #{e.message}"

createFromTemplate = (rl, title) ->
  console.log "📚 可用模板:"
  templates = [
    { name: "医疗质量与安全管理", charts: ["pdca", "pareto", "qualitySystem", "eventLoop"] }
    { name: "数据资产管理", charts: ["dataLifecycle"] }
    { name: "品牌建设", charts: ["brandPyramid"] }
    { name: "SWOT 分析", charts: ["swot"] }
    { name: "自定义", charts: [] }
  ]
  
  for t, i in templates
    console.log "   #{i+1}. #{t.name}"
  
  console.log ""
  choice = await question(rl, "请选择模板 (1-#{templates.length}): ")
  
  template = templates[parseInt(choice) - 1]
  
  课程 = new CourseGenerator(title)
  课程.addTitle(title, "交互式创建")
  
  if template and template.charts.length > 0
    for chartName in template.charts
      if CHARTS[chartName]
        课程.addMermaid(chartName, CHARTS[chartName])
  
  console.log ""
  outputName = await question(rl, "请输入输出文件名 (默认: interactive-demo): ")
  outputName = outputName || "interactive-demo"
  
  console.log ""
  log "正在生成..."
  await generate(课程, outputName)

createManual = (rl, title) ->
  课程 = new CourseGenerator(title)
  课程.addTitle(title, "交互式创建")
  
  console.log "📝 添加幻灯片类型:"
  console.log "   1. Mermaid 图表"
  console.log "   2. 列表"
  console.log "   3. 退出并生成"
  console.log ""
  
  loop
    choice = await question(rl, "请选择添加类型 (1-3): ")
    
    if choice is "3"
      break
    
    if choice is "1"
      console.log ""
      console.log "📊 可用图表:"
      for chartName of CHARTS
        console.log "   - #{chartName}"
      console.log ""
      
      chartKey = await question(rl, "请输入图表名称: ")
      slideTitle = await question(rl, "请输入幻灯片标题: ")
      
      if CHARTS[chartKey]
        课程.addMermaid(slideTitle, CHARTS[chartKey])
        success "添加图表: #{chartKey}"
      else
        warn "图表不存在: #{chartKey}"
    
    if choice is "2"
      slideTitle = await question(rl, "请输入列表标题: ")
      itemsStr = await question(rl, "请输入列表项 (逗号分隔): ")
      items = itemsStr.split(",").map (s) -> s.trim()
      课程.addList(slideTitle, items)
      success "添加列表: #{slideTitle}"
    
    console.log ""
  
  outputName = await question(rl, "请输入输出文件名 (默认: interactive-demo): ")
  outputName = outputName || "interactive-demo"
  
  console.log ""
  log "正在生成..."
  await generate(课程, outputName)

# ============================================
# 帮助信息
# ============================================

showHelp = ->
  console.log """
    BoxesPlus - 混合演示文稿生成器
    
    用法:
      boxesplus watch <path>      监听文件/目录变化
      boxesplus interactive       交互式创建演示文稿
      boxesplus generate <file>   一次性生成
      boxesplus help              显示帮助
    
    示例:
      boxesplus watch Demo/
      boxesplus interactive
      boxesplus generate Demo/demo-hybrid-v2.coffee
  """

# ============================================
# 主入口
# ============================================

main = ->
  args = process.argv.slice(2)
  command = args[0]
  
  switch command
    when "watch"
      target = args[1] || "Demo/"
      watch(target)
    when "interactive"
      await runInteractive()
    when "generate"
      if args[1]
        generateFromFile(args[1])
      else
        warn "请指定要生成的文件"
    when "help", "-h", "--help"
      showHelp()
    else
      if command
        warn "未知命令: #{command}"
      showHelp()

module.exports = { watch, runInteractive, generateFromFile, main }
