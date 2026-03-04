#!/usr/bin/env coffee

# BoxesPlus 中文 API
# 基于 boxesplus-artist 的中文封装，灵感来自 HQCoffee 项目

PptxGenJS = require "pptxgenjs"
{
  titleSlide, listSlide, cardSlide, tableSlide, quoteSlide,
  comparisonSlide, timelineSlide, endSlide, sectionSlide,
  chartSlide, barChartSlide, pieChartSlide,
  THEME, GRADIENTS
} = require "../api/boxesplus-artist.coffee"

# 中文别名映射
别名映射 =
  封面页: titleSlide
  标题页: titleSlide
  列表页: listSlide
  卡片页: cardSlide
  表格页: tableSlide
  引用页: quoteSlide
  对比页: comparisonSlide
  时间线页: timelineSlide
  结束页: endSlide
  章节页: sectionSlide
  柱状图页: barChartSlide
  饼图页: pieChartSlide
  图表页: chartSlide

# 中文参数映射
参数映射 =
  title: "标题"
  subtitle: "副标题"
  items: "项目"
  headers: "表头"
  rows: "行数据"
  cards: "卡片"
  quote: "引用"
  author: "作者"
  left: "左侧"
  right: "右侧"
  events: "事件"
  number: "编号"
  gradient: "渐变"
  data: "数据"
  labels: "标签"
  values: "数值"
  columns: "列数"
  content: "内容"
  color: "颜色"

# 渐变色中文映射
渐变映射 =
  蓝色: "blue"
  绿色: "green"
  紫色: "purple"
  红色: "red"

# 转换参数
转换参数 = (选项) ->
  结果 = {}
  for 中文键, 值 of 选项
    英文键 = 参数映射[中文键] ? 中文键
    if 英文键 == "渐变" and 渐变映射[值]?
      值 = 渐变映射[值]
    结果[英文键] = 值
  结果

# 创建演示文稿
创建演示 = (选项 = {}) ->
  演示 = new PptxGenJS()
  演示.layout = 选项.布局 ? "LAYOUT_16x9"
  
  if 选项.元数据
    演示.title = 选项.元数据.标题 ? "演示文稿"
    演示.author = 选项.元数据.作者 ? ""
    演示.subject = 选项.元数据.主题 ? ""
  
  演示

# 中文 API 函数
封面页 = (演示, 选项) ->
  titleSlide(演示, 转换参数(选项))

列表页 = (演示, 选项) ->
  listSlide(演示, 转换参数(选项))

卡片页 = (演示, 选项) ->
  cardSlide(演示, 转换参数(选项))

表格页 = (演示, 选项) ->
  tableSlide(演示, 转换参数(选项))

引用页 = (演示, 选项) ->
  quoteSlide(演示, 转换参数(选项))

对比页 = (演示, 选项) ->
  comparisonSlide(演示, 转换参数(选项))

时间线页 = (演示, 选项) ->
  timelineSlide(演示, 转换参数(选项))

章节页 = (演示, 选项) ->
  sectionSlide(演示, 转换参数(选项))

结束页 = (演示, 选项) ->
  endSlide(演示, 转换参数(选项))

柱状图页 = (演示, 选项) ->
  barChartSlide(演示, 转换参数(选项))

饼图页 = (演示, 选项) ->
  pieChartSlide(演示, 转换参数(选项))

图表页 = (演示, 选项) ->
  chartSlide(演示, 转换参数(选项))

# 保存文件
保存文件 = (演示, 文件名) ->
  演示.writeFile({ fileName: 文件名 })
    .then ->
      console.log "✅ 已创建: #{文件名}"
    .catch (错误) ->
      console.error "❌ 错误: #{错误.message}"

# 从 JSON 生成演示
从JSON生成 = (JSON路径, 输出路径) ->
  fs = require "fs"
  
  unless fs.existsSync(JSON路径)
    console.error "❌ JSON 文件不存在: #{JSON路径}"
    return
  
  内容 = fs.readFileSync(JSON路径, "utf-8")
  课程 = JSON.parse(内容)
  
  演示 = 创建演示
    元数据: 课程.元数据
  
  总页数 = 课程.幻灯片?.length ? 0
  console.log "📄 正在处理 #{总页数} 页幻灯片..."
  
  for 幻灯片, 索引 in 课程.幻灯片
    类型 = 幻灯片.类型
    处理器 = 别名映射[类型]
    
    if 处理器
      console.log "  [#{索引 + 1}/#{总页数}] #{类型}: #{幻灯片.标题 ? '无标题'}"
      处理器(演示, 转换参数(幻灯片))
    else
      console.warn "  ⚠️ 未知类型: #{类型}"
  
  输出路径 = 输出路径 ? JSON路径.replace(".json", ".pptx")
  保存文件(演示, 输出路径)

# 导出
module.exports = {
  创建演示
  保存文件
  从JSON生成
  
  封面页
  列表页
  卡片页
  表格页
  引用页
  对比页
  时间线页
  章节页
  结束页
  柱状图页
  饼图页
  图表页
  
  别名映射
  参数映射
  渐变映射
  转换参数
}
