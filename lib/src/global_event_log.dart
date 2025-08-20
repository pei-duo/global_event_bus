import 'package:flutter/foundation.dart';

import 'global_event_model.dart';

/// 日志级别枚举
/// 用于控制日志输出的详细程度
enum EventLogLevel {
  none, // 不输出日志
  error, // 只输出错误
  warning, // 输出警告和错误
  info, // 输出信息、警告和错误
  debug, // 输出所有日志
}

/// 全局事件日志配置类
/// 用于配置全局事件系统的日志输出行为
class GlobalEventLogConfig {
  /// 日志级别
  /// 默认值: EventLogLevel.info
  /// 控制输出哪些级别的日志信息
  final EventLogLevel level;

  /// 是否启用日志
  /// 默认值: true
  /// 总开关，控制是否输出任何日志
  final bool enabled;

  /// 是否显示时间戳
  /// 默认值: true
  /// 控制日志中是否包含时间戳信息
  final bool showTimestamp;

  /// 是否显示事件ID
  /// 默认值: false
  /// 控制日志中是否显示事件的唯一标识符
  final bool showEventId;

  /// 是否显示优先级
  /// 默认值: true
  /// 控制日志中是否显示事件的优先级信息
  final bool showPriority;

  /// 是否显示事件数据
  /// 默认值: false
  /// 控制日志中是否显示事件携带的数据内容
  /// 注意：显示事件数据可能会暴露敏感信息，生产环境建议关闭
  final bool showEventData;

  /// 是否显示监听器信息
  /// 默认值: true
  /// 控制日志中是否显示处理事件的监听器信息
  final bool showListenerInfo;

  /// 自定义日志前缀
  /// 默认值: '[GlobalEvent]'
  /// 用于标识全局事件系统的日志，便于在混合日志中识别
  final String logPrefix;

  /// 自定义日志输出函数
  /// 默认值: null
  /// 当为null时使用系统默认的debugPrint函数
  /// 可以自定义为文件输出、网络上传等
  final void Function(String message)? customLogger;

  /// 事件类型过滤器
  /// 默认值: null
  /// 当不为null时，只记录指定类型的事件日志
  /// 用于减少日志量，专注于特定事件类型的调试
  final List<String>? eventTypeFilter;

  /// 监听器ID过滤器
  /// 默认值: null
  /// 当不为null时，只记录指定监听器的日志
  /// 用于专注于特定监听器的行为调试
  final List<String>? listenerIdFilter;

  /// 构造函数
  /// 所有参数都有默认值，可以根据需要选择性配置
  const GlobalEventLogConfig({
    this.level = EventLogLevel.info, // 默认信息级别
    this.enabled = true, // 默认启用日志
    this.showTimestamp = true, // 默认显示时间戳
    this.showEventId = false, // 默认不显示事件ID
    this.showPriority = true, // 默认显示优先级
    this.showEventData = false, // 默认不显示事件数据
    this.showListenerInfo = true, // 默认显示监听器信息
    this.logPrefix = '[GlobalEvent]', // 默认日志前缀
    this.customLogger, // 默认为null，使用系统日志
    this.eventTypeFilter, // 默认为null，不过滤事件类型
    this.listenerIdFilter, // 默认为null，不过滤监听器
  });

  /// 创建默认配置
  /// 使用所有默认值的配置实例
  static const GlobalEventLogConfig defaultConfig = GlobalEventLogConfig();

  /// 创建调试配置
  /// 适合开发调试时使用，显示更多详细信息
  static const GlobalEventLogConfig debugConfig = GlobalEventLogConfig(
    level: EventLogLevel.debug, // 显示所有级别日志
    showEventId: true, // 显示事件ID
    showEventData: true, // 显示事件数据
  );

  /// 创建生产环境配置
  /// 适合生产环境使用，只显示关键错误信息
  static const GlobalEventLogConfig productionConfig = GlobalEventLogConfig(
    level: EventLogLevel.error, // 只显示错误级别
    showEventData: false, // 不显示敏感数据
    showListenerInfo: false, // 不显示监听器详情
  );

  /// 创建静默配置
  /// 完全关闭日志输出
  static const GlobalEventLogConfig silentConfig = GlobalEventLogConfig(
    enabled: false, // 禁用日志
    level: EventLogLevel.none, // 不输出任何级别
  );

  /// 复制并修改配置
  /// 基于当前配置创建新的配置实例，只修改指定的属性
  /// 使用copyWith模式，保持不可变性
  GlobalEventLogConfig copyWith({
    EventLogLevel? level,
    bool? enabled,
    bool? showTimestamp,
    bool? showEventId,
    bool? showPriority,
    bool? showEventData,
    bool? showListenerInfo,
    String? logPrefix,
    void Function(String message)? customLogger,
    List<String>? eventTypeFilter,
    List<String>? listenerIdFilter,
  }) {
    return GlobalEventLogConfig(
      level: level ?? this.level,
      enabled: enabled ?? this.enabled,
      showTimestamp: showTimestamp ?? this.showTimestamp,
      showEventId: showEventId ?? this.showEventId,
      showPriority: showPriority ?? this.showPriority,
      showEventData: showEventData ?? this.showEventData,
      showListenerInfo: showListenerInfo ?? this.showListenerInfo,
      logPrefix: logPrefix ?? this.logPrefix,
      customLogger: customLogger ?? this.customLogger,
      eventTypeFilter: eventTypeFilter ?? this.eventTypeFilter,
      listenerIdFilter: listenerIdFilter ?? this.listenerIdFilter,
    );
  }
}

