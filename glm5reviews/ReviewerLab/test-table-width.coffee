#!/usr/bin/env coffee

{ TableSlide, Section, Presentation } = require "./declarative-pptx-api/index"

class 短项目长内容 extends TableSlide
    @维度1: "结构质量|人员、设备、制度、环境，这是比较长的内容描述"
    @维度2: "过程质量|诊疗流程、操作规范，这也是比较长的内容"
    @维度3: "结果质量|诊疗效果、患者结局，内容更长一些"

class 长项目短内容 extends TableSlide
    @医疗质量管理体系架构: "顶层设计"
    @质量组织架构体系: "组织保障"
    @质量控制执行体系: "执行控制"

class 平衡内容 extends TableSlide
    @质量管理原则: "以患者安全为中心"
    @领导重视程度: "最高管理者主导"
    @全员参与机制: "质量安全，人人有责"

class 测试节 extends Section
    @幻灯片: -> [短项目长内容, 长项目短内容, 平衡内容]

class TableSlide测试 extends Presentation
    @sections: -> [测试节]
    @nowYou: @newPresentation()
