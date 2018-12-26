
#include "service_daemon_a.h"

ServiceDaemonA::ServiceDaemonA ()
  : DBusServiceDaemon ("org.dbus.daemons.DaemonA",
                       "/org/dbus/daemons/DaemonA")
{
}

bool ServiceDaemonA::OnInit() {
  std::cout << "Initializing Daemon A";
  if (!DBusServiceDaemon::OnInit()) {
    std::cout << "Failed to initialze service daemon";
    return false;
  }
  return true;
}

int main() {
  ServiceDaemonA daemonA;
  if (!daemonA.OnInit()) {
    std::cout << "Terminating..";
    exit (0);
  }

  return 0;

}
