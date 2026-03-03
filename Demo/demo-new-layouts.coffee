# BoxesPlus - 新布局类型演示

{ CourseGenerator, CHARTS } = require "../api/hybrid-generator.coffee"

# 创建课程
课程 = new CourseGenerator("新布局类型演示")

课程
  .addTitle("新布局类型演示", "双栏、图表、代码")
  
  # 标题页
  .addTitle("双栏布局示例", "左右分栏展示")
  
  # 双栏布局
  .addTwoCol(
    "方案对比",
    "传统方案", ["成本高", "周期长", "效果一般"],
    "新方案", ["成本低", "周期短", "效果显著"]
  )
  
  # Mermaid 图表
  .addMermaid("PDCA 循环", CHARTS.pdca)
  
  # 决策流程
  .addMermaid("条件判断流程", CHARTS.decision)
  
  # 时间线
  .addMermaid("项目时间线", CHARTS.timeline)
  
  # 架构图
  .addMermaid("系统架构", CHARTS.architecture)
  
  # 列表
  .addList("核心要点", [
    "支持多种布局类型"
    "双栏对比展示"
    "Mermaid 图表集成"
  ])
  
  # 代码（演示用，实际代码需要转义）
  .addCode("示例代码", "function hello() {\n  console.log('Hello!');\n}", "javascript")

# 生成
{ generate } = require "../api/hybrid-generator.coffee"
await generate(课程, "new-layouts")
console.log "🎉 新布局演示完成!"
