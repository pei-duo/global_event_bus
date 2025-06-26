#ifndef FLUTTER_PLUGIN_GLOBAL_EVENT_BUS_PLUGIN_H_
#define FLUTTER_PLUGIN_GLOBAL_EVENT_BUS_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>

namespace global_event_bus {

class GlobalEventBusPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  GlobalEventBusPlugin();

  virtual ~GlobalEventBusPlugin();

  // Disallow copy and assign.
  GlobalEventBusPlugin(const GlobalEventBusPlugin&) = delete;
  GlobalEventBusPlugin& operator=(const GlobalEventBusPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);
};

}  // namespace global_event_bus

#endif  // FLUTTER_PLUGIN_GLOBAL_EVENT_BUS_PLUGIN_H_
