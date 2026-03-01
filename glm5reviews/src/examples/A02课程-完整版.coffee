#!/usr/bin/env coffee

# A02战略规划课程 - 完整版
# 从大纲到PPTX和RevealJS的完整实践

fs = require "fs"
path = require "path"
PptxGenJS = require "pptxgenjs"

# ============================================
# 核心洞察：统一的内容定义，多种输出格式
# ============================================

课程内容 = [
  # 封面
  ["医院战略管理与规划实践", "理论与实践相结合，提升战略思维能力"]
  
  # 课程信息
  ["课程信息", """
课程时长：12小时（2天）
课程对象：医院高层管理者、中层干部、科室主任
教学方法：理论讲授、工具演练、案例分析、实战工作坊
  """]
  
  # 课程目标
  ["课程目标", """
知识目标：掌握战略管理理论与方法
能力目标：能够制定战略规划方案
素质目标：培养战略思维与全局观念
  """]
  
  # 第一模块封面
  ["第一模块", "医院战略管理导论", "理解战略管理的本质与价值"]
  
  # 1.1 战略管理的本质与价值
  ["1.1 战略管理的本质与价值", """
从规模扩张到高质量发展
战略思维 vs 战术思维
战略管理闭环：战略-预算-绩效-运营
  """]
  
  # 战略思维对比（表格）
  {
    类型: "表格"
    标题: "战略思维 vs 战术思维"
    表头: ["维度", "战略思维", "战术思维"]
    数据: [
      ["时间跨度", "3-5年甚至更长", "短期（季度/月度）"]
      ["关注点", "方向性、根本性问题", "具体操作、执行细节"]
      ["决策依据", "外部环境、内部能力", "现有资源、条件约束"]
      ["思维方式", "创造性与前瞻性", "程序性与重复性"]
    ]
  }
  
  # 战略管理闭环（流程）
  {
    类型: "流程"
    标题: "战略管理闭环"
    步骤: ["战略规划", "年度预算", "绩效考核", "运营调整"]
    循环: true
  }
  
  # 1.2 新时期医院面临的挑战
  ["1.2 新时期医院面临的挑战", """
DRG/DIP支付改革冲击
公立医院绩效考核导向
数字化转型与智慧医院建设
分级诊疗与区域医疗中心建设
  """]
  
  # DRG/DIP影响（表格）
  {
    类型: "表格"
    标题: "DRG/DIP支付改革对医院的影响"
    表头: ["维度", "影响", "医院应对"]
    数据: [
      ["收入模式", "从「收入中心」转为「成本中心」", "精细化成本管控"]
      ["诊疗行为", "过度医疗→合理诊疗", "临床路径优化"]
      ["病案质量", "首页质量决定支付金额", "病案质控升级"]
      ["学科发展", "病组结构决定学科定位", "病种结构调整"]
    ]
  }
  
  # 1.3 案例讨论
  ["1.3 案例讨论：某医院战略转型之路", """
案例背景：某三甲医院面临发展困境
现状分析：门诊量109万，出院量7万，面临空间制约、设施陈旧、人才流失
讨论问题：战略转型的关键成功因素有哪些？
  """]
  
  # 第二模块封面
  ["第二模块", "战略分析工具与方法", "掌握战略分析的核心工具"]
  
  # 2.1 外部环境分析
  ["2.1 外部环境分析", """
PESTEL分析法
政治、经济、社会、技术、环境、法律
全面扫描外部环境
  """]
  
  # PESTEL分析框架（表格）
  {
    类型: "表格"
    标题: "PESTEL分析框架"
    表头: ["维度", "关键要素"]
    数据: [
      ["政治（P）", "医改政策、医保政策、行业监管"]
      ["经济（E）", "经济发展水平、居民支付能力、医疗投入"]
      ["社会（S）", "人口老龄化、健康需求变化、就医行为"]
      ["技术（T）", "医疗技术创新、信息技术发展、AI应用"]
      ["环境（E）", "环保要求、绿色发展、医疗废物处理"]
      ["法律（L）", "医疗法规、行业规范、合规要求"]
    ]
  }
  
  # 2.2 内部能力诊断
  ["2.2 内部能力诊断", """
资源与能力分析
人才、技术、设备、品牌
运营能力、专科能力、科研能力
  """]
  
  # SWOT分析
  {
    类型: "结构"
    标题: "SWOT分析框架"
    层级: [
      {
        名称: "内部因素"
        项目: [
          "优势（S）：核心竞争力、特色专科、品牌影响力"
          "劣势（W）：短板与不足、资源约束、管理瓶颈"
        ]
      }
      {
        名称: "外部因素"
        项目: [
          "机会（O）：政策机遇、市场需求、技术进步"
          "威胁（T）：竞争加剧、政策变化、成本上升"
        ]
      }
    ]
  }
  
  # 2.3 综合战略研判
  ["2.3 综合战略研判", """
战略选择矩阵
增长型、防御型、收缩型、稳健型
根据环境与能力选择战略
  """]
  
  # 第三模块封面
  ["第三模块", "战略规划制定", "制定切实可行的战略规划"]
  
  # 3.1 战略定位与愿景设计
  ["3.1 战略定位与愿景设计", """
差异化定位策略
专科布局规划
区域医疗中心建设路径
  """]
  
  # 战略定位三要素
  {
    类型: "结构"
    标题: "战略定位三要素"
    层级: [
      {
        名称: "服务区域"
        项目: ["明确服务范围", "辐射半径分析"]
      }
      {
        名称: "服务人群"
        项目: ["定位目标患者", "患者需求分析"]
      }
      {
        名称: "核心能力"
        项目: ["打造竞争优势", "特色专科建设"]
      }
    ]
  }
  
  # 3.2 战略目标体系构建
  ["3.2 战略目标体系构建", """
平衡计分卡应用
财务、客户、内部流程、学习成长
战略地图绘制
  """]
  
  # 平衡计分卡四维度
  {
    类型: "表格"
    标题: "平衡计分卡四维度"
    表头: ["维度", "关键指标"]
    数据: [
      ["财务维度", "收入增长率、成本控制率、资产负债率"]
      ["客户维度", "患者满意度、市场份额、品牌知名度"]
      ["内部流程", "医疗质量指标、运营效率指标、安全指标"]
      ["学习成长", "人才培养数量、科研产出、创新能力"]
    ]
  }
  
  # 3.3 战略举措与行动计划
  ["3.3 战略举措与行动计划", """
专科发展策略：重点扶持、稳步发展、战略收缩
运营模式创新：门诊精细化管理、日间手术、互联网医院
资源配置优先级：人才、设备、信息化
  """]
  
  # 第四模块封面
  ["第四模块", "战略实施与保障", "确保战略有效落地"]
  
  # 4.1 组织变革与领导力
  ["4.1 组织变革与领导力", """
战略导向的组织架构调整
科室主任战略思维培养
中层管理者战略执行能力
  """]
  
  # 4.2 战略绩效管理体系
  ["4.2 战略绩效管理体系", """
国考指标与医院战略衔接
科室/个人绩效考核设计
战略复盘与动态调整机制
  """]
  
  # 国考指标体系
  {
    类型: "表格"
    标题: "国考指标体系示例"
    表头: ["维度", "关键指标"]
    数据: [
      ["医疗质量", "出院患者手术占比、四级手术占比、微创手术占比"]
      ["运营效率", "平均住院日、床位使用率、药占比"]
      ["持续发展", "科研经费、人才培养、教学任务"]
      ["满意度", "患者满意度、员工满意度"]
    ]
  }
  
  # 4.3 文化建设与战略落地
  ["4.3 文化建设与战略落地", """
战略宣贯与共识凝聚
学习型组织建设
战略沟通机制
  """]
  
  # 第五模块封面
  ["第五模块", "实战工作坊", "学以致用，实战演练"]
  
  # 5.1 小组练习
  ["5.1 小组练习：编制战略简案", """
任务要求：
- 每组4-5人
- 选择一个科室或医院作为对象
- 完成SWOT分析、战略定位、关键举措
  """]
  
  # 5.2 方案展示
  ["5.2 方案展示与互评", """
每组5分钟展示
其他组2分钟提问/点评
讲师点评与优化建议
  """]
  
  # 5.3 讲师点评
  ["5.3 讲师点评维度", """
战略定位清晰度
分析方法规范性
目标设定合理性
举措可操作性
  """]
  
  # 课程总结
  ["课程总结", """
战略管理是医院发展的核心
战略思维需要持续培养
战略执行需要全员参与
  """]
  
  # 结束页
  ["谢谢！", "欢迎交流讨论"]
]

