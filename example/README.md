# Global Event Bus Example

这个示例项目展示了如何使用 `global_event_bus` 插件的各种功能。

## 功能演示

### 基础示例 (main.dart)
- 事件发送和监听
- 不同优先级事件处理
- 批量事件处理
- 实时统计信息显示

### 高级示例 (advanced_example.dart)
- 多页面事件通信
- 类型安全的事件处理
- 用户登录状态管理
- 购物车状态同步

## 运行示例

```bash
cd example
flutter pub get
flutter run
```

## 主要特性展示

1. **类型安全**: 使用泛型确保事件数据类型安全
2. **优先级系统**: 支持 critical、high、normal、low 四个优先级
3. **批量处理**: 高频事件的批量处理模式
4. **性能监控**: 实时查看事件统计信息
5. **多页面通信**: 跨页面的事件通信机制
