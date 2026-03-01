#!/usr/bin/env coffee

# 使用data目录的数据文件生成课程
# 展示数据与代码分离的最佳实践

fs = require "fs"
PptxGenJS = require "pptxgenjs"

# ============================================
# 从data目录加载数据
# ============================================

课程数据 = require "../../reviewer-workspace/data2/A01医院管理总览课程.coffee"

console.log "\n=== 使用data目录数据生成课程 ===\n"
console.log "课程代码：", 课程数据.元数据.代码
console.log "课程标题：", 课程数据.元数据.标题
console.log "幻灯片数：", 课程数据.幻灯片.length

# ============================================
# PPTX渲染器
# ============================================

class PPTX渲染器
  constructor: ->
    @pptx = new PptxGenJS()
    @pptx.layout = "LAYOUT_16x9"
  
  渲染: (幻灯片列表) ->
    幻灯片列表.forEach (幻灯片) => @渲染页面 幻灯片
  
  渲染页面: (幻灯片) ->
    switch 幻灯片.类型
      when "封面页" then @渲染封面 幻灯片
      when "列表页" then @渲染列表 幻灯片
      when "表格页" then @渲染表格 幻灯片
      when "卡片页" then @渲染卡片 幻灯片
      when "章节页" then @渲染章节 幻灯片
      when "引用页" then @渲染引用 幻灯片
      when "结束页" then @渲染结束 幻灯片
  
  渲染封面: (数据) ->
    slide = @pptx.addSlide()
    slide.addText 数据.标题,
      x: 0.5, y: 2.5, w: 9, h: 1
      fontSize: 44, bold: true, align: "center", color: "2B579A"
    if 数据.副标题
      slide.addText 数据.副标题,
        x: 0.5, y: 3.5, w: 9, h: 0.6
        fontSize: 20, align: "center", color: "666666"
  
  渲染列表: (数据) ->
    slide = @pptx.addSlide()
    slide.addText 数据.标题,
      x: 0.5, y: 0.3, w: 9, h: 0.6
      fontSize: 28, bold: true, color: "2B579A"
    
    项目列表 = 数据.项目.map (项目) -> text: 项目, options: {bullet: true}
    slide.addText 项目列表,
      x: 0.5, y: 1.2, w: 9, h: 4
      fontSize: 16, color: "333333"
  
  渲染表格: (数据) ->
    slide = @pptx.addSlide()
    
    slide.addText 数据.标题,
      x: 0.5, y: 0.3, w: 9, h: 0.6
      fontSize: 28, bold: true, color: "2B579A"
    
    表格数据 = [数据.表头, ...数据.行数据]
    
    slide.addTable 表格数据,
      x: 0.5, y: 1.2, w: 9, h: 4
      fontSize: 14
      border: { type: "solid", pt: 1, color: "E0E0E0" }
      fill: { color: "F5F5F5" }
      color: "333333"
  
  渲染卡片: (数据) ->
    slide = @pptx.addSlide()
    
    slide.addText 数据.标题,
      x: 0.5, y: 0.3, w: 9, h: 0.6
      fontSize: 28, bold: true, color: "2B579A"
    
    列数 = 数据.列数 ? 2
    卡片宽度 = 8.5 / 列数
    
    数据.卡片.forEach (卡片, 索引) =>
      x = 0.75 + (索引 % 列数) * 卡片宽度
      y = 1.2 + Math.floor(索引 / 列数) * 2
      
      slide.addShape "rect",
        x: x, y: y, w: 卡片宽度 - 0.2, h: 1.8
        fill: { color: "F0F0F0" }
      
      slide.addText 卡片.标题,
        x: x + 0.1, y: y + 0.1, w: 卡片宽度 - 0.4, h: 0.4
        fontSize: 16, bold: true, color: "2B579A"
      
      slide.addText 卡片.内容,
        x: x + 0.1, y: y + 0.5, w: 卡片宽度 - 0.4, h: 1.2
        fontSize: 12, color: "333333"
  
  渲染章节: (数据) ->
    slide = @pptx.addSlide()
    
    slide.addText 数据.编号,
      x: 0.5, y: 1.5, w: 9, h: 0.6
      fontSize: 20, align: "center", color: "999999"
    
    slide.addText 数据.标题,
      x: 0.5, y: 2.2, w: 9, h: 1
      fontSize: 36, bold: true, align: "center", color: "2B579A"
    
    if 数据.副标题
      slide.addText 数据.副标题,
        x: 0.5, y: 3.3, w: 9, h: 0.6
        fontSize: 18, align: "center", color: "666666"
  
  渲染引用: (数据) ->
    slide = @pptx.addSlide()
    
    slide.addText "\"#{数据.引用}\"",
      x: 1, y: 2, w: 8, h: 1.5
      fontSize: 24, align: "center", color: "2B579A", italic: true
    
    if 数据.作者
      slide.addText "—— #{数据.作者}",
        x: 1, y: 3.5, w: 8, h: 0.5
        fontSize: 16, align: "center", color: "666666"
  
  渲染结束: (数据) ->
    slide = @pptx.addSlide()
    
    slide.addText 数据.标题,
      x: 0.5, y: 2.5, w: 9, h: 1
      fontSize: 44, bold: true, align: "center", color: "2B579A"
    
    if 数据.副标题
      slide.addText 数据.副标题,
        x: 0.5, y: 3.5, w: 9, h: 0.6
        fontSize: 20, align: "center", color: "666666"
  
  保存: (文件名) ->
    @pptx.writeFile({ fileName: 文件名 })
      .then -> console.log "✅ PPTX生成完成：#{文件名}"

# ============================================
# RevealJS渲染器
# ============================================