# ============================================
# PPTX渲染器
# ============================================

class PPTX渲染器
  constructor: ->
    @pptx = new PptxGenJS()
    @pptx.layout = "LAYOUT_16x9"
  
  渲染: (内容列表) ->
    内容列表.forEach (内容) => @渲染页面 内容
  
  渲染页面: (内容) ->
    if Array.isArray 内容
      @渲染数组内容 内容
    else if typeof 内容 == "object"
      switch 内容.类型
        when "表格" then @渲染表格 内容
        when "流程" then @渲染流程 内容
        when "结构" then @渲染结构 内容
  
  渲染数组内容: (内容) ->
    slide = @pptx.addSlide()
    
    switch 内容.length
      when 1
        slide.addText 内容[0],
          x: 0.5, y: 2.5, w: 9, h: 1
          fontSize: 44, bold: true, align: "center", color: "2B579A"
      
      when 2
        slide.addText 内容[0],
          x: 0.5, y: 2, w: 9, h: 1
          fontSize: 40, bold: true, align: "center", color: "2B579A"
        slide.addText 内容[1],
          x: 0.5, y: 3.2, w: 9, h: 0.8
          fontSize: 20, align: "center", color: "666666"
      
      when 3
        slide.addText 内容[0],
          x: 0.5, y: 1.5, w: 9, h: 0.6
          fontSize: 20, align: "center", color: "999999"
        slide.addText 内容[1],
          x: 0.5, y: 2.2, w: 9, h: 1
          fontSize: 36, bold: true, align: "center", color: "2B579A"
        slide.addText 内容[2],
          x: 0.5, y: 3.3, w: 9, h: 0.6
          fontSize: 18, align: "center", color: "666666"
  
  渲染表格: (数据) ->
    slide = @pptx.addSlide()
    
    slide.addText 数据.标题,
      x: 0.5, y: 0.3, w: 9, h: 0.6
      fontSize: 28, bold: true, color: "2B579A"
    
    表格数据 = [数据.表头, ...数据.数据]
    
    slide.addTable 表格数据,
      x: 0.5, y: 1.2, w: 9, h: 4
      fontSize: 14
      border: { type: "solid", pt: 1, color: "E0E0E0" }
      fill: { color: "F5F5F5" }
      color: "333333"
  
  渲染流程: (数据) ->
    slide = @pptx.addSlide()
    
    slide.addText 数据.标题,
      x: 0.5, y: 0.3, w: 9, h: 0.6
      fontSize: 28, bold: true, color: "2B579A"
    
    步骤数 = 数据.步骤.length
    步骤宽度 = 8 / 步骤数
    
    for 步骤, 索引 in 数据.步骤
      x = 1 + 索引 * 步骤宽度
      
      slide.addShape "rect",
        x: x, y: 1.8, w: 步骤宽度 - 0.3, h: 0.8
        fill: { color: "2B579A" }
      
      slide.addText 步骤,
        x: x, y: 1.9, w: 步骤宽度 - 0.3, h: 0.6
        fontSize: 14, color: "FFFFFF", align: "center", bold: true
      
      if 索引 < 步骤数 - 1
        slide.addText "→",
          x: x + 步骤宽度 - 0.3, y: 1.9, w: 0.3, h: 0.6
          fontSize: 20, color: "2B579A", align: "center"
    
    if 数据.循环
      slide.addText "↑←←←←←←←←←←←←←←←←←←←←←←←←←↓",
        x: 0.5, y: 2.8, w: 9, h: 0.4
        fontSize: 12, color: "2B579A", align: "center"
  
  渲染结构: (数据) ->
    slide = @pptx.addSlide()
    
    slide.addText 数据.标题,
      x: 0.5, y: 0.3, w: 9, h: 0.6
      fontSize: 28, bold: true, color: "2B579A"
    
    y = 1.2
    
    for 层级 in 数据.层级
      slide.addText 层级.名称,
        x: 0.5, y: y, w: 9, h: 0.5
        fontSize: 18, bold: true, color: "2B579A"
      
      y += 0.5
      
      for 项目 in 层级.项目
        slide.addText "• #{项目}",
          x: 0.8, y: y, w: 8.7, h: 0.4
          fontSize: 14, color: "333333"
        y += 0.4
      
      y += 0.2
  
  保存: (文件名) ->
    @pptx.writeFile({ fileName: 文件名 })
      .then -> console.log "✅ PPTX生成完成：#{文件名}"

