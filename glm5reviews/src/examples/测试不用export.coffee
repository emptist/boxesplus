#!/usr/bin/env coffee

# 测试：不用export的情况

try
  数据 = require "../../reviewer-workspace/data2/测试不用export.coffee"
  console.log "不用export的结果：", 数据
  console.log "数据类型：", typeof 数据
  console.log "数据内容：", JSON.stringify 数据, null, 2
catch 错误
  console.log "错误：", 错误.message
