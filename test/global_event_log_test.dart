import 'package:flutter_test/flutter_test.dart';
import 'package:global_event_bus/src/global_event_log.dart';
import 'package:global_event_bus/src/global_event_model.dart';

void main() {
  group('GlobalEventLogConfig Tests', () {
    test('should have correct default values', () {
      const config = GlobalEventLogConfig();
      
      expect(config.level, EventLogLevel.info);
      expect(config.enabled, true);
      expect(config.showTimestamp, true);
      expect(config.showEventId, false);
      expect(config.showPriority, true);
      expect(config.showEventData, false);
      expect(config.showListenerInfo, true);
      expect(config.logPrefix, '[GlobalEvent]');
      expect(config.customLogger, isNull);
      expect(config.eventTypeFilter, isNull);
      expect(config.listenerIdFilter, isNull);
    });

    test('should accept custom values', () {
      customLogger(String message) {}
      var config = GlobalEventLogConfig(
        level: EventLogLevel.debug,
        enabled: false,
        showTimestamp: false,
        showEventId: true,
        showPriority: false,
        showEventData: true,
        showListenerInfo: false,
        logPrefix: '[CustomEvent]',
        customLogger: customLogger,
        eventTypeFilter: const ['event1', 'event2'],
        listenerIdFilter: const ['listener1'],
      );
      
      expect(config.level, EventLogLevel.debug);
      expect(config.enabled, false);
      expect(config.showTimestamp, false);
      expect(config.showEventId, true);
      expect(config.showPriority, false);
      expect(config.showEventData, true);
      expect(config.showListenerInfo, false);
      expect(config.logPrefix, '[CustomEvent]');
      expect(config.customLogger, customLogger);
      expect(config.eventTypeFilter, ['event1', 'event2']);
      expect(config.listenerIdFilter, ['listener1']);
    });
  });

  group('GlobalEventLogger Tests', () {
    late List<String> logMessages;
    late GlobalEventLogConfig testConfig;

    setUp(() {
      logMessages = [];
      testConfig = GlobalEventLogConfig(
        level: EventLogLevel.debug,
        enabled: true,
        customLogger: (message) => logMessages.add(message),
      );
      GlobalEventLogger.setConfig(testConfig);
    });

    test('should log events when enabled', () {
      GlobalEventLogger.logEventSent(
        'test_event',
        EventPriority.normal,
        eventId: 'test_id',
        data: 'test_data',
      );
      
      expect(logMessages.length, 1);
      expect(logMessages.first, contains('test_event'));
    });

    test('should not log when disabled', () {
      GlobalEventLogger.setConfig(testConfig.copyWith(enabled: false));
      
      GlobalEventLogger.logEventSent(
        'test_event',
        EventPriority.normal,
      );
      
      expect(logMessages.length, 0);
    });

    test('should respect log level', () {
      GlobalEventLogger.setConfig(testConfig.copyWith(level: EventLogLevel.error));
      
      GlobalEventLogger.logDebug('debug message');
      GlobalEventLogger.logWarning('warning message');
      GlobalEventLogger.logError('error message');
      
      expect(logMessages.length, 1);
      expect(logMessages.first, contains('error message'));
    });

    test('should filter by event type', () {
      GlobalEventLogger.setConfig(testConfig.copyWith(
        eventTypeFilter: ['allowed_event'],
      ));
      
      GlobalEventLogger.logEventSent('allowed_event', EventPriority.normal);
      GlobalEventLogger.logEventSent('blocked_event', EventPriority.normal);
      
      expect(logMessages.length, 1);
      expect(logMessages.first, contains('allowed_event'));
    });

    test('should include timestamp when enabled', () {
      GlobalEventLogger.setConfig(testConfig.copyWith(showTimestamp: true));
      
      GlobalEventLogger.logDebug('test message');
      
      expect(logMessages.length, 1);
      // 时间戳格式检查
      expect(logMessages.first, matches(r'\d{4}-\d{2}-\d{2}'));
    });

    test('should include event ID when enabled', () {
      GlobalEventLogger.setConfig(testConfig.copyWith(showEventId: true));
      
      GlobalEventLogger.logEventSent(
        'test_event',
        EventPriority.normal,
        eventId: 'test_event_id',
      );
      
      expect(logMessages.length, 1);
      expect(logMessages.first, contains('test_event_id'));
    });

    test('should include priority when enabled', () {
      GlobalEventLogger.setConfig(testConfig.copyWith(showPriority: true));
      
      GlobalEventLogger.logEventSent(
        'test_event',
        EventPriority.critical,
      );
      
      expect(logMessages.length, 1);
      expect(logMessages.first, contains('critical'));
    });

    test('should include event data when enabled', () {
      GlobalEventLogger.setConfig(testConfig.copyWith(showEventData: true));
      
      GlobalEventLogger.logEventSent(
        'test_event',
        EventPriority.normal,
        data: {'key': 'value'},
      );
      
      expect(logMessages.length, 1);
      expect(logMessages.first, contains('key'));
      expect(logMessages.first, contains('value'));
    });
  });
}