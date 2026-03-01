# 四个课程完整演示 - 真实内容使用
fs = require "fs"
{ generateHtml } = require "../api/elegant"

课程 = 
  title: "四课程完整演示"
  slides: [
    { type: "title", title: "医院管理四课程完整演示" }
    
    # ===== C01 医疗质量与安全管理 =====
    { type: "section", title: "C01 医疗质量与安全管理" }
    
    # 课程信息
    { type: "list", title: "课程信息", items: [
      "课程定位：医院管理运营与质量模块课程（核心课程）"
      "课程时长：12小时（2天）"
      "课程对象：医院院长、分管副院长、质控部主任"
      "教学方法：理论讲授、方法演练、案例分析"
    ]}
    
    # 质量管理体系 - 三层架构
    { type: "comparison", title: "质量管理体系三层架构", 
      left: [
        { title: "决策层", items: ["质量管理委员会", "制定方针、统筹协调"] }
        { title: "管理层", items: ["质控部门", "日常管理、监督检查"] }
      ]
      right: [
        { title: "执行层", items: ["科室质控小组", "具体执行、持续改进"] }
      ]
    }
    
    # 质量概念 - 三维度
    { type: "comparison", title: "医疗质量三维概念", 
      left: [
        { title: "结构质量", items: ["人员、设备、制度", "资源配置"] }
        { title: "过程质量", items: ["诊疗流程", "操作规范"] }
      ]
      right: [
        { title: "结果质量", items: ["诊疗效果", "患者结局"] }
      ]
    }
    
    # PDCA循环 - 核心工具
    { type: "pdca", title: "PDCA循环 - 质量管理核心工具" }
    
    # 柏拉图/二八法则 - 核心问题分析
    { type: "box", title: "柏拉图与二八法则", content: """
      <div style="display: flex; align-items: flex-end; height: 180px; gap: 20px; padding: 20px 40px;">
        <div style="flex: 1; display: flex; flex-direction: column; align-items: center;">
          <div style="background: #e53e3e; width: 100%; height: 85%; display: flex; align-items: flex-start; justify-content: center; color: white; font-size: 0.8em; padding-top: 10px; border-radius: 4px 4px 0 0;">80%</div>
          <div style="margin-top: 8px; font-size: 0.7em; color: #1a365d; font-weight: bold;">核心问题</div>
        </div>
        <div style="flex: 1; display: flex; flex-direction: column; align-items: center;">
          <div style="background: #cbd5e0; width: 100%; height: 25%; display: flex; align-items: flex-start; justify-content: center; color: #4a5568; font-size: 0.8em; padding-top: 5px; border-radius: 4px 4px 0 0;">20%</div>
          <div style="margin-top: 8px; font-size: 0.7em; color: #718096;">次要问题</div>
        </div>
      </div>
      <div style="text-align: center; margin-top: 15px; font-size: 0.7em; color: #4a5568;">
        找出20%的问题，解决80%的效果
      </div>
    """}
    
    # 不良事件闭环管理
    { type: "flowchart", title: "不良事件闭环管理", 
      steps: [
        { text: "事件报告", color: "#3182ce" }
        { text: "原因分析", color: "#d69e2e" }
        { text: "整改措施", color: "#38a169" }
        { text: "效果评价", color: "#e53e3e" }
      ]
      loop: true
    }
    
    # 质量趋势对比
    { type: "comparison", title: "医疗质量管理趋势", 
      left: [
        { title: "传统模式", items: ["经验管理", "结果管理", "单体管理", "被动应对"] }
      ]
      right: [
        { title: "现代模式", items: ["科学管理", "过程管理", "系统管理", "主动改进"] }
      ]
    }
    
    # ===== D01 学科建设与专科发展 =====
    { type: "section", title: "D01 学科建设与专科发展" }
    
    # 学科建设体系 - 核心内容
    { type: "verticalFlow", title: "学科建设核心体系", steps: [
      { text: "学科战略规划\n顶层设计", color: "#e53e3e" }
      { text: "人才队伍建设\n核心要素", color: "#d69e2e" }
      { text: "技术创新发展\n关键支撑", color: "#38a169" }
      { text: "管理支撑保障\n基础条件", color: "#3182ce" }
    ]}
    
    # 学科评估四维度
    { type: "comparison", title: "学科评估四维度", 
      left: [
        { title: "医疗质量", items: ["医疗安全", "诊疗效率", "护理质量"] }
        { title: "科研教学", items: ["科研成果", "教学能力", "人才培养"] }
      ]
      right: [
        { title: "人才队伍", items: ["学科带头人", "骨干人才", "团队结构"] }
        { title: "学科声誉", items: ["学术地位", "社会影响", "合作网络"] }
      ]
    }
    
    # 学科建设流程
    { type: "flowchart", title: "学科建设路径", 
      steps: [
        { text: "现状评估", color: "#3182ce" }
        { text: "战略定位", color: "#d69e2e" }
        { text: "资源配置", color: "#38a169" }
        { text: "建设实施", color: "#805ad5" }
        { text: "绩效评估", color: "#e53e3e" }
      ]
    }
    
    # ===== E02 品牌建设 =====
    { type: "section", title: "E02 品牌建设" }
    
    # 品牌层次金字塔
    { type: "pyramid", title: "品牌层次金字塔", levels: [
      { text: "文化品牌", color: "#1a365d" }
      { text: "服务品牌", color: "#2c5282" }
      { text: "技术品牌", color: "#3182ce" }
      { text: "标识品牌", color: "#4299e1" }
    ]}
    
    # 品牌传播矩阵
    { type: "matrix", title: "品牌传播矩阵", 
      rows: [
        { topLeft: "官方-传统媒体\n电视/报纸/广播", topRight: "官方-新媒体\n微信/抖音/微博" }
        { bottomLeft: "口碑-传统媒体\n医患交流/口口相传", bottomRight: "口碑-新媒体\n社交媒体/网络评价" }
      ]
    }
    
    # 品牌建设流程
    { type: "flowchart", title: "品牌建设流程", 
      steps: [
        { text: "调研分析", color: "#3182ce" }
        { text: "规划设计", color: "#d69e2e" }
        { text: "执行推广", color: "#38a169" }
        { text: "评估优化", color: "#805ad5" }
      ]
    }
    
    # 品牌与学科关系
    { type: "comparison", title: "品牌建设与学科建设关系", 
      left: [
        { title: "学科建设", items: ["技术能力", "人才梯队", "科研实力", "服务品质"] }
      ]
      right: [
        { title: "品牌建设", items: ["公众认知", "患者口碑", "行业认可", "社会影响"] }
      ]
    }
    
    # ===== F05 数据资产管理 =====
    { type: "section", title: "F05 数据资产管理" }
    
    # 数据资产管理体系
    { type: "verticalFlow", title: "数据资产管理体系", steps: [
      { text: "数据战略与治理\n顶层设计", color: "#e53e3e" }
      { text: "数据采集管理\n源头把控", color: "#d69e2e" }
      { text: "数据存储管理\n基础保障", color: "#38a169" }
      { text: "数据分析应用\n价值实现", color: "#3182ce" }
    ]}
    
    # 数据生命周期
    { type: "verticalFlow", title: "数据生命周期", steps: [
      { text: "数据采集", color: "#3182ce" }
      { text: "数据存储", color: "#38a169" }
      { text: "数据处理", color: "#d69e2e" }
      { text: "数据分析", color: "#e53e3e" }
      { text: "数据应用", color: "#805ad5" }
    ]}
    
    # 数据资产估值矩阵
    { type: "matrix", title: "数据资产估值矩阵", 
      rows: [
        { topLeft: "战略数据\n高价值-高风险", topRight: "核心数据\n高价值-低风险" }
        { bottomLeft: "风险数据\n低价值-高风险", bottomRight: "基础数据\n低价值-低风险" }
      ]
    }
    
    # 数据质量评估
    { type: "comparison", title: "数据质量评估维度", 
      left: [
        { title: "准确性", items: ["数据真实", "描述正确"] }
        { title: "完整性", items: ["不缺项", "不漏记录"] }
      ]
      right: [
        { title: "及时性", items: ["更新及时", "时效保障"] }
        { title: "一致性", items: ["标准统一", "格式规范"] }
      ]
    }
    
    # ===== 总结 =====
    { type: "section", title: "总结与关联" }
    
    # 四大模块关联
    { type: "box", title: "医院管理四大模块关联", content: """
      <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px; padding: 20px;">
        <div style="background: linear-gradient(135deg, #3182ce, #2c5282); color: white; padding: 20px; border-radius: 8px; text-align: center;">
          <div style="font-size: 1.2em; font-weight: bold;">C01 医疗质量</div>
          <div style="font-size: 0.8em; opacity: 0.9;">核心业务</div>
        </div>
        <div style="background: linear-gradient(135deg, #38a169, #2f855a); color: white; padding: 20px; border-radius: 8px; text-align: center;">
          <div style="font-size: 1.2em; font-weight: bold;">D01 学科建设</div>
          <div style="font-size: 0.8em; opacity: 0.9;">核心竞争力</div>
        </div>
        <div style="background: linear-gradient(135deg, #d69e2e, #b7791f); color: white; padding: 20px; border-radius: 8px; text-align: center;">
          <div style="font-size: 1.2em; font-weight: bold;">E02 品牌建设</div>
          <div style="font-size: 0.8em; opacity: 0.9;">市场影响力</div>
        </div>
        <div style="background: linear-gradient(135deg, #805ad5, #6b46c1); color: white; padding: 20px; border-radius: 8px; text-align: center;">
          <div style="font-size: 1.2em; font-weight: bold;">F05 数据资产</div>
          <div style="font-size: 0.8em; opacity: 0.9;">决策支撑</div>
        </div>
      </div>
    """}
    
    { type: "end", title: "演示完成!" }
  ]

generateHtml 课程, "outputs/four-courses-complete.html"
console.log "✅ Created: outputs/four-courses-complete.html"
