# BoxesPlus - 流程图/组织架构图实现
# 使用形状组合实现 ASCII 流程图效果

PptxGenJS = require "pptxgenjs"
{ titleSlide, THEME } = require "../api/boxesplus-artist.coffee"

pres = new PptxGenJS()

# ============ 示例1: PDCA循环 - 使用形状 ============
titleSlide pres,
  title: "PDCA循环 - 形状实现"
  subtitle: "模拟ASCII流程图"
  gradient: "purple"

slide1 = pres.addSlide()
slide1.addText "PDCA循环 - 流程图实现", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true

# PLAN 盒子
slide1.addShape pres.ShapeType.roundRect,
  x: 3.5, y: 1, w: 3, h: 0.8
  fill: { color: THEME.accent }
slide1.addText "PLAN\n计划",
  x: 3.5, y: 1.1, w: 3, h: 0.6
  fontSize: 14, color: "ffffff", align: "center", bold: true

# 向下箭头
slide1.addShape pres.ShapeType.downArrow,
  x: 4.5, y: 1.8, w: 1, h: 0.5
  fill: { color: "666666" }

# DO 盒子
slide1.addShape pres.ShapeType.roundRect,
  x: 3.5, y: 2.3, w: 3, h: 0.8
  fill: { color: THEME.success }
slide1.addText "DO\n执行",
  x: 3.5, y: 2.4, w: 3, h: 0.6
  fontSize: 14, color: "ffffff", align: "center", bold: true

# 向下箭头
slide1.addShape pres.ShapeType.downArrow,
  x: 4.5, y: 3.1, w: 1, h: 0.5
  fill: { color: "666666" }

# CHECK 盒子
slide1.addShape pres.ShapeType.roundRect,
  x: 3.5, y: 3.6, w: 3, h: 0.8
  fill: { color: THEME.warning }
slide1.addText "CHECK\n检查",
  x: 3.5, y: 3.7, w: 3, h: 0.6
  fontSize: 14, color: "ffffff", align: "center", bold: true

# 向下箭头
slide1.addShape pres.ShapeType.downArrow,
  x: 4.5, y: 4.4, w: 1, h: 0.5
  fill: { color: "666666" }

# ACTION 盒子
slide1.addShape pres.ShapeType.roundRect,
  x: 3.5, y: 4.9, w: 3, h: 0.8
  fill: { color: THEME.danger }
slide1.addText "ACTION\n处理",
  x: 3.5, y: 5, w: 3, h: 0.6
  fontSize: 14, color: "ffffff", align: "center", bold: true

# 循环箭头 - 从 ACTION 回到 PLAN
slide1.addShape pres.ShapeType.curvedRightArrow,
  x: 1.5, y: 4, w: 2, h: 2
  fill: { color: "3182ce" }
slide1.addText "循环",
  x: 1.8, y: 4.5, w: 1.5, h: 0.5
  fontSize: 10, color: "ffffff", align: "center"

# ============ 示例2: 组织架构图 ============
titleSlide pres,
  title: "组织架构图 - 形状实现"
  subtitle: "层级结构"
  gradient: "purple"

slide2 = pres.addSlide()
slide2.addText "医院质量组织架构", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true

# 顶层 - 院长
slide2.addShape pres.ShapeType.roundRect,
  x: 3.5, y: 0.8, w: 3, h: 0.7
  fill: { color: THEME.primary }
slide2.addText "院长/书记",
  x: 3.5, y: 0.9, w: 3, h: 0.5
  fontSize: 14, color: "ffffff", align: "center", bold: true

# 连接线
slide2.addShape pres.ShapeType.line,
  x: 5, y: 1.5, w: 0, h: 0.3
  line: { color: "666666", width: 2 }

# 第二层 - 职能科室
slide2.addShape pres.ShapeType.roundRect,
  x: 1, y: 1.8, w: 2.2, h: 0.6
  fill: { color: THEME.accent }
slide2.addText "质控部",
  x: 1, y: 1.9, w: 2.2, h: 0.4
  fontSize: 12, color: "ffffff", align: "center"

slide2.addShape pres.ShapeType.roundRect,
  x: 3.9, y: 1.8, w: 2.2, h: 0.6
  fill: { color: THEME.accent }
slide2.addText "医务部",
  x: 3.9, y: 1.9, w: 2.2, h: 0.4
  fontSize: 12, color: "ffffff", align: "center"

slide2.addShape pres.ShapeType.roundRect,
  x: 6.8, y: 1.8, w: 2.2, h: 0.6
  fill: { color: THEME.accent }
slide2.addText "护理部",
  x: 6.8, y: 1.9, w: 2.2, h: 0.4
  fontSize: 12, color: "ffffff", align: "center"

