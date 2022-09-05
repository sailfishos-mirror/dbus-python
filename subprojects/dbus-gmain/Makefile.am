# Copyright © 2002-2003 CodeFactory AB
# Copyright © 2002-2010 Red Hat, Inc.
# Copyright © 2003 James Willcox
# Copyright © 2006 Marc-Andre Lureau
# Copyright © 2006-2018 Collabora Ltd.
# Copyright © 2010-2012 Mike Gorse
#
# SPDX-License-Identifier: AFL-2.1 OR GPL-2.0-or-later

EXTRA_DIST = \
	AUTHORS \
	CONTRIBUTING.md \
	COPYING \
	LICENSES/AFL-2.1.txt \
	LICENSES/GPL-2.0-or-later.txt \
	LICENSES/MIT.txt \
	README.md \
	meson.build \
	meson_options.txt \
	tests/meson.build \
	tests/use-as-subproject.py \
	tests/use-as-subproject/README \
	tests/use-as-subproject/meson.build \
	tests/use-as-subproject/use-dbus-gmain.c \
	$(NULL)

AM_CPPFLAGS = \
	-I$(top_srcdir) \
	-I$(top_srcdir)/subprojects \
	-I$(top_builddir) \
	-I$(top_builddir)/subprojects \
	$(DBUS_CFLAGS) \
	$(GLIB_CFLAGS) \
	$(NULL)

noinst_LTLIBRARIES = \
	libdbus-gmain.la \
	tests/libtest.la \
	$(NULL)

libdbus_gmain_la_SOURCES = \
	dbus-gmain.c \
	dbus-gmain/dbus-gmain.h \
	$(NULL)

libdbus_gmain_la_LIBADD = $(DBUS_LIBS) $(GLIB_LIBS)
libdbus_gmain_la_LDFLAGS = -no-undefined

tests_libtest_la_SOURCES = \
	tests/util.c \
	tests/util.h \
	$(NULL)

tests_libtest_la_LIBADD = $(DBUS_LIBS) $(GLIB_LIBS)
tests_libtest_la_LDFLAGS = -no-undefined

TESTS = \
	tests/test-30574 \
	$(NULL)

noinst_PROGRAMS = \
	tests/test-30574 \
	tests/test-thread-server \
	tests/test-thread-client \
	$(NULL)

tests_test_thread_server_SOURCES = \
	tests/test-thread-server.c \
	tests/test-thread.h \
	$(NULL)
tests_test_thread_server_LDADD = \
	libdbus-gmain.la \
	tests/libtest.la \
	$(GLIB_THREADS_LIBS) \
	$(GLIB_LIBS) \
	$(DBUS_LIBS) \
	$(NULL)

tests_test_thread_client_SOURCES = \
	tests/test-thread-client.c \
	tests/test-thread.h \
	$(NULL)
tests_test_thread_client_LDADD = \
	libdbus-gmain.la \
	tests/libtest.la \
	$(GLIB_THREADS_LIBS) \
	$(GLIB_LIBS) \
	$(DBUS_LIBS) \
	$(NULL)

tests_test_30574_SOURCES = \
	tests/30574.c \
	$(NULL)
tests_test_30574_LDADD = \
	libdbus-gmain.la \
	tests/libtest.la \
	$(GLIB_LIBS) \
	$(DBUS_LIBS) \
	$(NULL)

LOG_COMPILER = $(DBUS_RUN_SESSION) --
