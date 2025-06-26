import 'dart:async';
import 'global_event_model.dart';
import 'global_event_manager.dart';
import 'global_event_log.dart';


/// # 全局事件总线系统 (Global Event Bus System)
///
/// 这是一个高性能、类型安全的全局事件分发系统，用于在应用程序的不同模块之间进行解耦通信。
/// 采用观察者模式和流式处理架构，支持事件优先级、批量处理、日志监控等高级功能。


/// 便捷的全局事件管理器实例
final globalEventBus = GlobalEventBus.instance;

/// 全局事件总线便捷API
class GlobalEventBus {
  static final GlobalEventBus _instance = GlobalEventBus._internal();
  factory GlobalEventBus() => _instance;
  static GlobalEventBus get instance => _instance;

  GlobalEventBus._internal();

  final GlobalEventManager _manager = GlobalEventManager();

  /// 获取管理器实例
  GlobalEventManager get manager => _manager;

  /// 发送事件
  void sendEvent<T>({
    required String type,
    required T data,
    EventPriority priority = EventPriority.normal,
    Map<String, dynamic>? metadata,
  }) {
    _manager.sendEvent<T>(
      type: type,
      data: data,
      priority: priority,
      metadata: metadata,
    );
  }

  /// 监听事件
  StreamSubscription<BaseGlobalEvent> listen<T>({
    required String listenerId,
    required void Function(GlobalEvent<T> event) onEvent,
    List<String>? eventTypes,
  }) {
    return _manager.addTypedListener<T>(
      listenerId: listenerId,
      onEvent: onEvent,
      eventTypes: eventTypes,
    );
  }

  /// 移除监听器
  void removeListener(String listenerId) {
    _manager.removeListener(listenerId);
  }

  /// 配置日志
  void configureLogging(GlobalEventLogConfig config) {
    _manager.configureLogging(config);
  }

  /// 获取统计信息
  EventStats get stats => _manager.stats;

  /// 销毁
  void dispose() {
    _manager.dispose();
  }
}


/// 便捷的事件发送方法
void sendGlobalEvent<T>({
  required String type,
  required T data,
  EventPriority priority = EventPriority.normal,
  Map<String, dynamic>? metadata,
}) {
  globalEventBus.sendEvent<T>(
    type: type,
    data: data,
    priority: priority,
    metadata: metadata,
  );
}

/// 便捷的类型安全监听方法
StreamSubscription<BaseGlobalEvent> listenGlobalEvent<T>({
  required String listenerId,
  required void Function(GlobalEvent<T> event) onEvent,
  List<String>? eventTypes,
}) {
  return globalEventBus.listen<T>(
    listenerId: listenerId,
    onEvent: onEvent,
    eventTypes: eventTypes,
  );
}

/// 便捷的全局事件注销方法
void removeGlobalEventListener(String listenerId) {
  globalEventBus.removeListener(listenerId);
}

/// 便捷的日志配置方法
void configureGlobalEventLogging(GlobalEventLogConfig config) {
  globalEventBus.configureLogging(config);
}

/// 快速配置开发环境日志
void enableDebugLogging() {
  configureGlobalEventLogging(GlobalEventLogConfig.debugConfig);
}

/// 快速配置生产环境日志
void enableProductionLogging() {
  configureGlobalEventLogging(GlobalEventLogConfig.productionConfig);
}

/// 快速禁用日志
void disableLogging() {
  configureGlobalEventLogging(GlobalEventLogConfig.silentConfig);
}

/// 启用批量模式（可选）
///
/// 批量模式下，事件发送会延迟一段时间（默认100ms），
/// 并将多个相同类型的事件合并为一个批量事件。
/// 这对于高频事件（如用户交互）非常有用，可以减少事件处理开销。
///
/// 注意：
/// - 批量模式仅影响高频事件，对于低频率事件无效
/// - 批量间隔时间可以根据应用需求调整
void enableBatchMode({int intervalMs = 100}) {
  globalEventBus.manager.setBatchMode(true, intervalMs: 100);
}
