#!/usr/bin/env coffee

# 测试标准写法

数据 = require "../../reviewer-workspace/data2/标准写法示例.coffee"

console.log "\n=== 标准写法测试 ===\n"
console.log "课程代码:", 数据.元数据.代码
console.log "课程标题:", 数据.元数据.标题
console.log "幻灯片数:", 数据.幻灯片.length
console.log "\n✅ 标准写法：第一行直接写 module.exports = {"
