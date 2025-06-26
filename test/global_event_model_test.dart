import 'package:flutter_test/flutter_test.dart';
import 'package:global_event_bus/src/global_event_model.dart';

void main() {
  group('EventPriority Tests', () {
    test('should have correct priority values', () {
      expect(EventPriority.low.value, 0);
      expect(EventPriority.normal.value, 1);
      expect(EventPriority.high.value, 2);
      expect(EventPriority.critical.value, 3);
    });
  });

  group('EventStats Tests', () {
    late EventStats stats;

    setUp(() {
      stats = EventStats();
    });

    test('should initialize with zero values', () {
      expect(stats.totalEventsSent, 0);
      expect(stats.totalEventsReceived, 0);
      expect(stats.eventTypeCount, isEmpty);
      expect(stats.lastEventTime, isNull);
    });

    test('should record sent events correctly', () {
      stats.recordSentEvent('test_event');
      
      expect(stats.totalEventsSent, 1);
      expect(stats.eventTypeCount['test_event'], 1);
      expect(stats.lastEventTime, isNotNull);
    });

    test('should count multiple events of same type', () {
      stats.recordSentEvent('test_event');
      stats.recordSentEvent('test_event');
      stats.recordSentEvent('other_event');
      
      expect(stats.totalEventsSent, 3);
      expect(stats.eventTypeCount['test_event'], 2);
      expect(stats.eventTypeCount['other_event'], 1);
    });

    test('should record received events', () {
      stats.recordReceivedEvent();
      stats.recordReceivedEvent();
      
      expect(stats.totalEventsReceived, 2);
    });
  });

  group('BaseGlobalEvent Tests', () {
    test('should generate unique event IDs', () {
      final event1 = GlobalEvent<String>(
        type: 'test',
        data: 'data1',
      );
      final event2 = GlobalEvent<String>(
        type: 'test',
        data: 'data2',
      );
      
      expect(event1.eventId, isNot(equals(event2.eventId)));
    });

    test('should have correct default values', () {
      final event = GlobalEvent<String>(
        type: 'test',
        data: 'test_data',
      );
      
      expect(event.type, 'test');
      expect(event.data, 'test_data');
      expect(event.priority, EventPriority.normal);
      expect(event.metadata, isNull);
      expect(event.timestamp, isNotNull);
      expect(event.eventId, isNotNull);
    });

    test('should accept custom priority and metadata', () {
      final metadata = {'key': 'value'};
      final event = GlobalEvent<int>(
        type: 'test',
        data: 42,
        priority: EventPriority.high,
        metadata: metadata,
      );
      
      expect(event.priority, EventPriority.high);
      expect(event.metadata, metadata);
    });
  });

  group('GlobalEvent Tests', () {
    test('should preserve data type', () {
      final stringEvent = GlobalEvent<String>(
        type: 'string_event',
        data: 'hello',
      );
      final intEvent = GlobalEvent<int>(
        type: 'int_event',
        data: 123,
      );
      final mapEvent = GlobalEvent<Map<String, dynamic>>(
        type: 'map_event',
        data: {'key': 'value'},
      );
      
      expect(stringEvent.data, isA<String>());
      expect(intEvent.data, isA<int>());
      expect(mapEvent.data, isA<Map<String, dynamic>>());
    });

    test('should have meaningful toString', () {
      final event = GlobalEvent<String>(
        type: 'test_event',
        data: 'test_data',
        priority: EventPriority.high,
      );
      
      final str = event.toString();
      expect(str, contains('test_event'));
      expect(str, contains('test_data'));
      expect(str, contains('high'));
    });
  });
}