#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <dbus/dbus.h>                                                          
#include <dbus/dbus-glib-lowlevel.h> /* for glib main loop */

#include <iostream>
#include <memory>

class DBusServiceDaemon {
  public:
  DBusServiceDaemon (const char *interface, const char *object_path);
  virtual bool OnInit();    
  bool Connect();    
  bool MessageHandler();    
  protected:
  private:
  GMainLoop *gmain_loop_;
  DBusConnection *dbus_connection_;
  DBusError dbus_error_;

  std::string interface_;
  std::string object_path_;
  std::string service_name_;

  DBusObjectPathVTable server_vtable_;
  //= { 
  //      .message_function = MessageHandler 
  //};
};
