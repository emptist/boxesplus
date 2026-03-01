#!/usr/bin/env coffee

# 测试所有导出方式

console.log "\n=== 测试CoffeeScript导出方式 ===\n"

# 测试方式1：module.exports = {...}
方式1 = require "../../reviewer-workspace/data2/方式1.coffee"
console.log "方式1 (module.exports = {...}):"
console.log "  结果:", JSON.stringify 方式1
console.log "  成功:", 方式1.方式 == "module.exports"

# 测试原始的A01课程文件
课程数据 = require "../../reviewer-workspace/data2/A01医院管理总览课程.coffee"
console.log "\nA01课程数据:"
console.log "  课程代码:", 课程数据.元数据.代码
console.log "  课程标题:", 课程数据.元数据.标题
console.log "  幻灯片数:", 课程数据.幻灯片.length

console.log "\n✅ 标准写法确认：module.exports = {...}"
