/// 事件优先级枚举
enum EventPriority {
  low(0),
  normal(1),
  high(2),
  critical(3);

  const EventPriority(this.value);
  final int value;
}

/// 事件统计信息
class EventStats {
  int totalEventsSent = 0;
  int totalEventsReceived = 0;
  final Map<String, int> eventTypeCount = {};
  DateTime? lastEventTime;

  void recordSentEvent(String type) {
    totalEventsSent++;
    eventTypeCount[type] = (eventTypeCount[type] ?? 0) + 1;
    lastEventTime = DateTime.now();
  }

  void recordReceivedEvent() {
    totalEventsReceived++;
  }
}

/// 基础事件类
abstract class BaseGlobalEvent {
  final String type; // 事件类型标识
  final DateTime timestamp;
  final String eventId;
  final EventPriority priority;
  final Map<String, dynamic>? metadata;

  BaseGlobalEvent({
    required this.type,
    this.priority = EventPriority.normal,
    this.metadata,
  })  : timestamp = DateTime.now(),
        eventId = _generateEventId();

  static String _generateEventId() {
    // 使用更高效的ID生成策略
    return '${DateTime.now().millisecondsSinceEpoch}_${_counter++}';
  }

  static int _counter = 0;

  @override
  String toString() {
    return 'GlobalEvent{type: $type, priority: $priority, timestamp: $timestamp}';
  }
}

/// 泛型全局事件类
class GlobalEvent<T> extends BaseGlobalEvent {
  final T data;

  GlobalEvent({
    required super.type,
    required this.data,
    super.priority,
    super.metadata,
  });

  @override
  String toString() {
    return 'GlobalEvent{type: $type, data: $data, priority: $priority, timestamp: $timestamp}';
  }
}
