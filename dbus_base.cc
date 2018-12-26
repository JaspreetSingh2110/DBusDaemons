#include "dbus_base.h"

DBusServiceDaemon::DBusServiceDaemon(const char *interface, const char *object_path)
  : interface_(interface), object_path_(object_path), service_name_("Myapp") {}

bool DBusServiceDaemon::OnInit() {
  if (!Connect()) {
    std::cout << "Failed to connect\n";
    return false;
  }
  return true;
}

bool DBusServiceDaemon::Connect() {
  DBusError dbus_error;
  dbus_error_init(&dbus_error);

  dbus_connection_ = dbus_bus_get(DBUS_BUS_SYSTEM, &dbus_error);
  if (!dbus_connection_) {
    std::cout << "Failed to connect\n";
  }

  int rv = dbus_bus_request_name(                                                   
      dbus_connection_,                                                                     
      interface_.c_str(),                                                 
      DBUS_NAME_FLAG_REPLACE_EXISTING,                                          
      &dbus_error);                                                                    

  if (rv != DBUS_REQUEST_NAME_REPLY_PRIMARY_OWNER) {
    fprintf(stderr,  "Failed %s\n", dbus_error.message);        
    return false;
  }                                                                             

  if (!dbus_connection_register_object_path(                                    
      dbus_connection_,                                                                     
      object_path_.c_str(),                                                
      &server_vtable_,                                                           
      NULL)) {
    fprintf(stderr, "Failed to register a object path for 'TestObject'\n");     
    return false;
  }

  gmain_loop_ = g_main_loop_new(NULL, false);

  dbus_connection_setup_with_g_main(dbus_connection_, NULL);

  std::cout << "\nWaiting for requests ..\n";
  g_main_loop_run(gmain_loop_);

  return true;
}


