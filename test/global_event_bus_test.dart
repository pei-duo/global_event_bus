import 'package:flutter_test/flutter_test.dart';
import 'package:global_event_bus/global_event_bus.dart';
import 'package:global_event_bus/global_event_bus_platform_interface.dart';
import 'package:global_event_bus/global_event_bus_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGlobalEventBusPlatform
    with MockPlatformInterfaceMixin
    implements GlobalEventBusPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final GlobalEventBusPlatform initialPlatform = GlobalEventBusPlatform.instance;

  test('$MethodChannelGlobalEventBus is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGlobalEventBus>());
  });

  test('getPlatformVersion', () async {
    GlobalEventBus globalEventBusPlugin = GlobalEventBus();
    MockGlobalEventBusPlatform fakePlatform = MockGlobalEventBusPlatform();
    GlobalEventBusPlatform.instance = fakePlatform;

    expect(await globalEventBusPlugin.getPlatformVersion(), '42');
  });
}
