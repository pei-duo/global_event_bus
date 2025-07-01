# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### 🚀 计划新功能

- 事件持久化支持
- 事件重放功能
- 更多的事件过滤器

---

## [0.0.4] - 2025-07-01

### 🐛 修复

- 修复了 Android 平台包名配置问题，解决插件引用时找不到主类的错误
- 添加了 Android Kotlin 文件的包声明，确保包名与配置一致
- 修复了测试文件中`dart:async`导入缺失的问题
- 优化了插件的 Android 平台兼容性

### 🔧 改进

- 统一了 Android 包名为`com.example.global_event_bus`
- 完善了 Kotlin 文件的包结构声明
- 提升了插件在不同项目中的引用稳定性

### 📝 文档

- 更新了 Android 平台配置相关文档
- 完善了插件集成指南

---

## [0.0.3] - 2025-06-30

### 🚀 新功能

- 升级 Dart SDK 最低版本要求至 2.19.0，提升性能和稳定性
- 升级 Flutter SDK 最低版本要求至 3.3.0
- 移出 web 插件的支持
- 增强了类型安全检查和编译时优化

### 🔧 改进

- 优化了事件分发性能，减少内存占用
- 改进了批量处理机制的效率
- 增强了错误处理和异常捕获
- 优化了日志输出格式和性能

### 📝 文档

- 更新了 API 文档以反映最新变更
- 完善了代码示例和最佳实践指南
- 添加了性能优化建议

### 🐛 修复

- 修复了高并发场景下的内存泄漏问题
- 解决了某些边缘情况下的事件丢失问题
- 修复了 Web 平台上的兼容性问题

### ⚠️ 破坏性变更

- 最低 Dart SDK 版本要求从 2.17.0 提升至 2.19.0
- 最低 Flutter SDK 版本要求从 3.0.0 提升至 3.3.0

---

## [0.0.2] - 2025-06-27

### 🚀 新功能

- 降低了 Flutter SDK 最低版本要求至 3.0.0，提高兼容性
- 降低了 Dart SDK 最低版本要求至 2.17.0
- 优化了依赖包版本约束，提升稳定性

### 🔧 改进

- 更新了项目文档和示例代码
- 完善了测试覆盖率
- 优化了插件平台兼容性配置

### 📝 文档

- 添加了详细的 API 文档
- 完善了使用示例和最佳实践
- 更新了 README.md 文件

### 🐛 修复

- 修复了在某些平台上的兼容性问题
- 优化了事件处理的性能

---

## [0.0.1] - 2025-06-27

### 🎉 首次发布

- Initial release of Global Event Bus
- Type-safe event system with generic support
- Event priority system (critical, high, normal, low)
- Batch processing mode for high-frequency events
- Comprehensive logging system with multiple levels
- Performance monitoring and statistics
- Delayed event sending
- Multiple listener types (once, multi-type, conditional)

### ✨ 核心特性

- **类型安全**: 完全支持 Dart 泛型，编译时类型检查
- **优先级系统**: 支持 critical、high、normal、low 四个优先级
- **批量处理**: 高频事件的批量处理模式，提升性能
- **日志系统**: 多级别日志记录，便于调试和监控
- **性能监控**: 内置统计功能，监控事件发送和接收
- **延迟发送**: 支持延迟事件发送
- **多种监听器**: 支持一次性、多类型、条件监听器

### 🎯 平台支持

- ✅ Android
- ✅ iOS
- ✅ Web
- ✅ macOS
- ✅ Linux
- ✅ Windows

---

## 版本说明

### 版本号规则

本项目遵循 [语义化版本控制](https://semver.org/lang/zh-CN/)：

- **主版本号**: 不兼容的 API 修改
- **次版本号**: 向下兼容的功能性新增
- **修订号**: 向下兼容的问题修正

### 图标说明

- 🚀 新功能 (Added)
- 🔧 改进 (Changed)
- 🗑️ 废弃 (Deprecated)
- 🐛 修复 (Fixed)
- 🔒 安全 (Security)
- 📝 文档 (Documentation)
- ⚠️ 破坏性变更 (Breaking Changes)
- 🎉 重要里程碑 (Major Milestones)
