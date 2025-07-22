

import 'dart:async';

import 'global_event_log.dart';
import 'global_event_model.dart';

/// 全局事件管理器 - 用于统一管理事件监听和销毁
class GlobalEventManager {
  static final GlobalEventManager _instance = GlobalEventManager._internal();
  factory GlobalEventManager() => _instance;
  GlobalEventManager._internal();

  /// 全局事件流控制器
  final StreamController<BaseGlobalEvent> _globalEventStream =
      StreamController<BaseGlobalEvent>.broadcast();

  /// 存储所有的订阅，用于统一管理
  final Map<String, StreamSubscription<BaseGlobalEvent>> _subscriptions = {};

  /// 事件统计
  final EventStats _stats = EventStats();

  /// 批量发送队列
  final List<BaseGlobalEvent> _batchQueue = [];
  Timer? _batchTimer;

  /// 是否启用批量发送
  bool _batchEnabled = false;

  /// 批量发送间隔（毫秒）
  int _batchInterval = 100;

  /// 配置日志
  void configureLogging(GlobalEventLogConfig config) {
    GlobalEventLogger.setConfig(config);
    GlobalEventLogger.logDebug('日志配置已更新', context: 'GlobalEventManager');
  }

  /// 发送特定类型的事件
  void sendEvent<T>({
    required String type,
    T? data,
    EventPriority priority = EventPriority.normal,
    Map<String, dynamic>? metadata,
  }) {
    try {
      final event = GlobalEvent<T>(
        type: type,
        data: data,
        priority: priority,
        metadata: metadata,
      );

      if (_batchEnabled) {
        _addToBatch(event);
      } else {
        _sendEventInternal(event);
      }

      _stats.recordSentEvent(type);

      // 记录发送日志
      GlobalEventLogger.logEventSent(
        type,
        priority,
        eventId: event.eventId,
        data: data,
      );
    } catch (e) {
      GlobalEventLogger.logError(
        '发送事件失败: $type',
        error: e,
        context: 'sendEvent',
      );
    }
  }

  /// 安全发送事件（不会抛出异常）
  bool sendEventSafe<T>({
    required String type,
    T? data,
    EventPriority priority = EventPriority.normal,
    Map<String, dynamic>? metadata,
  }) {
    try {
      sendEvent<T>(
        type: type,
        data: data,
        priority: priority,
        metadata: metadata,
      );
      return true;
    } catch (e) {
      GlobalEventLogger.logError(
        '安全发送事件失败: $type',
        error: e,
        context: 'sendEventSafe',
      );
      return false;
    }
  }

  /// 延迟发送事件
  void sendEventDelayed<T>({
    required String type,
    required Duration delay,
    T? data,
    EventPriority priority = EventPriority.normal,
    Map<String, dynamic>? metadata,
  }) {
    GlobalEventLogger.logDebug(
      '延迟发送事件: $type (延迟: ${delay.inMilliseconds}ms)',
      context: 'sendEventDelayed',
    );

    Timer(delay, () {
      sendEvent<T>(
        type: type,
        data: data,
        priority: priority,
        metadata: metadata,
      );
    });
  }

  /// 内部发送事件方法
  void _sendEventInternal(BaseGlobalEvent event) {
    if (_globalEventStream.isClosed) {
      GlobalEventLogger.logWarning(
        '尝试向已关闭的流发送事件: ${event.type}',
        context: '_sendEventInternal',
      );
      return;
    }
    _globalEventStream.add(event);
  }

  /// 添加到批量队列
  void _addToBatch(BaseGlobalEvent event) {
    _batchQueue.add(event);

    _batchTimer?.cancel();
    _batchTimer = Timer(Duration(milliseconds: _batchInterval), () {
      _flushBatch();
    });
  }

  /// 刷新批量队列
  void _flushBatch() {
    if (_batchQueue.isEmpty) return;

    GlobalEventLogger.logDebug(
      '刷新批量队列: ${_batchQueue.length} 个事件',
      context: '_flushBatch',
    );

    // 按优先级排序
    _batchQueue.sort((a, b) => b.priority.value.compareTo(a.priority.value));

    for (final event in _batchQueue) {
      _sendEventInternal(event);
    }

    _batchQueue.clear();
    _batchTimer = null;
  }

  /// 启用/禁用批量发送
  void setBatchMode(bool enabled, {int intervalMs = 100}) {
    _batchEnabled = enabled;
    _batchInterval = intervalMs;

    GlobalEventLogger.logDebug(
      '批量模式${enabled ? "启用" : "禁用"} (间隔: ${intervalMs}ms)',
      context: 'setBatchMode',
    );

    if (!enabled && _batchQueue.isNotEmpty) {
      _flushBatch();
    }
  }

