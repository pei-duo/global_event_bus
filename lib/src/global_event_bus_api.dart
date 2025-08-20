import 'dart:async';
import 'global_event_model.dart';
import 'global_event_manager.dart';
import 'global_event_log.dart';

/// # 全局事件总线系统 (Global Event Bus System)
///
/// 这是一个高性能、类型安全的全局事件分发系统，用于在应用程序的不同模块之间进行解耦通信。
/// 采用观察者模式和流式处理架构，支持事件优先级、批量处理、日志监控等高级功能。
///
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

  /// 发送无数据事件
  void sendEventWithoutData({
    required String type,
    EventPriority priority = EventPriority.normal,
    Map<String, dynamic>? metadata,
  }) {
    _manager.sendWithoutData(
      type: type,
      priority: priority,
      metadata: metadata,
    );
  }

  /// 安全发送事件（不会抛出异常）
  bool sendEventSafe<T>({
    required String type,
    required T data,
    EventPriority priority = EventPriority.normal,
    Map<String, dynamic>? metadata,
  }) {
    return _manager.sendEventSafe<T>(
      type: type,
      data: data,
      priority: priority,
      metadata: metadata,
    );
  }

  /// 延迟发送事件
  void sendEventDelayed<T>({
    required String type,
    required Duration delay,
    required T data,
    EventPriority priority = EventPriority.normal,
    Map<String, dynamic>? metadata,
  }) {
    _manager.sendEventDelayed<T>(
      type: type,
      delay: delay,
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
    void Function(Object error)? onError,
  }) {
    return _manager.addTypedListener<T>(
      listenerId: listenerId,
      onEvent: onEvent,
      eventTypes: eventTypes,
      onError: onError,
    );
  }

  /// 一次性监听事件
  StreamSubscription<BaseGlobalEvent> listenOnce<T>({
    required String listenerId,
    required void Function(GlobalEvent<T> event) onEvent,
    List<String>? eventTypes,
  }) {
    return _manager.addOnceListener<T>(
      listenerId: listenerId,
      onEvent: onEvent,
      eventTypes: eventTypes,
    );
  }

  /// 移除监听器
  void removeListener(String listenerId) {
    _manager.removeListener(listenerId);
  }

  /// 移除所有监听器
  void removeAllListeners() {
    _manager.removeAllListeners();
  }

  /// 清理过期监听器
  void cleanupExpiredListeners() {
    _manager.cleanupExpiredListeners();
  }

  /// 配置日志
  void configureLogging(GlobalEventLogConfig config) {
    _manager.configureLogging(config);
  }

  /// 启用/禁用批量发送模式
  void setBatchMode(bool enabled, {int intervalMs = 100}) {
    _manager.setBatchMode(enabled, intervalMs: intervalMs);
  }

  /// 获取统计信息
  EventStats get stats => _manager.stats;

  /// 获取当前监听器数量
  int get listenerCount => _manager.listenerCount;

  /// 获取所有监听器ID
  List<String> get listenerIds => _manager.listenerIds;

  /// 获取性能信息
  Map<String, dynamic> get performanceInfo => _manager.performanceInfo;

  /// 检查是否有指定的监听器
  bool hasListener(String listenerId) {
    return _manager.listenerIds.contains(listenerId);
  }

  /// 销毁
  void dispose() {
    _manager.dispose();
  }
}
