#!/usr/bin/env coffee

# Markdown教案自动转换器
# 将Markdown格式的教案转换为CSON数据文件

fs = require "fs"
path = require "path"

# ============================================
# Markdown解析器
# ============================================

class Markdown解析器
  constructor: (@文件路径) ->
    @内容 = fs.readFileSync(@文件路径, "utf-8").split "\n"
    @当前行 = 0
    @元数据 = {}
    @章节列表 = []
    @幻灯片列表 = []
  
  解析: ->
    console.log "\n=== 开始解析Markdown教案 ==="
    console.log "文件：#{path.basename @文件路径}"
    console.log "总行数：#{@内容.length}"
    
    @提取元数据()
    @解析章节()
    @生成幻灯片()
    
    结果 =
      元数据: @元数据
      幻灯片: @幻灯片列表
    
    console.log "\n✅ 解析完成"
    console.log "   元数据：#{Object.keys(@元数据).length} 项"
    console.log "   章节：#{@章节列表.length} 章"
    console.log "   幻灯片：#{@幻灯片列表.length} 页"
    
    结果
  
  提取元数据: ->
    console.log "\n📝 提取元数据..."
    
    in元数据 = false
    while @当前行 < @内容.length
      行 = @内容[@当前行].trim()
      
      if 行.startsWith "## 课程信息"
        in元数据 = true
        @当前行++
        continue
      
      if in元数据 and 行.startsWith "##"
        break
      
      if in元数据 and 行.startsWith "- **"
        # 解析：- **课程名称**：医院医疗质量与安全管理
        match = 行.match /- \*\*(.+?)\*\*[:：](.+)/
        if match
          key = match[1].trim()
          value = match[2].trim()
          @元数据[key] = value
          console.log "   #{key}：#{value}"
      
      @当前行++
  
  解析章节: ->
    console.log "\n📚 解析章节..."
    
    while @当前行 < @内容.length
      行 = @内容[@当前行].trim()
      
      # 识别章节：## 第一章：医疗质量管理概述（1小时）
      if 行.match /^## 第.+章[:：]/
        章节 = @解析章节内容()
        @章节列表.push 章节
      
      @当前行++
  
  解析章节内容: ->
    章节 =
      标题: ""
      时长: ""
      小节列表: []
    
    行 = @内容[@当前行].trim()
    
    # 提取章节标题和时长
    match = 行.match /^## 第(.+?)章[:：](.+?)（(.+?)）/
    if match
      章节.编号 = match[1]
      章节.标题 = match[2].trim()
      章节.时长 = match[3]
      console.log "\n   📖 第#{章节.编号}章：#{章节.标题}（#{章节.时长}）"
    
    @当前行++
    
    # 解析小节
    while @当前行 < @内容.length
      行 = @内容[@当前行].trim()
      
      # 遇到下一章，结束
      if 行.match /^## 第.+章[:：]/
        @当前行--
        break
      
      # 识别小节：### 1.1 医疗质量概念（25分钟）
      if 行.match /^### \d+\.\d+/
        小节 = @解析小节内容()
        章节.小节列表.push 小节
      
      @当前行++
    
    章节
  
  解析小节内容: ->
    小节 =
      编号: ""
      标题: ""
      时长: ""
      内容块列表: []
    
    行 = @内容[@当前行].trim()
    
    # 提取小节编号、标题和时长
    match = 行.match /^### (\d+\.\d+)\s+(.+?)（(.+?)）/
    if match
      小节.编号 = match[1]
      小节.标题 = match[2].trim()
      小节.时长 = match[3]
      console.log "      #{小节.编号} #{小节.标题}（#{小节.时长}）"
    
    @当前行++
    
    # 解析内容块
    while @当前行 < @内容.length
      行 = @内容[@当前行].trim()
      
      # 遇到下一小节或章节，结束
      if 行.match(/^### \d+\.\d+/) or 行.match(/^## 第.+章[:：]/)
        @当前行--
        break
      
      # 识别内容块标题：#### 核心内容
      if 行 == "#### 核心内容"
        内容块 = @解析内容块()
        小节.内容块列表.push 内容块
      
      @当前行++
    
    小节
  
  解析内容块: ->
    内容块 =
      类型: "核心内容"
      内容列表: []
    
    @当前行++
    
    while @当前行 < @内容.length
      行 = @内容[@当前行]
      
      # 遇到下一个内容块或小节，结束
      if 行.match(/^#### /) or 行.match(/^### \d+\.\d+/) or 行.match(/^## 第.+章[:：]/)
        @当前行--
        break
      
      # 识别标题：**一、医疗质量内涵（原为图例）：**
      if 行.match /^\*\*[一二三四五六七八九十]+[:：、]/
        标题块 = @解析标题块()
        内容块.内容列表.push 标题块
      
      # 识别表格
      else if 行.match /^\|/
        表格 = @解析表格()
        if 表格.表头 and 表格.行数据
          内容块.内容列表.push 表格
      
      # 识别列表
      else if 行.match /^- /
        列表 = @解析列表()
        内容块.内容列表.push 列表
      
      @当前行++
    
    内容块
  
  解析标题块: ->
    标题块 =
      类型: "标题块"
      标题: ""
      是图例: false
      内容: []
    
    行 = @内容[@当前行]
    
    # 提取标题
    match = 行.match /^\*\*([一二三四五六七八九十]+)[:：、](.+?)\*\*[:：]?\s*(.*)/
    if match
      标题块.序号 = match[1]
      标题块.标题 = match[2].trim()
      剩余 = match[3].trim()
      
      # 检查是否是图例
      if 剩余.includes "（原为图例）"
        标题块.是图例 = true
        剩余 = 剩余.replace "（原为图例）", ""
      
      if 剩余
        标题块.内容.push 剩余
    
    @当前行++
    
    # 解析后续内容
    while @当前行 < @内容.length
      行 = @内容[@当前行]
      
      # 遇到下一个标题块，结束
      if 行.match /^\*\*[一二三四五六七八九十]+[:：、]/
        @当前行--
        break
      
      # 遇到表格或列表，结束
      if 行.match /^\|/ or 行.match /^- /
        @当前行--
        break
      
      # 遇到空行，跳过
      if 行.trim() == ""
        @当前行++
        continue
      
      # 遇到下一个内容块或小节，结束
      if 行.match(/^#### /) or 行.match(/^### \d+\.\d+/) or 行.match(/^## 第.+章[:：]/)
        @当前行--
        break
      
      # 添加内容
      标题块.内容.push 行.trim()
      
      @当前行++
    
    标题块
  
  解析表格: ->
    表格 =
      类型: "表格"
      表头: []
      行数据: []
    
    while @当前行 < @内容.length
      行 = @内容[@当前行]
      
      # 不是表格行，结束
      if not 行.match /^\|/
        break
      
      # 跳过分隔行
      if 行.match /^\|[-\s|:]+\|$/
        @当前行++
        continue
      
      # 解析表格行
      单元格 = 行.split("|")
        .map (单元格) -> 单元格.trim()
        .filter (单元格) -> 单元格 != ""
      
      if 表格.表头.length == 0
        表格.表头 = 单元格
      else
        表格.行数据.push 单元格
      
      @当前行++
    
    表格
  
  解析列表: ->
    列表 =
      类型: "列表"
      项目: []
    
    while @当前行 < @内容.length
      行 = @内容[@当前行]
      
      # 不是列表项，结束
      if not 行.match /^- /
        break
      
      # 添加列表项
      项目 = 行.replace(/^- /, "").trim()
      列表.项目.push 项目
      
      @当前行++
    
    列表
  
  生成幻灯片: ->
    console.log "\n🎨 生成幻灯片..."
    
    # 添加封面页
    @幻灯片列表.push
      类型: "封面页"
      标题: @元数据["课程名称"] ? "课程标题"
      副标题: "医院管理核心模块课程"
      渐变: "蓝色"
    
    # 添加课程信息页
    if @元数据["课程时长"] or @元数据["课程对象"]
      项目 = []
      if @元数据["课程定位"]
        项目.push "课程定位：#{@元数据["课程定位"]}"
      if @元数据["课程时长"]
        项目.push "课程时长：#{@元数据["课程时长"]}"
      if @元数据["课程对象"]
        项目.push "课程对象：#{@元数据["课程对象"]}"
      if @元数据["教学方法"]
        项目.push "教学方法：#{@元数据["教学方法"]}"
      
      @幻灯片列表.push
        类型: "列表页"
        标题: "课程信息"
        项目: 项目
    
    # 为每个章节生成幻灯片
    @章节列表.forEach (章节) =>
      # 添加章节页
      @幻灯片列表.push
        类型: "章节页"
        编号: "第#{章节.编号}章"
        标题: 章节.标题
        副标题: "时长：#{章节.时长}"
        渐变: "蓝色"
      
      # 为每个小节生成幻灯片
      章节.小节列表.forEach (小节) =>
        @生成小节幻灯片 小节
  
  生成小节幻灯片: (小节) ->
    # 为每个内容块生成幻灯片
    小节.内容块列表.forEach (内容块) =>
      内容块.内容列表.forEach (内容) =>
        幻灯片 = @转换为幻灯片 内容, 小节
        if 幻灯片
          @幻灯片列表.push 幻灯片
  
  转换为幻灯片: (内容, 小节) ->
    switch 内容.类型
      when "表格"
        return
          类型: "表格页"
          标题: 小节.标题
          表头: 内容.表头
          行数据: 内容.行数据
      
      when "列表"
        return
          类型: "列表页"
          标题: 小节.标题
          项目: 内容.项目
      
      when "标题块"
        # 如果有内容
        if 内容.内容.length > 0
          内容文本 = 内容.内容.join "\n"
          内容行数 = 内容文本.split("\n").length
          总字数 = 内容文本.replace(/\n/g, "").length
          
          # 规则1：超过5行 → 表格页
          if 内容行数 > 5
            console.log "      📊 内容超过5行，使用表格页：#{内容.标题}"
            return
              类型: "表格页"
              标题: 内容.标题
              表头: ["内容"]
              行数据: [[内容文本]]
          
          # 规则2：单行内容超过50字 → 表格页
          if 内容行数 == 1 and 总字数 > 50
            console.log "      📊 单行超过50字，使用表格页：#{内容.标题}"
            return
              类型: "表格页"
              标题: 内容.标题
              表头: ["内容"]
              行数据: [[内容文本]]
          
          # 规则3：其他情况 → 卡片页
          console.log "      📄 使用卡片页：#{内容.标题}"
          return
            类型: "卡片页"
            标题: 内容.标题
            列数: 1
            卡片: [
              标题: 内容.标题
              内容: 内容文本
            ]
    
    null

# ============================================
# CSON生成器
# ============================================

class CSON生成器
  @生成: (数据) ->
    lines = []
    
    lines.push "module.exports = {"
    lines.push "  # 元数据"
    lines.push "  元数据: {"
    
    for key, value of 数据.元数据
      lines.push "    #{key}: \"#{value}\""
    
    lines.push "  }"
    lines.push ""
    lines.push "  # 幻灯片列表"
    lines.push "  幻灯片: ["
    
    数据.幻灯片.forEach (幻灯片, 索引) ->
      lines.push "    # 幻灯片 #{索引 + 1}"
      lines.push "    {"
      
      for key, value of 幻灯片
        if Array.isArray value
          lines.push "      #{key}: ["
          value.forEach (项) ->
            if typeof 项 == "string"
              lines.push "        \"#{项}\""
            else
              lines.push "        #{JSON.stringify 项}"
          lines.push "      ]"
        else if typeof value == "string"
          lines.push "      #{key}: \"#{value}\""
        else
          lines.push "      #{key}: #{JSON.stringify value}"
      
      lines.push "    }"
    
    lines.push "  ]"
    lines.push "}"
    
    lines.join "\n"

# ============================================
# 主程序
# ============================================

转换教案 = (输入文件, 输出文件) ->
  console.log "\n" + "=".repeat(50)
  console.log "Markdown教案转换器"
  console.log "=".repeat(50)
  
  # 解析Markdown
  解析器 = new Markdown解析器 输入文件
  数据 = 解析器.解析()
  
  # 生成CSON
  console.log "\n💾 生成CSON文件..."
  cson内容 = CSON生成器.生成 数据
  
  # 保存文件
  fs.writeFileSync 输出文件, cson内容, "utf-8"
  console.log "✅ 保存成功：#{输出文件}"

# 导出模块
module.exports = {Markdown解析器, CSON生成器, 转换教案}

# 如果直接运行
if require.main == module
  输入文件 = process.argv[2] ? "../notes/C01医疗质量与安全管理课程详细教案.md"
  输出文件 = process.argv[3] ? "../reviewer-workspace/data2/C01医疗质量与安全管理课程.coffee"
  
  转换教案 输入文件, 输出文件
