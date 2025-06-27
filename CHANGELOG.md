## 0.0.2

### 🚀 新功能
* 降低了 Flutter SDK 最低版本要求至 3.0.0，提高兼容性
* 降低了 Dart SDK 最低版本要求至 2.17.0
* 优化了依赖包版本约束，提升稳定性

### 🔧 改进
* 更新了项目文档和示例代码
* 完善了测试覆盖率
* 优化了插件平台兼容性配置

### 📝 文档
* 添加了详细的 API 文档
* 完善了使用示例和最佳实践
* 更新了 README.md 文件

### 🐛 修复
* 修复了在某些平台上的兼容性问题
* 优化了事件处理的性能

---

## 0.0.1

### 🎉 首次发布
* Initial release of Global Event Bus
* Type-safe event system with generic support
* Event priority system (critical, high, normal, low)
* Batch processing mode for high-frequency events
* Comprehensive logging system with multiple levels
* Performance monitoring and statistics
* Delayed event sending
* Multiple listener types (once, multi-type, conditional)

### ✨ 核心特性
* **类型安全**: 完全支持 Dart 泛型，编译时类型检查
* **优先级系统**: 支持 critical、high、normal、low 四个优先级
* **批量处理**: 高频事件的批量处理模式，提升性能
* **日志系统**: 多级别日志记录，便于调试和监控
* **性能监控**: 内置统计功能，监控事件发送和接收
* **延迟发送**: 支持延迟事件发送
* **多种监听器**: 支持一次性、多类型、条件监听器

### 🎯 平台支持
* ✅ Android
* ✅ iOS
* ✅ Web
* ✅ macOS
* ✅ Linux
* ✅ Windows