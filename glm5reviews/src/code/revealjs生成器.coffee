#!/usr/bin/env coffee

# RevealJS生成器探索
# 目标：应用PPTX探索中学到的模式

fs = require "fs"
path = require "path"

# ============================================
# 核心洞察：RevealJS是HTML，PPTX是XML
# 但生成模式是相同的
# ============================================

class RevealJS生成器
  constructor: (@选项 = {}) ->
    @幻灯片列表 = []
    @配置 =
      主题: @选项.主题 ? "black"
      过渡: @选项.过渡 ? "slide"
      控制键: @选项.控制键 ? true
      进度条: @选项.进度条 ? true
  
  # 添加幻灯片
  添加: (内容, 属性 = {}) ->
    @幻灯片列表.push
      内容: 内容
      属性: 属性
    this
  
  # 封面页
  封面: (标题, 副标题 = "") ->
    @添加 """
      <h1>#{标题}</h1>
      #{if 副标题 then "<h3>#{副标题}</h3>" else ""}
    """, class: "fit"
  
  # 章节页
  章节: (编号, 标题, 副标题 = "") ->
    @添加 """
      <h2>#{编号}</h2>
      <h1>#{标题}</h1>
      #{if 副标题 then "<h3>#{副标题}</h3>" else ""}
    """
  
  # 列表页
  列表: (标题, 项目列表) ->
    项目HTML = 项目列表.map (项) -> "<li>#{项}</li>" .join "\n"
    @添加 """
      <h2>#{标题}</h2>
      <ul>
        #{项目HTML}
      </ul>
    """
  
  # 流程页
  流程: (标题, 步骤列表, 循环 = false) ->
    步骤HTML = 步骤列表.map (步骤, 索引) ->
      """
      <div class="step">
        <span class="step-number">#{索引 + 1}</span>
        <span class="step-text">#{步骤}</span>
      </div>
      """
    .join if 循环 then " → " else " → "
    
    @添加 """
      <h2>#{标题}</h2>
      <div class="flow">
        #{步骤HTML}
      </div>
    """
  
  # 生成HTML
  生成: ->
    """
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>#{@选项.标题 ? "演示文稿"}</title>
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.5.0/reveal.min.css">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.5.0/theme/#{@配置.主题}.min.css">
      <style>
        .fit h1, .fit h2, .fit h3 {
          text-align: center;
        }
        .flow {
          display: flex;
          justify-content: space-around;
          align-items: center;
          margin-top: 2em;
        }
        .step {
          text-align: center;
          padding: 1em;
          background: rgba(255,255,255,0.1);
          border-radius: 5px;
        }
        .step-number {
          display: block;
          font-size: 2em;
          font-weight: bold;
          color: #42affa;
        }
        .step-text {
          display: block;
          margin-top: 0.5em;
        }
      </style>
    </head>
    <body>
      <div class="reveal">
        <div class="slides">
          #{@生成幻灯片()}
        </div>
      </div>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.5.0/reveal.min.js"></script>
      <script>
        Reveal.initialize({
          controls: #{@配置.控制键},
          progress: #{@配置.进度条},
          transition: '#{@配置.过渡}'
        });
      </script>
    </body>
    </html>
    """
  
  生成幻灯片: ->
    @幻灯片列表.map (幻灯片) =>
      属性字符串 = @生成属性 幻灯片.属性
      """
      <section #{属性字符串}>
        #{幻灯片.内容}
      </section>
      """
    .join "\n"
  
  生成属性: (属性) ->
    Object.entries(属性)
      .map ([键, 值]) -> "#{键}=\"#{值}\""
      .join " "
  
  # 保存文件
  保存: (文件名) ->
    html = @生成()
    fs.writeFileSync 文件名, html, "utf-8"
    console.log "✅ 生成完成：#{文件名}"
    console.log "   共 #{@幻灯片列表.length} 张幻灯片"

# ============================================
# 诗式API（与PPTX相同模式）
# ============================================

class 诗式RevealJS extends RevealJS生成器
  诗: (内容) ->
    if Array.isArray 内容
      switch 内容.length
        when 1
          @添加 "<h1>#{内容[0]}</h1>", class: "fit"
        when 2
          @封面 内容[0], 内容[1]
        when 3
          @章节 内容[0], 内容[1], 内容[2]
        else
          @列表 内容[0], 内容[1..]
    else if typeof 内容 == "object"
      if 内容.步骤
        @流程 内容.标题, 内容.步骤, 内容.循环
      else if 内容.项目
        @列表 内容.标题, 内容.项目
    
    this

# ============================================
# 使用示例
# ============================================

console.log "\n=== RevealJS生成器探索 ===\n"

# 方式1：传统API
生成器1 = new RevealJS生成器 标题: "医院管理课程"
生成器1
  .封面 "医院管理总览", "体系、趋势与中国特色"
  .章节 "第一篇", "医院管理导论", "理解医院管理的全貌"
  .列表 "课程目标", [
    "知识目标：掌握医疗健康服务体系演进"
    "能力目标：从宏观视角审视医院管理"
    "素质目标：培养战略思维与全局观念"
  ]
  .流程 "战略管理闭环", ["战略规划", "年度预算", "绩效考核", "运营调整"], true
  .保存 "../../output/reveal-传统API.html"

# 方式2：诗式API
生成器2 = new 诗式RevealJS 标题: "医院管理课程"
生成器2
  .诗 ["医院管理总览", "体系、趋势与中国特色"]
  .诗 ["第一篇", "医院管理导论", "理解医院管理的全貌"]
  .诗 ["课程目标", [
    "知识目标：掌握医疗健康服务体系演进"
    "能力目标：从宏观视角审视医院管理"
    "素质目标：培养战略思维与全局观念"
  ]]
  .诗 标题: "战略管理闭环", 步骤: ["战略规划", "年度预算", "绩效考核", "运营调整"], 循环: true
  .保存 "../../output/reveal-诗式API.html"

# ============================================
# 反思：PPTX vs RevealJS
# ============================================

反思 = """
=== 反思：PPTX vs RevealJS ===

相同点：
1. 都需要定义幻灯片结构
2. 都需要填充内容
3. 都需要样式配置
4. 都可以用相同的API模式

不同点：
1. 输出格式：PPTX是XML，RevealJS是HTML
2. 渲染方式：PPTX用Office打开，RevealJS用浏览器
3. 交互性：RevealJS支持更多交互
4. 分享性：RevealJS更容易分享（URL即可）

核心模式：
  内容定义 → 格式转换 → 最终输出

这个模式可以应用到任何演示格式：
  - PPTX
  - RevealJS
  - PDF
  - 视频
  - ...

关键洞察：
  API设计应该独立于输出格式
  只需要实现不同的渲染器
"""

console.log "\n#{反思}"

module.exports = {
  RevealJS生成器
  诗式RevealJS
}
