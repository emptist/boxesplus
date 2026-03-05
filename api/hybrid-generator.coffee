# BoxesPlus - 混合生成器
# 整合自 AI 朋友的探索 + 我们的实践
# 简单内容 → PPTX直接生成
# 复杂内容（Mermaid图表）→ HTML生成 → 转换为PDF

fs = require "fs"
path = require "path"
puppeteer = require "puppeteer"
PptxGenJS = require "pptxgenjs"

# ============================================
# 预定义 Mermaid 图表模板
# ============================================

CHARTS =
  pdca: """
flowchart LR
    P[PLAN<br/>计划] --> D[DO<br/>执行]
    D --> C[CHECK<br/>检查]
    C --> A[ACTION<br/>处理]
    A -.->|改进| P
    style P fill:#3182ce,color:#fff
    style D fill:#38a169,color:#fff
    style C fill:#d69e2e,color:#fff
    style A fill:#e53e3e,color:#fff
"""

  pareto: """
pie title 二八法则
    "核心问题" : 80
    "次要问题" : 20
"""

  eventLoop: """
flowchart LR
    A[事件报告] --> B[原因分析]
    B --> C[整改措施]
    C --> D[效果评估]
    D -.->|改进| A
    style A fill:#bee3f8,stroke:#3182ce
    style B fill:#e9d8fd,stroke:#805ad5
    style C fill:#c6f6d5,stroke:#38a169
    style D fill:#feebc8,stroke:#d69e2e
"""

  dataLifecycle: """
flowchart LR
    A[采集] --> B[存储] --> C[处理] --> D[分析] --> E[应用]
    style A fill:#4299e1,color:#fff
    style B fill:#48bb78,color:#fff
    style C fill:#ed8936,color:#fff
    style D fill:#9f7aea,color:#fff
    style E fill:#f56565,color:#fff
"""

  brandPyramid: """
flowchart LR
    A[文化品牌] --> B[技术品牌]
    A --> C[服务品牌]
    B & C --> D[视觉识别]
    style A fill:#805ad5,color:#fff
    style B fill:#3182ce,color:#fff
    style C fill:#38a169,color:#fff
    style D fill:#d69e2e,color:#fff
"""

  # 质量管理体系 - 简化版 LR
  qualitySystem: """
flowchart LR
    方针[质量方针] --> 组织[质量组织]
    目标[质量目标] --> 制度[质量制度]
    文化[质量文化] --> 流程[质量流程]
    组织 --> 控制[质量控制]
    制度 --> 保证[质量保证]
    style 方针,目标,文化 fill:#e6f3ff,stroke:#3182ce
    style 组织,制度,流程 fill:#e6ffed,stroke:#38a169
    style 控制,保证,改进 fill:#fffaf0,stroke:#d69e2e
"""

  # 患者安全目标
  patientSafety: """
flowchart LR
    G1[正确识别] --> G2[手术核查]
    G3[用药安全] --> G4[提升水平]
    G5[院感防控] --> G6[不良报告]
    G7[跌倒预防] --> G8[器械监管]
    style G1,G2 fill:#bee3f8,stroke:#3182ce
    style G3,G4 fill:#c6f6d5,stroke:#38a169
    style G5 fill:#feebc8,stroke:#d69e2e
    style G6,G7,G8 fill:#e9d8fd,stroke:#805ad5
"""

  # SWOT分析
  swot: """
flowchart LR
    S1[技术领先] & S2[专家团队]
    W1[传播不足] & W2[新媒体弱]
    O1[政策支持] & O2[市场需求]
    T1[竞争激烈] & T2[舆论风险]
    style S1,S2 fill:#c6f6d5,stroke:#38a169
    style W1,W2 fill:#fed7d7,stroke:#e53e3e
    style O1,O2 fill:#bee3f8,stroke:#3182ce
    style T1,T2 fill:#feebc8,stroke:#d69e2e
"""

  # 围手术期
  surgery: """
flowchart LR
    P1[手术指征] --> P2[知情同意] --> P3[术前核查]
    I1[安全核查] --> I2[手术操作] --> I3[记录规范]
    A1[术后交接] --> A2[术后访视] --> A3[并发症防治]
    P3 --> I1
    I3 --> A1
    style P1,P2,P3 fill:#bee3f8,stroke:#3182ce
    style I1,I2,I3 fill:#feebc8,stroke:#d69e2e
    style A1,A2,A3 fill:#c6f6d5,stroke:#38a169
"""

  # 学科评估
  evaluation: """
flowchart LR
    评估[学科评估] --> 质量 & 科研 & 人才 & 声誉
    质量 --> 治愈[治愈率] & 感染[感染率]
    科研 --> 论文[论文数量] & 课题[课题]
    人才 --> 学历[学历结构] & 带头[学科带头人]
    声誉 --> 任职[学术任职] & 满意[患者满意度]
    style 评估 fill:#1a365d,color:#fff
    style 质量,科研,人才,声誉 fill:#2c5282,color:#fff
    style 治愈,感染,论文,课题,学历,带头,任职,满意 fill:#f7fafc,stroke:#ccc
"""

  # 时间线
  timeline: """
gantt
    title 项目时间线
    dateFormat  YYYY-MM-DD
    section 阶段一
    需求分析       :a1, 2024-01-01, 30d
    设计方案       :a2, after a1, 20d
    section 阶段二
    开发实现       :b1, after a2, 45d
    测试验收       :b2, after b1, 15d
    section 阶段三
    部署上线       :c1, after b2, 10d
    培训支持       :c2, after c1, 7d
"""

  # 思维导图
  mindmap: """
mindmap
  root((中心主题))
    分支一
      子主题A
      子主题B
    分支二
      子主题C
      子主题D
    分支三
      子主题E
"""

  # 甘特图简化版
  ganttSimple: """
gantt
    title 工作计划
    dateFormat  HH:mm
    09:00-12:00 : task1, 09:00, 3h
    14:00-17:00 : task2, 14:00, 3h
    18:00-20:00 : task3, 18:00, 2h
"""

  # 流程图 - 决策
  decision: """
flowchart TD
    A[开始] --> B{条件判断}
    B -->|是| C[处理A]
    B -->|否| D[处理B]
    C --> E[输出结果]
    D --> E
    E --> F[结束]
    style A fill:#3182ce,color:#fff
    style B fill:#d69e2e,color:#fff
    style E fill:#38a169,color:#fff
    style F fill:#e53e3e,color:#fff
"""

  # 用户旅程
  userJourney: """
journey
    title 用户旅程
    section 阶段一
      访问网站: 5: 用户1, 用户2
      浏览产品: 4: 用户1, 用户2
    section 阶段二
      加入购物车: 3: 用户1
      填写订单: 3: 用户1
    section 阶段三
      支付: 2: 用户1
      收到商品: 5: 用户1
"""

  # Git图
  gitGraph: """
gitGraph
   commit id: "初始版本"
   branch feature1
   commit id: "功能开发"
   commit id: "功能完成"
   checkout main
   commit id: "合并分支"
   commit id: "发布v1.0"
"""

  # 架构图
  architecture: """
flowchart TB
    subgraph Client[客户端]
        Web[网页端]
        Mobile[移动端]
    end
    
    subgraph Server[服务端]
        API[API网关]
        Auth[认证服务]
        Biz[业务服务]
    end
    
    subgraph Data[数据层]
        DB[(数据库)]
        Cache[(缓存)]
    end
    
    Web --> API
    Mobile --> API
    API --> Auth
    API --> Biz
    Biz --> DB
    Biz --> Cache
    
    style Client fill:#e6ffed,stroke:#38a169
    style Server fill:#bee3f8,stroke:#3182ce
    style Data fill:#feebc8,stroke:#d69e2e
"""

  # 患者安全目标
  patientSafety: """
flowchart LR
    G1[正确识别患者] --> G2[强化手术安全]
    G3[提高用药安全] --> G4[提升护理安全]
    G5[预防院内感染] --> G6[鼓励不良上报]
    G7[预防跌倒] --> G8[加强器械管理]
    style G1,G2 fill:#bee3f8,stroke:#3182ce
    style G3,G4 fill:#c6f6d5,stroke:#38a169
    style G5,G6 fill:#feebc8,stroke:#d69e2e
    style G7,G8 fill:#e9d8fd,stroke:#805ad5
"""

  # 医院等级评审
  hospitalReview: """
flowchart LR
    A[医院自评] --> B[数据收集]
    B --> C[专家评审]
    C --> D{评审结果}
    D -->|通过| E[持续改进]
    D -->|整改| F[限期整改]
    F --> B
    style A fill:#e6f3ff,stroke:#3182ce
    style B fill:#e6ffed,stroke:#38a169
    style C fill:#fffaf0,stroke:#d69e2e
    style D fill:#f5f5f5,stroke:#666666
    style E fill:#e8f5e9,stroke:#2e7d32
    style F fill:#ffebee,stroke:#c62828
"""

  # 医患沟通
  doctorPatient: """
flowchart LR
    A[入院沟通] --> B[诊疗沟通]
    B --> C[手术沟通] 
    C --> D[出院沟通]
    D --> E[随访沟通]
    A -.->|持续| B
    B -.->|持续| C
    C -.->|持续| D
    D -.->|持续| E
    style A fill:#bee3f8,stroke:#3182ce
    style B fill:#c6f6d5,stroke:#38a169
    style C fill:#feebc8,stroke:#d69e2e
    style D fill:#e9d8fd,stroke:#805ad5
    style E fill:#fed7d7,stroke:#e53e3e
"""

  # 绩效管理
  performance: """
flowchart LR
    A[目标设定] --> B[过程管理]
    B --> C[绩效考核]
    C --> D[结果应用]
    D -.->|反馈| A
    style A fill:#3182ce,color:#fff
    style B fill:#38a169,color:#fff
    style C fill:#d69e2e,color:#fff
    style D fill:#e53e3e,color:#fff
"""

  # 教学培训流程
  training: """
flowchart LR
    A[需求分析] --> B[计划制定]
    B --> C[组织实施]
    C --> D[效果评估]
    D --> E[持续改进]
    style A fill:#e6f3ff,stroke:#3182ce
    style B fill:#e6ffed,stroke:#38a169
    style C fill:#fffaf0,stroke:#d69e2e
    style D fill:#f3e5f5,stroke:#805ad5
    style E fill:#ffebee,stroke:#e53e3e
"""

  # 科研项目流程
  research: """
flowchart LR
    A[选题立项] --> B[文献综述]
    B --> C[研究设计]
    C --> D[项目实施]
    D --> E[数据分析]
    E --> F[论文发表]
    style A fill:#bee3f8,stroke:#3182ce
    style B fill:#c6f6d5,stroke:#38a169
    style C fill:#feebc8,stroke:#d69e2e
    style D fill:#e9d8fd,stroke:#805ad5
    style E fill:#fed7d7,stroke:#e53e3e
    style F fill:#e6f3ff,stroke:#3182ce
"""

  # 人才梯队
  talentTeam: """
flowchart TB
    高层[高层管理] --> 中层[中层管理]
    中层 --> 基层[基层员工]
    高层 --- 高层梯队[人才梯队建设]
    中层 --- 中层梯队[储备干部培养]
    基层 --- 基层梯队[技能培训]
    style 高层 fill:#3182ce,color:#fff
    style 中层 fill:#38a169,color:#fff
    style 基层 fill:#d69e2e,color:#fff
"""

  # 漏斗图
  funnel: """
funnel
    title 转化漏斗
    曝光: 10000
    点击: 5000
    注册: 2000
    付费: 500
    复购: 200
"""

  # 饼图 - 满意度
  pieSatisfaction: """
pie title 客户满意度
    "非常满意" : 45
    "满意" : 30
    "一般" : 15
    "不满意" : 7
    "非常不满意" : 3
"""

  # 饼图 - 预算分配
  pieBudget: """
pie title 预算分配
    "人力资源" : 40
    "设备采购" : 25
    "市场营销" : 20
    "研发投入" : 10
    "其他" : 5
"""

  # 饼图 - 市场份额
  pieMarketShare: """
pie title 市场份额
    "本公司" : 35
    "竞争对手A" : 25
    "竞争对手B" : 20
    "其他" : 20
"""

  # 甘特图 - 项目计划
  ganttProject: """
gantt
    title 项目进度计划
    dateFormat  YYYY-MM-DD
    section 项目管理
    项目启动会       :2024-01-01, 2d
    需求评审         :2024-01-03, 3d
    section 开发
    系统设计         :2024-01-06, 5d
    编码实现         :2024-01-11, 10d
    section 测试
    测试用例编写     :2024-01-15, 3d
    系统测试         :2024-01-18, 5d
    上线部署         :2024-01-23, 2d
"""

  # 状态图
  stateDiagram: """
stateDiagram-v2
    [*] --> 待处理
    待处理 --> 进行中: 开始处理
    进行中 --> 待审核: 完成任务
    待审核 --> 进行中: 退回修改
    待审核 --> 已完成: 审核通过
    已完成 --> [*]
"""

  # 类图
  classDiagram: """
classDiagram
    class 动物 {
        +String 名称
        +int 年龄
        +进食()
        +移动()
    }
    class 狗 {
        +String 品种
        +吠叫()
    }
    动物 <|-- 狗
"""

  # ER图
  erDiagram: """
erDiagram
    用户 ||--o{ 订单 : "下"
    订单 ||--|{ 订单明细 : "包含"
    商品 ||--o{ 订单明细 : "关联"
"""

  # 流程图 - 患者就诊
  patientFlow: """
flowchart LR
    subgraph 挂号[挂号]
        现场[现场挂号]
        线上[线上预约]
    end
    subgraph 候诊[候诊]
        分诊[分诊]
        等候[等待叫号]
    end
    subgraph 诊疗[诊疗]
        问诊[医生问诊]
        检查[检查检验]
        诊断[诊断治疗]
    end
    subgraph 结束[离院]
        取药[取药]
        收费[费用结算]
        出院[离院]
    end
    现场 --> 分诊
    线上 --> 分诊
    分诊 --> 等候
    等候 --> 问诊
    问诊 --> 检查
    检查 --> 诊断
    诊断 --> 取药
    诊断 --> 收费
    取药 --> 出院
    收费 --> 出院
    style 现场,线上 fill:#bee3f8
    style 分诊,等候 fill:#c6f6d5
    style 问诊,检查,诊断 fill:#feebc8
    style 取药,收费,出院 fill:#e9d8fd
"""

  # 流程图 - 质量改进
  qualityImprovement: """
flowchart LR
    A[识别问题] --> B[分析原因]
    B --> C[制定措施]
    C --> D[实施改进]
    D --> E[效果评估]
    E --> F{达到目标?}
    F -->|是| G[标准化]
    F -->|否| B
    G --> H[持续监控]
    H -.->|新问题| A
    style A fill:#bee3f8
    style B fill:#c6f6d5
    style C fill:#feebc8
    style D fill:#e9d8fd
    style E fill:#fed7d7
    style G fill:#c6f6d5
    style H fill:#bee3f8
"""

  # 象限图 - 重要紧急
  quadrant: """
quadrantChart
    title 任务优先级矩阵
    x-axis 低紧急 --> 高紧急
    y-axis 低重要 --> 高重要
    quadrant-1 马上做
    quadrant-2 计划做
    quadrant-3 委托做
    quadrant-4 删除
    "危机处理": [0.9, 0.9]
    "重要会议": [0.7, 0.8]
    "常规工作": [0.3, 0.4]
    "娱乐活动": [0.1, 0.2]
    "培训学习": [0.6, 0.3]
    "邮件处理": [0.2, 0.5]
"""

  # 桑基图
  sankey: """
sankey-beta
    门诊,挂号,100
    急诊,挂号,80
    住院,挂号,50
    挂号,内科,80
    挂号,外科,70
    挂号,儿科,50
    挂号,其他,30
    内科,治愈,60
    内科,好转,15
    内科,转院,5
    外科,治愈,50
    外科,好转,15
    外科,转院,5
"""

  # 华夫饼图
  waffle: """
waffle
    title 目标完成情况
    {
        "完全完成": 60,
        "部分完成": 25,
        "未完成": 15
    }
    100: 10
"""

  # XY图
  xyChart: """
xychart-beta
    title "月度销售额趋势"
    x-axis [1月, 2月, 3月, 4月, 5月, 6月]
    y-axis "销售额(万元)" 0 --> 100
    line [45, 52, 38, 65, 72, 80]
"""