# 连接线到第三层
slide2.addShape pres.ShapeType.line,
  x: 2.2, y: 2.4, w: 0, h: 0.3
  line: { color: "666666", width: 1 }
slide2.addShape pres.ShapeType.line,
  x: 5, y: 2.4, w: 0, h: 0.3
  line: { color: "666666", width: 1 }
slide2.addShape pres.ShapeType.line,
  x: 7.9, y: 2.4, w: 0, h: 0.3
  line: { color: "666666", width: 1 }

# 第三层 - 科室
slide2.addShape pres.ShapeType.rect,
  x: 0.3, y: 2.7, w: 1.8, h: 0.5
  fill: { color: THEME.success }
slide2.addText "质控科",
  x: 0.3, y: 2.8, w: 1.8, h: 0.3
  fontSize: 10, color: "ffffff", align: "center"

slide2.addShape pres.ShapeType.rect,
  x: 2.3, y: 2.7, w: 1.8, h: 0.5
  fill: { color: THEME.success }
slide2.addText "医务科",
  x: 2.3, y: 2.8, w: 1.8, h: 0.3
  fontSize: 10, color: "ffffff", align: "center"

slide2.addShape pres.ShapeType.rect,
  x: 4.3, y: 2.7, w: 1.8, h: 0.5
  fill: { color: THEME.success }
slide2.addText "院感科",
  x: 4.3, y: 2.8, w: 1.8, h: 0.3
  fontSize: 10, color: "ffffff", align: "center"

slide2.addShape pres.ShapeType.rect,
  x: 6.3, y: 2.7, w: 1.8, h: 0.5
  fill: { color: THEME.success }
slide2.addText "护理部",
  x: 6.3, y: 2.8, w: 1.8, h: 0.3
  fontSize: 10, color: "ffffff", align: "center"

slide2.addShape pres.ShapeType.rect,
  x: 8.3, y: 2.7, w: 1.4, h: 0.5
  fill: { color: THEME.success }
slide2.addText "其他",
  x: 8.3, y: 2.8, w: 1.4, h: 0.3
  fontSize: 10, color: "ffffff", align: "center"

# ============ 示例3: 流程图 - 决策 diamond ============
titleSlide pres,
  title: "流程图 - 菱形判断"
  subtitle: "使用菱形"
  gradient: "purple"

slide3 = pres.addSlide()
slide3.addText "患者就诊流程", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true

# 开始
slide3.addShape pres.ShapeType.ellipse,
  x: 0.5, y: 1, w: 1.5, h: 0.7
  fill: { color: THEME.success }
slide3.addText "开始",
  x: 0.5, y: 1.2, w: 1.5, h: 0.4
  fontSize: 12, color: "ffffff", align: "center"

# 箭头
slide3.addShape pres.ShapeType.rightArrow,
  x: 2, y: 1.3, w: 1, h: 0.3
  fill: { color: "666666" }

# 判断菱形
slide3.addShape pres.ShapeType.diamond,
  x: 3.2, y: 1, w: 2, h: 1
  fill: { color: THEME.warning }
slide3.addText "是否急诊?",
  x: 3.2, y: 1.3, w: 2, h: 0.6
  fontSize: 11, color: "ffffff", align: "center"

# 是分支
slide3.addShape pres.ShapeType.rightArrow,
  x: 5.2, y: 1.3, w: 0.8, h: 0.3
  fill: { color: "666666" }
slide3.addText "是",
  x: 5.3, y: 1.1, w: 0.5, h: 0.3
  fontSize: 10, color: "333333"

slide3.addShape pres.ShapeType.roundRect,
  x: 6.2, y: 1, w: 2, h: 0.6
  fill: { color: THEME.danger }
slide3.addText "急诊处理",
  x: 6.2, y: 1.1, w: 2, h: 0.4
  fontSize: 12, color: "ffffff", align: "center"

# 否分支 - 向下
slide3.addShape pres.ShapeType.rightArrow,
  x: 4.2, y: 2, w: 0.3, h: 0.5
  fill: { color: "666666" }
slide3.addText "否",
  x: 4.4, y: 2.1, w: 0.5, h: 0.3
  fontSize: 10, color: "333333"

slide3.addShape pres.ShapeType.roundRect,
  x: 3.7, y: 2.5, w: 2, h: 0.6
  fill: { color: THEME.accent }
slide3.addText "门诊挂号",
  x: 3.7, y: 2.6, w: 2, h: 0.4
  fontSize: 12, color: "ffffff", align: "center"

# 箭头向下
slide3.addShape pres.ShapeType.downArrow,
  x: 4.5, y: 3.1, w: 0.5, h: 0.5
  fill: { color: "666666" }

