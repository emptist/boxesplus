#!/usr/bin/env coffee

# 散文式 PPTX 生成器
# 让写 PPTX 像写散文一样简单

fs = require "fs"
PptxGenJS = require "pptxgenjs"

# 全局演示对象
当前演示 = null
当前幻灯片 = null
幻灯片列表 = []

# 创建演示
开始 = (标题, 选项 = {}) ->
  当前演示 = new PptxGenJS()
  当前演示.layout = "LAYOUT_16x9"
  当前演示.title = 标题
  当前演示.author = 选项.作者 ? ""
  当前演示.subject = 选项.主题 ? ""
  幻灯片列表 = []
  console.log "📝 开始创作：#{标题}"

# 封面页
封面 = (标题, 副标题, 颜色 = "蓝色") ->
  幻灯片列表.push
    类型: "封面"
    标题: 标题
    副标题: 副标题
    渐变: 颜色
  console.log "  📄 封面：#{标题}"

# 章节页
章节 = (编号, 标题, 副标题, 颜色 = "蓝色") ->
  幻灯片列表.push
    类型: "章节"
    编号: 编号
    标题: 标题
    副标题: 副标题
    渐变: 颜色
  console.log "  📑 章节：#{编号} #{标题}"

# 内容页
内容 = (标题, 项目...) ->
  幻灯片列表.push
    类型: "列表"
    标题: 标题
    项目: 项目
  console.log "  📝 内容：#{标题}"

# 表格页
表格 = (标题, 表头, 行...) ->
  幻灯片列表.push
    类型: "表格"
    标题: 标题
    表头: 表头
    行数据: 行
  console.log "  📊 表格：#{标题}"

# 引用页
引用 = (文字, 作者 = "") ->
  幻灯片列表.push
    类型: "引用"
    引用: 文字
    作者: 作者
  console.log "  💬 引用：#{文字[0..20]}..."

# 对比页
对比 = (标题, 左侧, 右侧) ->
  幻灯片列表.push
    类型: "对比"
    标题: 标题
    左侧: 左侧
    右侧: 右侧
  console.log "  ⚖️ 对比：#{标题}"

# 卡片页
卡片 = (标题, 卡片列表...) ->
  幻灯片列表.push
    类型: "卡片"
    标题: 标题
    卡片: 卡片列表
  console.log "  🃏 卡片：#{标题}"

# 时间线页
时间线 = (标题, 事件...) ->
  幻灯片列表.push
    类型: "时间线"
    标题: 标题
    事件: 事件
  console.log "  📅 时间线：#{标题}"

# 结束页
结束 = (标题 = "谢谢！", 副标题 = "") ->
  幻灯片列表.push
    类型: "结束"
    标题: 标题
    副标题: 副标题
  console.log "  🏁 结束：#{标题}"

# 保存文件
保存 = (文件名) ->
  生成PPTX(当前演示, 幻灯片列表)
  当前演示.writeFile({ fileName: 文件名 })
    .then ->
      console.log "✅ 已保存：#{文件名}"
      console.log "   共 #{幻灯片列表.length} 页幻灯片"
    .catch (错误) ->
      console.error "❌ 错误：#{错误.message}"

