#!/usr/bin/env coffee

# 测试：直接使用.coffee文件作为数据源
# 展示CSON格式的便利性

# 直接require .coffee文件，无需任何转换！
课程数据 = require "../../reviewer-workspace/data2/A01医院管理总览课程.coffee"

console.log "\n=== 测试直接使用.coffee文件 ===\n"

# 显示元数据
console.log "课程代码：", 课程数据.元数据.代码
console.log "课程标题：", 课程数据.元数据.标题
console.log "课程副标题：", 课程数据.元数据.副标题
console.log "课程时长：", 课程数据.元数据.时长

# 统计幻灯片
console.log "\n幻灯片总数：", 课程数据.幻灯片.length

# 统计各类型幻灯片
类型统计 = {}
课程数据.幻灯片.forEach (幻灯片) ->
  类型 = 幻灯片.类型
  类型统计[类型] = (类型统计[类型] ? 0) + 1

console.log "\n幻灯片类型统计："
for 类型, 数量 of 类型统计
  console.log "  #{类型}: #{数量}页"

# 显示前3张幻灯片标题
console.log "\n前3张幻灯片："
课程数据.幻灯片[0..2].forEach (幻灯片, 索引) ->
  console.log "  #{索引 + 1}. #{幻灯片.类型} - #{幻灯片.标题 ? 幻灯片.编号}"

console.log "\n✅ 测试成功！.coffee文件可以直接作为数据源使用！"
console.log "\n=== CSON格式的优势 ==="
console.log "1. 无需JSON转换"
console.log "2. 支持注释"
console.log "3. 支持多行字符串"
console.log "4. 结构清晰"
console.log "5. 可直接require使用"