slide3.addShape pres.ShapeType.roundRect,
  x: 3.7, y: 3.6, w: 2, h: 0.6
  fill: { color: THEME.secondary }
slide3.addText "诊疗",
  x: 3.7, y: 3.7, w: 2, h: 0.4
  fontSize: 12, color: "ffffff", align: "center"

# 结束
slide3.addShape pres.ShapeType.downArrow,
  x: 4.5, y: 4.2, w: 0.5, h: 0.5
  fill: { color: "666666" }

slide3.addShape pres.ShapeType.ellipse,
  x: 3.7, y: 4.7, w: 2, h: 0.7
  fill: { color: THEME.success }
slide3.addText "结束",
  x: 3.7, y: 4.9, w: 2, h: 0.4
  fontSize: 12, color: "ffffff", align: "center"

# ============ 示例4: 泳道图 ============
titleSlide pres,
  title: "泳道图 - 多部门流程"
  subtitle: "使用形状分隔"
  gradient: "purple"

slide4 = pres.addSlide()
slide4.addText "门诊就诊流程 - 泳道图", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true

# 泳道分隔线 - 垂直线
slide4.addShape pres.ShapeType.line,
  x: 3, y: 0.9, w: 0, h: 5
  line: { color: "cccccc", width: 2, dashType: "dash" }

slide4.addShape pres.ShapeType.line,
  x: 6, y: 0.9, w: 0, h: 5
  line: { color: "cccccc", width: 2, dashType: "dash" }

# 泳道标题
slide4.addText "患者", x: 0.5, y: 1, w: 2.5, h: 0.4, fontSize: 14, bold: true, color: THEME.primary, align: "center"
slide4.addText "护士", x: 3.3, y: 1, w: 2.5, h: 0.4, fontSize: 14, bold: true, color: THEME.primary, align: "center"
slide4.addText "医生", x: 6.3, y: 1, w: 2.5, h: 0.4, fontSize: 14, bold: true, color: THEME.primary, align: "center"

# 患者流程
slide4.addShape pres.ShapeType.roundRect,
  x: 0.3, y: 1.5, w: 2, h: 0.5
  fill: { color: THEME.accent }
slide4.addText "挂号", x: 0.3, y: 1.6, w: 2, h: 0.3, fontSize: 10, color: "ffffff", align: "center"

slide4.addShape pres.ShapeType.rightArrow,
  x: 2.3, y: 1.7, w: 0.5, h: 0.2
  fill: { color: "666666" }

slide4.addShape pres.ShapeType.roundRect,
  x: 0.3, y: 2.2, w: 2, h: 0.5
  fill: { color: THEME.accent }
slide4.addText "候诊", x: 0.3, y: 2.3, w: 2, h: 0.3, fontSize: 10, color: "ffffff", align: "center"

# 护士流程
slide4.addShape pres.ShapeType.roundRect,
  x: 3.3, y: 1.5, w: 2, h: 0.5
  fill: { color: THEME.success }
slide4.addText "分诊", x: 3.3, y: 1.6, w: 2, h: 0.3, fontSize: 10, color: "ffffff", align: "center"

slide4.addShape pres.ShapeType.rightArrow,
  x: 5.3, y: 1.7, w: 0.5, h: 0.2
  fill: { color: "666666" }

slide4.addShape pres.ShapeType.roundRect,
  x: 3.3, y: 2.2, w: 2, h: 0.5
  fill: { color: THEME.success }
slide4.addText "测量生命体征", x: 3.3, y: 2.3, w: 2, h: 0.3, fontSize: 9, color: "ffffff", align: "center"

# 医生流程
slide4.addShape pres.ShapeType.roundRect,
  x: 6.3, y: 1.5, w: 2, h: 0.5
  fill: { color: THEME.warning }
slide4.addText "问诊", x: 6.3, y: 1.6, w: 2, h: 0.3, fontSize: 10, color: "ffffff", align: "center"

slide4.addShape pres.ShapeType.rightArrow,
  x: 8.3, y: 1.7, w: 0.5, h: 0.2
  fill: { color: "666666" }

slide4.addShape pres.ShapeType.roundRect,
  x: 6.3, y: 2.2, w: 2, h: 0.5
  fill: { color: THEME.warning }
slide4.addText "检查治疗", x: 6.3, y: 2.3, w: 2, h: 0.3, fontSize: 10, color: "ffffff", align: "center"

slide4.addShape pres.ShapeType.rightArrow,
  x: 8.3, y: 2.7, w: 0.5, h: 0.2
  fill: { color: "666666" }

slide4.addShape pres.ShapeType.roundRect,
  x: 6.3, y: 2.9, w: 2, h: 0.5
  fill: { color: THEME.danger }
