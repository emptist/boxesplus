# BoxesPlus API - 简单 DSL 解析器
# 用法: coffee boxesplus-api.coffee input.md [output.pptx]

PptxGenJS = require "pptxgenjs"
fs = require "fs"
path = require "path"

# 幻灯片对象
class Slide
  constructor: (@pres, @type = "content", @title = "") ->
    @slide = @pres.addSlide()
    @content = []
    @options = {}

  setTitle: (title) ->
    @title = title
    @slide.addText title,
      x: 0.5, y: 0.3, w: 9, h: 0.6
      fontSize: 28, color: "1a365d", bold: true

  addList: (items) ->
    y = 1.2
    for item in items
      @slide.addText "• #{item}",
        x: 0.8, y: y, w: 8, h: 0.4
        fontSize: 18, color: "2d3748"
      y += 0.5

  addBox: (title, content) ->
    # 标题栏
    @slide.addShape @pres.ShapeType.rect,
      x: 0.5, y: 1, w: 9, h: 0.7
      fill: { color: "2c5282" }
    
    @slide.addText title,
      x: 0.7, y: 1.1, w: 8.6, h: 0.5
      fontSize: 18, color: "ffffff", bold: true
    
    # 内容框
    @slide.addShape @pres.ShapeType.rect,
      x: 0.5, y: 1.9, w: 9, h: 3.5
      fill: { color: "f7fafc" }
      line: { color: "2c5282", width: 2 }
    
    # 内容
    y = 2.2
    for line in content
      @slide.addText line,
        x: 0.8, y: y, w: 8.4, h: 0.4
        fontSize: 14, color: "2d3748"
      y += 0.45
      break if y > 5

  addFlow: (steps) ->
    # 简单的流程图 - 每步一个框
    y = 1.2
    for step in steps
      @slide.addShape @pres.ShapeType.roundRect,
        x: 1.5, y: y, w: 6, h: 0.6
        fill: { color: "4299e1" }
      
      @slide.addText step,
        x: 1.5, y: y + 0.1, w: 6, h: 0.4
        fontSize: 14, color: "ffffff", align: "center"
      
      y += 0.8

  addTable: (rows) ->
    return unless rows.length > 0
    
    x = 0.5
    y = 1.2
    colW = 8 / rows[0].length
    
    # 表头
    @slide.addShape @pres.ShapeType.rect,
      x: x, y: y, w: 8, h: 0.5
      fill: { color: "2c5282" }
    
    for cell, i in rows[0]
      @slide.addText cell,
        x: x + 0.1, y: y + 0.1, w: colW - 0.2, h: 0.3
        fontSize: 12, color: "ffffff", bold: true
      x += colW
    
    # 数据行
    y += 0.5
    for row, ri in rows.slice(1)
      x = 0.5
      bg = if ri % 2 is 0 then "f7fafc" else "ffffff"
      for cell in row
        @slide.addText cell,
          x: x + 0.1, y: y + 0.1, w: colW - 0.2, h: 0.3
          fontSize: 11, color: "2d3748"
        x += colW
      y += 0.4

# 主解析器
class Parser
  constructor: (@content) ->
    @slides = []
    @lines = @content.split('\n')
    @i = 0

  parse: ->
    pres = new PptxGenJS()
    
    while @i < @lines.length
      line = @lines[@i].trim()
      
      if line.startsWith '# '
        # 标题幻灯片
        title = line[2..]
        slide = new Slide(pres, "title", title)
        slide.setTitle title
        @slides.push slide
        @i++
      
      else if line.startsWith '## '
        # 内容幻灯片
        title = line[3..]
        slide = new Slide(pres, "content", title)
        slide.setTitle title
        @parseContent(slide)
        @slides.push slide
      
      else
        @i++
    
    pres

  parseContent: (slide) ->
    items = []
    boxMode = false
    boxTitle = ""
    boxContent = []
    flowMode = false
    flowSteps = []
    tableMode = false
    tableRows = []
    currentRow = []
    
    while @i < @lines.length
      @i++
      break if @i >= @lines.length
      
      line = @lines[@i].trim()
      
      # 结束标记
      if line == "}}" or line.startsWith '## '
        @i--
        break
      
      # 列表
      if line.startsWith '- '
        items.push line[2..]
        continue
      
      # 方框
      if line == '{{box}}'
        boxMode = true
        continue
      if line == '{{/box}}'
        slide.addBox boxTitle, boxContent
        boxMode = false
        boxTitle = ""
        boxContent = []
        continue
      if boxMode
        if line.includes ':'
          [k, v] = line.split ':'
          if not boxTitle then boxTitle = v.trim()
          else boxContent.push "#{k}: #{v.trim()}"
        continue
      
      # 流程
      if line == '{{flow}}'
        flowMode = true
        continue
      if line == '{{/flow}}'
        slide.addFlow flowSteps
        flowMode = false
        flowSteps = []
        continue
      if flowMode
        if line.includes '->'
          steps = line.split '->'
          for s in steps
            flowSteps.push s.trim()
        else if line.trim()
          flowSteps.push line.trim()
        continue
      
      # 表格
      if line.startsWith '|'
        cells = line.split('|')[1...-1].map (c) -> c.trim()
        tableRows.push cells
        continue
      else if tableMode and tableRows.length > 0
        slide.addTable tableRows
        tableRows = []
        tableMode = false
      
      # 空行结束
      if line == ''
        if items.length > 0
          slide.addList items
          items = []
        if tableRows.length > 0
          slide.addTable tableRows
          tableRows = []
    
    # 最后处理
    if items.length > 0
      slide.addList items
    if tableRows.length > 0
      slide.addTable tableRows

# 主程序
main = ->
  inputFile = process.argv[2] || "example.md"
  outputFile = process.argv[3] || inputFile.replace('.md', '.pptx')
  
  unless fs.existsSync inputFile
    console.log "用法: coffee boxesplus-api.coffee input.md [output.pptx]"
    console.log "  input.md  - 输入的markdown文件"
    console.log "  output.pptx - 输出的PPTX文件(可选)"
    process.exit 1
  
  content = fs.readFileSync(inputFile, "utf-8")
  parser = new Parser(content)
  pres = parser.parse()
  
  pres.writeFile({ fileName: outputFile })
    .then -> console.log "已创建: #{outputFile}"
    .catch (err) -> console.error err

main()
