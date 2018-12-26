
CFLAGS_DBUS = $(shell pkg-config --cflags --libs dbus-1)
CFLAGS_DBUS_GLIB = $(shell pkg-config --cflags --libs dbus-glib-1)
CFLAGS_GIO  = $(shell pkg-config --cflags --libs gio-2.0)

CFLAGS = -g
CFLAGS2 = -g -Wall -Werror

MYDBUSLIB_SOURCES     = dbus_base.cc
MYDBUSLIB_OUTPUTFILE  = libmydbus.so
LIB_INSTALLDIR  = lib

CXX	= g++
LDFLAGS = -shared -fPIC

all: $(MYDBUSLIB_OUTPUTFILE) daemonA

$(MYDBUSLIB_OUTPUTFILE): $(subst .cpp,.o,$(MYDBUSLIB_SOURCES)) 
	$(CXX) $(LDFLAGS) -o $@ $^ $(CFLAGS) $(CFLAGS_DBUS) $(CFLAGS_DBUS_GLIB)

.PHONY: install
install:
	mkdir -p $(LIB_INSTALLDIR)
	mv $(MYDBUSLIB_OUTPUTFILE) $(LIB_INSTALLDIR)

daemonA: service_daemon_a.cc 
	$(CXX) $< -o $@ $(CFLAGS_DBUS) $(CFLAGS_DBUS_GLIB) -L./lib/$(MYDBUSLIB_OUTPUTFILE)

clean:
	rm -f daemonA


.PHONY: all clean
