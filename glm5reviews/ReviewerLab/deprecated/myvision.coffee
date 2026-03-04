#myvision.coffee




# 第一种写作方式
class AI革命前教学平台定义 extends 幻灯片
    @AI革命前："那是一个美好的时代，我们在这个时代里，有很多的创新，有很多的突破，有很多的变化。"
    @AI革命后："那是一个美好的时代，我们在这个时代里，有很多的创新，有很多的突破，有很多的变化。"
    @插图："AI革命前教学平台定义.png"

class AI革命后教学平台定义 extends 幻灯片
    @图文：{
        图："AI革命后教学平台定义.png"
        文："那是一个美好的时代，我们在这个时代里，有很多的创新，有很多的突破，有很多的变化。"
    }



class 国际学科平台定义 extends 节
    @幻灯片: [
        AI革命前学科平台定义
        AI革命后学科平台定义
    ]


class 国际教学平台定义 extends 节
    @幻灯片: [
        AI革命前教学平台定义
        AI革命后教学平台定义
    ]



class 学科平台定义 extends 章
    @节: [
      国际学科平台定义
      国内学科平台定义
    ]


class 学科平台构成 extends 章
    @节: [
      国际学科平台构成
      国内学科平台构成
    ]


class 教学平台构成 extends 章
    @节: [
      国际教学平台构成
      国内教学平台构成
    ]

class 教学平台定义 extends 章
    @节: [
      国际教学平台定义
      国内教学平台定义
    ]

class 教学平台建设 extends Section
    @章: [
      教学平台定义
      教学平台搭建
    ]

class 科研能力提升 extends Section
  @章: [
    科研能力定义
    科研能力培养
  ]


class 学科平台建设 extends Section
  @章: [
    学科平台定义
    学科平台投资
  ]

class 我的幻灯片 extends 幻灯片
  @sections： [
    学科平台建设
    教学平台建设
  ]
