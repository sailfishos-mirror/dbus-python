# Copyright 2022 Collabora Ltd.
# SPDX-License-Identifier: MIT

project(
    'dbus-gmain',
    'c',
    default_options: [
        'warning_level=2',
    ],
    meson_version: '>=0.56',
)

cc = meson.get_compiler('c')
compile_warnings = []
compile_warnings_c = []

if cc.get_id() != 'msvc'
  # -fno-common makes the linker more strict: on some systems the linker
  # is *always* this strict, so we want to behave like that everywhere.
  # We treat this like a warning, since that's basically how we're using it.
  compile_warnings += ['-fno-common']

  compile_warnings += [
      # Intentionally disabled: missing field initializers being implicitly
      # default-initialized is a feature, not a bug
      '-Wno-missing-field-initializers',

      # General warnings for both C and C++, excluding those that are part
      # of -Wall or -Wextra
      '-Wcast-align',
      '-Wdouble-promotion',
      '-Wduplicated-branches',
      '-Wduplicated-cond',
      '-Wfloat-equal',
      '-Wformat-nonliteral',
      '-Wformat-security',
      '-Wformat=2',
      '-Winit-self',
      '-Wlogical-op',
      '-Wmissing-declarations',
      '-Wmissing-format-attribute',
      '-Wmissing-include-dirs',
      '-Wmissing-noreturn',
      '-Wnull-dereference',
      '-Wpacked',
      '-Wpointer-arith',
      '-Wredundant-decls',
      '-Wshadow',
      '-Wswitch-default',
      '-Wswitch-enum',
      '-Wundef',
      '-Wunused-but-set-variable',
      '-Wwrite-strings',
  ]

  compile_warnings_c += [
      # Extra warnings just for C
      '-Wdeclaration-after-statement',
      '-Wjump-misses-init',
      '-Wmissing-prototypes',
      '-Wnested-externs',
      '-Wold-style-definition',
      '-Wpointer-sign',
      '-Wstrict-prototypes',
  ]
endif

compile_warnings_c = cc.get_supported_arguments(
    compile_warnings + compile_warnings_c,
)
add_project_arguments(compile_warnings_c, language: 'c')

if get_option('redefine_function_declaration') != ''
    if not get_option('redefine_function_declaration').contains('name')
        error('redefine_function_declaration option needs to contain "name"')
    endif

    if not get_option('redefine_function_declaration').contains('ret')
        error('redefine_function_declaration option needs to contain "ret"')
    endif

    if not get_option('redefine_function_declaration').contains('__VA_ARGS__')
        error('redefine_function_declaration option needs to contain "__VA_ARGS__"')
    endif

    add_project_arguments(
        '-DDBUS_GMAIN_FUNCTION(ret, name, ...)=@0@'.format(
            get_option('redefine_function_declaration'),
        ),
        language: 'c',
    )
endif

if get_option('redefine_function_name') != ''
    if not get_option('redefine_function_name').contains('name')
        error('redefine_function_name option needs to contain "name"')
    endif

    add_project_arguments(
        '-DDBUS_GMAIN_FUNCTION_NAME(name)=@0@'.format(
            get_option('redefine_function_name'),
        ),
        language: 'c',
    )
endif

dbus_dep = dependency('dbus-1', version: '>=1.8')
glib_dep = dependency('glib-2.0', version: '>=2.40')
gthread_dep = dependency(
    'gthread-2.0',
    version: '>=2.40',
    required: get_option('tests'),
)

libdbus_gmain = static_library(
    'dbus-gmain',
    'dbus-gmain.c',
    dependencies: [
        dbus_dep,
        glib_dep,
    ],
)

dbus_gmain_dep = declare_dependency(
    dependencies: [
        dbus_dep,
        glib_dep,
    ],
    include_directories: include_directories('.'),
    link_with: libdbus_gmain,
)

dbus_run_session = find_program(
    'dbus-run-session',
    required: get_option('tests'),
)

if get_option('tests')
    subdir('tests')
endif
