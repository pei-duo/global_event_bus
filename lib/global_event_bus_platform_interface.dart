import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'global_event_bus_method_channel.dart';

abstract class GlobalEventBusPlatform extends PlatformInterface {
  /// Constructs a GlobalEventBusPlatform.
  GlobalEventBusPlatform() : super(token: _token);

  static final Object _token = Object();

  static GlobalEventBusPlatform _instance = MethodChannelGlobalEventBus();

  /// The default instance of [GlobalEventBusPlatform] to use.
  ///
  /// Defaults to [MethodChannelGlobalEventBus].
  static GlobalEventBusPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GlobalEventBusPlatform] when
  /// they register themselves.
  static set instance(GlobalEventBusPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
