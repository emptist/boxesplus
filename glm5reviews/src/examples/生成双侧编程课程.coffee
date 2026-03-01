#!/usr/bin/env coffee

# 生成"双侧编程+数据驱动"演示文稿
# 用双侧编程+数据驱动来展示"双侧编程+数据驱动"本身

fs = require "fs"
PptxGenJS = require "pptxgenjs"

# ============================================
# 加载课程数据
# ============================================

课程数据 = require "../../reviewer-workspace/data2/双侧编程课程.coffee"

console.log "\n=== 生成演示文稿 ==="
console.log "课程：#{课程数据.元数据.标题}"
console.log "幻灯片数：#{课程数据.幻灯片.length}"

# ============================================
# 幻灯片类 - 双侧编程
# ============================================

class 幻灯片
  # 类一侧：定义规则和模板
  @模板库: {}
  @默认:
    颜色: "2B579A"
    字体: 16
    主题色:
      蓝色: "2B579A"
      绿色: "2E7D32"
      紫色: "6A1B9A"
      红色: "C62828"
  
  @注册模板: (名称, 模板) ->
    @模板库[名称] = 模板
  
  @从数据创建: (数据) ->
    new @(数据)
  
  @批量创建: (数据列表) ->
    数据列表.map (数据) => @从数据创建 数据
  
  # 实例一侧：具体渲染
  constructor: (@数据) ->
    {@类型, @标题, @副标题, @渐变} = @数据
    @颜色 = @constructor.默认.主题色[@渐变] ? @constructor.默认.颜色
  
  渲染: (演示) ->
    switch @类型
      when "封面页" then @渲染封面 演示
      when "章节页" then @渲染章节 演示
      when "列表页" then @渲染列表 演示
      when "表格页" then @渲染表格 演示
      when "卡片页" then @渲染卡片 演示
      when "引用页" then @渲染引用 演示
      when "结束页" then @渲染结束 演示
  
  渲染封面: (演示) ->
    slide = 演示.addSlide()
    slide.addText @标题,
      x: 0.5, y: 2.5, w: 9, h: 1
      fontSize: 44, bold: true, align: "center", color: @颜色
    if @副标题
      slide.addText @副标题,
        x: 0.5, y: 3.5, w: 9, h: 0.6
        fontSize: 20, align: "center", color: "666666"
  
  渲染章节: (演示) ->
    slide = 演示.addSlide()
    if @数据.编号
      slide.addText @数据.编号,
        x: 0.5, y: 1.5, w: 9, h: 0.6
        fontSize: 20, align: "center", color: "999999"
    slide.addText @标题,
      x: 0.5, y: 2.2, w: 9, h: 1
      fontSize: 36, bold: true, align: "center", color: @颜色
    if @副标题
      slide.addText @副标题,
        x: 0.5, y: 3.3, w: 9, h: 0.6
        fontSize: 18, align: "center", color: "666666"
  
  渲染列表: (演示) ->
    slide = 演示.addSlide()
    slide.addText @标题,
      x: 0.5, y: 0.3, w: 9, h: 0.6
      fontSize: 28, bold: true, color: @颜色
    
    if @数据.项目
      # 处理缩进的项目
      项目列表 = @数据.项目.map (项目) =>
        if 项目.startsWith("  ")
          text: "  #{项目.trim()}", options: 
            breakLine: true
            fontSize: 14
            color: "666666"
        else
          text: "• #{项目}", options: 
            breakLine: true
            fontSize: 16
            color: "333333"
      
      slide.addText 项目列表,
        x: 0.5, y: 1.2, w: 9, h: 4
  
  渲染表格: (演示) ->
    slide = 演示.addSlide()
    slide.addText @标题,
      x: 0.5, y: 0.3, w: 9, h: 0.6
      fontSize: 28, bold: true, color: @颜色
    
    if @数据.表头 and @数据.行数据
      表格数据 = [@数据.表头, ...@数据.行数据]
      slide.addTable 表格数据,
        x: 0.5, y: 1.2, w: 9, h: 4
        fontSize: 14
        border: {type: "solid", pt: 1, color: "E0E0E0"}
        fill: {color: "F5F5F5"}
        color: "333333"
  
  渲染卡片: (演示) ->
    slide = 演示.addSlide()
    slide.addText @标题,
      x: 0.5, y: 0.3, w: 9, h: 0.6
      fontSize: 28, bold: true, color: @颜色
    
    if @数据.卡片
      列数 = @数据.列数 ? 2
      卡片宽度 = 8.5 / 列数
      
      @数据.卡片.forEach (卡片, 索引) =>
        x = 0.75 + (索引 % 列数) * 卡片宽度
        y = 1.2 + Math.floor(索引 / 列数) * 2.2
        
        slide.addShape "rect",
          x: x, y: y, w: 卡片宽度 - 0.2, h: 2
          fill: {color: "F0F0F0"}
        
        slide.addText 卡片.标题,
          x: x + 0.1, y: y + 0.1, w: 卡片宽度 - 0.4, h: 0.4
          fontSize: 16, bold: true, color: @颜色
        
        # 处理多行内容
        内容 = 卡片.内容.replace(/\n/g, "\n")
        slide.addText 内容,
          x: x + 0.1, y: y + 0.5, w: 卡片宽度 - 0.4, h: 1.4
          fontSize: 12, color: "333333"
  
  渲染引用: (演示) ->
    slide = 演示.addSlide()
    
    slide.addText "\"#{@数据.引用}\"",
      x: 1, y: 2, w: 8, h: 1.5
      fontSize: 28, align: "center", color: @颜色, italic: true
    
    if @数据.作者
      slide.addText "—— #{@数据.作者}",
        x: 1, y: 3.5, w: 8, h: 0.5
        fontSize: 16, align: "center", color: "666666"
  
  渲染结束: (演示) ->
    slide = 演示.addSlide()
    
    slide.addText @标题,
      x: 0.5, y: 2.5, w: 9, h: 1
      fontSize: 44, bold: true, align: "center", color: @颜色
    
    if @副标题
      slide.addText @副标题,
        x: 0.5, y: 3.5, w: 9, h: 0.6
        fontSize: 20, align: "center", color: "666666"

