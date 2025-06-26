import 'global_event_bus_platform_interface.dart';

// 导出所有公共API
export 'src/global_event_model.dart';
export 'src/global_event_manager.dart';
export 'src/global_event_log.dart';
export 'src/global_event_bus_api.dart';

class GlobalEventBus {
  Future<String?> getPlatformVersion() {
    return GlobalEventBusPlatform.instance.getPlatformVersion();
  }
}