  /// 类型安全的监听器添加方法
  StreamSubscription<BaseGlobalEvent> addTypedListener<T>({
    required String listenerId,
    required void Function(GlobalEvent<T> event) onEvent,
    void Function(Object error)? onError,
    List<String>? eventTypes,
  }) {
    return _addListener(
      listenerId,
      (event) {
        try {
          if (event is GlobalEvent<T>) {
            // 记录接收日志
            GlobalEventLogger.logEventReceived(
              event.type,
              listenerId,
              event.priority,
              eventId: event.eventId,
            );

            onEvent(event);
            _stats.recordReceivedEvent();
          }
        } catch (e) {
          GlobalEventLogger.logError(
            '事件处理错误',
            error: e,
            context: 'addTypedListener:$listenerId',
          );
          onError?.call(e);
        }
      },
      eventTypes: eventTypes,
      onError: onError,
    );
  }

  /// 一次性监听器
  StreamSubscription<BaseGlobalEvent> addOnceListener<T>({
    required String listenerId,
    required void Function(GlobalEvent<T> event) onEvent,
    List<String>? eventTypes,
  }) {
    late StreamSubscription<BaseGlobalEvent> subscription;

    subscription = addTypedListener<T>(
      listenerId: '${listenerId}_once',
      onEvent: (event) {
        onEvent(event);
        subscription.cancel();
        _subscriptions.remove('${listenerId}_once');
        GlobalEventLogger.logDebug(
          '一次性监听器已自动移除: ${listenerId}_once',
          context: 'addOnceListener',
        );
      },
      eventTypes: eventTypes,
    );

    return subscription;
  }

  /// 添加监听器
  StreamSubscription<BaseGlobalEvent> _addListener(
    String listenerId,
    void Function(BaseGlobalEvent event) onEvent, {
    List<String>? eventTypes,
    void Function(Object error)? onError,
  }) {
    // 如果已存在同名监听器，先取消
    removeListener(listenerId);

    StreamSubscription<BaseGlobalEvent> subscription;

    Stream<BaseGlobalEvent> stream = _globalEventStream.stream;

    if (eventTypes != null && eventTypes.isNotEmpty) {
      // 只监听指定类型的事件
      stream = stream.where((event) => eventTypes.contains(event.type));
    }

    subscription = stream.listen(
      onEvent,
      onError: (error) {
        GlobalEventLogger.logError(
          '监听器错误: $listenerId',
          error: error,
          context: '_addListener',
        );
        onError?.call(error);
      },
    );

    _subscriptions[listenerId] = subscription;

    // 记录监听器操作日志
    GlobalEventLogger.logListenerOperation(
      '添加',
      listenerId,
      eventTypes: eventTypes,
    );

    return subscription;
  }

  /// 移除指定监听器
  void removeListener(String listenerId) {
    final subscription = _subscriptions.remove(listenerId);
    if (subscription != null) {
      subscription.cancel();
      GlobalEventLogger.logListenerOperation('移除', listenerId);
    }
  }

  /// 移除所有监听器
  void removeAllListeners() {
    final count = _subscriptions.length;
    for (final subscription in _subscriptions.values) {
      subscription.cancel();
    }
    _subscriptions.clear();
    GlobalEventLogger.logDebug(
      '移除所有监听器: $count 个',
      context: 'removeAllListeners',
    );
  }

  /// 自动清理过期监听器（可在应用生命周期中调用）
  void cleanupExpiredListeners() {
    final expiredIds = <String>[];

    for (final entry in _subscriptions.entries) {
      // 检查监听器是否仍然有效
      if (entry.value.isPaused) {
        expiredIds.add(entry.key);
      }
    }

    for (final id in expiredIds) {
      removeListener(id);
    }

    if (expiredIds.isNotEmpty) {
      GlobalEventLogger.logDebug(
        '清理了 ${expiredIds.length} 个过期监听器',
        context: 'cleanupExpiredListeners',
      );
    }
  }

  /// 销毁管理器
  void dispose() {
    _batchTimer?.cancel();
    _flushBatch();
    removeAllListeners();
    _globalEventStream.close();
    GlobalEventLogger.logDebug('管理器已销毁', context: 'dispose');
  }

  /// 获取当前监听器数量
  int get listenerCount => _subscriptions.length;

  /// 获取所有监听器ID
  List<String> get listenerIds => _subscriptions.keys.toList();

  /// 获取事件统计信息
  EventStats get stats => _stats;

  /// 获取性能信息
  Map<String, dynamic> get performanceInfo => {
    'listenerCount': listenerCount,
    'totalEventsSent': _stats.totalEventsSent,
    'totalEventsReceived': _stats.totalEventsReceived,
    'eventTypeCount': Map.from(_stats.eventTypeCount),
    'lastEventTime': _stats.lastEventTime?.toIso8601String(),
    'batchEnabled': _batchEnabled,
    'batchQueueSize': _batchQueue.length,
  };
}