# 生成 PPTX
生成PPTX = (演示, 列表) ->
  for 幻灯片 in 列表
    slide = 演示.addSlide()
    
    switch 幻灯片.类型
      when "封面"
        slide.addText 幻灯片.标题,
          x: 0.5, y: 2, w: 9, h: 1.5
          fontSize: 44, bold: true, color: "2B579A", align: "center"
        if 幻灯片.副标题
          slide.addText 幻灯片.副标题,
            x: 0.5, y: 3.5, w: 9, h: 0.8
            fontSize: 24, color: "666666", align: "center"
      
      when "章节"
        slide.addText 幻灯片.编号,
          x: 0.5, y: 1.5, w: 9, h: 0.8
          fontSize: 20, color: "999999", align: "center"
        slide.addText 幻灯片.标题,
          x: 0.5, y: 2.2, w: 9, h: 1.2
          fontSize: 40, bold: true, color: "2B579A", align: "center"
        if 幻灯片.副标题
          slide.addText 幻灯片.副标题,
            x: 0.5, y: 3.4, w: 9, h: 0.6
            fontSize: 18, color: "666666", align: "center"
      
      when "列表"
        slide.addText 幻灯片.标题,
          x: 0.5, y: 0.3, w: 9, h: 0.7
          fontSize: 28, bold: true, color: "2B579A"
        text = 幻灯片.项目.map (项目, 索引) ->
          { text: "#{索引 + 1}. #{项目}\n", options: { fontSize: 16, color: "333333", breakLine: true } }
        slide.addText text,
          x: 0.5, y: 1.2, w: 9, h: 4
      
      when "表格"
        slide.addText 幻灯片.标题,
          x: 0.5, y: 0.3, w: 9, h: 0.7
          fontSize: 28, bold: true, color: "2B579A"
        slide.addTable [幻灯片.表头, ...幻灯片.行数据],
          x: 0.5, y: 1.2, w: 9, h: 4
          fontSize: 12, color: "333333"
          border: { type: "solid", pt: 1, color: "CCCCCC" }
      
      when "引用"
        slide.addText "\"#{幻灯片.引用}\"",
          x: 1, y: 1.5, w: 8, h: 2.5
          fontSize: 24, italic: true, color: "666666", align: "center"
        if 幻灯片.作者
          slide.addText "—— #{幻灯片.作者}",
            x: 1, y: 4, w: 8, h: 0.5
            fontSize: 14, color: "999999", align: "right"
      
      when "对比"
        slide.addText 幻灯片.标题,
          x: 0.5, y: 0.3, w: 9, h: 0.7
          fontSize: 28, bold: true, color: "2B579A"
        slide.addText 幻灯片.左侧.标题,
          x: 0.5, y: 1.2, w: 4.2, h: 0.5
          fontSize: 18, bold: true, color: "2B579A"
        左侧文本 = 幻灯片.左侧.项目.map (项目) ->
          { text: "• #{项目}\n", options: { fontSize: 14, breakLine: true } }
        slide.addText 左侧文本,
          x: 0.5, y: 1.8, w: 4.2, h: 3.5
        slide.addText 幻灯片.右侧.标题,
          x: 5.3, y: 1.2, w: 4.2, h: 0.5
          fontSize: 18, bold: true, color: "2B579A"
        右侧文本 = 幻灯片.右侧.项目.map (项目) ->
          { text: "• #{项目}\n", options: { fontSize: 14, breakLine: true } }
        slide.addText 右侧文本,
          x: 5.3, y: 1.8, w: 4.2, h: 3.5
      
      when "卡片"
        slide.addText 幻灯片.标题,
          x: 0.5, y: 0.3, w: 9, h: 0.7
          fontSize: 28, bold: true, color: "2B579A"
        列数 = Math.min(幻灯片.卡片.length, 4)
        卡片宽度 = 9 / 列数 - 0.2
        for 卡片, 索引 in 幻灯片.卡片
          列 = 索引 % 列数
          行 = Math.floor(索引 / 列数)
          x = 0.5 + 列 * (卡片宽度 + 0.2)
          y = 1.2 + 行 * 2
          slide.addText 卡片.标题,
            x: x, y: y, w: 卡片宽度, h: 0.5
            fontSize: 14, bold: true, color: "2B579A"
          slide.addText 卡片.内容,
            x: x, y: y + 0.6, w: 卡片宽度, h: 1.2
            fontSize: 11, color: "666666"
      
      when "时间线"
        slide.addText 幻灯片.标题,
          x: 0.5, y: 0.3, w: 9, h: 0.7
          fontSize: 28, bold: true, color: "2B579A"
        事件数 = 幻灯片.事件.length
        事件宽度 = 9 / 事件数
        for 事件, 索引 in 幻灯片.事件
          x = 0.5 + 索引 * 事件宽度
          slide.addText 事件.date,
            x: x, y: 1.5, w: 事件宽度, h: 0.4
            fontSize: 12, color: "2B579A", align: "center"
          slide.addText 事件.title,
            x: x, y: 2, w: 事件宽度, h: 0.4
            fontSize: 14, bold: true, align: "center"
          slide.addText 事件.desc,
            x: x, y: 2.5, w: 事件宽度, h: 1
            fontSize: 10, color: "666666", align: "center"
      
      when "结束"
        slide.addText 幻灯片.标题,
          x: 0.5, y: 2, w: 9, h: 1.5
          fontSize: 44, bold: true, color: "2B579A", align: "center"
        if 幻灯片.副标题
          slide.addText 幻灯片.副标题,
            x: 0.5, y: 3.5, w: 9, h: 0.8
            fontSize: 18, color: "666666", align: "center"

# 导出
module.exports = {
  开始, 封面, 章节, 内容, 表格, 引用, 对比, 卡片, 时间线, 结束, 保存
}
