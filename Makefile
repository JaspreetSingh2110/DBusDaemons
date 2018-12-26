
CFLAGS_DBUS = $(shell pkg-config --cflags --libs dbus-1)
CFLAGS_DBUS_GLIB = $(shell pkg-config --cflags --libs dbus-glib-1)
CFLAGS_GIO  = $(shell pkg-config --cflags --libs gio-2.0)

CFLAGS = -g
CFLAGS2 = -g -Wall -Werror

MYDBUSLIB_SOURCES     = dbus_base.cc
MYDBUSLIB_SHARED_OUTPUTFILE  = libmydbus.so
MYDBUSLIB_STATIC_OUTPUTFILE  = libmydbus.a
LIB_INSTALLDIR  = lib

CXX	= g++
LDFLAGS = -shared -fPIC
LDFLAGS2 = -static

APPLICATION_1 = daemonA

all: $(MYDBUSLIB_SHARED_OUTPUTFILE) $(MYDBUSLIB_STATIC_OUTPUTFILE) $(APPLICATION_1) 

$(MYDBUSLIB_SHARED_OUTPUTFILE): $(subst .cpp,.o,$(MYDBUSLIB_SOURCES)) 
	$(CXX) $(LDFLAGS) -o $@ $^ $(CFLAGS) $(CFLAGS_DBUS) $(CFLAGS_DBUS_GLIB)

$(MYDBUSLIB_STATIC_OUTPUTFILE): $(subst .cpp,.o,$(MYDBUSLIB_SOURCES)) 
	$(CXX) -c $^ $(CFLAGS_DBUS) $(CFLAGS_DBUS_GLIB)
	ar rvs $(MYDBUSLIB_STATIC_OUTPUTFILE) dbus_base.o
	ranlib $@
	rm dbus_base.o

.PHONY: install
install:
	mkdir -p $(LIB_INSTALLDIR)
	mv $(MYDBUSLIB_SHARED_OUTPUTFILE) $(MYDBUSLIB_STATIC_OUTPUTFILE) $(LIB_INSTALLDIR)

$(APPLICATION_1): service_daemon_a.cc 
	$(CXX) $< -o $@ $(CFLAGS_DBUS) $(CFLAGS_DBUS_GLIB) -L./lib/$(MYDBUSLIB_SHARED_OUTPUTFILE)

clean:
	rm -f $(APPLICATION_1)
	rm -rf $(LIB_INSTALLDIR)


.PHONY: all clean
