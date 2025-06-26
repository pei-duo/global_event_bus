#include "include/global_event_bus/global_event_bus_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "global_event_bus_plugin.h"

void GlobalEventBusPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  global_event_bus::GlobalEventBusPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
