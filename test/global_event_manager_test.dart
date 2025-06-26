import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:global_event_bus/src/global_event_manager.dart';
import 'package:global_event_bus/src/global_event_model.dart';
import 'package:global_event_bus/src/global_event_log.dart';

void main() {
  group('GlobalEventManager Tests', () {
    late GlobalEventManager manager;

    setUp(() {
      manager = GlobalEventManager();
      // 配置测试日志
      manager.configureLogging(
        const GlobalEventLogConfig(
          level: EventLogLevel.none, // 测试时关闭日志
          enabled: false,
        ),
      );
    });

    tearDown(() {
      manager.dispose();
    });

    test('should be singleton', () {
      final manager1 = GlobalEventManager();
      final manager2 = GlobalEventManager();
      expect(manager1, same(manager2));
    });

    test('should send and receive events', () async {
      final completer = Completer<GlobalEvent<String>>();

      // 添加监听器
      manager.addTypedListener<String>(
        listenerId: 'test_listener',
        onEvent: (event) {
          completer.complete(event);
        },
        eventTypes: ['test_event'],
      );

      // 发送事件
      manager.sendEvent<String>(type: 'test_event', data: 'test_data');

      // 验证接收
      final receivedEvent = await completer.future.timeout(
        const Duration(seconds: 1),
      );

      expect(receivedEvent.type, 'test_event');
      expect(receivedEvent.data, 'test_data');
    });

    test('should handle multiple listeners', () async {
      final completer1 = Completer<GlobalEvent<String>>();
      final completer2 = Completer<GlobalEvent<String>>();

      // 添加多个监听器
      manager.addTypedListener<String>(
        listenerId: 'listener1',
        onEvent: (event) => completer1.complete(event),
      );

      manager.addTypedListener<String>(
        listenerId: 'listener2',
        onEvent: (event) => completer2.complete(event),
      );

      // 发送事件
      manager.sendEvent<String>(
        type: 'broadcast_event',
        data: 'broadcast_data',
      );

      // 验证两个监听器都收到事件
      final event1 = await completer1.future.timeout(
        const Duration(seconds: 1),
      );
      final event2 = await completer2.future.timeout(
        const Duration(seconds: 1),
      );

      expect(event1.type, 'broadcast_event');
      expect(event2.type, 'broadcast_event');
    });

    test('should filter events by type', () async {
      final receivedEvents = <GlobalEvent<String>>[];

      // 只监听特定类型的事件
      manager.addTypedListener<String>(
        listenerId: 'filtered_listener',
        onEvent: (event) => receivedEvents.add(event),
        eventTypes: ['allowed_event'],
      );

      // 发送不同类型的事件
      manager.sendEvent<String>(type: 'allowed_event', data: 'should_receive');

      manager.sendEvent<String>(
        type: 'blocked_event',
        data: 'should_not_receive',
      );

      // 等待事件处理
      await Future.delayed(const Duration(milliseconds: 100));

      expect(receivedEvents.length, 1);
      expect(receivedEvents.first.type, 'allowed_event');
    });

    test('should remove listeners', () async {
      final receivedEvents = <GlobalEvent<String>>[];

      // 添加监听器
      manager.addTypedListener<String>(
        listenerId: 'removable_listener',
        onEvent: (event) => receivedEvents.add(event),
      );

      // 发送第一个事件
      manager.sendEvent<String>(type: 'test_event', data: 'first');

      // 移除监听器
      manager.removeListener('removable_listener');

      // 发送第二个事件
      manager.sendEvent<String>(type: 'test_event', data: 'second');

      // 等待事件处理
      await Future.delayed(const Duration(milliseconds: 100));

      // 应该只收到第一个事件
      expect(receivedEvents.length, 1);
      expect(receivedEvents.first.data, 'first');
    });

    test('should handle event priorities', () async {
      final receivedEvents = <GlobalEvent<String>>[];

      manager.addTypedListener<String>(
        listenerId: 'priority_listener',
        onEvent: (event) => receivedEvents.add(event),
      );

      // 发送不同优先级的事件
      manager.sendEvent<String>(
        type: 'test_event',
        data: 'low',
        priority: EventPriority.low,
      );

      manager.sendEvent<String>(
        type: 'test_event',
        data: 'critical',
        priority: EventPriority.critical,
      );

      manager.sendEvent<String>(
        type: 'test_event',
        data: 'normal',
        priority: EventPriority.normal,
      );

      // 等待事件处理
      await Future.delayed(const Duration(milliseconds: 100));

      expect(receivedEvents.length, 3);
      // 验证优先级顺序（critical > normal > low）
      expect(receivedEvents[0].data, 'critical');
      expect(receivedEvents[1].data, 'normal');
      expect(receivedEvents[2].data, 'low');
    });

    test('should track statistics', () {
      final initialStats = manager.stats;
      expect(initialStats.totalEventsSent, 0);

      // 发送一些事件
      manager.sendEvent<String>(type: 'event1', data: 'data1');
      manager.sendEvent<String>(type: 'event2', data: 'data2');
      manager.sendEvent<String>(type: 'event1', data: 'data3');

      final stats = manager.stats;
      expect(stats.totalEventsSent, 3);
      expect(stats.eventTypeCount['event1'], 2);
      expect(stats.eventTypeCount['event2'], 1);
      expect(stats.lastEventTime, isNotNull);
    });

    test('should handle sendEventSafe', () {
      // 正常情况应该返回true
      final result1 = manager.sendEventSafe<String>(
        type: 'safe_event',
        data: 'safe_data',
      );
      expect(result1, true);

      // 即使有异常也不应该抛出
      final result2 = manager.sendEventSafe<String>(
        type: 'safe_event',
        data: 'safe_data',
      );
      expect(result2, true);
    });

    test('should handle batch sending', () async {
      final receivedEvents = <GlobalEvent<String>>[];

      manager.addTypedListener<String>(
        listenerId: 'batch_listener',
        onEvent: (event) => receivedEvents.add(event),
      );

      // 启用批量发送
      manager.setBatchMode(true, intervalMs: 50);

      // 快速发送多个事件
      for (int i = 0; i < 5; i++) {
        manager.sendEvent<String>(type: 'batch_event', data: 'data_$i');
      }

      // 等待批量处理
      await Future.delayed(const Duration(milliseconds: 100));

      expect(receivedEvents.length, 5);

      // 禁用批量发送
      manager.setBatchMode(false);
    });

    test('should handle delayed events', () async {
      final receivedEvents = <GlobalEvent<String>>[];
      final startTime = DateTime.now();

      manager.addTypedListener<String>(
        listenerId: 'delay_listener',
        onEvent: (event) {
          receivedEvents.add(event);
        },
      );

      // 发送延迟事件
      manager.sendEventDelayed<String>(
        type: 'delayed_event',
        data: 'delayed_data',
        delay: const Duration(milliseconds: 100),
      );

      // 立即检查，应该没有收到事件
      expect(receivedEvents.length, 0);

      // 等待延迟时间
      await Future.delayed(const Duration(milliseconds: 150));

      // 现在应该收到事件
      expect(receivedEvents.length, 1);
      expect(receivedEvents.first.data, 'delayed_data');

      // 验证延迟时间
      final elapsed = DateTime.now().difference(startTime).inMilliseconds;
      expect(elapsed, greaterThanOrEqualTo(100));
    });
  });
}
