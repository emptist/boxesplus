# C01 医疗质量与安全管理课程 - 严格按照教案
fs = require "fs"
{ generateHtml } = require "../api/elegant"

课程 = 
  title: "C01 医疗质量与安全管理"
  slides: [
    # ===== 封面 =====
    { type: "title", title: "医疗质量与安全管理", subtitle: "医院管理核心模块课程" }
    
    # ===== 课程信息 (来自教案) =====
    { type: "list", title: "课程信息", items: [
      "课程名称：医院医疗质量与安全管理"
      "课程定位：医院管理核心模块课程"
      "课程时长：12小时（2天）"
      "课程对象：医院院长、分管副院长、质控部主任、医务部主任、护理部主任、临床科室主任"
      "教学方法：理论讲授、方法演练、案例分析、课堂讨论、实操练习"
    ]}
    
    # ===== 课程目标 =====
    { type: "list", title: "知识目标", items: [
      "1. 掌握医疗质量管理体系的构成"
      "2. 熟悉质量管理工具与方法"
      "3. 了解患者安全目标与措施"
    ]}
    
    { type: "list", title: "能力目标", items: [
      "1. 能够建立质量管理体系"
      "2. 能够运用质量管理工具"
      "3. 能够处理质量安全事件"
    ]}
    
    { type: "list", title: "素质目标", items: [
      "1. 培养质量安全意识"
      "2. 提升质量管理能力"
    ]}
    
    # ===== 第一章：医疗质量管理概述 =====
    { type: "section", title: "第一章：医疗质量管理概述（1小时）" }
    
    { type: "list", title: "教学目标", items: [
      "1. 理解医疗质量概念"
      "2. 认识质量管理体系"
      "3. 了解发展趋势"
    ]}
    
    # 1.1 医疗质量概念
    { type: "box", title: "1.1 医疗质量概念（25分钟）", content: """
      <div style="padding: 20px; text-align: center;">
        <div style="font-size: 1em; color: #1a365d; font-weight: bold; margin-bottom: 15px;">医疗质量定义</div>
        <div style="font-size: 0.85em; color: #4a5568; line-height: 2; margin-bottom: 20px;">
          医疗质量是指医疗服务在满足患者及其家属健康需求方面所达到的程度，包括医疗技术质量和服务质量。
        </div>
        <div style="display: flex; gap: 30px; justify-content: center;">
          <div style="background: #bee3f8; padding: 20px; border-radius: 8px; min-width: 150px;">
            <div style="font-size: 0.9em; font-weight: bold; color: #2c5282;">狭义</div>
            <div style="font-size: 1.1em; color: #2b6cb0; margin-top: 5px;">诊疗质量</div>
          </div>
          <div style="background: #c6f6d5; padding: 20px; border-radius: 8px; min-width: 150px;">
            <div style="font-size: 0.9em; font-weight: bold; color: #276749;">广义</div>
            <div style="font-size: 1.1em; color: #2f855a; margin-top: 5px;">技术+服务+管理+环境</div>
          </div>
        </div>
      </div>
    """}
    
    # 医疗质量维度 - 来自教案表格
    { type: "comparison", title: "医疗质量维度", 
      left: [
        { title: "结构质量", items: ["人员", "设备", "制度", "环境"] }
      ]
      right: [
        { title: "过程质量", items: ["诊疗流程", "操作规范"] }
        { title: "结果质量", items: ["诊疗效果", "患者结局"] }
      ]
    }
    
    # 1.2 医疗质量管理体系 - 来自教案ASCII图（完整三层）
    { type: "box", title: "1.2 医疗质量管理体系（20分钟）- 体系架构", content: """
      <div style="display: flex; flex-direction: column; gap: 8px; padding: 20px; align-items: center;">
        <div style="background: #e53e3e; color: white; padding: 15px 50px; border-radius: 5px; text-align: center; width: 70%;">
          <div style="font-weight: bold;">质量方针  质量目标  质量文化</div>
        </div>
        <div style="color: #a0aec0; font-size: 0.7em;">▼</div>
        <div style="background: #d69e2e; color: white; padding: 15px 50px; border-radius: 5px; text-align: center; width: 70%;">
          <div style="font-weight: bold;">质量组织  质量制度  质量流程</div>
        </div>
        <div style="color: #a0aec0; font-size: 0.7em;">▼</div>
        <div style="background: #38a169; color: white; padding: 15px 50px; border-radius: 5px; text-align: center; width: 70%;">
          <div style="font-weight: bold;">质量控制  质量保证  质量改进</div>
        </div>
      </div>
    """}
    
    # 1.3 管理趋势
    { type: "comparison", title: "1.3 管理趋势（15分钟）", 
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
    { type: "section", title: "第二章：医疗质量管理体系（1.5小时）" }
    
    # 2.1 质量管理体系架构
    { type: "comparison", title: "2.1 质量管理体系架构（25分钟）- 质量管理原则", 
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
    
    # 体系文件 - 来自教案ASCII
    { type: "verticalFlow", title: "质量管理体系文件层级", steps: [
      { text: "第一层：质量手册\n质量方针、质量目标、体系框架", color: "#e53e3e" }
      { text: "第二层：程序文件\n管理制度、操作流程", color: "#d69e2e" }
      { text: "第三层：作业指导书\n操作规范、技术标准", color: "#38a169" }
      { text: "第四层：质量记录\n表单、报表、档案", color: "#3182ce" }
    ]}
    
    # 2.2 组织架构与职责
    { type: "comparison", title: "2.2 组织架构与职责（35分钟）- 质量管理组织", 
      left: [
        { title: "质量管理委员会", items: ["决策", "统筹"] }
        { title: "质控部门", items: ["日常管理"] }
      ]
      right: [
        { title: "科室质控小组", items: ["科室落实"] }
        { title: "全院职工", items: ["具体执行"] }
      ]
    }
    
    # 职责分工 - 来自教案ASCII
    { type: "box", title: "各层级质量职责", content: """
      <div style="display: flex; flex-direction: column; gap: 12px; padding: 15px;">
        <div style="background: #ebf8ff; padding: 12px; border-radius: 5px; border-left: 4px solid #3182ce;">
          <div style="font-weight: bold; color: #2c5282;">院级层面</div>
          <div style="font-size: 0.75em; color: #4a5568;">├─ 制定质量方针目标 │ ├─ 配置资源保障 │ └─ 考核评价监督</div>
        </div>
        <div style="background: #f0fff4; padding: 12px; border-radius: 5px; border-left: 4px solid #38a169;">
          <div style="font-weight: bold; color: #276749;">职能部门</div>
          <div style="font-size: 0.75em; color: #4a5568;">├─ 落实质量制度 │ ├─ 日常监督检查 │ └─ 问题分析改进</div>
        </div>
        <div style="background: #fffaf0; padding: 12px; border-radius: 5px; border-left: 4px solid #d69e2e;">
          <div style="font-weight: bold; color: #744210;">科室层面</div>
          <div style="font-size: 0.75em; color: #4a5568;">├─ 执行诊疗规范 │ ├─ 科室自查自纠 │ └─ 持续改进提高</div>
        </div>
      </div>
    """}
    
    # 2.3 质量管理制度
    { type: "comparison", title: "2.3 质量管理制度（25分钟）- 核心制度（18项）", 
      left: [
        { title: "首诊负责", items: ["首诊负责制度"] }
        { title: "三级查房", items: ["三级查房制度"] }
        { title: "会诊制度", items: ["科间会诊", "多学科会诊"] }
        { title: "手术安全", items: ["手术安全核查制度"] }
      ]
      right: [
        { title: "病历书写", items: ["病历书写规范"] }
        { title: "危急值", items: ["危急值报告制度"] }
      ]
    }
    
    { type: "comparison", title: "诊疗规范", 
      left: [
        { title: "临床路径", items: ["标准化诊疗流程"] }
      ]
      right: [
        { title: "诊疗指南", items: ["疾病诊疗规范"] }
        { title: "操作常规", items: ["技术操作标准"] }
      ]
    }
    
    # ===== 第三章：质量管理工具与方法 =====
    { type: "section", title: "第三章：质量管理工具与方法（2小时）" }
    
    # 3.1 PDCA循环
    { type: "pdca", title: "3.1 PDCA循环（35分钟）- PDCA循环图" }
    
    # PDCA应用 - 来自教案表格
    { type: "comparison", title: "PDCA各阶段主要活动", 
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
    { type: "comparison", title: "3.2 常用质量管理工具（50分钟）- 鱼骨图", 
      left: [
        { title: "鱼骨图（因果图）", items: ["用途：分析问题原因", "类别：人、机、料、法、环、测"] }
      ]
      right: [
        { title: "应用", items: ["质量问题根因分析"] }
      ]
    }
    
    { type: "comparison", title: "流程图", 
      left: [
        { title: "流程图", items: ["描述过程步骤"] }
      ]
      right: [
        { title: "泳道图", items: ["多部门流程"] }
      ]
    }
    
    # 柏拉图 - 来自教案ASCII
    { type: "box", title: "柏拉图（二八法则）", content: """
      <div style="padding: 20px;">
        <div style="font-weight: bold; color: #1a365d; margin-bottom: 10px; font-size: 1em;">柏拉图应用</div>
        <div style="font-size: 0.85em; color: #4a5568; margin-bottom: 10px;">用途：找出主要问题</div>
        <div style="font-size: 0.85em; color: #e53e3e; font-weight: bold; margin-bottom: 15px;">原理：80%问题由20%原因导致</div>
        <div style="background: #f7fafc; padding: 12px; border-radius: 5px; margin-bottom: 15px;">
          <div style="font-size: 0.8em; color: #2c5282; font-weight: bold; margin-bottom: 5px;">做法：</div>
          <div style="font-size: 0.8em; color: #4a5568;">1. 收集数据 → 2. 排序统计 → 3. 绘制图表 → 4. 找出关键少数</div>
        </div>
      </div>
    """}
    
    # 3.3 临床路径管理
    { type: "comparison", title: "3.3 临床路径管理（35分钟）- 概念", 
      left: [
        { title: "定义", items: ["标准化诊疗流程"] }
        { title: "目标", items: ["规范诊疗", "保证质量", "控制费用"] }
      ]
      right: [
        { title: "适用范围", items: ["常见病", "多发病"] }
      ]
    }
    
    { type: "comparison", title: "实施要点", 
      left: [
        { title: "入径率", items: ["≥70%"] }
        { title: "完成率", items: ["≥80%"] }
      ]
      right: [
        { title: "变异率", items: ["≤10%"] }
      ]
    }
    
    { type: "comparison", title: "效果评价", 
      left: [
        { title: "医疗质量", items: ["诊疗规范性"] }
        { title: "医疗效率", items: ["平均住院日"] }
      ]
      right: [
        { title: "医疗费用", items: ["次均费用"] }
      ]
    }
    
    # ===== 第四章：患者安全目标与措施 =====
    { type: "section", title: "第四章：患者安全目标与措施（1.5小时）" }
    
    # 4.1 患者安全目标 - 来自教案ASCII
    { type: "list", title: "4.1 患者安全目标（25分钟）- 中国患者安全目标（2023版）", items: [
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
    { type: "comparison", title: "4.2 医疗安全风险（20分钟）- 不良事件类型", 
      left: [
        { title: "医源性伤害", items: ["手术并发症", "院内感染"] }
        { title: "非医源性伤害", items: ["患者跌倒", "坠床"] }
      ]
      right: [
        { title: "系统错误", items: ["流程缺陷", "设备故障"] }
      ]
    }
    
    # 风险识别 - 来自教案ASCII
    { type: "box", title: "医疗安全风险识别方法", content: """
      <div style="padding: 20px;">
        <div style="display: flex; flex-direction: column; gap: 15px;">
          <div style="background: #ebf8ff; padding: 15px; border-radius: 5px; border-left: 4px solid #3182ce;">
            <div style="font-weight: bold; color: #2c5282; margin-bottom: 8px;">1. 不良事件报告</div>
            <div style="font-size: 0.8em; color: #4a5568;">├─ 自愿报告 │ └─ 强制报告</div>
          </div>
          <div style="background: #f0fff4; padding: 15px; border-radius: 5px; border-left: 4px solid #38a169;">
            <div style="font-weight: bold; color: #276749; margin-bottom: 8px;">2. 风险评估</div>
            <div style="font-size: 0.8em; color: #4a5568;">├─ 事前评估 │ └─ 定期评估</div>
          </div>
          <div style="background: #fffaf0; padding: 15px; border-radius: 5px; border-left: 4px solid #d69e2e;">
            <div style="font-weight: bold; color: #744210; margin-bottom: 8px;">3. 监督检查</div>
            <div style="font-size: 0.8em; color: #4a5568;">├─ 日常巡查 │ └─ 专项检查</div>
          </div>
        </div>
      </div>
    """}
    
    # 4.3 不良事件管理
    { type: "comparison", title: "4.3 不良事件管理（30分钟）- 报告制度", 
      left: [
        { title: "可疑不良事件", items: ["应当报告"] }
        { title: "严重不良事件", items: ["立即报告"] }
      ]
      right: [
        { title: "药品不良反应", items: ["专门报告"] }
      ]
    }
    
    # 不良事件闭环 - 来自教案ASCII
    { type: "flowchart", title: "不良事件闭环管理", 
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
    { type: "section", title: "第五章：重点环节质量管理（1.5小时）" }
    
    # 5.1 核心制度落实
    { type: "comparison", title: "5.1 核心制度落实（30分钟）- 18项医疗质量安全核心制度", 
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
    
    # 5.2 重点环节管理 - 围手术期 来自教案ASCII
    { type: "box", title: "5.2 重点环节管理（35分钟）- 围手术期安全管理", content: """
      <div style="padding: 20px;">
        <div style="display: flex; flex-direction: column; gap: 12px;">
          <div style="background: #ebf8ff; padding: 15px; border-radius: 5px; border-left: 4px solid #3182ce;">
            <div style="font-weight: bold; color: #2c5282; margin-bottom: 5px;">术前</div>
            <div style="font-size: 0.8em; color: #4a5568;">├─ 手术指征评估 │ ├─ 手术知情同意 │ └─ 术前准备核查</div>
          </div>
          <div style="background: #f0fff4; padding: 15px; border-radius: 5px; border-left: 4px solid #38a169;">
            <div style="font-weight: bold; color: #276749; margin-bottom: 5px;">术中</div>
            <div style="font-size: 0.8em; color: #4a5568;">├─ 手术安全核查 │ ├─ 手术记录规范 │ └─ 术中应急处理</div>
          </div>
          <div style="background: #fffaf0; padding: 15px; border-radius: 5px; border-left: 4px solid #d69e2e;">
            <div style="font-weight: bold; color: #744210; margin-bottom: 5px;">术后</div>
            <div style="font-size: 0.8em; color: #4a5568;">├─ 术后交接 │ ├─ 术后访视 │ └─ 并发症防治</div>
          </div>
        </div>
      </div>
    """}
    
    # 危急值管理
    { type: "comparison", title: "危急值管理", 
      left: [
        { title: "报告", items: ["及时", "准确"] }
        { title: "接收", items: ["记录", "复述"] }
      ]
      right: [
        { title: "处理", items: ["立即响应"] }
        { title: "追踪", items: ["闭环管理"] }
      ]
    }
    
    # 5.3 护理质量管理
    { type: "comparison", title: "5.3 护理质量管理（20分钟）- 护理质量指标", 
      left: [
        { title: "结构指标", items: ["床护比", "护患比"] }
        { title: "过程指标", items: ["护理技术合格率"] }
      ]
      right: [
        { title: "结果指标", items: ["护理不良事件发生率"] }
      ]
    }
    
    { type: "comparison", title: "护理安全管理", 
      left: [
        { title: "坠床/跌倒", items: ["评估", "宣教", "防护"] }
        { title: "压疮", items: ["风险评估", "翻身护理"] }
      ]
      right: [
        { title: "用药错误", items: ["三查七对", "高危药管理"] }
        { title: "导管滑脱", items: ["固定牢固", "密切观察"] }
      ]
    }
    
    # ===== 第六章：案例研讨与实操 =====
    { type: "section", title: "第六章：案例研讨与实操（1.5小时）" }
    
    # 6.1 案例分析
    { type: "box", title: "6.1 案例分析（45分钟）- 案例一：典型医疗质量案例", content: """
      <div style="padding: 20px;">
        <div style="background: #fed7d7; padding: 15px; border-radius: 5px; margin-bottom: 15px;">
          <div style="font-weight: bold; color: #c53030; margin-bottom: 8px;">背景</div>
          <div style="font-size: 0.9em; color: #742a2a;">某院手术部位错误事件</div>
        </div>
        <div style="background: #feebc8; padding: 15px; border-radius: 5px; margin-bottom: 15px;">
          <div style="font-weight: bold; color: #c05621; margin-bottom: 8px;">问题分析</div>
          <div style="font-size: 0.9em; color: #744210;">1. 核对制度执行不到位 2. 手术标记不规范 3. 沟通不畅</div>
        </div>
        <div style="background: #c6f6d5; padding: 15px; border-radius: 5px;">
          <div style="font-weight: bold; color: #276749; margin-bottom: 8px;">改进措施</div>
          <div style="font-size: 0.9em; color: #22543d;">1. 严格执行time-out制度 2. 规范手术标记 3. 加强培训</div>
        </div>
      </div>
    """}
    
    { type: "box", title: "案例二：不良事件改进案例", content: """
      <div style="padding: 20px;">
        <div style="background: #fed7d7; padding: 15px; border-radius: 5px; margin-bottom: 15px;">
          <div style="font-weight: bold; color: #c53030; margin-bottom: 8px;">背景</div>
          <div style="font-size: 0.9em; color: #742a2a;">某院跌倒不良事件频发</div>
        </div>
        <div style="background: #bee3f8; padding: 15px; border-radius: 5px;">
          <div style="font-weight: bold; color: #2c5282; margin-bottom: 8px;">分析改进</div>
          <div style="font-size: 0.9em; color: #2a4365;">1. 数据分析找原因 → 2. 针对性改进措施 → 3. 持续监测评估</div>
        </div>
      </div>
    """}
    
    # 6.2 实操练习
    { type: "box", title: "6.2 实操练习（45分钟）- 质量分析工具应用", content: """
      <div style="padding: 25px; text-align: center;">
        <div style="font-size: 1em; color: #1a365d; font-weight: bold; margin-bottom: 15px;">任务</div>
        <div style="font-size: 0.9em; color: #4a5568; margin-bottom: 20px;">使用鱼骨图分析某质量问题原因</div>
        <div style="background: #f7fafc; padding: 20px; border-radius: 8px; border: 2px solid #e2e8f0;">
          <div style="font-size: 0.9em; color: #2c5282; font-weight: bold; margin-bottom: 10px;">题目</div>
          <div style="font-size: 1.1em; color: #e53e3e; font-weight: bold;">患者候诊时间过长的原因分析</div>
        </div>
      </div>
    """}
    
    # ===== 课程总结 =====
    { type: "section", title: "课程总结" }
    
    { type: "list", title: "核心要点回顾", items: [
      "质量是生命：医疗质量是医院生存发展的根本"
      "体系是基础：建立完善的质量管理体系"
      "工具是手段：运用科学的质量管理工具"
      "安全是目标：确保患者安全是最终目标"
    ]}
    
    { type: "list", title: "课后思考", items: [
      "1. 您医院质量管理体系存在什么问题？"
      "2. 如何提升全员质量意识？"
      "3. 不良事件管理如何持续改进？"
    ]}
    
    # 推荐阅读
    { type: "list", title: "推荐阅读 - 政策文件", items: [
      "1. 《医疗质量管理办法》"
      "2. 《医疗质量安全核心制度要点》"
      "3. 《患者安全目标（2023版）》"
      "4. 《医疗机构病历管理规定》"
    ]}
    
    # 附录
    { type: "list", title: "附录 - 工具模板", items: [
      "1. 质量检查表"
      "2. 不良事件报告表"
      "3. 原因分析鱼骨图"
      "4. 整改措施表"
    ]}
    
    # 课时分配
    { type: "box", title: "课时分配（12小时完整版）", content: """
      <div style="padding: 20px;">
        <table style="width: 100%; border-collapse: collapse; font-size: 0.85em;">
          <tr style="background: #2c5282; color: white;">
            <th style="padding: 10px; text-align: left;">章节</th>
            <th style="padding: 10px; text-align: left;">内容</th>
            <th style="padding: 10px; text-align: center;">时长</th>
          </tr>
          <tr style="background: #f7fafc;">
            <td style="padding: 10px;">第一章</td>
            <td style="padding: 10px;">医疗质量管理概述</td>
            <td style="padding: 10px; text-align: center;">1小时</td>
          </tr>
          <tr style="background: white;">
            <td style="padding: 10px;">第二章</td>
            <td style="padding: 10px;">医疗质量管理体系</td>
            <td style="padding: 10px; text-align: center;">1.5小时</td>
          </tr>
          <tr style="background: #f7fafc;">
            <td style="padding: 10px;">第三章</td>
            <td style="padding: 10px;">质量管理工具与方法</td>
            <td style="padding: 10px; text-align: center;">2小时</td>
          </tr>
          <tr style="background: white;">
            <td style="padding: 10px;">第四章</td>
            <td style="padding: 10px;">患者安全目标与措施</td>
            <td style="padding: 10px; text-align: center;">1.5小时</td>
          </tr>
          <tr style="background: #f7fafc;">
            <td style="padding: 10px;">第五章</td>
            <td style="padding: 10px;">重点环节质量管理</td>
            <td style="padding: 10px; text-align: center;">1.5小时</td>
          </tr>
          <tr style="background: white;">
            <td style="padding: 10px;">第六章</td>
            <td style="padding: 10px;">案例研讨与实操</td>
            <td style="padding: 10px; text-align: center;">1.5小时</td>
          </tr>
        </table>
      </div>
    """}
    
    { type: "end", title: "谢谢!" }
  ]

generateHtml 课程, "outputs/C01-教案完整版.html"
console.log "✅ Created: outputs/C01-教案完整版.html"