slide4.addText "诊断书写", x: 6.3, y: 3, w: 2, h: 0.3, fontSize: 10, color: "ffffff", align: "center"

# ============ 示例5: 层次结构图 ============
titleSlide pres,
  title: "层次结构 - 复杂流程"
  subtitle: "使用多种形状"
  gradient: "purple"

slide5 = pres.addSlide()
slide5.addText "质量管理体系 - 层次图", x: 0.5, y: 0.3, w: 9, h: 0.6, fontSize: 28, bold: true

# 顶层
slide5.addShape pres.ShapeType.roundRect,
  x: 2.5, y: 0.8, w: 5, h: 0.6
  fill: { color: THEME.primary }
slide5.addText "医院质量委员会",
  x: 2.5, y: 0.9, w: 5, h: 0.4
  fontSize: 14, color: "ffffff", align: "center", bold: true

# 连接线
slide5.addShape pres.ShapeType.downArrow,
  x: 4.75, y: 1.4, w: 0.5, h: 0.3
  fill: { color: "666666" }

# 第二层 - 3个部门
slide5.addShape pres.ShapeType.roundRect,
  x: 0.3, y: 1.7, w: 2.5, h: 0.6
  fill: { color: THEME.accent }
slide5.addText "质量管理部",
  x: 0.3, y: 1.8, w: 2.5, h: 0.4
  fontSize: 12, color: "ffffff", align: "center"

slide5.addShape pres.ShapeType.roundRect,
  x: 3.75, y: 1.7, w: 2.5, h: 0.6
  fill: { color: THEME.success }
slide5.addText "医务管理部",
  x: 3.75, y: 1.8, w: 2.5, h: 0.4
  fontSize: 12, color: "ffffff", align: "center"

slide5.addShape pres.ShapeType.roundRect,
  x: 7.2, y: 1.7, w: 2.5, h: 0.6
  fill: { color: THEME.warning }
slide5.addText "护理管理部",
  x: 7.2, y: 1.8, w: 2.5, h: 0.4
  fontSize: 12, color: "ffffff", align: "center"

# 连接线到第三层
slide5.addShape pres.ShapeType.line,
  x: 1.55, y: 2.3, w: 0, h: 0.3
  line: { color: "666666", width: 1 }
slide5.addShape pres.ShapeType.line,
  x: 5, y: 2.3, w: 0, h: 0.3
  line: { color: "666666", width: 1 }
slide5.addShape pres.ShapeType.line,
  x: 8.45, y: 2.3, w: 0, h: 0.3
  line: { color: "666666", width: 1 }

# 第三层 - 具体科室
slide5.addShape pres.ShapeType.rect,
  x: 0.3, y: 2.6, w: 2.5, h: 0.5
  fill: { color: THEME.secondary }
slide5.addText "质控科/安全科/纠纷科",
  x: 0.3, y: 2.7, w: 2.5, h: 0.3
  fontSize: 9, color: "ffffff", align: "center"

slide5.addShape pres.ShapeType.rect,
  x: 3.75, y: 2.6, w: 2.5, h: 0.5
  fill: { color: THEME.secondary }
slide5.addText "医务科/质控科/院感科",
  x: 3.75, y: 2.7, w: 2.5, h: 0.3
  fontSize: 9, color: "ffffff", align: "center"

slide5.addShape pres.ShapeType.rect,
  x: 7.2, y: 2.6, w: 2.5, h: 0.5
  fill: { color: THEME.secondary }
slide5.addText "护理部/供应室/院感",
  x: 7.2, y: 2.7, w: 2.5, h: 0.3
  fontSize: 9, color: "ffffff", align: "center"

# 第四层 - 科室质控小组
slide5.addShape pres.ShapeType.line,
  x: 1.55, y: 3.1, w: 0, h: 0.3
  line: { color: "666666", width: 1 }
slide5.addShape pres.ShapeType.line,
  x: 5, y: 3.1, w: 0, h: 0.3
  line: { color: "666666", width: 1 }
slide5.addShape pres.ShapeType.line,
  x: 8.45, y: 3.1, w: 0, h: 0.3
  line: { color: "666666", width: 1 }

slide5.addShape pres.ShapeType.rect,
  x: 0.3, y: 3.4, w: 9.3, h: 0.5
  fill: { color: THEME.muted }
slide5.addText "各临床/医技科室质控小组",
  x: 0.3, y: 3.5, w: 9.3, h: 0.3
  fontSize: 12, color: "ffffff", align: "center"

# 保存
pres.writeFile({ fileName: "outputs/demo-flowchart-shapes.pptx" })
  .then -> console.log "✅ Created: outputs/demo-flowchart-shapes.pptx"
  .catch (err) -> console.error err
