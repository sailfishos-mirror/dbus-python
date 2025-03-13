#!/bin/sh
# Copyright 2006-2025 Collabora Ltd.
# SPDX-License-Identifier: MIT

set -eux

distdir="${MESON_PROJECT_DIST_ROOT}"

MKDIR_P="${MKDIR_P-mkdir -p}"
SED="${SED-sed}"

VERSION="$1"
PYTHON="$2"

umask 022

echo "${VERSION}" > "${distdir}/.version"
${MKDIR_P} "${distdir}/dbus_python.egg-info"
touch "${distdir}/MANIFEST"
touch "${distdir}/MANIFEST.in"
touch "${distdir}/dbus_python.egg-info/SOURCES.txt"
${PYTHON} "${distdir}/tools/generate-pkginfo.py" "${VERSION}" "${distdir}/PKG-INFO"
echo > "${distdir}/dbus_python.egg-info/dependency_links.txt"
echo _dbus_bindings > "${distdir}/dbus_python.egg-info/top_level.txt"
echo _dbus_glib_bindings >> "${distdir}/dbus_python.egg-info/top_level.txt"
echo dbus >> "${distdir}/dbus_python.egg-info/top_level.txt"
cp "${distdir}/PKG-INFO" "${distdir}/dbus_python.egg-info/PKG-INFO"

( cd "${distdir}" && find . -type d -o -print ) | \
        LC_ALL=C sort | \
        ${SED} -e 's|^\./||' \
        > "${distdir}/MANIFEST"
${SED} -e 's/.*/include &/' < "${distdir}/MANIFEST" > "${distdir}/MANIFEST.in"
cp "${distdir}/MANIFEST" "${distdir}/dbus_python.egg-info/SOURCES.txt"
