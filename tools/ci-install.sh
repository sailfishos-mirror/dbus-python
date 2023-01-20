#!/bin/bash

# Copyright © 2015-2018 Collabora Ltd.
#
# SPDX-License-Identifier: MIT
#
# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

set -euo pipefail
set -x

NULL=

# ci_distro:
# OS distribution in which we are testing
# Typical values: ubuntu, debian; maybe fedora in future
: "${ci_distro:=debian}"

# ci_docker:
# If non-empty, this is the name of a Docker image. ci-install.sh will
# fetch it with "docker pull" and use it as a base for a new Docker image
# named "ci-image" in which we will do our testing.
: "${ci_docker:=}"

# ci_host:
# Either "native", or an Autoconf --host argument to cross-compile
# the package (not currently supported for dbus-python)
: "${ci_host:=native}"

# ci_in_docker:
# Used internally by ci-install.sh. If yes, we are inside the Docker image
# (ci_docker is empty in this case).
: "${ci_in_docker:=no}"

# ci_suite:
# OS suite (release, branch) in which we are testing.
# Typical values for ci_distro=debian: sid, buster
# Typical values for ci_distro=fedora might be 25, rawhide
: "${ci_suite:=bookworm}"

if [ $(id -u) = 0 ]; then
    sudo=
else
    sudo=sudo
fi

have_system_meson=

if [ -n "$ci_docker" ]; then
    sed \
        -e "s/@ci_distro@/${ci_distro}/" \
        -e "s/@ci_docker@/${ci_docker}/" \
        -e "s/@ci_suite@/${ci_suite}/" \
        -e "s/@dbus_ci_system_python@/${dbus_ci_system_python-}/" \
        < tools/ci-Dockerfile.in > Dockerfile
    exec docker build -t ci-image .
fi

if [ -n "${dbus_ci_system_python-}" ]; then
    if [ -z "${dbus_ci_system_python_module_suffix-}" ]; then
        case "$dbus_ci_system_python}" in
            (*-dbg)
                dbus_ci_system_python_module_suffix=-dbg
                ;;
            (*)
                dbus_ci_system_python_module_suffix=
                ;;
        esac
    fi
fi

case "$ci_distro" in
    (debian|ubuntu)
        # Don't ask questions, just do it
        sudo="$sudo env DEBIAN_FRONTEND=noninteractive"

        # Debian Docker images use httpredir.debian.org but it seems to be
        # unreliable; use a CDN instead
        $sudo sed -i -e 's/httpredir\.debian\.org/deb.debian.org/g' \
            /etc/apt/sources.list

        $sudo apt-get -qq -y update

        $sudo apt-get -qq -y install --no-install-recommends \
            adduser \
            autoconf \
            autoconf-archive \
            automake \
            autotools-dev \
            ccache \
            debhelper \
            dh-autoreconf \
            docbook-xml \
            docbook-xsl \
            gcc \
            gnome-desktop-testing \
            libdbus-1-dev \
            libglib2.0-dev \
            libtool \
            make \
            sudo \
            virtualenv \
            wget \
            xmlto \
            ${NULL}

        if [ -n "${dbus_ci_system_python-}" ]; then
              sudo apt-get -qq -y install \
                ${dbus_ci_system_python} \
                ${dbus_ci_system_python%-dbg}-dev \
                python3-docutils \
                python3-gi${dbus_ci_system_python_module_suffix} \
                python3-pip \
                python3-setuptools \
                python3-sphinx \
                python3-sphinx-rtd-theme \
                python3-tap \
                ${NULL}
        fi

        if [ "$ci_in_docker" = yes ]; then
            # Add the user that we will use to do the build inside the
            # Docker container, and let them use sudo
            adduser --disabled-password --gecos "" user
            echo "user ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/nopasswd
            chmod 0440 /etc/sudoers.d/nopasswd
        fi

        case "$ci_suite" in
            (buster|focal|bullseye)
                $sudo apt-get -qq -y install dbus
                ;;

            (*)
                $sudo apt-get -qq -y install dbus-daemon
                ;;
        esac

        case "$ci_suite" in
            (buster|focal)
                ;;

            (*)
                $sudo apt-get -qq -y install meson
                have_system_meson=true
                ;;
        esac

        # Needed for distcheck
        case "$ci_suite" in
            (buster|focal|bullseye)
                runuser -u user -- \
                    "${dbus_ci_system_python-python3}" -m pip install --user \
                    pyproject_metadata \
                    tomli \
                    ${NULL}
                ;;

            (*)
                $sudo apt-get -qq -y install \
                    python3-pyproject-metadata \
                    python3-tomli \
                    ${NULL}
                ;;
        esac
        ;;

    (*)
        echo "Don't know how to set up ${ci_distro}" >&2
        exit 1
        ;;
esac

if [ -n "$have_system_meson" ]; then
    :
elif [ -n "${dbus_ci_system_python-}" ]; then
    runuser -u user -- "$dbus_ci_system_python" -m pip install --user meson ninja
else
    runuser -u user -- pip install meson ninja
fi

# vim:set sw=4 sts=4 et:
