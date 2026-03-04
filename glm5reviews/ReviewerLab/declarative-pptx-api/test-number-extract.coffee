#!/usr/bin/env coffee

{ NumberSlide, Section, Presentation } = require "./index"

class TestMixedNumberSlide extends NumberSlide
    @知名度: "区域认知度 90%"
    @美誉度: "满意度 95%"
    @忠诚度: "复诊率 60%"
    @推荐度: "愿意推荐比例 80%"

class TestBigNumberSlide extends NumberSlide
    @粉丝量: "粉丝量100万+"
    @阅读量: "阅读量500万"
    @点赞数: "点赞数3.5万"

class TestSection extends Section
    @幻灯片: -> [TestMixedNumberSlide, TestBigNumberSlide]

class TestNumberPresentation extends Presentation
    @sections: -> [TestSection]
    @nowYou: @newPresentation()
