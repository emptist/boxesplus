# 测试 CoffeeScript extended 钩子

class Parent
    @extended: (child) ->
        console.log "Parent.extended: child.name = #{child.name}"
    
    @test: ->
        console.log "Parent.test: @name = #{@name}"

class Child extends Parent
    # 子类定义

# 测试
console.log "\n--- Testing ---"
Parent.test()
Child.test()
