#!/usr/bin/env coffee

{ ContentSlide, Section, Presentation } = require "./declarative-pptx-api/index"

class Markdown风格演示 extends ContentSlide
    @标题: """
# 医疗质量管理体系
    """
    
    @内容: """
## 一、质量方针

以患者为中心，持续改进医疗服务质量。

## 二、质量目标

- 患者满意度 ≥ 95%
- 医疗事故发生率 ≤ 0.1%
- 核心制度执行率 100%

## 三、质量原则

1. **患者导向** - 以患者安全为中心
2. **领导重视** - 最高管理者主导
3. **全员参与** - 质量安全，人人有责

> 质量是生命，安全是底线

---

*参考：《医疗质量管理办法》*
    """

class Markdown表格 extends ContentSlide
    @表格: """
| 维度 | 内容 | 指标 |
|------|------|------|
| 结构质量 | 人员、设备、制度 | 床护比、设备完好率 |
| 过程质量 | 诊疗流程、操作规范 | 核心制度执行率 |
| 结果质量 | 诊疗效果、患者结局 | 治愈率、满意度 |
    """

class Markdown列表 extends ContentSlide
    @列表: """
## 核心制度（18项）

- [ ] 首诊负责制度
- [ ] 三级查房制度
- [ ] 会诊制度
- [ ] 手术安全核查制度
- [ ] 病历书写规范
- [ ] 危急值报告制度

**注意**：必须100%执行！
    """

class Markdown代码 extends ContentSlide
    @代码: """
## PDCA 循环

```
PLAN   → 分析现状、制定计划
DO     → 实施计划、落实措施
CHECK  → 检查效果、发现问题
ACTION → 总结经验、持续改进
```

循环往复，永无止境！
    """

class 测试节 extends Section
    @幻灯片: -> [
        Markdown风格演示
        Markdown表格
        Markdown列表
        Markdown代码
    ]

class Markdown即代码演示 extends Presentation
    @sections: -> [测试节]
    @nowYou: @newPresentation()
