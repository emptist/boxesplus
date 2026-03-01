# C01 医疗质量与安全管理课程 - 完整版
fs = require "fs"
{ generateHtml } = require "../api/elegant"

课程 = 
  title: "C01 医疗质量与安全管理"
  slides: [
    # ===== 封面 =====
    { type: "title", title: "医疗质量与安全管理", subtitle: "医院管理核心模块课程" }
    
    # ===== 课程信息 =====
    { type: "list", title: "课程信息", items: [
      "课程定位：医院管理核心模块课程"
      "课程时长：12小时（2天）"
      "课程对象：医院院长、分管副院长、质控部主任、医务部主任"
      "教学方法：理论讲授、方法演练、案例分析、课堂讨论、实操练习"
    ]}
    
    # ===== 课程目标 =====
    { type: "comparison", title: "课程目标", 
      left: [
        { title: "知识目标", items: ["掌握质量管理体系构成", "熟悉质量管理工具", "了解患者安全目标"] }
        { title: "能力目标", items: ["建立质量管理体系", "运用质量管理工具", "处理质量安全事件"] }
      ]
      right: [
        { title: "素质目标", items: ["培养质量安全意识", "提升质量管理能力"] }
      ]
    }
    
    # ===== 第一章：医疗质量管理概述 =====
    { type: "section", title: "第一章：医疗质量管理概述" }
    
    # 1.1 医疗质量概念
    { type: "box", title: "1.1 医疗质量概念", content: """
      <div style="background: #f7fafc; padding: 20px; border-radius: 8px; margin: 10px 0;">
        <div style="font-size: 0.9em; color: #1a365d; font-weight: bold; margin-bottom: 15px;">医疗质量定义</div>
        <div style="font-size: 0.8em; color: #4a5568; line-height: 1.8;">
          医疗质量是指医疗服务在满足患者及其家属健康需求方面所达到的程度，包括医疗技术质量和服务质量。
        </div>
        <div style="display: flex; gap: 30px; margin-top: 20px;">
          <div style="flex: 1; background: #bee3f8; padding: 15px; border-radius: 5px; text-align: center;">
            <div style="font-size: 0.8em; font-weight: bold; color: #2c5282;">狭义</div>
            <div style="font-size: 0.9em; color: #2b6cb0;">诊疗质量</div>
          </div>
          <div style="flex: 1; background: #c6f6d5; padding: 15px; border-radius: 5px; text-align: center;">
            <div style="font-size: 0.8em; font-weight: bold; color: #276749;">广义</div>
            <div style="font-size: 0.9em; color: #2f855a;">技术+服务+管理+环境</div>
          </div>
        </div>
      </div>
    """}
    
    # 医疗质量维度
    { type: "comparison", title: "医疗质量三维概念", 
      left: [
        { title: "结构质量", items: ["人员", "设备", "制度", "环境"] }
        { title: "过程质量", items: ["诊疗流程", "操作规范"] }
      ]
      right: [
        { title: "结果质量", items: ["诊疗效果", "患者结局"] }
      ]
    }
    
    # 1.2 医疗质量管理体系
    { type: "box", title: "1.2 医疗质量管理体系架构", content: """
      <div style="display: flex; flex-direction: column; gap: 8px; padding: 20px;">
        <div style="background: #e53e3e; color: white; padding: 15px; border-radius: 5px; text-align: center;">
          <div style="font-weight: bold;">第一层：顶层设计</div>
          <div style="font-size: 0.75em; opacity: 0.9;">质量方针 · 质量目标 · 质量文化</div>
        </div>
        <div style="text-align: center; color: #a0aec0;">▼</div>
        <div style="background: #d69e2e; color: white; padding: 15px; border-radius: 5px; text-align: center;">
          <div style="font-weight: bold;">第二层：组织保障</div>
          <div style="font-size: 0.75em; opacity: 0.9;">质量组织 · 质量制度 · 质量流程</div>
        </div>
        <div style="text-align: center; color: #a0aec0;">▼</div>
        <div style="background: #38a169; color: white; padding: 15px; border-radius: 5px; text-align: center;">
          <div style="font-weight: bold;">第三层：执行控制</div>
          <div style="font-size: 0.75em; opacity: 0.9;">质量控制 · 质量保证 · 质量改进</div>
        </div>
      </div>
    """}
    
    # 1.3 管理趋势
    { type: "comparison", title: "1.3 医疗质量管理趋势", 
      left: [
        { title: "科学化", items: ["数据驱动", "循证决策"] }
        { title: "精细化", items: ["精准诊疗", "个体化"] }
      ]
      right: [
        { title: "信息化", items: ["智能质控", "实时监测"] }
        { title: "患者为中心", items: ["体验", "质量", "安全"] }
      ]
    }
    
    # ===== 第二章：医疗质量管理体系 =====
    { type: "section", title: "第二章：医疗质量管理体系" }
    
    # 2.1 质量管理原则
    { type: "comparison", title: "2.1 质量管理原则", 
      left: [
        { title: "患者导向", items: ["以患者安全为中心"] }
        { title: "领导重视", items: ["最高管理者主导"] }
        { title: "全员参与", items: ["质量安全，人人有责"] }
      ]
      right: [
        { title: "过程方法", items: ["关注过程", "关注结果"] }
        { title: "持续改进", items: ["永无止境", "追求卓越"] }
      ]
    }
    
    # 质量管理体系文件层级
    { type: "verticalFlow", title: "质量管理体系文件层级", steps: [
      { text: "第一层：质量手册\n质量方针、目标、体系框架", color: "#e53e3e" }
      { text: "第二层：程序文件\n管理制度、操作流程", color: "#d69e2e" }
      { text: "第三层：作业指导书\n操作规范、技术标准", color: "#38a169" }
      { text: "第四层：质量记录\n表单、报表、档案", color: "#3182ce" }
    ]}
    
    # 2.2 组织架构与职责
    { type: "list", title: "2.2 质量管理组织架构", items: [
      "质量管理委员会 - 决策、统筹"
      "质控部门 - 日常管理"
      "科室质控小组 - 科室落实"
      "全院职工 - 具体执行"
    ]}
    
    # 各层级质量职责
    { type: "box", title: "各层级质量职责", content: """
      <div style="display: flex; flex-direction: column; gap: 15px; padding: 15px;">
        <div style="background: #ebf8ff; padding: 12px; border-radius: 5px; border-left: 4px solid #3182ce;">
          <div style="font-weight: bold; color: #2c5282;">院级层面</div>
          <div style="font-size: 0.75em; color: #4a5568;">制定质量方针目标 · 配置资源保障 · 考核评价监督</div>
        </div>
        <div style="background: #f0fff4; padding: 12px; border-radius: 5px; border-left: 4px solid #38a169;">
          <div style="font-weight: bold; color: #276749;">职能部门</div>
          <div style="font-size: 0.75em; color: #4a5568;">落实质量制度 · 日常监督检查 · 问题分析改进</div>
        </div>
        <div style="background: #fffaf0; padding: 12px; border-radius: 5px; border-left: 4px solid #d69e2e;">
          <div style="font-weight: bold; color: #744210;">科室层面</div>
          <div style="font-size: 0.75em; color: #4a5568;">执行诊疗规范 · 科室自查自纠 · 持续改进提高</div>
        </div>
      </div>
    """}
    
    # 2.3 质量管理制度
    { type: "comparison", title: "2.3 核心制度（18项）", 
      left: [
        { title: "首诊负责", items: ["首诊负责制度"] }
        { title: "三级查房", items: ["三级查房制度"] }
        { title: "会诊制度", items: ["科间会诊", "多学科会诊"] }
      ]
      right: [
        { title: "手术安全", items: ["手术安全核查制度"] }
        { title: "病历书写", items: ["病历书写规范"] }
        { title: "危急值", items: ["危急值报告制度"] }
      ]
    }
    
    # ===== 第三章：质量管理工具与方法 =====
    { type: "section", title: "第三章：质量管理工具与方法" }
    
    # 3.1 PDCA循环
    { type: "pdca", title: "3.1 PDCA循环" }
    
    # PDCA应用
    { type: "comparison", title: "PDCA各阶段活动", 
      left: [
        { title: "P 计划", items: ["分析现状", "找问题", "分析原因", "制定计划"] }
        { title: "D 执行", items: ["实施计划", "落实措施"] }
      ]
      right: [
        { title: "C 检查", items: ["检查效果", "发现问题"] }
        { title: "A 处理", items: ["总结经验", "标准化", "遗留问题入下轮"] }
      ]
    }
    
    # 3.2 常用质量管理工具
    { type: "comparison", title: "3.2 常用质量管理工具", 
      left: [
        { title: "鱼骨图（因果图）", items: ["用途：分析问题原因", "类别：人机料法环测"] }
        { title: "流程图", items: ["描述过程步骤", "泳道图：多部门流程"] }
      ]
      right: [
        { title: "柏拉图（二八法则）", items: ["找出主要问题", "80%问题由20%原因导致"] }
      ]
    }
    
    # 柏拉图/二八法则
    { type: "box", title: "柏拉图与二八法则", content: """
      <div style="padding: 20px;">
        <div style="font-weight: bold; color: #1a365d; margin-bottom: 10px;">柏拉图应用</div>
        <div style="font-size: 0.8em; color: #4a5568; margin-bottom: 15px;">用途：找出主要问题</div>
        <div style="font-size: 0.8em; color: #e53e3e; margin-bottom: 15px; font-weight: bold;">原理：80%问题由20%原因导致</div>
        <div style="background: #f7fafc; padding: 15px; border-radius: 5px;">
          <div style="font-size: 0.8em; color: #2c5282; font-weight: bold; margin-bottom: 8px;">做法：</div>
          <div style="font-size: 0.75em; color: #4a5568; line-height: 1.8;">
            1. 收集数据 → 2. 排序统计 → 3. 绘制图表 → 4. 找出关键少数
          </div>
        </div>
        <div style="display: flex; align-items: flex-end; height: 100px; gap: 10px; margin-top: 15px;">
          <div style="background: #3182ce; width: 70%; height: 80%; display: flex; align-items: flex-start; justify-content: center; color: white; font-size: 0.8em; padding-top: 5px; border-radius: 4px 4px 0 0;">80%</div>
          <div style="background: #cbd5e0; width: 30%; height: 20%; display: flex; align-items: flex-start; justify-content: center; color: #4a5568; font-size: 0.8em; padding-top: 5px; border-radius: 4px 4px 0 0;">20%</div>
        </div>
      </div>
    """}
    
    # 3.3 临床路径管理
    { type: "comparison", title: "3.3 临床路径管理", 
      left: [
        { title: "概念", items: ["标准化诊疗流程", "规范诊疗、保证质量、控制费用"] }
        { title: "实施要点", items: ["入径率≥70%", "完成率≥80%", "变异率≤10%"] }
      ]
      right: [
        { title: "效果评价", items: ["医疗质量：诊疗规范性", "医疗效率：平均住院日", "医疗费用：次均费用"] }
      ]
    }
    
    # ===== 第四章：患者安全目标与措施 =====
    { type: "section", title: "第四章：患者安全目标与措施" }
    
    # 4.1 患者安全目标
    { type: "list", title: "4.1 中国患者安全目标（2023版）", items: [
      "1. 正确识别患者身份"
      "2. 强化手术安全核查"
      "3. 确保用药安全"
      "4. 减少医院相关性感染"
      "5. 落实患者安全不良事件报告制度"
      "6. 加强孕产妇和新生儿安全"
      "7. 预防和减少患者跌倒/坠床"
      "8. 加强医疗器械安全监管"
      "9. 提升用药安全水平"
      "10. 营造安全文化"
    ]}
    
    # 4.2 医疗安全风险
    { type: "comparison", title: "4.2 医疗安全风险", 
      left: [
        { title: "不良事件类型", items: ["医源性伤害", "非医源性伤害", "系统错误"] }
        { title: "风险识别", items: ["不良事件报告", "风险评估", "监督检查"] }
      ]
      right: [
        { title: "医源性伤害", items: ["手术并发症", "院内感染"] }
        { title: "非医源性伤害", items: ["患者跌倒", "坠床"] }
      ]
    }
    
    # 4.3 不良事件管理
    { type: "flowchart", title: "4.3 不良事件闭环管理", 
      steps: [
        { text: "事件报告", color: "#3182ce" }
        { text: "初步调查", color: "#d69e2e" }
        { text: "根因分析", color: "#38a169" }
        { text: "改进措施", color: "#805ad5" }
        { text: "效果评估", color: "#e53e3e" }
        { text: "标准化", color: "#2c5282" }
      ]
      loop: true
    }
    
    # ===== 第五章：重点环节质量管理 =====
    { type: "section", title: "第五章：重点环节质量管理" }
    
    # 5.1 核心制度落实
    { type: "comparison", title: "5.1 核心制度（18项医疗质量安全核心制度）", 
      left: [
        { title: "首诊负责", items: ["首诊医师负责到底"] }
        { title: "三级查房", items: ["主任、主治、住院医"] }
        { title: "会诊制度", items: ["及时", "准确"] }
      ]
      right: [
        { title: "手术安全核查", items: ["三方核查", "Time-out"] }
        { title: "病历书写", items: ["及时", "完整", "准确"] }
        { title: "危急值", items: ["接报即办"] }
      ]
    }
    
    # 5.2 重点环节管理 - 围手术期
    { type: "verticalFlow", title: "5.2 围手术期安全管理", steps: [
      { text: "术前\n手术指征评估 · 手术知情同意 · 术前准备核查", color: "#3182ce" }
      { text: "术中\n手术安全核查 · 手术记录规范 · 术中应急处理", color: "#d69e2e" }
      { text: "术后\n术后交接 · 术后访视 · 并发症防治", color: "#38a169" }
    ]}
    
    # 危急值管理
    { type: "flowchart", title: "危急值管理闭环", 
      steps: [
        { text: "报告", color: "#3182ce" }
        { text: "接收", color: "#d69e2e" }
        { text: "处理", color: "#38a169" }
        { text: "追踪", color: "#e53e3e" }
      ]
    }
    
    # 5.3 护理质量管理
    { type: "comparison", title: "5.3 护理质量管理", 
      left: [
        { title: "护理质量指标", items: ["结构指标：床护比", "过程指标：合格率", "结果指标：不良事件"] }
      ]
      right: [
        { title: "护理安全管理", items: ["坠床/跌倒防范", "压疮防护", "用药错误防范", "导管滑脱预防"] }
      ]
    }
    
    # ===== 第六章：案例研讨与实操 =====
    { type: "section", title: "第六章：案例研讨与实操" }
    
    # 案例一
    { type: "box", title: "案例一：手术部位错误事件", content: """
      <div style="padding: 15px;">
        <div style="background: #fed7d7; padding: 10px; border-radius: 5px; margin-bottom: 10px;">
          <div style="font-weight: bold; color: #c53030;">背景</div>
          <div style="font-size: 0.8em; color: #742a2a;">某院手术部位错误事件</div>
        </div>
        <div style="background: #feebc8; padding: 10px; border-radius: 5px; margin-bottom: 10px;">
          <div style="font-weight: bold; color: #c05621;">问题分析</div>
          <div style="font-size: 0.8em; color: #744210;">1. 核对制度执行不到位 2. 手术标记不规范 3. 沟通不畅</div>
        </div>
        <div style="background: #c6f6d5; padding: 10px; border-radius: 5px;">
          <div style="font-weight: bold; color: "#276749";>改进措施</div>
          <div style="font-size: 0.8em; color: "#22543d";>1. 严格执行time-out制度 2. 规范手术标记 3. 加强培训</div>
        </div>
      </div>
    """}
    
    # 案例二
    { type: "box", title: "案例二：跌倒不良事件改进", content: """
      <div style="padding: 15px;">
        <div style="background: #fed7d7; padding: 10px; border-radius: 5px; margin-bottom: 10px;">
          <div style="font-weight: bold; color: #c53030;">背景</div>
          <div style="font-size: 0.8em; color: #742a2a;">某院跌倒不良事件频发</div>
        </div>
        <div style="background: #bee3f8; padding: 10px; border-radius: 5px;">
          <div style="font-weight: bold; color: #2c5282;">分析改进</div>
          <div style="font-size: 0.8em; color: #2a4365;">1. 数据分析找原因 → 2. 针对性改进措施 → 3. 持续监测评估</div>
        </div>
      </div>
    """}
    
    # 实操练习
    { type: "box", title: "实操练习：质量分析工具应用", content: """
      <div style="padding: 20px; text-align: center;">
        <div style="font-size: 1em; color: #1a365d; font-weight: bold; margin-bottom: 15px;">任务</div>
        <div style="font-size: 0.9em; color: #4a5568; margin-bottom: 20px;">使用鱼骨图分析某质量问题原因</div>
        <div style="background: #f7fafc; padding: 15px; border-radius: 8px;">
          <div style="font-size: 0.85em; color: #2c5282; font-weight: bold;">题目</div>
          <div style="font-size: 1em; color: #e53e3e; margin-top: 10px;">患者候诊时间过长的原因分析</div>
        </div>
      </div>
    """}
    
    # ===== 课程总结 =====
    { type: "section", title: "课程总结" }
    
    { type: "list", title: "核心要点回顾", items: [
      "医疗质量概念：结构质量、过程质量、结果质量"
      "管理体系：三层架构（顶层设计、组织保障、执行控制）"
      "核心工具：PDCA循环、鱼骨图、柏拉图、临床路径"
      "患者安全：十大安全目标、不良事件闭环管理"
      "持续改进：永远在路上，没有最好只有更好"
    ]}
    
    { type: "end", title: "谢谢!" }
  ]

generateHtml 课程, "outputs/C01-医疗质量与安全管理-完整版.html"
console.log "✅ Created: outputs/C01-医疗质量与安全管理-完整版.html"
