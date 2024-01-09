#include "libafl_s_tests.h"
#include "tfm_api.h"

int __attribute__((noinline)) BREAKPOINT() {
  for (;;) {}
}

__attribute__((naked)) void exit(__attribute__((unused)) int status) {
  /* Force qemu to exit using ARM Semihosting */
  __asm volatile(
    "mov r1, r0\n"
    "cmp r1, #0\n"
    "bne .notclean\n"
    "ldr r1, =0x20026\n" /* ADP_Stopped_ApplicationExit, a clean exit */
    ".notclean:\n"
    "movs r0, #0x18\n" /* SYS_EXIT */
    "bkpt 0xab\n"
    "end: b end\n");
}

int LLVMFuzzerTestOneInput(unsigned int *Data, unsigned int Size) {
  if (Data[3] == 0) {
    while (1) {}
  }  // cause a timeout
  for (int i = 0; i < Size; i++) {
    // if (Data[i] > 0xFFd0 && Data[i] < 0xFFFF) {return 1;}    // cause qemu to
    // crash
    for (int j = i + 1; j < Size; j++) {
      if (Data[j] == 0) { continue; }
      if (Data[j] > Data[i]) {
        int tmp = Data[i];
        Data[i] = Data[j];
        Data[j] = tmp;
        if (Data[i] <= 100) { j--; }
      }
    }
  }
  return BREAKPOINT();
}

unsigned int FUZZ_INPUT[] = {
    101, 201, 700, 230, 860, 234, 980, 200, 340, 678, 230, 134, 900,
    236, 900, 123, 800, 123, 658, 607, 246, 804, 567, 568, 207, 407,
    246, 678, 457, 892, 834, 456, 878, 246, 699, 854, 234, 844, 290,
    125, 324, 560, 852, 928, 910, 790, 853, 345, 234, 586,
};

static void tfm_libafl_test_1001(struct test_result_t *ret);

static struct test_t libafl_tests[] = {
  {&tfm_libafl_test_1001, "TFM_NS_LIBAFL_TEST_1001", "Example test case"},
};

void register_testsuite_s_libafl_interface(struct test_suite_t *p_test_suite) {
  uint32_t list_size = 0;
  list_size = (sizeof(libafl_tests) / sizeof(libafl_tests[0]));

  set_testsuite("LIBAFL secure interface test (TFM_NS_LIBAFL_TEST_1XXX)",
      libafl_tests, list_size, p_test_suite);
}

static void tfm_libafl_test_1001(struct test_result_t *ret) {
  LLVMFuzzerTestOneInput(FUZZ_INPUT, 50);
  exit(0);
}

