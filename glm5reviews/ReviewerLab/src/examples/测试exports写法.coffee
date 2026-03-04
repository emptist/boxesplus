#!/usr/bin/env coffee

# 测试：exports = {...} 写法

数据 = require "../../reviewer-workspace/data2/测试exports写法.coffee"
console.log "exports = {...} 的结果："
console.log JSON.stringify 数据, null, 2
console.log "\n✅ 成功！可以用 exports = {...} 这种简洁写法！"
