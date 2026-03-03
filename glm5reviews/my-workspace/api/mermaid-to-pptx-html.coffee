#!/usr/bin/env coffee

# Mermaid图表到PPTX/HTML生成器
# 支持将图表导出为PPTX、HTML、PDF格式

fs = require "fs"
PptxGenJS = require "pptxgenjs"

# ============================================
# PPTX生成器
# ============================================

class PPTX生成器
  constructor: (@标题) ->
    @pptx = new PptxGenJS()
    @pptx.layout = "LAYOUT_16x9"
    @pptx.title = @标题
    @图表列表 = []
  
  添加图表: (图表) ->
    @图表列表.push 图表
    this
  
  生成: ->
    for 图表, 索引 in @图表列表
      slide = @pptx.addSlide()
      
      slide.addText 图表.标题,
        x: 0.5, y: 0.3, w: 9, h: 0.6
        fontSize: 28, bold: true, color: "2B579A"
      
      mermaid代码 = 图表.生成Mermaid()
      ascii代码 = 图表.生成ASCII()
      
      slide.addText "Mermaid代码：",
        x: 0.5, y: 1.2, w: 9, h: 0.4
        fontSize: 14, bold: true, color: "666666"
      
      slide.addText mermaid代码,
        x: 0.5, y: 1.7, w: 9, h: 2.5
        fontSize: 10, color: "333333", align: "left"
      
      slide.addText "ASCII框图：",
        x: 0.5, y: 4.5, w: 9, h: 0.4
        fontSize: 14, bold: true, color: "666666"
      
      slide.addText ascii代码,
        x: 0.5, y: 5.0, w: 9, h: 2.5
        fontSize: 8, color: "333333", align: "left"
  
  保存: (文件名) ->
    @生成()
    @pptx.writeFile({ fileName: 文件名 })
      .then =>
        console.log "✅ PPTX生成完成：#{文件名}"
        console.log "   共 #{@图表列表.length} 个图表"

# ============================================
# HTML/RevealJS生成器
# ============================================

class HTML生成器
  constructor: (@标题) ->
    @图表列表 = []
    @配置 =
      主题: "black"
      过渡: "slide"
      控制键: true
      进度条: true
  
  添加图表: (图表) ->
    @图表列表.push 图表
    this
  
  生成: ->
    幻灯片HTML = @图表列表.map (图表) =>
      """
      <section>
        <h2>#{图表.标题}</h2>
        <div class="mermaid">
          #{图表.生成Mermaid()}
        </div>
        <div class="ascii">
          <pre><code>#{图表.生成ASCII()}</code></pre>
        </div>
      </section>
      """
    .join "\n"
    
    """
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>#{@标题}</title>
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.5.0/reveal.min.css">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.5.0/theme/#{@配置.主题}.min.css">
      <script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>
      <style>
        .reveal h2 {
          text-align: center;
          margin-bottom: 1em;
        }
        .mermaid {
          text-align: center;
          margin: 2em 0;
          font-size: 0.8em;
        }
        .ascii {
          background: rgba(255,255,255,0.1);
          padding: 1em;
          border-radius: 5px;
          margin-top: 2em;
        }
        .ascii pre {
          margin: 0;
          font-size: 0.5em;
          line-height: 1.2;
        }
        .ascii code {
          font-family: 'Courier New', monospace;
        }
      </style>
    </head>
    <body>
      <div class="reveal">
        <div class="slides">
          <section>
            <h1>#{@标题}</h1>
          </section>
          #{幻灯片HTML}
        </div>
      </div>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.5.0/reveal.min.js"></script>
      <script>
        Reveal.initialize({
          controls: #{@配置.控制键},
          progress: #{@配置.进度条},
          transition: '#{@配置.过渡}'
        });
        mermaid.initialize({
          startOnLoad: true,
          theme: 'default'
        });
      </script>
    </body>
    </html>
    """
  
  保存: (文件名) ->
    html = @生成()
    fs.writeFileSync 文件名, html, "utf-8"
    console.log "✅ HTML生成完成：#{文件名}"
    console.log "   共 #{@图表列表.length} 个图表"

# ============================================
# 简化HTML生成器（无RevealJS）
# ============================================

class 简化HTML生成器
  constructor: (@标题) ->
    @图表列表 = []
  
  添加图表: (图表) ->
    @图表列表.push 图表
    this
  
  生成: ->
    图表HTML = @图表列表.map (图表) =>
      """
      <section>
        <h2>#{图表.标题}</h2>
        <div class="mermaid">
          #{图表.生成Mermaid()}
        </div>
        <div class="ascii">
          <pre><code>#{图表.生成ASCII()}</code></pre>
        </div>
      </section>
      """
    .join "\n"
    
    """
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>#{@标题}</title>
      <script src="https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.min.js"></script>
      <style>
        body {
          font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
          max-width: 1200px;
          margin: 0 auto;
          padding: 2em;
        }
        h1 {
          text-align: center;
          color: #2B579A;
        }
        h2 {
          color: #2B579A;
          border-bottom: 2px solid #2B579A;
          padding-bottom: 0.5em;
        }
        .mermaid {
          text-align: center;
          margin: 2em 0;
        }
        .ascii {
          background: #f5f5f5;
          padding: 1em;
          border-radius: 5px;
          margin: 2em 0;
        }
        .ascii pre {
          margin: 0;
          font-size: 0.8em;
          line-height: 1.4;
        }
        .ascii code {
          font-family: 'Courier New', monospace;
        }
      </style>
    </head>
    <body>
      <h1>#{@标题}</h1>
      #{图表HTML}
      <script>
        mermaid.initialize({
          startOnLoad: true,
          theme: 'default'
        });
      </script>
    </body>
    </html>
    """
  
  保存: (文件名) ->
    html = @生成()
    fs.writeFileSync 文件名, html, "utf-8"
    console.log "✅ HTML生成完成：#{文件名}"
    console.log "   共 #{@图表列表.length} 个图表"

# ============================================
# 导出
# ============================================

module.exports = {
  PPTX生成器
  HTML生成器
  简化HTML生成器
}
