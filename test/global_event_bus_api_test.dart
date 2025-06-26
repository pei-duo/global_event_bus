import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_event_bus/src/global_event_bus_api.dart';
import 'package:global_event_bus/src/global_event_model.dart';
import 'package:global_event_bus/src/global_event_log.dart';

void main() {
  group('GlobalEventBus API Tests', () {
    late GlobalEventBus eventBus;

    setUp(() {
      eventBus = GlobalEventBus();
      eventBus.configureLogging(const GlobalEventLogConfig(
        level: EventLogLevel.none,
        enabled: false,
      ));
    });

    tearDown(() {
      eventBus.dispose();
    });

    test('should be singleton', () {
      final bus1 = GlobalEventBus();
      final bus2 = GlobalEventBus.instance;
      expect(bus1, same(bus2));
      expect(globalEventBus, same(bus1));
    });

    test('should send and listen to events', () async {
      final completer = Completer<GlobalEvent<String>>();
      
      // 监听事件
      eventBus.listen<String>(
        listenerId: 'api_test_listener',
        onEvent: (event) => completer.complete(event),
        eventTypes: ['api_test'],
      );
      
      // 发送事件
      eventBus.sendEvent<String>(
        type: 'api_test',
        data: 'api_test_data',
        priority: EventPriority.high,
        metadata: {'source': 'api_test'},
      );
      
      // 验证接收
      final event = await completer.future.timeout(const Duration(seconds: 1));
      expect(event.type, 'api_test');
      expect(event.data, 'api_test_data');
      expect(event.priority, EventPriority.high);
      expect(event.metadata?['source'], 'api_test');
    });

    test('should remove listeners', () async {
      final receivedEvents = <GlobalEvent<String>>[];
      
      // 添加监听器
      eventBus.listen<String>(
        listenerId: 'removable_api_listener',
        onEvent: (event) => receivedEvents.add(event),
      );
      
      // 发送事件
      eventBus.sendEvent<String>(
        type: 'remove_test',
        data: 'before_remove',
      );
      
      // 移除监听器
      eventBus.removeListener('removable_api_listener');
      
      // 再次发送事件
      eventBus.sendEvent<String>(
        type: 'remove_test',
        data: 'after_remove',
      );
      
      await Future.delayed(const Duration(milliseconds: 100));
      
      expect(receivedEvents.length, 1);
      expect(receivedEvents.first.data, 'before_remove');
    });

    test('should provide access to manager', () {
      expect(eventBus.manager, isNotNull);
    });

    test('should provide access to stats', () {
      final stats = eventBus.stats;
      expect(stats, isNotNull);
      expect(stats.totalEventsSent, 0);
      
      eventBus.sendEvent<String>(type: 'stats_test', data: 'test');
      expect(stats.totalEventsSent, 1);
    });
  });

  group('Global Convenience Functions Tests', () {
    setUp(() {
      globalEventBus.configureLogging(const GlobalEventLogConfig(
        level: EventLogLevel.none,
        enabled: false,
      ));
    });

    tearDown(() {
      globalEventBus.dispose();
    });

    test('sendGlobalEvent should work', () async {
      final completer = Completer<GlobalEvent<String>>();
      
      listenGlobalEvent<String>(
        listenerId: 'global_send_test',
        onEvent: (event) => completer.complete(event),
        eventTypes: ['global_send'],
      );
      
      sendGlobalEvent<String>(
        type: 'global_send',
        data: 'global_data',
        priority: EventPriority.critical,
      );
      
      final event = await completer.future.timeout(const Duration(seconds: 1));
      expect(event.type, 'global_send');
      expect(event.data, 'global_data');
      expect(event.priority, EventPriority.critical);
    });

    test('listenGlobalEvent should work', () async {
      final receivedEvents = <GlobalEvent<int>>[];
      
      final subscription = listenGlobalEvent<int>(
        listenerId: 'global_listen_test',
        onEvent: (event) => receivedEvents.add(event),
      );
      
      sendGlobalEvent<int>(
        type: 'global_listen',
        data: 42,
      );
      
      await Future.delayed(const Duration(milliseconds: 100));
      
      expect(receivedEvents.length, 1);
      expect(receivedEvents.first.data, 42);
      
      await subscription.cancel();
    });
  });
}