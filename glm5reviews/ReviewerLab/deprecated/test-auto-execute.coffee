# Test: Can we auto-execute code after class definition?

# 方案1：利用 CoffeeScript 类定义时执行代码
class Base
    console.log "✅ Base class defined"

class Child extends Base
    console.log "✅ Child class defined"

# 方案2：利用全局注册
globalRegistry = []

class AutoBase
    # 尝试在类定义时注册
    @register: ->
        globalRegistry.push(this)
        console.log "📝 Registered: #{@name}"

# 手动注册
AutoBase.register()

class AutoChild extends AutoBase
AutoChild.register()

# 方案3：利用 Object.defineProperty
# 尝试拦截类的创建

console.log "\n=== Registry ==="
console.log globalRegistry.map((c) -> c.name)

# 方案4：利用模块加载后的代码执行
console.log "\n=== After all classes defined ==="
console.log "All classes are defined now, we can scan them!"
