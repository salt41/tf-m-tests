#-------------------------------------------------------------------------------
# Copyright (c) 2020-2022, Arm Limited. All rights reserved.
#
# SPDX-License-Identifier: BSD-3-Clause
#
#-------------------------------------------------------------------------------

cmake_policy(SET CMP0079 NEW)

if (NOT TEST_NS_LIBAFL AND NOT TEST_S_LIBAFL)
    return()
endif()

####################### Non Secure #############################################

if (TEST_NS_LIBAFL)
    add_library(tfm_test_suite_libafl_ns STATIC EXCLUDE_FROM_ALL)

    target_sources(tfm_test_suite_libafl_ns
        PRIVATE
            non_secure/libafl_ns_interface_testsuite.c
    )

    target_include_directories(tfm_test_suite_libafl_ns
        PUBLIC
            non_secure
        PRIVATE
            .
    )

    target_compile_definitions(tfm_test_suite_libafl_ns
        INTERFACE
            TEST_NS_LIBAFL
    )

    target_link_libraries(tfm_test_suite_libafl_ns
        PRIVATE
            tfm_qcbor_ns
            tfm_t_cose_ns
            tfm_test_framework_ns
            #TODO I'm not sure this should _really_ be linked here
            #tfm_libafl_defs
            tfm_boot_status
            platform_ns
    )

    target_link_libraries(tfm_ns_tests
        INTERFACE
            tfm_test_suite_libafl_ns
    )
endif()

####################### Secure #################################################

if (TEST_S_LIBAFL)
    target_sources(tfm_test_suite_libafl_s
        PRIVATE
            ${CMAKE_CURRENT_SOURCE_DIR}/secure/libafl_s_interface_testsuite.c
    )

    target_include_directories(tfm_test_suite_libafl_s
        PUBLIC
            ${CMAKE_CURRENT_SOURCE_DIR}/secure
        PRIVATE
            .
    )

    target_compile_definitions(tfm_test_suite_libafl_s
        INTERFACE
            TEST_S_LIBAFL
    )

    target_compile_options(tfm_test_suite_libafl_s
        PUBLIC
            ${COMPILER_CP_FLAG}
    )

    target_link_libraries(tfm_test_suite_libafl_s
        PRIVATE
            tfm_qcbor_s
            tfm_t_cose_s
            tfm_test_framework_s
            tfm_boot_status
            # tfm_psa_rot_partition_crypto
            platform_s
    )

    target_link_libraries(tfm_s_tests
        INTERFACE
            tfm_test_suite_libafl_s
    )
endif()