# ============================================
# RevealJS渲染器
# ============================================

class RevealJS渲染器
  constructor: (@选项 = {}) ->
    @幻灯片列表 = []
  
  渲染: (内容列表) ->
    内容列表.forEach (内容) => @渲染页面 内容
  
  渲染页面: (内容) ->
    if Array.isArray 内容
      @渲染数组内容 内容
    else if typeof 内容 == "object"
      switch 内容.类型
        when "表格" then @渲染表格 内容
        when "流程" then @渲染流程 内容
        when "结构" then @渲染结构 内容
  
  渲染数组内容: (内容) ->
    switch 内容.length
      when 1
        @幻灯片列表.push """
          <section class="fit">
            <h1>#{内容[0]}</h1>
          </section>
        """
      when 2
        @幻灯片列表.push """
          <section>
            <h1>#{内容[0]}</h1>
            <h3>#{内容[1]}</h3>
          </section>
        """
      when 3
        @幻灯片列表.push """
          <section>
            <h2>#{内容[0]}</h2>
            <h1>#{内容[1]}</h1>
            <h3>#{内容[2]}</h3>
          </section>
        """
  
  渲染表格: (数据) ->
    表头HTML = 数据.表头.map((项) -> "<th>#{项}</th>").join ""
    数据HTML = 数据.数据.map((行) ->
      行单元格 = 行.map((单元格) -> "<td>#{单元格}</td>").join ""
      "<tr>#{行单元格}</tr>"
    ).join ""
    
    @幻灯片列表.push """
      <section>
        <h2>#{数据.标题}</h2>
        <table>
          <thead><tr>#{表头HTML}</tr></thead>
          <tbody>#{数据HTML}</tbody>
        </table>
      </section>
    """
  
  渲染流程: (数据) ->
    步骤HTML = 数据.步骤.map (步骤, 索引) ->
      """
      <div class="step">
        <span class="step-number">#{索引 + 1}</span>
        <span class="step-text">#{步骤}</span>
      </div>
      """
    .join " → "
    
    循环标记 = if 数据.循环 then "<div class='cycle'>↑ 循环优化 ↓</div>" else ""
    
    @幻灯片列表.push """
      <section>
        <h2>#{数据.标题}</h2>
        <div class="flow">#{步骤HTML}</div>
        #{循环标记}
      </section>
    """
  
  渲染结构: (数据) ->
    层级HTML = 数据.层级.map((层级) ->
      项目列表 = 层级.项目.map((项目) -> "<li>#{项目}</li>").join ""
      """
      <div class="level">
        <h3>#{层级.名称}</h3>
        <ul>#{项目列表}</ul>
      </div>
      """
    ).join ""
    
    @幻灯片列表.push """
      <section>
        <h2>#{数据.标题}</h2>
        <div class="structure">#{层级HTML}</div>
      </section>
    """
  
  生成: ->
    """
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="utf-8">
      <title>#{@选项.标题 ? "演示文稿"}</title>
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.5.0/reveal.min.css">
      <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.5.0/theme/black.min.css">
      <style>
        .fit h1 { text-align: center; }
        .flow {
          display: flex;
          justify-content: space-around;
          align-items: center;
          margin-top: 2em;
        }
        .step {
          text-align: center;
          padding: 1em;
          background: rgba(255,255,255,0.1);
          border-radius: 5px;
        }
        .step-number {
          display: block;
          font-size: 2em;
          font-weight: bold;
          color: #42affa;
        }
        .cycle {
          text-align: center;
          margin-top: 1em;
          color: #42affa;
        }
        .structure {
          text-align: left;
          margin-top: 1em;
        }
        .level {
          margin: 1em 0;
        }
        table {
          width: 100%;
          border-collapse: collapse;
          margin-top: 1em;
        }
        th, td {
          border: 1px solid #666;
          padding: 0.5em;
          text-align: left;
        }
        th {
          background: rgba(255,255,255,0.1);
        }
      </style>
    </head>
    <body>
      <div class="reveal">
        <div class="slides">
          #{@幻灯片列表.join "\n"}
        </div>
      </div>
      <script src="https://cdnjs.cloudflare.com/ajax/libs/reveal.js/4.5.0/reveal.min.js"></script>
      <script>
        Reveal.initialize({
          controls: true,
          progress: true,
          transition: 'slide'
        });
      </script>
    </body>
    </html>
    """
  
  保存: (文件名) ->
    html = @生成()
    fs.writeFileSync 文件名, html, "utf-8"
    console.log "✅ RevealJS生成完成：#{文件名}"

