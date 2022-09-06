#!/bin/sh
# Copyright 2022 Collabora Ltd.
# SPDX-License-Identifier: MIT

me="$(readlink -f "$0")"
here="$(dirname "$me")"
top="$(dirname "$here")"

DBUS_TOP_SRCDIR="$top" python3 "$here/redirects.py"
rsync -rtvzPp --chmod=Dg+s,ug+rwX,o=rX \
    doc/html/ \
    "${DOC_RSYNC_DEST-dbus.freedesktop.org:/srv/dbus.freedesktop.org/www/doc/dbus-python}/"
