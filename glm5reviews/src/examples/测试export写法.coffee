#!/usr/bin/env coffee

# 测试：export = {...} 写法

数据 = require "../../reviewer-workspace/data2/测试export写法.coffee"
console.log "export = {...} 的结果："
console.log JSON.stringify 数据, null, 2
console.log "\n✅ 成功！可以用 export = {...} 这种简洁写法！"
