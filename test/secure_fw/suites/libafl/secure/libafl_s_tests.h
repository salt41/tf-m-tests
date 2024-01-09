#ifndef __AVA_NS_TESTS_H__
#define __AVA_NS_TESTS_H__

#include "test_framework.h"

#ifdef __cplusplus
extern "C" {
#endif

/**
 * \brief Register testsuite for the initial libafl service.
 *
 * \param[in] p_test_suite The test suite to be executed.
 */
void
register_testsuite_s_libafl_interface(struct test_suite_t *p_test_suite);

#ifdef __cplusplus
}
#endif

#endif /* __AVA_NS_TESTS_H__ */
