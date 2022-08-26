# Copyright 2022 Collabora Ltd.
# SPDX-License-Identifier: MIT

project(
  'use-dbus-gmain-as-subproject',
  'c',
  version : '0',
  meson_version : '>=0.49.0',
)

redefine_function_declaration = 'ret DBUS_GMAIN_FUNCTION_NAME (name) (__VA_ARGS__)'
redefine_function_name = '_my_ ## name'

add_project_arguments(
    '-DDBUS_GMAIN_FUNCTION(ret, name, ...)=' + redefine_function_declaration,
    '-DDBUS_GMAIN_FUNCTION_NAME(name)=' + redefine_function_name,
    language: 'c',
)

dbus_gmain = subproject(
    'dbus-gmain',
    default_options: [
        'redefine_function_declaration=' + redefine_function_declaration,
        'redefine_function_name=' + redefine_function_name,
        'tests=false',
    ],
)
dbus_gmain_dep = dbus_gmain.get_variable('dbus_gmain_dep')

executable('use-dbus-gmain', 'use-dbus-gmain.c', dependencies: dbus_gmain_dep)
