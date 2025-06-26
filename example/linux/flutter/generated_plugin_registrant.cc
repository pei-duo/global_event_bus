//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <global_event_bus/global_event_bus_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) global_event_bus_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "GlobalEventBusPlugin");
  global_event_bus_plugin_register_with_registrar(global_event_bus_registrar);
}
