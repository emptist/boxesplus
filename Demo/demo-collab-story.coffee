# BoxesPlus - AI 协作故事演示
# 讲述主项目团队与 Reviewer AI 的协作历程

{ 
  Slide, TitleSlide, ContentSlide, ListSlide, MermaidSlide,
  Section, Presentation, CHARTS,
  PDCA, Timeline, ComparisonSlide
} = require "../api/declarative-api.coffee"

# ============================================
# 第一章：项目起源
# ============================================

class 项目介绍 extends ContentSlide
  @名称: "BoxesPlus - 混合演示文稿生成器"
  @核心理念: "用 Mermaid 创建图表 → 导出 PDF/PPTX"
  @技术栈: "CoffeeScript + PptxGenJS + Puppeteer"

class 团队构成 extends ContentSlide
  @主项目团队: "负责核心功能开发与整合"
  @Reviewer团队: "负责探索与评审"
  @协作模式: "实验 → 整合 → 持续改进"

# ============================================
# 第二章：协作历程
# ============================================

class 时间线 extends Timeline
  @第一天: "Reviewer AI 开始探索声明式 PPTX"
  @第二天: "主项目发现 glm5reviews 文件夹"
  @第三天: "学习并采纳声明式 API 设计"
  @第四天: "修复 bug，添加新图表模板"
  @第五天: "迁移 ComparisonSlide，文档互通"

class 重要时刻 extends ListSlide
  @时刻一: "发现 declarative-pptx-api 项目"
  @时刻二: "修复 HTML 生成 bug"
  @时刻三: "创建 declarative-api.coffee"
  @时刻四: "收到 Reviewer AI 详细评审"
  @时刻五: "回复评审，建立持续对话机制"

# ============================================
# 第三章：成果对比
# ============================================

class 技术对比 extends ComparisonSlide
  @整合前: "仅有基础 OO API\n无声明式支持\n图表模板较少"
  @整合后: "声明式 API\n24+ 图表模板\n自动生成 PPTX"

class 工作流程对比 extends ComparisonSlide
  @整合前: "主项目独立开发\n缺少反馈机制"
  @整合后: "探索-整合循环\nAI 评审协作\n知识共享"

# ============================================
# 第四章：未来展望
# ============================================

class 下一步计划 extends ListSlide
  @短期: "迁移更多幻灯片类型\n优化性能"
  @中期: "主题系统\n动画效果\n共享组件库"
  @长期: "AI 辅助功能\n多格式输出\n云端服务"

class 感谢 extends ContentSlide
  @感谢Reviewer: "感谢详细的代码评审与建议"
  @感谢用户: "感谢使用与反馈"
  @展望未来: "期待更多精彩协作！"

# ============================================
# 章节定义
# ============================================

class 第一章 extends Section
  @slides: -> [
    项目介绍
    团队构成
  ]

class 第二章 extends Section
  @slides: -> [
    时间线
    重要时刻
  ]

class 第三章 extends Section
  @slides: -> [
    技术对比
    工作流程对比
  ]

class 第四章 extends Section
  @slides: -> [
    下一步计划
    感谢
  ]

# ============================================
# 演示文稿
# ============================================

class AI协作故事 extends Presentation
  @sections: -> [
    第一章
    第二章
    第三章
    第四章
  ]
  
  # 自动运行！
  @now: @newPresentation()

console.log "✅ AI 协作故事演示准备就绪!"
