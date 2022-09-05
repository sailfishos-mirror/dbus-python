# Copyright 2022 Collabora Ltd.
# SPDX-License-Identifier: MIT

testlib = static_library(
    'testutils',
    'util.c',
    dependencies: [
        dbus_dep,
        glib_dep,
    ],
)

test_thread_server = executable(
    'test-thread-server',
    'test-thread-server.c',
    dependencies: [
        dbus_gmain_dep,
        dbus_dep,
        glib_dep,
        gthread_dep,
    ],
    link_with: testlib,
)

test_thread_client = executable(
    'test-thread-client',
    'test-thread-client.c',
    dependencies: [
        dbus_gmain_dep,
        dbus_dep,
        glib_dep,
        gthread_dep,
    ],
    link_with: testlib,
)

test_cases = ['30574']

foreach test_case : test_cases
    exe = executable(
        'test-' + test_case,
        test_case + '.c',
        dependencies: [
            dbus_gmain_dep,
            dbus_dep,
            glib_dep,
        ],
        link_with: testlib,
    )
    test(
        test_case,
        dbus_run_session,
        args: [
            '--',
            exe,
        ],
    )
endforeach

test(
    'use-as-subproject',
    find_program('python3'),
    args: [
      files('use-as-subproject.py'),
    ],
)