# ============================================
# 课程数据生成器
# ============================================

class CourseGenerator
  constructor: (title) ->
    @title = title
    @slides = []
  
  addTitle: (title, subtitle = "") ->
    @slides.push { type: "title", title, subtitle }
    this
  
  addMermaid: (title, chart, scale = "") ->
    @slides.push { type: "mermaid", title, chart, scale }
    this
  
  addList: (title, items) ->
    @slides.push { type: "list", title, items }
    this

  addTwoCol: (title, leftTitle, leftItems, rightTitle, rightItems) ->
    @slides.push { type: "two-col", title, leftTitle, leftItems, rightTitle, rightItems }
    this

  addImage: (title, imagePath, caption = "") ->
    @slides.push { type: "image", title, imagePath, caption }
    this

  addCode: (title, code, language = "") ->
    @slides.push { type: "code", title, code, language }
    this

# ============================================
# HTML 生成器（用于 Mermaid 图表）
# ============================================

generateHtml = (data, outputPath) ->
  slidesHtml = for slide in data.slides
    if slide.type is "title"
      """
      <div class="slide title-slide">
        <h1>#{slide.title}</h1>
        <p>#{slide.subtitle || ''}</p>
      </div>
      """
    else if slide.type is "mermaid"
      scale = slide.scale || "1.0"
      chartHtml = slide.chart?.trim()
      """
      <div class="slide">
        <h3>#{slide.title}</h3>
        <div class="mermaid-container" style="transform: scale(#{scale});">
          <pre class="mermaid">#{chartHtml}</pre>
        </div>
      </div>
      """
    else if slide.type is "list" or slide.type is "content"
      itemsHtml = for item, i in (slide.items ? [])
        "<li>#{item}</li>"
      """
      <div class="slide">
        <h3>#{slide.title}</h3>
        <ul>#{itemsHtml.join('')}</ul>
      </div>
      """
    else if slide.type is "two-col"
      leftHtml = for item in slide.leftItems
        "<li>#{item}</li>"
      rightHtml = for item in slide.rightItems
        "<li>#{item}</li>"
      """
      <div class="slide">
        <h3>#{slide.title}</h3>
        <div class="two-col">
          <div class="col">
            <h4>#{slide.leftTitle}</h4>
            <ul>#{leftHtml.join('')}</ul>
          </div>
          <div class="col">
            <h4>#{slide.rightTitle}</h4>
            <ul>#{rightHtml.join('')}</ul>
          </div>
        </div>
      </div>
      """
    else if slide.type is "image"
      """
      <div class="slide">
        <h3>#{slide.title}</h3>
        <div class="image-container">
          <img src="#{slide.imagePath}" alt="#{slide.title}">
          <p class="caption">#{slide.caption || ''}</p>
        </div>
      </div>
      """
    else if slide.type is "code"
      """
      <div class="slide">
        <h3>#{slide.title}</h3>
        <pre class="code"><code class="language-#{slide.language}">#{slide.code}</code></pre>
      </div>
      """
    else if slide.type is "comparison"
      """
      <div class="slide">
        <h3>#{slide.title}</h3>
        <div class="comparison">
          <div class="comparison-left">
            <h4>#{slide.leftTitle}</h4>
            <p>#{slide.leftContent}</p>
          </div>
          <div class="comparison-vs">VS</div>
          <div class="comparison-right">
            <h4>#{slide.rightTitle}</h4>
            <p>#{slide.rightContent}</p>
          </div>
        </div>
      </div>
      """
    else if slide.type is "quote"
      """
      <div class="slide">
        <h3>#{slide.title}</h3>
        <div class="quote-container">
          <blockquote>"#{slide.quote}"</blockquote>
          <p class="quote-author">— #{slide.author}</p>
        </div>
      </div>
      """
  
  slidesHtmlStr = slidesHtml.join('')
  
  html = """
<!doctype html>
<html>
<head>
  <meta charset="utf-8">
  <title>#{data.title}</title>
  <script src="https://cdn.jsdelivr.net/npm/mermaid@9.4.3/dist/mermaid.min.js"></script>
  <script>
    mermaid.initialize({ 
      startOnLoad: true,
      theme: 'default'
    });
  </script>
  <style>
    * { box-sizing: border-box; }
    body { margin: 0; padding: 0; background: #333; }
    .slide { 
      width: 1000px; 
      height: 562px; 
      margin: 10px auto;
      padding: 30px 40px;
      background: white;
      page-break-after: always;
      position: relative;
      overflow: hidden;
    }
    .slide h1 { color: #366092; font-size: 36px; margin: 0 0 20px 0; }
    .slide h3 { color: #366092; font-size: 28px; margin: 0 0 15px 0; }
    .slide h4 { color: #366092; font-size: 20px; margin: 0 0 10px 0; }
    .slide p { font-size: 16px; color: #333; margin: 5px 0; }
    .slide li { font-size: 16px; color: #333; margin: 8px 0; }
    .title-slide { 
      text-align: center; 
      padding-top: 150px;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    }
    .title-slide h1 { color: white; font-size: 48px; }
    .title-slide p { color: #e0e0e0; font-size: 24px; }
    ul { padding-left: 25px; }
    .comparison { display: flex; align-items: stretch; justify-content: center; margin-top: 30px; height: 300px; }
    .comparison-left, .comparison-right { flex: 1; padding: 25px; margin: 5px; border-radius: 8px; display: flex; flex-direction: column; }
    .comparison-left { background: #E8F4FD; }
    .comparison-right { background: #FFF4E6; }
    .comparison-left h4, .comparison-right h4 { text-align: center; }
    .comparison-vs { 
      display: flex; align-items: center; 
      font-size: 28px; font-weight: bold; color: #FF6B6B; 
      margin: 0 10px; 
    }
    .quote-container { 
      margin: 80px auto; 
      max-width: 900px; 
      text-align: center; 
      padding: 40px;
      background: #f9f9f9;
      border-left: 5px solid #366092;
      border-radius: 0 10px 10px 0;
    }
    .quote-container blockquote { 
      font-size: 32px; 
      font-style: italic; 
      color: #366092; 
      margin: 20px 0; 
      line-height: 1.4;
    }
    .quote-author { font-size: 20px; color: #666; text-align: right; }
    .mermaid-container { 
      display: flex; 
      justify-content: center; 
      align-items: center; 
      height: 380px; 
    }
    .mermaid-container pre { 
      transform-origin: center center; 
      transform: scale(0.9); 
    }
    .card-container { display: flex; gap: 15px; margin-top: 30px; }
    .card { flex: 1; padding: 20px; background: #f5f5f5; border-radius: 8px; text-align: center; }
    .card h4 { color: #366092; }
    .theme-switcher {
      position: fixed;
      bottom: 20px;
      right: 20px;
      z-index: 9999;
      background: rgba(255,255,255,0.95);
      padding: 10px 15px;
      border-radius: 8px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.2);
      display: flex;
      gap: 8px;
      align-items: center;
    }
    .theme-switcher label { font-size: 12px; color: #666; }
    .theme-switcher select {
      padding: 5px 10px;
      border: 1px solid #ddd;
      border-radius: 4px;
      font-size: 12px;
      cursor: pointer;
    }
    
    /* Animation Styles */
    .slide { opacity: 0; animation: fadeIn 0.5s ease forwards; }
    @keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } }
    @keyframes slideInLeft { from { transform: translateX(-100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
    @keyframes slideInRight { from { transform: translateX(100%); opacity: 0; } to { transform: translateX(0); opacity: 1; } }
    @keyframes slideInUp { from { transform: translateY(100%); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
    @keyframes slideInDown { from { transform: translateY(-100%); opacity: 0; } to { transform: translateY(0); opacity: 1; } }
    @keyframes zoomIn { from { transform: scale(0); opacity: 0; } to { transform: scale(1); opacity: 1; } }
    @keyframes bounce { 0%, 20%, 50%, 80%, 100% { transform: translateY(0); } 40% { transform: translateY(-30px); } 60% { transform: translateY(-15px); } }
    @keyframes flip { from { transform: perspective(400px) rotateY(0); } to { transform: perspective(400px) rotateY(360deg); } }
    @keyframes shake { 0%, 100% { transform: translateX(0); } 10%, 30%, 50%, 70%, 90% { transform: translateX(-10px); } 20%, 40%, 60%, 80% { transform: translateX(10px); } }
    @keyframes pulse { 0% { transform: scale(1); } 50% { transform: scale(1.05); } 100% { transform: scale(1); } }
    .slide.fade { animation-name: fadeIn; }
    .slide.slide-left { animation-name: slideInLeft; }
    .slide.slide-right { animation-name: slideInRight; }
    .slide.slide-up { animation-name: slideInUp; }
    .slide.slide-down { animation-name: slideInDown; }
    .slide.zoom { animation-name: zoomIn; }
    .slide.bounce { animation-name: bounce; }
    .slide.flip { animation-name: flip; }
    .slide.shake { animation-name: shake; }
    .slide.pulse { animation-name: pulse; }
    .slide.fast { animation-duration: 0.2s; }
    .slide.slow { animation-duration: 1s; }
    .slide.very-slow { animation-duration: 2s; }
    
    /* Transition Effects */
    .slide { transition: all 0.3s ease; }
    .slide:hover { transform: scale(1.02); box-shadow: 0 10px 30px rgba(0,0,0,0.2); }
    
    /* Stagger animations for list items */
    .slide ul li { opacity: 0; animation: fadeIn 0.3s ease forwards; }
    .slide ul li:nth-child(1) { animation-delay: 0.1s; }
    .slide ul li:nth-child(2) { animation-delay: 0.2s; }
    .slide ul li:nth-child(3) { animation-delay: 0.3s; }
    .slide ul li:nth-child(4) { animation-delay: 0.4s; }
    .slide ul li:nth-child(5) { animation-delay: 0.5s; }
    .slide ul li:nth-child(6) { animation-delay: 0.6s; }
  </style>
<script>
    function switchTheme(themeName) {
      var colors = {
        default: { bg: "#ffffff", primary: "#366092", text: "#333333" },
        blue: { bg: "#ebf8ff", primary: "#2b6cb0", text: "#2c5282" },
        green: { bg: "#f0fff4", primary: "#276749", text: "#22543d" },
        dark: { bg: "#1a202c", primary: "#63b3ed", text: "#e2e8f0" },
        purple: { bg: "#faf5ff", primary: "#6b46c1", text: "#44337a" },
        orange: { bg: "#fffaf0", primary: "#c05621", text: "#7b341e" }
      };
      var c = colors[themeName] || colors.default;
      document.querySelectorAll(".slide").forEach(function(slide) {
        slide.style.background = c.bg;
        slide.style.color = c.text;
      });
      document.querySelectorAll(".slide h1, .slide h3, .slide h4").forEach(function(el) {
        el.style.color = c.primary;
      });
    }
  </script>
</head>
<body>
  <div class="theme-switcher">
    <label>主题:</label>
    <select onchange="switchTheme(this.value)">
      <option value="default">默认</option>
      <option value="blue">蓝色</option>
      <option value="green">绿色</option>
      <option value="dark">深色</option>
      <option value="purple">紫色</option>
      <option value="orange">橙色</option>
    </select>
  </div>
#{slidesHtmlStr}
</body>
</html>
"""
  
  fs.writeFileSync(outputPath, html)
  console.log "✅ HTML: #{outputPath}"

