#!/usr/bin/env coffee

# Mermaid图表到PPTX/HTML生成器（修复版）
# 修复了PPTX、HTML和简化HTML的问题

fs = require "fs"
PptxGenJS = require "pptxgenjs"
{ exec } = require "child_process"
{ promisify } = require "util"

const execAsync = promisify(exec)

# 导入图表类和创建函数
{ 流程图, 时序图, 类图, 状态图, 创建流程图, 创建时序图, 创建类图, 创建状态图 } = require "./mermaid-enhanced.coffee"

# ============================================
# 全局状态（诗式API）
# ============================================

当前演示 = null
图表编号 = 0

# ============================================
# PPTX生成器（改进版）
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
      
      slide.addText "Mermaid代码：",
        x: 0.5, y: 1.2, w: 9, h: 0.4
        fontSize: 14, bold: true, color: "666666"
      
      slide.addText mermaid代码,
        x: 0.5, y: 1.7, w: 9, h: 2.5
        fontSize: 10, color: "333333", align: "left"
      
      ascii代码 = 图表.生成ASCII()
      
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
        console.log "⚠️  PPTX生成完成：#{文件名}"
        console.log "   共 #{@图表列表.length} 个图表"
        console.log "   注意：PptxGenJS不支持直接渲染Mermaid图表，仅显示代码和ASCII框图"
        console.log "   如需渲染图表，请使用HTML版本"

# ============================================
# HTML/RevealJS生成器（修复版）
# ============================================

class HTML生成器
  constructor: (@标题) ->
    @图表列表 = []
    @配置 =
      主题: "white"
      过渡: "slide"
      控制键: true
      进度条: true
  
  添加图表: (图表) ->
    @图表列表.push 图表
    this
  
  生成: ->
    幻灯片HTML = @图表列表.map (图表) =>
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
          padding: 1em;
          background: rgba(255,255,255,0.9);
          border-radius: 8px;
        }
        .mermaid {
          font-size: 0.8em;
          display: inline-block;
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
        // 先初始化Mermaid
        mermaid.initialize({
          startOnLoad: false,
          theme: 'default',
          securityLevel: 'loose'
        });
        
        // 再初始化RevealJS
        Reveal.initialize({
          controls: #{@配置.控制键},
          progress: #{@配置.进度条},
          transition: '#{@配置.过渡}',
          hash: true,
          slideNumber: true
        });
        
        // 在RevealJS加载完成后渲染Mermaid图表
        Reveal.on('ready', function() {
          mermaid.init();
        });
        
        // 在幻灯片切换时重新渲染Mermaid
        Reveal.on('slidechanged', function(event) {
          setTimeout(function() {
            mermaid.init(undefined, event.currentSlide.querySelectorAll('.mermaid'));
          }, 100);
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
    console.log "   使用RevealJS，支持导航和交互"

# ============================================
# 简化HTML生成器（带导航）
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
        .mermaid-container {
          text-align: center;
          margin: 2em 0;
          padding: 1em;
          background: #f9f9f9;
          border-radius: 8px;
        }
        .mermaid {
          font-size: 0.8em;
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
        
        /* 导航按钮 */
        .nav {
          position: fixed;
          bottom: 20px;
          right: 20px;
          display: flex;
          gap: 10px;
          z-index: 1000;
        }
        .nav button {
          padding: 10px 20px;
          font-size: 16px;
          background: #2B579A;
          color: white;
          border: none;
          border-radius: 5px;
          cursor: pointer;
          transition: background 0.3s;
        }
        .nav button:hover {
          background: #1a3a5a;
        }
        .nav button:disabled {
          background: #ccc;
          cursor: not-allowed;
        }
        
        /* 进度指示器 */
        .progress {
          position: fixed;
          bottom: 20px;
          left: 20px;
          font-size: 14px;
          color: #666;
        }
      </style>
    </head>
    <body>
      <h1>#{@标题}</h1>
      #{图表HTML}
      
      <!-- 导航按钮 -->
      <div class="nav">
        <button onclick="prevSlide()">← 上一页</button>
        <button onclick="nextSlide()">下一页 →</button>
      </div>
      
      <!-- 进度指示器 -->
      <div class="progress">
        <span id="current-slide">1</span> / <span id="total-slides">#{@图表列表.length}</span>
      </div>
      
      <script>
        var slides = document.querySelectorAll('section');
        var currentIndex = 0;
        var totalSlides = slides.length;
        
        function showSlide(index) {
          if (index < 0 || index >= totalSlides) return;
          
          slides.forEach(function(slide, i) {
            slide.style.display = (i === index) ? 'block' : 'none';
          });
          
          currentIndex = index;
          updateProgress();
          
          // 滚动到顶部
          window.scrollTo(0, 0);
          
          // 重新渲染Mermaid图表
          setTimeout(function() {
            mermaid.init(undefined, slides[currentIndex].querySelectorAll('.mermaid'));
          }, 100);
        }
        
        function nextSlide() {
          if (currentIndex < totalSlides - 1) {
            showSlide(currentIndex + 1);
          }
        }
        
        function prevSlide() {
          if (currentIndex > 0) {
            showSlide(currentIndex - 1);
          }
        }
        
        function updateProgress() {
          document.getElementById('current-slide').textContent = currentIndex + 1;
          document.getElementById('total-slides').textContent = totalSlides;
        }
        
        // 键盘导航
        document.addEventListener('keydown', function(e) {
          if (e.key === 'ArrowRight' || e.key === ' ') {
            e.preventDefault();
            nextSlide();
          } else if (e.key === 'ArrowLeft') {
            e.preventDefault();
            prevSlide();
          }
        });
        
        // 初始化
        showSlide(0);
        
        // 初始化Mermaid
        mermaid.initialize({
          startOnLoad: false,
          theme: 'default',
          securityLevel: 'loose'
        });
        
        // 页面加载完成后渲染第一个图表
        window.addEventListener('load', function() {
          setTimeout(function() {
            mermaid.init(undefined, slides[0].querySelectorAll('.mermaid'));
          }, 100);
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
    console.log "   带导航按钮和键盘支持"

# ============================================
# 诗式API（极简）
# ============================================

开始绘图PPTX = (标题) ->
  当前演示 = new PPTX生成器 标题
  图表编号 = 0
  console.log "🎨 开始绘图（PPTX）：#{标题}"
  当前演示

开始绘图HTML = (标题) ->
  当前演示 = new HTML生成器 标题
  图表编号 = 0
  console.log "🎨 开始绘图（HTML）：#{标题}"
  当前演示

开始绘图简化HTML = (标题) ->
  当前演示 = new 简化HTML生成器 标题
  图表编号 = 0
  console.log "🎨 开始绘图（简化HTML）：#{标题}"
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
  开始绘图PPTX
  开始绘图HTML
  开始绘图简化HTML
  完成绘图
  创建流程图
  创建时序图
  创建类图
  创建状态图
  流程图
  时序图
  类图
  状态图
  PPTX生成器
  HTML生成器
  简化HTML生成器
}
