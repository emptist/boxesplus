#!/usr/bin/env coffee

# Mermaid图表生成器 - 修复版（使用startOnLoad: true）
# 关键修复：使用startOnLoad: true让Mermaid自动渲染

fs = require "fs"
path = require "path"

# 导入图表类和创建函数
{ 流程图, 时序图, 类图, 状态图, 创建流程图, 创建时序图, 创建类图, 创建状态图 } = require "./mermaid-enhanced.coffee"

# ============================================
# 全局状态（诗式API）
# ============================================

当前演示 = null
图表编号 = 0

# ============================================
# 简化HTML生成器（修复版）
# ============================================

class 简化HTML生成器
  constructor: (@标题) ->
    @图表列表 = []
  
  添加图表: (图表) ->
    @图表列表.push 图表
    this
  
  生成: ->
    图表HTML = @图表列表.map (图表, 索引) =>
      mermaid代码 = 图表.生成Mermaid()
      ascii代码 = 图表.生成ASCII()
      
      """
      <section id="slide-#{索引}">
        <h2>#{图表.标题}</h2>
        <div class="mermaid-container">
          <div class="mermaid">
#{mermaid代码}
          </div>
        </div>
        <div class="ascii">
          <h3>ASCII框图</h3>
          <pre><code>#{ascii代码}</code></pre>
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
        section {
          margin: 3em 0;
          padding: 2em;
          border: 1px solid #e2e8f0;
          border-radius: 8px;
          background: #ffffff;
        }
        .mermaid-container {
          text-align: center;
          margin: 2em 0;
          padding: 2em;
          background: #f9f9f9;
          border-radius: 8px;
          min-height: 400px;
        }
        .mermaid {
          font-size: 1.2em;
          display: inline-block;
          width: 100%;
        }
        .mermaid svg {
          max-width: 100% !important;
          height: auto !important;
        }
        .ascii {
          background: #f5f5f5;
          padding: 1em;
          border-radius: 5px;
          margin: 2em 0;
        }
        .ascii h3 {
          margin: 0 0 1em 0;
          font-size: 1em;
          color: #2B579A;
        }
        .ascii pre {
          margin: 0;
          font-size: 0.8em;
          line-height: 1.4;
          overflow-x: auto;
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
        // 关键修复：使用startOnLoad: true让Mermaid自动渲染
        mermaid.initialize({
          startOnLoad: true,
          theme: 'default',
          securityLevel: 'loose'
        });
      </script>
    </body>
    </html>
    """
  
  保存: (文件名) ->
    html = @生成()
    fs.writeFileSync 文件名, html, "utf-8"
    console.log "✅ 简化HTML生成完成：#{文件名}"
    console.log "   共 #{@图表列表.length} 个图表"
    console.log "   使用startOnLoad: true自动渲染Mermaid"
    文件名

# ============================================
# RevealJS HTML生成器（修复版）
# ============================================

class HTML生成器
  constructor: (@标题, @配置 = {}) ->
    @图表列表 = []
    @配置.主题 ?= "white"
    @配置.过渡 ?= "slide"
    @配置.控制键 ?= true
    @配置.进度条 ?= true
  
  添加图表: (图表) ->
    @图表列表.push 图表
    this
  
  生成: ->
    幻灯片HTML = @图表列表.map (图表, 索引) =>
      mermaid代码 = 图表.生成Mermaid()
      ascii代码 = 图表.生成ASCII()
      
      """
      <section>
        <h2>#{图表.标题}</h2>
        <div class="mermaid-container">
          <div class="mermaid">
#{mermaid代码}
          </div>
        </div>
        <div class="ascii">
          <h3>ASCII框图</h3>
          <pre><code>#{ascii代码}</code></pre>
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
          color: #2B579A;
        }
        .mermaid-container {
          text-align: center;
          margin: 2em 0;
          padding: 2em;
          background: rgba(255,255,255,0.95);
          border-radius: 8px;
          min-height: 400px;
        }
        .mermaid {
          font-size: 1.2em;
          display: inline-block;
          width: 100%;
        }
        .mermaid svg {
          max-width: 100% !important;
          height: auto !important;
        }
        .ascii {
          background: #f5f5f5;
          padding: 1em;
          border-radius: 5px;
          margin-top: 2em;
        }
        .ascii h3 {
          margin: 0 0 1em 0;
          font-size: 1em;
          color: #2B579A;
        }
        .ascii pre {
          margin: 0;
          font-size: 0.6em;
          line-height: 1.2;
          overflow-x: auto;
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
        // 关键修复：使用startOnLoad: true让Mermaid自动渲染
        // 然后初始化RevealJS
        mermaid.initialize({
          startOnLoad: true,
          theme: 'default',
          securityLevel: 'loose'
        });
        
        Reveal.initialize({
          controls: #{@配置.控制键},
          progress: #{@配置.进度条},
          transition: '#{@配置.过渡}',
          hash: true,
          slideNumber: true,
          width: 1280,
          height: 720,
          margin: 0.04
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
    console.log "   使用RevealJS + startOnLoad: true自动渲染Mermaid"
    文件名

# ============================================
# 诗式API（极简）
# ============================================

开始绘图简化HTML = (标题) ->
  当前演示 = new 简化HTML生成器 标题
  图表编号 = 0
  console.log "🎨 开始绘图（简化HTML）：#{标题}"
  当前演示

开始绘图HTML = (标题, 配置 = {}) ->
  当前演示 = new HTML生成器 标题, 配置
  图表编号 = 0
  console.log "🎨 开始绘图（HTML）：#{标题}"
  当前演示

完成绘图 = (文件名) ->
  if 当前演示
    当前演示.保存 文件名
  else
    console.log "⚠️  没有活动的演示"

# ============================================
# 导出
# ============================================

module.exports = {
  开始绘图简化HTML
  开始绘图HTML
  完成绘图
  创建流程图
  创建时序图
  创建类图
  创建状态图
  流程图
  时序图
  类图
  状态图
  简化HTML生成器
  HTML生成器
}