# ============================================
# PDF 导出
# ============================================

htmlToPdf = (htmlPath, pdfPath) ->
  console.log "📄 生成 PDF..."
  
  browser = await puppeteer.launch({
    headless: "new"
    executablePath: "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
  })
  
  page = await browser.newPage()
  await page.setViewport({ width: 1280, height: 720 })
  
  fileUrl = "file://" + fs.realpathSync(htmlPath)
  await page.goto(fileUrl, { waitUntil: 'networkidle0', timeout: 60000 })
  
  # 等待 Mermaid 渲染完成 (增加超时时间)
  try
    await page.waitForFunction ->
      document.querySelectorAll('.mermaid svg').length > 0
    , { timeout: 60000 }
    console.log "   ✓ Mermaid 渲染完成"
  catch e
    console.log "   ⚠️ Mermaid 渲染超时，尝试截图..."
    # 再等待5秒
    await new Promise (resolve) -> setTimeout(resolve, 5000)
  
  # 额外等待确保渲染完成
  await new Promise (resolve) -> setTimeout(resolve, 3000)
  
  await page.pdf({
    path: pdfPath
    width: "1280px"
    height: "720px"
    printBackground: true
    margin: { top: 0, bottom: 0, left: 0, right: 0 }
  })
  
  await browser.close()
  console.log "✅ PDF: #{pdfPath}"

