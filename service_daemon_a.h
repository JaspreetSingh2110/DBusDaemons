#include "dbus_base.h"

class ServiceDaemonA : public DBusServiceDaemon {
  public:
  ServiceDaemonA();
  bool OnInit();

};