# ============================================
# 执行生成
# ============================================

console.log "\n=== A02战略规划课程生成 ===\n"

# 生成PPTX
pptx渲染器 = new PPTX渲染器()
pptx渲染器.渲染 课程内容
pptx渲染器.保存 "../../output/A02战略规划课程.pptx"

# 生成RevealJS
reveal渲染器 = new RevealJS渲染器 标题: "医院战略管理与规划实践"
reveal渲染器.渲染 课程内容
reveal渲染器.保存 "../../output/A02战略规划课程.html"

console.log "\n✅ 课程材料生成完成！"
console.log "   - PPTX: output/A02战略规划课程.pptx"
console.log "   - RevealJS: output/A02战略规划课程.html"

# ============================================
# 反思：实操中的发现
# ============================================

反思 = """
=== 实操反思 ===

1. 内容定义的统一性
   - 相同的课程内容定义
   - 不同的渲染器输出
   - 证明了模式的可行性

2. 复杂页面类型的处理
   - 表格：数据驱动，结构清晰
   - 流程：步骤可视化，循环标记
   - 结构：层级分明，易于理解

3. 医疗内容的严谨性
   - 避免假大空，注重实用性
   - 数据支撑，案例真实
   - 工具方法，可操作性强

4. 发现的问题
   - 表格样式需要优化（颜色、间距）
   - 流程图可以更美观
   - 结构图可以增加视觉层次

5. 改进方向
   - 增加更多页面类型（图表、时间线）
   - 优化样式系统
   - 支持主题切换
   - 增加动画效果
"""

console.log "\n#{反思}"
