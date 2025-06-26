import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'global_event_bus_platform_interface.dart';

/// An implementation of [GlobalEventBusPlatform] that uses method channels.
class MethodChannelGlobalEventBus extends GlobalEventBusPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('global_event_bus');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
