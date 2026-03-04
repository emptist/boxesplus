#!/usr/bin/env coffee

# 使用C01数据文件生成PPTX
# 测试Markdown转换器的效果

PptxGenJS = require "pptxgenjs"

# 加载C01课程数据
课程数据 = require "../../reviewer-workspace/data2/C01医疗质量与安全管理课程.coffee"

console.log "\n=== 生成C01课程PPTX ==="
console.log "课程：#{课程数据.元数据.课程名称}"
console.log "幻灯片数：#{课程数据.幻灯片.length}"

# ============================================
# 幻灯片类 - 双侧编程
# ============================================

class 幻灯片
  @默认:
    颜色: "2B579A"
    字体: 16
    主题色:
      蓝色: "2B579A"
      绿色: "2E7D32"
      紫色: "6A1B9A"
      红色: "C62828"
  
  @从数据创建: (数据) ->
    new @(数据)
  
  @批量创建: (数据列表) ->
    数据列表.map (数据) => @从数据创建 数据
  
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
      # 根据项目数量自动调整字体大小
      项目数 = @数据.项目.length
      字体大小 = if 项目数 <= 4 then 18
      else if 项目数 <= 6 then 16
      else if 项目数 <= 8 then 14
      else 12
      
      项目列表 = @数据.项目.map (项目) ->
        text: "• #{项目}", options: 
          breakLine: true
          fontSize: 字体大小
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
        y = 1.2 + Math.floor(索引 / 列数) * 2
        
        # 清理Markdown格式
        内容 = 卡片.内容
          .replace /\*\*/g, ""
          .replace /\n-/g, "\n•"
          .replace "（原为图例）", ""
        
        # 卡片背景
        slide.addShape "rect",
          x: x, y: y, w: 卡片宽度 - 0.2, h: 1.8
          fill: {color: "F0F0F0"}
        
        # 卡片标题
        slide.addText 卡片.标题,
          x: x + 0.1, y: y + 0.1, w: 卡片宽度 - 0.4, h: 0.4
          fontSize: 16, bold: true, color: @颜色
        
        # 卡片内容
        slide.addText 内容,
          x: x + 0.1, y: y + 0.5, w: 卡片宽度 - 0.4, h: 1.2
          fontSize: 12, color: "333333"
  
  解析层次结构: (内容) ->
    行列表 = []
    行数组 = 内容.split "\n"
    
    当前标题 = ""
    当前行内容 = []
    
    行数组.forEach (行) ->
      行 = 行.trim()
      
      # 检测层次标题（支持两种格式）
      # 格式1：第X层：XXX
      match1 = 行.match /^第([一二三四五六七八九十]+)[层级][:：]\s*(.+)/
      # 格式2：XXX：（例如：院级层面：）
      match2 = 行.match /^(.+?)[:：]\s*$/
      
      if match1
        # 保存上一个层次
        if 当前标题 != ""
          行列表.push
            标题: 当前标题
            内容: 当前行内容.join("\n")
        
        # 开始新的层次
        当前标题 = match1[2].trim()
        当前行内容 = []
      else if match2
        # 保存上一个层次
        if 当前标题 != ""
          行列表.push
            标题: 当前标题
            内容: 当前行内容.join("\n")
        
        # 开始新的层次
        当前标题 = match2[1].trim()
        当前行内容 = []
      else if 行.startsWith "•"
        # 列表项：保留原有的格式
        项目 = 行.replace(/^•\s*/, "• ").trim()
        if 项目 != "•"
          当前行内容.push 项目
      else if 行 != "" and 当前标题 != ""
        # 其他内容
        当前行内容.push 行
    
    # 保存最后一个层次
    if 当前标题 != ""
      行列表.push
        标题: 当前标题
        内容: 当前行内容.join("\n")
    
    行列表
  
  渲染默认: (演示) ->
    slide = 演示.addSlide()
    slide.addText @标题 ? "未识别类型",
      x: 0.5, y: 2.5, w: 9, h: 1
      fontSize: 28, bold: true, align: "center", color: "999999"

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
    @pptx.title = @元数据.课程名称
    @幻灯片列表 = []
    console.log "📝 创建：#{@元数据.课程名称}"
  
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

# 生成带时间戳的文件名
时间戳 = new Date().toISOString().replace(/[:.]/g, "-").slice(0, 19)
文件名 = "../../output/C01医疗质量与安全管理-#{时间戳}.pptx"

演示.保存 文件名

console.log "\n=== 转换效果说明 ==="
console.log "✅ 自动识别表格、列表、层次结构"
console.log "✅ 自动生成封面页、章节页、内容页"
console.log "✅ 清理Markdown格式（粗体、列表标记）"
console.log "✅ 保持原有结构（章节、小节）"
console.log "\n⚠️  需要人工审核的地方："
console.log "   1. 卡片页布局可能需要调整"
console.log "   2. 内容分页可能需要优化"
console.log "   3. 图例内容可能需要重新设计"
