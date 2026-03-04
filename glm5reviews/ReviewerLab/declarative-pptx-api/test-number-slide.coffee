#!/usr/bin/env coffee

{ NumberSlide, Section, Presentation } = require "./index"

class TestNumberSlide extends NumberSlide
    @知名度: "90%"
    @美誉度: "95%"
    @忠诚度: "60%"
    @推荐度: "80%"

class TestSection extends Section
    @幻灯片: -> [TestNumberSlide]

class TestNumberPresentation extends Presentation
    @sections: -> [TestSection]
    @nowYou: @newPresentation()
