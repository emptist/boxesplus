#!/usr/bin/env coffee

# 双侧编程 + 数据驱动 = 最佳实践
# 类一侧：定义渲染逻辑和模板
# 实例一侧：从数据文件加载内容

fs = require "fs"
PptxGenJS = require "pptxgenjs"

# ============================================
# 从数据文件加载课程内容
# ============================================

课程数据 = require "../../reviewer-workspace/data2/A01医院管理总览课程.coffee"

console.log "\n=== 双侧编程 + 数据驱动 ===\n"
console.log "课程：#{课程数据.元数据.标题}"
console.log "幻灯片数：#{课程数据.幻灯片.length}"

# ============================================
# 幻灯片类 - 双侧编程
# ============================================

class 幻灯片
  # ==========================================
  # 类一侧：定义规则、模板、默认值
  # ==========================================
  
  @模板库: {}
  @默认:
    颜色: "2B579A"
    字体: 16
    主题色:
      蓝色: "2B579A"
      绿色: "2E7D32"
      紫色: "6A1B9A"
      红色: "C62828"
  
  # 类方法：注册模板
  @注册模板: (名称, 模板) ->
    @模板库[名称] = 模板
    console.log "   📌 注册模板：#{名称}"
  
  # 类方法：从数据创建实例
  @从数据创建: (数据) ->
    new @(数据)
  
  # 类方法：批量从数据创建
  @批量创建: (数据列表) ->
    数据列表.map (数据) => @从数据创建 数据
  
  # 类方法：应用模板
  @应用模板: (模板名称, 数据) ->
    模板 = @模板库[模板名称] ? {}
    new @(Object.assign {}, 模板, 数据)
  
  # ==========================================
  # 实例一侧：具体内容和渲染
  # ==========================================
  
  constructor: (@数据) ->
    {@类型, @标题, @副标题, @渐变} = @数据
    @颜色 = @constructor.默认.主题色[@渐变] ? @constructor.默认.颜色
  
  # 实例方法：渲染到PPTX
  渲染: (演示) ->
    switch @类型
      when "封面页" then @渲染封面 演示
      when "章节页" then @渲染章节 演示
      when "列表页" then @渲染列表 演示
      when "表格页" then @渲染表格 演示
      when "卡片页" then @渲染卡片 演示
      when "引用页" then @渲染引用 演示
      when "结束页" then @渲染结束 演示
      else @渲染默认 演示
  
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
      项目列表 = @数据.项目.map (项目) -> 
        text: "• #{项目}", options: {breakLine: true, fontSize: 16}
      slide.addText 项目列表,
        x: 0.5, y: 1.2, w: 9, h: 4, color: "333333"
  
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
        y = 1.2 + Math.floor(索引 / 列数) * 2
        
        slide.addShape "rect",
          x: x, y: y, w: 卡片宽度 - 0.2, h: 1.8
          fill: {color: "F0F0F0"}
        
        slide.addText 卡片.标题,
          x: x + 0.1, y: y + 0.1, w: 卡片宽度 - 0.4, h: 0.4
          fontSize: 16, bold: true, color: @颜色
        
        slide.addText 卡片.内容,
          x: x + 0.1, y: y + 0.5, w: 卡片宽度 - 0.4, h: 1.2
          fontSize: 12, color: "333333"
  
  渲染引用: (演示) ->
    slide = 演示.addSlide()
    
    slide.addText "\"#{@数据.引用}\"",
      x: 1, y: 2, w: 8, h: 1.5
      fontSize: 24, align: "center", color: @颜色, italic: true
    
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
  
  渲染默认: (演示) ->
    slide = 演示.addSlide()
    slide.addText @标题 ? "未定义类型",
      x: 0.5, y: 2.5, w: 9, h: 1
      fontSize: 28, bold: true, align: "center", color: @颜色

# ============================================
# 演示文稿类 - 双侧编程
# ============================================

class 演示文稿
  # ==========================================
  # 类一侧：全局配置和工厂方法
  # ==========================================
  
  @当前: null
  @配置:
    布局: "LAYOUT_16x9"
    默认主题: "蓝色"
  
  # 类方法：从数据创建
  @从数据创建: (课程数据) ->
    演示 = new @(课程数据.元数据)
    演示.添加幻灯片 课程数据.幻灯片
    演示
  
  # ==========================================
  # 实例一侧：具体演示文稿
  # ==========================================
  
  constructor: (@元数据) ->
    @pptx = new PptxGenJS()
    @pptx.layout = @constructor.配置.布局
    @pptx.title = @元数据.标题
    @幻灯片列表 = []
    console.log "📝 创建演示文稿：#{@元数据.标题}"
  
  # 添加幻灯片
  添加幻灯片: (数据列表) ->
    console.log "   📄 添加 #{数据列表.length} 张幻灯片"
    @幻灯片列表 = 幻灯片.批量创建 数据列表
    this
  
  # 保存
  保存: (文件名) ->
    @幻灯片列表.forEach (幻灯) => 幻灯.渲染 @pptx
    @pptx.writeFile({fileName: 文件名})
      .then =>
        console.log "✅ 保存成功：#{文件名}"
        console.log "   共 #{@幻灯片列表.length} 页"

# ============================================
# 注册模板（类一侧）
# ============================================

console.log "\n📌 注册模板："

幻灯片.注册模板 "课程封面",
  类型: "封面页"
  渐变: "蓝色"

幻灯片.注册模板 "课程章节",
  类型: "章节页"
  渐变: "蓝色"

幻灯片.注册模板 "课程列表",
  类型: "列表页"
  渐变: "蓝色"

# ============================================
# 使用：从数据创建演示文稿（实例一侧）
# ============================================

console.log "\n🎨 从数据创建演示文稿："

演示 = 演示文稿.从数据创建 课程数据
演示.保存 "../../output/A01医院管理总览-双侧编程版.pptx"

console.log "\n=== 双侧编程 + 数据驱动的优势 ==="
console.log "1. 类一侧：定义渲染逻辑和模板，可复用"
console.log "2. 实例一侧：从数据文件加载内容，易维护"
console.log "3. 数据驱动：内容和代码完全分离"
console.log "4. 模板系统：预定义样式，保证一致性"
console.log "5. 灵活扩展：新增类型只需扩展类方法"
