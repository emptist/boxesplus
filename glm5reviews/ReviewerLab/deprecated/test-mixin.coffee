# CoffeeScript Mixin Test
# 测试 CoffeeScript 对 mixin 的支持

# ============================================
# 测试1：基本的静态属性和方法
# ============================================
console.log "\n=== Test 1: Static Properties and Methods ==="

class BaseClass
  @staticProp: "I am static"
  @staticMethod: -> "Static method called"
  
  instanceMethod: -> "Instance method called"

console.log "Static property:", BaseClass.staticProp
console.log "Static method:", BaseClass.staticMethod()
console.log "Instance method:", new BaseClass().instanceMethod()

# ============================================
# 测试2：使用 Object.assign 实现 mixin
# ============================================
console.log "\n=== Test 2: Object.assign Mixin ==="

AnimationMixin =
  fadeIn: -> @animation = "fade"; this
  slideIn: -> @animation = "slide"; this
  zoomIn: -> @animation = "zoom"; this

ThemeMixin =
  blueTheme: -> @theme = "blue"; this
  greenTheme: -> @theme = "green"; this

class Slide
  @animation: null
  @theme: null
  
  # 使用 Object.assign 混入
  @extend: (mixin) ->
    Object.assign this, mixin
    this

# 应用 mixin
Object.assign Slide, AnimationMixin
Object.assign Slide, ThemeMixin

console.log "Before mixin:", Slide.animation, Slide.theme
Slide.fadeIn().blueTheme()
console.log "After mixin:", Slide.animation, Slide.theme

# ============================================
# 测试3：继承链中的 mixin
# ============================================
console.log "\n=== Test 3: Mixin in Inheritance Chain ==="

class BaseSlide
  @layout: "default"
  @animation: null
  @theme: null
  
  @extend: (mixin) ->
    Object.assign this, mixin
    this
  
  @validate: -> true

class CardsSlide extends BaseSlide
  @layout: "cards"
  @columns: 2
  @cards: []
  
  @validate: -> @cards.length > 0

# 应用 mixin
CardsSlide.extend(AnimationMixin).extend(ThemeMixin)

console.log "CardsSlide.layout:", CardsSlide.layout
console.log "CardsSlide.columns:", CardsSlide.columns
CardsSlide.fadeIn().greenTheme()
console.log "CardsSlide after mixin:", CardsSlide.animation, CardsSlide.theme

# ============================================
# 测试4：实例级别的 mixin
# ============================================
console.log "\n=== Test 4: Instance-level Mixin ==="

InstanceMixin =
  sayHello: -> "Hello from #{@name}"
  sayGoodbye: -> "Goodbye from #{@name}"

class Person
  constructor: (@name) ->
  
  @include: (mixin) ->
    Object.assign @prototype, mixin
    this

Person.include(InstanceMixin)

person = new Person("Alice")
console.log person.sayHello()
console.log person.sayGoodbye()

# ============================================
# 测试5：静态属性继承
# ============================================
console.log "\n=== Test 5: Static Property Inheritance ==="

class Parent
  @staticValue: "parent"
  @staticMethod: -> "parent method"
  
  @updateStatic: (value) ->
    @staticValue = value
    this

class Child extends Parent
  @staticValue: "child"  # 覆盖父类静态属性

console.log "Parent.staticValue:", Parent.staticValue
console.log "Child.staticValue:", Child.staticValue
console.log "Child.staticMethod():", Child.staticMethod()

Child.updateStatic("updated child")
console.log "After update - Child.staticValue:", Child.staticValue
console.log "After update - Parent.staticValue:", Parent.staticValue

# ============================================
# 测试6：链式调用
# ============================================
console.log "\n=== Test 6: Chained Calls ==="

class FluentSlide
  @title: ""
  @theme: ""
  @animation: ""
  
  @setTitle: (title) ->
    @title = title
    this
  
  @setTheme: (theme) ->
    @theme = theme
    this
  
  @setAnimation: (animation) ->
    @animation = animation
    this
  
  @render: ->
    title: @title
    theme: @theme
    animation: @animation

result = FluentSlide
  .setTitle("My Slide")
  .setTheme("blue")
  .setAnimation("fade")
  .render()

console.log "Fluent result:", result

# ============================================
# 测试7：验证 mixin 不会污染原型链
# ============================================
console.log "\n=== Test 7: Mixin Does Not Pollute Prototype ==="

TestMixin =
  mixinMethod: -> "mixin method"

class TestClass
  @extend: (mixin) ->
    Object.assign this, mixin
    this

TestClass.extend(TestMixin)

console.log "Static method exists:", TestClass.mixinMethod?
try
  instance = new TestClass()
  console.log "Instance method exists:", instance.mixinMethod?
catch error
  console.log "Instance method check error:", error.message

# ============================================
# 总结
# ============================================
console.log "\n=== Summary ==="
console.log """
✅ CoffeeScript 支持:
  1. 静态属性和方法 (@property, @method)
  2. 静态方法继承
  3. Object.assign 实现 mixin
  4. 链式调用
  5. 实例级别 mixin (通过 prototype)
  6. 静态属性覆盖

⚠️ 注意事项:
  1. 静态属性在继承时会被共享（除非显式覆盖）
  2. mixin 不会自动继承到子类
  3. 需要手动实现 @extend 方法
"""