# ============================================
# PPTX 导出（截图方式）
# ============================================

htmlToPptx = (htmlPath, pptxPath) ->
  console.log "📊 生成 PPTX..."
  
  outputDir = path.join(path.dirname(pptxPath), "temp-slides-#{Date.now()}")
  fs.mkdirSync(outputDir, { recursive: true })
  
  try
    browser = await puppeteer.launch({
      headless: "new"
      executablePath: "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
    })
  
    page = await browser.newPage()
    await page.setViewport({ width: 1280, height: 720 })
    
    fileUrl = "file://" + fs.realpathSync(htmlPath)
    await page.goto(fileUrl, { waitUntil: 'networkidle0', timeout: 60000 })
    await new Promise (resolve) -> setTimeout(resolve, 3000)
    
    slides = await page.$$(".slide")
    console.log "   找到 #{slides.length} 张幻灯片"
    
    pres = new PptxGenJS()
    
    for slide, i in slides
      imgPath = path.join(outputDir, "slide-#{i}.png")
      await slide.screenshot({ path: imgPath, width: 1280, height: 720 })
      
      pptxSlide = pres.addSlide()
      pptxSlide.addImage({ path: imgPath, x: 0, y: 0, w: 10, h: 5.625 })
      console.log "   导出 #{i+1}/#{slides.length}"
    
    await pres.writeFile({ fileName: pptxPath })
    await browser.close()
    
    # 清理临时文件
    fs.rmSync(outputDir, { recursive: true })
    console.log "✅ PPTX: #{pptxPath}"
  catch e
    console.log "   ⚠️ PPTX 生成失败: #{e.message}"
    console.log "   错误详情: #{e.stack}"
    try
      await browser?.close()
      fs.rmSync(outputDir, { recursive: true, force: true })
    catch
      null
    throw e

# ============================================
# 完整工作流
# ============================================

generate = (data, baseName) ->
  htmlPath = "outputs/#{baseName}.html"
  pdfPath = "outputs/#{baseName}.pdf"
  pptxPath = "outputs/#{baseName}.pptx"
  
  generateHtml(data, htmlPath)
  await htmlToPdf(htmlPath, pdfPath)
  await htmlToPptx(htmlPath, pptxPath)
  console.log "🎉 全部完成!"

module.exports = {
  CourseGenerator
  generateHtml, htmlToPdf, htmlToPptx, generate
  CHARTS
}
