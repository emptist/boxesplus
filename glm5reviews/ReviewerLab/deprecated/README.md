# Deprecated Files

这个目录存放了声明式框架开发过程中的早期探索版本。

## 📂 文件说明

### 声明式框架探索版本

| 文件 | 说明 | 状态 |
|------|------|------|
| declarative-framework-auto-register.coffee | 使用全局注册表自动注册 | 已废弃 |
| declarative-framework-auto.coffee | 自动执行探索版本 | 已废弃 |
| declarative-framework-final.coffee | 早期"最终"版本 | 已废弃 |
| declarative-framework-magic.coffee | 魔法版本探索 | 已废弃 |
| declarative-framework-pptx.coffee | PPTX生成探索 | 已废弃 |
| declarative-framework-pure.coffee | 纯净版本探索 | 已废弃 |
| declarative-framework-scan.coffee | 扫描版本探索 | 已废弃 |
| declarative-framework-simple.coffee | 简化版本探索 | 已废弃 |
| declarative-framework-ultimate.coffee | 终极版本探索 | 已废弃 |
| declarative-framework-v2.coffee | V2版本探索 | 已废弃 |
| declarative-framework.coffee | 最初版本 | 已废弃 |

### 其他探索文件

| 文件 | 说明 | 状态 |
|------|------|------|
| framework.coffee | 早期框架版本 | 已废弃 |
| myslide-*.coffee | 幻灯片探索 | 已废弃 |
| myvision-*.coffee | 演示文稿探索 | 已废弃 |
| test-*.coffee | 测试文件 | 已废弃 |
| E02品牌建设课程-多版本.coffee | 多版本测试 | 已废弃 |

## ✅ 最终版本

最终版本已经整理到 `../declarative-pptx-api/` 目录：

```
declarative-pptx-api/
├── index.coffee              # 核心框架（最终版本）
├── README.md                 # 使用文档
└── examples/                 # 示例代码
    ├── self.coffee           # 简单示例
    ├── you.coffee            # 测试示例
    └── E02品牌建设课程.coffee # 完整示例
```

## 🎯 核心设计

最终版本的核心设计：

1. **函数延迟解析**：`@sections: -> [...]`
2. **setImmediate 延迟执行**：`@newPresentation: -> setImmediate => @generate()`
3. **类定义时执行**：`@nowYou: @newPresentation()`
4. **任意顺序定义类**：用户可以自由写作

---

**这些文件仅供参考，不建议使用。**

**最后更新**: 2026-03-04
