#include "libspir_types.h"
#include "hls_stream.h"
#include "xcl_top_defines.h"
#include "ap_axi_sdata.h"
#define EXPORT_PIPE_SYMBOLS 1
#include "cpu_pipes.h"
#undef EXPORT_PIPE_SYMBOLS
#include "xcl_half.h"
#include <cstddef>
#include <vector>
#include <complex>
#include <pthread.h>
using namespace std;

extern "C" {

void ydma(size_t input1, size_t input2, size_t output1, size_t output2, unsigned int config_size, unsigned int input_size, unsigned int output_size);

static pthread_mutex_t __xlnx_cl_ydma_mutex = PTHREAD_MUTEX_INITIALIZER;
void __stub____xlnx_cl_ydma(char **argv) {
  void **args = (void **)argv;
  size_t input1 = *((size_t*)args[0+1]);
  size_t input2 = *((size_t*)args[1+1]);
  size_t output1 = *((size_t*)args[2+1]);
  size_t output2 = *((size_t*)args[3+1]);
  unsigned int config_size = *((unsigned int*)args[4+1]);
  unsigned int input_size = *((unsigned int*)args[5+1]);
  unsigned int output_size = *((unsigned int*)args[6+1]);
 pthread_mutex_lock(&__xlnx_cl_ydma_mutex);
  ydma(input1, input2, output1, output2, config_size, input_size, output_size);
  pthread_mutex_unlock(&__xlnx_cl_ydma_mutex);
}
}
