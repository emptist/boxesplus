# C01 医疗质量与安全管理课程 - 使用声明式 API v2
# 用法: coffee Demo/generate-C01-v2.coffee

{ 
  Presentation, Section, Chapter, Node, Slide,
  ContentSlide, ListSlide, ComparisonSlide, MermaidSlide,
  PDCA, SWOT, Timeline
} = require "../api/declarative-v2.coffee"

# ============================================
# 封面幻灯片
# ============================================

class 医疗质量与安全管理 extends Slide
  @layout: "title"
  @style: "title"

class 课程信息 extends ContentSlide
  @课程定位: "医院管理运营与质量模块课程（核心课程）"
  @课程对象: "院长、分管副院长、质控部主任、医务部主任"
  @教学方法: "理论讲授、方法演练、案例分析、实操练习"

class 课程目标 extends ContentSlide
  @知识目标: "掌握医疗质量管理体系构成与运作机制\n熟悉质量管理工具与方法\n了解患者安全目标与措施"
  @能力目标: "建立完善质量管理体系\n运用质量管理工具分析改进\n有效处理质量安全事件"
  @素质目标: "树立质量第一、安全至上理念\n提升质量管理专业化能力"

# ============================================
# 章节：医疗质量管理概述
# ============================================

class 医疗质量管理概述 extends Section
  @including: [
    class 医疗质量概念 extends ContentSlide
      @内涵: "结构质量、过程质量、结果质量"
      @特点: "高度专业、高度风险、高度不确定性"
      @影响: "患者生命、医院生存、社会和谐"
    
    class 质量管理体系 extends ContentSlide
      @体系架构: "决策层、管理层、执行层"
      @组织架构: "质量管理委员会、质控部门、科室质控小组"
      @制度体系: "制度、规范、流程、预案"
    
    class 管理趋势 extends ListSlide
      @经验到科学: "用数据说话，用工具分析"
      @结果到过程: "过程控制比事后补救更有效"
      @单体到系统: "全院一盘棋、体系化运作"
    
    class 质量关联 extends ComparisonSlide
      @前置: "信息化是基础\n数据资产是前提"
      @共生: "与流程优化关联\n与医保管理关联\n与绩效管理关联"
  ]

# ============================================
# 章节：患者安全
# ============================================

class 患者安全 extends Section
  @including: [
    class 患者安全目标 extends ListSlide
      @目标一: "正确识别患者身份"
      @目标二: "强化手术安全核查"
      @目标三: "提高用药安全"
      @目标四: "预防院内感染"
      @目标五: "鼓励不良事件上报"
    
    class 安全措施 extends ContentSlide
      @身份识别: "双人核对、反问确认"
      @手术安全: "Time-out制度、手术核查单"
      @用药安全: "双人核对、高危药品管理"
      @院感防控: "手卫生、标准预防"
    
    class 患者安全SWOT extends SWOT
  ]

# ============================================
# 章节：质量管理与工具
# ============================================

class 质量管理与工具 extends Section
  @including: [
    class 质量管理工具 extends ListSlide
      @PDCA: "计划-执行-检查-处理"
      @FMEA: "失效模式与效应分析"
      @RCA: "根因分析法"
      @QCC: "品管圈"
    
    class PDCA循环 extends PDCA
    
    class 质量指标 extends ContentSlide
      @指标类别: "结构指标、过程指标、结果指标"
      @国考指标: "医疗质量、运营效率、持续发展"
      @DRG指标: "CMI、时间消耗指数、费用消耗指数"
  ]

# ============================================
# 章节：案例研讨
# ============================================

class 案例研讨 extends Section
  @including: [
    class 案例一 extends ContentSlide
      @案例: "某三甲医院质控体系建设"
      @举措: "建立三级质控网络\n完善制度流程\n引入信息系统"
      @成效: "医疗纠纷下降40%，满意度提升"
    
    class 案例二 extends ContentSlide
      @案例: "不良事件管理实践"
      @举措: "建立上报系统\n分析根因\n制定整改措施"
      @成效: "同类型事件下降60%"
  ]

# ============================================
# 总结
# ============================================

class 课程总结 extends Section
  @including: [
    class 核心要点 extends ComparisonSlide
      @体系建设: "三级质控网络"
      @工具应用: "PDCA、FMEA、RCA"
      @患者安全: "十大安全目标"
      @数据驱动: "指标监测、持续改进"
    
    class 结束页 extends ContentSlide
      @感谢: "感谢学习！"
      @目标: "质量第一，安全至上"
      @行动: "建立体系，用好工具，持续改进"
  ]

# ============================================
# 演示文稿
# ============================================

class C01医疗质量与安全管理课程 extends Presentation
  @theme: "medical"
  @including: [
    医疗质量与安全管理
    课程信息
    课程目标
    医疗质量管理概述
    患者安全
    质量管理与工具
    案例研讨
    课程总结
  ]
  
  @now: @newPresentation()

console.log "✅ C01医疗质量与安全管理课程准备就绪!"
