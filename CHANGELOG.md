# 变更日志

此项目的所有显著更改都将记录在此文件中。

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] 

### 🔧 Code Quality Improvements
- 修复测试文件中的代码风格问题
- 优化构造函数使用const关键字提升性能
- 通过静态代码分析检查，确保代码质量
- 统一代码格式化标准

---

## [1.0.0]

### 🎉 Major Release - Pure Dart Package

#### ✨ Features
- **BREAKING CHANGE**: 转换为纯Dart包，移除所有平台特定代码
- 保持所有核心事件总线功能完整性
- 简化包结构，提升性能和兼容性

#### 🗑️ Removed
- 移除平台插件配置和依赖
- 删除 `getPlatformVersion()` 方法（非核心功能）
- 移除所有原生平台目录（android, ios, linux, macos, windows）
- 删除平台接口相关文件：
  - `global_event_bus_platform_interface.dart`
  - `global_event_bus_method_channel.dart`
  - `global_event_bus_web.dart`

#### 🔧 Technical Changes
- 更新 `pubspec.yaml`，移除 `plugin_platform_interface` 和 `flutter_web_plugins` 依赖
- 简化主入口文件 `global_event_bus.dart`
- 更新测试文件，专注于核心事件总线功能测试

#### 📈 Benefits
- ✅ 更好的跨平台兼容性
- ✅ 更简单的维护和部署
- ✅ 更快的包加载速度
- ✅ 减少依赖冲突风险

#### 🔄 Migration Guide
如果您之前使用了 `getPlatformVersion()` 方法，请移除相关调用。所有其他API保持不变。

---

## [Unreleased]

### 🚀 计划新功能

- 事件持久化支持
- 事件重放功能
- 更多的事件过滤器

---

## [0.0.7]

### 🔧 改进

- **仓库迁移**：将主要仓库从 GitHub 迁移到 Gitee，提供更好的国内访问体验
- **文档更新**：更新所有项目文档中的仓库链接，包括：
  - `pubspec.yaml` 中的 homepage、repository 和 issue_tracker 链接
  - `README.md` 中的克隆命令
  - iOS 和 macOS podspec 文件中的 homepage 链接
- **双仓库同步**：配置了 Gitee 和 GitHub 的双仓库同步机制，GitHub 作为备份仓库

### 📝 文档

- 更新项目主页链接为 Gitee 仓库
- 更新问题反馈链接指向 Gitee Issues
- 保持技术文档和第三方依赖的原有链接不变

---

## [0.0.6] 

### 🚀 新功能

`GlobalEventBus` 类

- **增强的事件发送 API**： 新增 `sendEventWithoutData()` 方法，支持发送无数据载荷的事件
- **安全事件发送**：新增 `sendEventSafe()` 方法，提供不抛出异常的安全发送机制
- **延迟事件发送**：新增 `sendEventDelayed()` 方法，支持延迟指定时间后发送事件
- **一次性监听器**：新增 `listenOnce()` 方法，支持只触发一次的事件监听器
- **批量监听器管理**：新增 `removeAllListeners()` 和 `cleanupExpiredListeners()` 方法
- **监听器状态查询**：新增 `hasListener()` 方法检查指定监听器是否存在
- **性能监控增强**：新增 `listenerCount`、`listenerIds` 和 `performanceInfo` 属性
- **批量处理控制**：新增 `setBatchMode()` 方法，可动态启用/禁用批量处理模式

### 🔧 改进

- **API 完整性提升**：GlobalEventBus 类现在提供了更完整的事件管理功能
- **错误处理增强**：所有监听器方法现在支持可选的 `onError` 回调参数
- **类型安全优化**：改进了泛型事件的类型推断和安全性
- **性能监控**：增强了事件统计和性能信息收集功能
- **代码结构优化**：更好的封装性，隐藏了内部实现细节

### 📝 文档

- 完善了 GlobalEventBus 类的 API 文档
- 添加了新功能的使用示例和最佳实践
- 更新了性能优化相关的文档说明

### 🐛 修复

- 修复了 `sendEventDelayed()` 方法中 metadata 参数传递的问题
- 优化了一次性监听器的自动清理机制
- 改进了批量处理模式下的事件排序逻辑

### ⚡ 性能优化

- 优化了监听器查找和管理的性能
- 改进了批量事件处理的效率
- 减少了不必要的内存分配和垃圾回收

---

## [0.0.5] 

### 🚀 新功能

- 支持事件发送时可选 data 字段（GlobalEvent 类已修改为 T?类型）
- 优化 global_event_manager.dart 的 sendEvent 方法实现

### 🔧 改进

- 增加对空 data 场景的类型校验
- 更新相关测试用例覆盖无 data 参数的事件发送

---

## [0.0.4] 

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

### ⚠️ 版本说明

- 版本 0.0.2 和 0.0.3 因 Android 兼容性问题已撤回
- 强烈建议所有用户升级到 0.0.4 版本

---

## [0.0.3] 

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

## [0.0.2] 

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

## [0.0.1] 

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
- ⚡ 性能优化 (Performance)
