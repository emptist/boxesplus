# 测试 CoffeeScript 继承机制

class Parent
    @test: ->
        console.log "Parent.test: @name = #{@name}"
    
    # 这行代码在类定义时执行
    @autoRun: console.log "Parent.autoRun: @name = #{@name}" if @name?

class Child extends Parent
    # 子类定义

# 测试
console.log "\n--- Testing ---"
Parent.test()
Child.test()
