# Test: How to get class name in CoffeeScript

class MyClass
    @test: ->
        console.log "@constructor:", @constructor
        console.log "@constructor.name:", @constructor.name
        console.log "@name:", @name
        console.log "this:", this
        console.log "this.name:", this.name
        console.log "this.constructor:", this.constructor
        console.log "this.constructor.name:", this.constructor?.name

console.log "\n=== Testing class name access ==="
MyClass.test()

console.log "\n=== Direct access ==="
console.log "MyClass.name:", MyClass.name
console.log "MyClass.constructor:", MyClass.constructor
console.log "MyClass.constructor.name:", MyClass.constructor?.name

class ChildClass extends MyClass
    @test2: ->
        console.log "\n=== Child class ==="
        console.log "@name:", @name
        console.log "this.name:", this.name

ChildClass.test2()
console.log "ChildClass.name:", ChildClass.name
