#include "ava_ns_tests.h"
#include "tfm_api.h"
#include "tfm_ns_interface.h"

static void tfm_ava_test_1001(struct test_result_t *ret);

static struct test_t ava_tests[] = {
  {&tfm_ava_test_1001, "TFM_NS_AVA_TEST_1001", "Example test case"},
};

void register_testsuite_ns_ava_interface(struct test_suite_t *p_test_suite) {
  uint32_t list_size = 0;
  list_size = (sizeof(ava_tests) / sizeof(ava_tests[0]));

  set_testsuite("AVA non-secure interface test (TFM_NS_AVA_TEST_1XXX)",
      ava_tests, list_size, p_test_suite);
}

uint32_t helper(uint32_t arg0, uint32_t arg1, uint32_t arg2, uint32_t arg3) {
  printf("%d %d %d %d\n", arg0, arg1, arg2, arg3);
  return 0x41;
}

static void tfm_ava_test_1001(struct test_result_t *ret) {

  // uint32_t *ptr = (uint32_t*)0x10000250;
  // uint32_t *ptr = (uint32_t*)0x1003e0;
  printf("PSA API version %x\n", psa_framework_version());
  printf("%010p: psa_version done\n", *(uint32_t*)psa_version);
  printf("%010p: tfm_ns_interface_dispatch\n", 
      *(uint32_t*)tfm_ns_interface_dispatch);

  // NSC memory cannot be read by NS
  printf("%010p: tfm_psa_call_veneer\n", (uint32_t*)tfm_psa_call_veneer);
  // calling NSC: unclear behavior
  // printf("tfm_psa_call_veneer status: %x", tfm_psa_call_veneer(0,0,0,0));

  // example dispatch: returns PSA_ERROR_PROGRAMMER_ERROR
  printf("tfm_ns_interface_dispatch status: %x\n", 
      tfm_ns_interface_dispatch((veneer_fn)tfm_psa_call_veneer,0,0,0,0));

  printf("%010p: helper function address\n", helper);
  // what does this do? -> just calls the function
  printf("tfm_ns_interface_dispatch status: %x\n", 
      tfm_ns_interface_dispatch((veneer_fn)helper,0,1,2,3));
}