# ============================================
# 演示文稿类
# ============================================

class 演示文稿
  @配置:
    布局: "LAYOUT_16x9"
  
  @从数据创建: (课程数据) ->
    演示 = new @(课程数据.元数据)
    演示.添加幻灯片 课程数据.幻灯片
    演示
  
  constructor: (@元数据) ->
    @pptx = new PptxGenJS()
    @pptx.layout = @constructor.配置.布局
    @pptx.title = @元数据.标题
    @幻灯片列表 = []
    console.log "📝 创建：#{@元数据.标题}"
  
  添加幻灯片: (数据列表) ->
    console.log "   📄 添加 #{数据列表.length} 张幻灯片"
    @幻灯片列表 = 幻灯片.批量创建 数据列表
    this
  
  保存: (文件名) ->
    @幻灯片列表.forEach (幻灯) => 幻灯.渲染 @pptx
    @pptx.writeFile({fileName: 文件名})
      .then =>
        console.log "✅ 保存：#{文件名}"
        console.log "   共 #{@幻灯片列表.length} 页"

# ============================================
# 生成演示文稿
# ============================================

演示 = 演示文稿.从数据创建 课程数据
演示.保存 "../../output/双侧编程-数据驱动.pptx"

console.log "\n=== 代码如何在Slide中呈现 ==="
console.log "1. 列表页：代码作为文本项目展示"
console.log "2. 表格页：代码对比，结构清晰"
console.log "3. 卡片页：代码片段，分类展示"
console.log "4. 引用页：核心代码，突出显示"
console.log "\n✅ 这就是自我演示的威力！"