/// 全局事件日志器
class GlobalEventLogger {
  static GlobalEventLogConfig _config = GlobalEventLogConfig.defaultConfig;

  /// 设置日志配置
  static void setConfig(GlobalEventLogConfig config) {
    _config = config;
  }

  /// 获取当前配置
  static GlobalEventLogConfig get config => _config;

  /// 记录事件发送日志
  static void logEventSent(
    String type,
    EventPriority priority, {
    String? eventId,
    dynamic data,
  }) {
    if (!_config.enabled || !_shouldLog(EventLogLevel.info)) return;
    if (_config.eventTypeFilter != null &&
        !_config.eventTypeFilter!.contains(type)) {
      return;
    }

    final message = _buildEventMessage(
      '发送事件',
      type,
      priority,
      eventId: eventId,
      data: data,
    );
    _output(message);
  }

  /// 记录事件接收日志
  static void logEventReceived(
    String type,
    String listenerId,
    EventPriority priority, {
    String? eventId,
  }) {
    if (!_config.enabled || !_shouldLog(EventLogLevel.info)) return;
    if (_config.eventTypeFilter != null &&
        !_config.eventTypeFilter!.contains(type)) {
      return;
    }
    if (_config.listenerIdFilter != null &&
        !_config.listenerIdFilter!.contains(listenerId)) {
      return;
    }

    final message = _buildEventMessage(
      '接收事件',
      type,
      priority,
      eventId: eventId,
      listenerId: listenerId,
    );
    _output(message);
  }

  /// 记录监听器操作日志
  static void logListenerOperation(
    String operation,
    String listenerId, {
    List<String>? eventTypes,
  }) {
    if (!_config.enabled ||
        !_shouldLog(EventLogLevel.info) ||
        !_config.showListenerInfo) {
      return;
    }
    if (_config.listenerIdFilter != null &&
        !_config.listenerIdFilter!.contains(listenerId)) {
      return;
    }

    final buffer = StringBuffer();
    buffer.write(_config.logPrefix);

    if (_config.showTimestamp) {
      buffer.write(' [${DateTime.now().toIso8601String()}]');
    }

    buffer.write(' $operation监听器: $listenerId');

    if (eventTypes != null && eventTypes.isNotEmpty) {
      buffer.write(' (事件类型: ${eventTypes.join(", ")})');
    }

    _output(buffer.toString());
  }

  /// 记录错误日志
  static void logError(String message, {Object? error, String? context}) {
    if (!_config.enabled || !_shouldLog(EventLogLevel.error)) return;

    final buffer = StringBuffer();
    buffer.write(_config.logPrefix);

    if (_config.showTimestamp) {
      buffer.write(' [${DateTime.now().toIso8601String()}]');
    }

    buffer.write(' [ERROR]');

    if (context != null) {
      buffer.write(' [$context]');
    }

    buffer.write(' $message');

    if (error != null) {
      buffer.write(' - $error');
    }

    _output(buffer.toString());
  }

  /// 记录警告日志
  static void logWarning(String message, {String? context}) {
    if (!_config.enabled || !_shouldLog(EventLogLevel.warning)) return;

    final buffer = StringBuffer();
    buffer.write(_config.logPrefix);

    if (_config.showTimestamp) {
      buffer.write(' [${DateTime.now().toIso8601String()}]');
    }

    buffer.write(' [WARNING]');

    if (context != null) {
      buffer.write(' [$context]');
    }

    buffer.write(' $message');

    _output(buffer.toString());
  }

  /// 记录调试日志
  static void logDebug(String message, {String? context}) {
    if (!_config.enabled || !_shouldLog(EventLogLevel.debug)) return;

    final buffer = StringBuffer();
    buffer.write(_config.logPrefix);

    if (_config.showTimestamp) {
      buffer.write(' [${DateTime.now().toIso8601String()}]');
    }

    buffer.write(' [DEBUG]');

    if (context != null) {
      buffer.write(' [$context]');
    }

    buffer.write(' $message');

    _output(buffer.toString());
  }

  /// 构建事件消息
  static String _buildEventMessage(
    String action,
    String type,
    EventPriority priority, {
    String? eventId,
    dynamic data,
    String? listenerId,
  }) {
    final buffer = StringBuffer();
    buffer.write(_config.logPrefix);

    if (_config.showTimestamp) {
      buffer.write(' [${DateTime.now().toIso8601String()}]');
    }

    buffer.write(' $action: $type');

    if (_config.showPriority) {
      buffer.write(' (优先级: ${priority.name})');
    }

    if (_config.showEventId && eventId != null) {
      buffer.write(' [ID: $eventId]');
    }

    if (listenerId != null && _config.showListenerInfo) {
      buffer.write(' [监听器: $listenerId]');
    }

    if (_config.showEventData && data != null) {
      buffer.write(' [数据: $data]');
    }

    return buffer.toString();
  }

  /// 检查是否应该记录日志
  static bool _shouldLog(EventLogLevel level) {
    return _config.level.index >= level.index;
  }

  /// 输出日志
  static void _output(String message) {
    if (_config.customLogger != null) {
      _config.customLogger!(message);
    } else {
      debugPrint(message);
    }
  }
}
