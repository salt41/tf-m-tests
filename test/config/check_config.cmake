#-------------------------------------------------------------------------------
# Copyright (c) 2021-2022, Arm Limited. All rights reserved.
#
# SPDX-License-Identifier: BSD-3-Clause
#
#-------------------------------------------------------------------------------

########################## TEST Configuration ##################################

include(utils)
    dump_options("TEST Configuration"
    "
        TEST_NS;
        TEST_S;
        TEST_NS_ATTESTATION;
        TEST_NS_AUDIT;
        TEST_NS_CORE;
        TEST_NS_CRYPTO;
        TEST_NS_ITS;
        TEST_NS_QCBOR;
        TEST_NS_PS;
        TEST_NS_T_COSE;
        TEST_NS_PLATFORM;
        TEST_NS_FWU;
        TEST_NS_IPC;
        TEST_NS_SLIH_IRQ;
        TEST_NS_FLIH_IRQ;
        TEST_NS_MULTI_CORE;
        TEST_NS_MANAGE_NSID;
        TEST_NS_SFN_BACKEND;
        TEST_NS_FPU;
        TEST_S_ATTESTATION;
        TEST_S_AUDIT;
        TEST_S_CRYPTO;
        TEST_S_ITS;
        TEST_S_PS;
        TEST_S_PLATFORM;
        TEST_S_FWU;
        TEST_S_IPC;
        TEST_S_SFN_BACKEND;
        TEST_S_FPU;
    "
    )

########################## Check Flags Input ###################################

tfm_invalid_config((NOT TFM_PARTITION_PROTECTED_STORAGE AND NOT FORWARD_PROT_MSG) AND (TEST_NS_PS OR TEST_S_PS))
tfm_invalid_config((NOT TFM_PARTITION_INTERNAL_TRUSTED_STORAGE AND NOT FORWARD_PROT_MSG) AND (TEST_NS_ITS OR TEST_S_ITS OR TEST_NS_PS))
tfm_invalid_config((NOT TFM_PARTITION_CRYPTO AND NOT FORWARD_PROT_MSG) AND (TEST_NS_CRYPTO OR TEST_S_CRYPTO))
tfm_invalid_config((NOT TFM_PARTITION_INITIAL_ATTESTATION AND NOT FORWARD_PROT_MSG) AND (TEST_NS_ATTESTATION OR TEST_S_ATTESTATION OR TEST_NS_QCBOR OR TEST_NS_T_COSE))
tfm_invalid_config((NOT TFM_PARTITION_PLATFORM AND NOT FORWARD_PROT_MSG) AND (TEST_NS_PLATFORM OR TEST_S_PLATFORM))
tfm_invalid_config(NOT TFM_PARTITION_FIRMWARE_UPDATE AND (TEST_NS_FWU OR TEST_S_FWU))
tfm_invalid_config(NOT TFM_PARTITION_AUDIT_LOG AND (TEST_NS_AUDIT OR TEST_S_AUDIT))

tfm_invalid_config((TEST_NS_IPC OR TEST_S_IPC OR TEST_NS_SLIH_IRQ OR TEST_NS_FLIH_IRQ) AND (TFM_LIB_MODEL))
tfm_invalid_config((TEST_NS_IPC OR TEST_S_IPC OR TEST_NS_CORE) AND CONFIG_TFM_SPM_BACKEND_SFN)
tfm_invalid_config(TEST_S_SFN_BACKEND AND CONFIG_TFM_SPM_BACKEND_IPC)

tfm_invalid_config(CONFIG_TFM_FP STREQUAL "soft" AND (TEST_S_FPU OR TEST_NS_FPU))
tfm_invalid_config(TFM_LIB_MODEL AND (TEST_S_FPU OR TEST_NS_FPU OR TEST_S_SFN_BACKEND))
tfm_invalid_config((NOT TFM_MULTI_CORE_TOPOLOGY) AND TEST_NS_MULTI_CORE)
tfm_invalid_config(TEST_NS_T_COSE AND SYMMETRIC_INITIAL_ATTESTATION)
tfm_invalid_config((NOT TFM_NS_MANAGE_NSID) AND TEST_NS_MANAGE_NSID)

# So far all NS regression tests are triggered from NS app
tfm_invalid_config(NOT NS AND TEST_FRAMEWORK_NS)

########################## Check suites dependence #############################

tfm_invalid_config(TEST_NS_PS AND NOT TEST_NS_ITS)

############################ FLIH/SLIH dependence ##############################

# FLIH and SLIH testing can not be enabled at the same time
tfm_invalid_config(TEST_NS_SLIH_IRQ AND TEST_NS_FLIH_IRQ)
tfm_invalid_config(NOT PLATFORM_SLIH_IRQ_TEST_SUPPORT AND TEST_NS_SLIH_IRQ)
tfm_invalid_config(NOT PLATFORM_FLIH_IRQ_TEST_SUPPORT AND TEST_NS_FLIH_IRQ)

####### Disable FP tests for MVE feature enabled platform and GCC Release #####

# Disable FP test cases under particular configurations: For MVE feature
# enabled platform, hard ABI and Release build type for GNU Arm Embedded
# Toolchain.
# The config above can generate FP context in SPM when MVE instructions
# in C sub-routines are called. It is a normal behavior.
# Current FP test cases are designed by using specific setup of FP context, to
# check secure FP context protection. Then those test cases can be affected by
# the generated FP context mentioned above. The secure FP context protection
# mechanism still works as expected.
# Re-enable those test cases later when the test mechanism is enhanced.
tfm_invalid_config(CONFIG_TFM_FP STREQUAL "hard" AND CMAKE_C_COMPILER_ID STREQUAL "GNU"
                AND CMAKE_BUILD_TYPE STREQUAL "Release"
                AND ${TFM_SYSTEM_ARCHITECTURE} STREQUAL "armv8.1-m.main"
                AND (TEST_S_FPU OR TEST_NS_FPU))
