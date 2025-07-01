// In order to *not* need this ignore, consider extracting the "web" version
// of your plugin as a separate package, instead of inlining it in the same
// package as the core of your plugin.
// ignore: avoid_web_libraries_in_flutter

import 'package:flutter_web_plugins/flutter_web_plugins.dart';

import 'global_event_bus_platform_interface.dart';

/// A web implementation of the GlobalEventBusPlatform of the GlobalEventBus plugin.
class GlobalEventBusWeb extends GlobalEventBusPlatform {
  /// Constructs a GlobalEventBusWeb
  GlobalEventBusWeb();

  static void registerWith(Registrar registrar) {
    GlobalEventBusPlatform.instance = GlobalEventBusWeb();
  }

  /// Returns a [String] containing the version of the platform.
  @override
  Future<String?> getPlatformVersion() async {
    
    return 'Web Platform';
  }
}