class RevealJS渲染器
  constructor: (@选项 = {}) ->
    @幻灯片列表 = []
  
  渲染: (幻灯片列表) ->
    幻灯片列表.forEach (幻灯片) => @渲染页面 幻灯片
  
  渲染页面: (幻灯片) ->
    switch 幻灯片.类型
      when "封面页" then @渲染封面 幻灯片
      when "列表页" then @渲染列表 幻灯片
      when "表格页" then @渲染表格 幻灯片
      when "卡片页" then @渲染卡片 幻灯片
      when "章节页" then @渲染章节 幻灯片
      when "引用页" then @渲染引用 幻灯片
      when "结束页" then @渲染结束 幻灯片
  
  渲染封面: (数据) ->
    @幻灯片列表.push """
      <section class="fit">
        <h1>#{数据.标题}</h1>
        #{if 数据.副标题 then "<h3>#{数据.副标题}</h3>" else ""}
      </section>
    """
  
  渲染列表: (数据) ->
    项目列表 = 数据.项目.map((项目) -> "<li>#{项目}</li>").join "\n"
    @幻灯片列表.push """
      <section>
        <h2>#{数据.标题}</h2>
        <ul>#{项目列表}</ul>
      </section>
    """
  
  渲染表格: (数据) ->
    表头HTML = 数据.表头.map((项) -> "<th>#{项}</th>").join ""
    数据HTML = 数据.行数据.map((行) ->
      行单元格 = 行.map((单元格) -> "<td>#{单元格}</td>").join ""
      "<tr>#{行单元格}</tr>"
    ).join ""
    
    @幻灯片列表.push """
      <section>
        <h2>#{数据.标题}</h2>
        <table>
          <thead><tr>#{表头HTML}</tr></thead>
          <tbody>#{数据HTML}</tbody>
        </table>
      </section>
    """
  
  渲染卡片: (数据) ->
    卡片HTML = 数据.卡片.map((卡片) ->
      """
      <div class="card">
        <h3>#{卡片.标题}</h3>
        <p>#{卡片.内容.replace /\n/g, "<br>"}</p>
      </div>
      """
    ).join "\n"
    
    @幻灯片列表.push """
      <section>
        <h2>#{数据.标题}</h2>
        <div class="cards">#{卡片HTML}</div>
      </section>
    """
  
  渲染章节: (数据) ->
    @幻灯片列表.push """
      <section>
        <h2>#{数据.编号}</h2>
        <h1>#{数据.标题}</h1>
        #{if 数据.副标题 then "<h3>#{数据.副标题}</h3>" else ""}
      </section>
    """
  
  渲染引用: (数据) ->
    @幻灯片列表.push """
      <section>
        <blockquote>
          <p>"#{数据.引用}"</p>
          #{if 数据.作者 then "<footer>—— #{数据.作者}</footer>" else ""}
        </blockquote>
      </section>
    """
  
  渲染结束: (数据) ->
    @幻灯片列表.push """
      <section class="fit">
        <h1>#{数据.标题}</h1>
        #{if 数据.副标题 then "<h3>#{数据.副标题}</h3>" else ""}
      </section>
    """
  
  生成: ->
    """
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>#{@选项.标题 ? 课程数据.元数据.标题}</title>
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.5.0/reveal.min.css">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.5.0/theme/black.min.css">
      <style>
        .fit h1 { text-align: center; }
        .cards {
          display: flex;
          flex-wrap: wrap;
          justify-content: space-around;
          margin-top: 1em;
        }
        .card {
          width: 45%;
          margin: 0.5em;
          padding: 1em;
          background: rgba(255,255,255,0.1);
          border-radius: 5px;
        }
        table {
          width: 100%;
          border-collapse: collapse;
          margin-top: 1em;
        }
        th, td {
          border: 1px solid #666;
          padding: 0.5em;
          text-align: left;
        }
        th {
          background: rgba(255,255,255,0.1);
        }
        blockquote {
          font-style: italic;
          font-size: 1.2em;
        }
      </style>
    </head>
    <body>
      <div class="reveal">
        <div class="slides">
          #{@幻灯片列表.join "\n"}
        </div>
      </div>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.5.0/reveal.min.js"></script>
      <script>
        Reveal.initialize({
          controls: true,
          progress: true,
          transition: 'slide'
        });
      </script>
    </body>
    </html>
    """
  
  保存: (文件名) ->
    html = @生成()
    fs.writeFileSync 文件名, html, "utf-8"
    console.log "✅ RevealJS生成完成：#{文件名}"

# ============================================
# 执行生成
# ============================================

# 生成PPTX
pptx渲染器 = new PPTX渲染器()
pptx渲染器.渲染 课程数据.幻灯片
pptx渲染器.保存 "../../output/A01医院管理总览-数据驱动版.pptx"

# 生成RevealJS
reveal渲染器 = new RevealJS渲染器 标题: 课程数据.元数据.标题
reveal渲染器.渲染 课程数据.幻灯片
reveal渲染器.保存 "../../output/A01医院管理总览-数据驱动版.html"

console.log "\n✅ 数据驱动课程生成完成！"
console.log "   - PPTX: output/A01医院管理总览-数据驱动版.pptx"
console.log "   - RevealJS: output/A01医院管理总览-数据驱动版.html"
console.log "\n=== 数据与代码分离的优势 ==="
console.log "1. 数据独立维护，无需修改代码"
console.log "2. 多人协作：数据人员专注内容，开发人员专注功能"
console.log "3. 版本控制：数据变更历史清晰"
console.log "4. 复用性强：同一数据可生成多种格式"
console.log "5. 易于测试：数据验证与代码测试分离"
