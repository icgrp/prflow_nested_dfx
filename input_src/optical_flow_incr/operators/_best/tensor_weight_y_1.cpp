#include "../host/typedefs.h"
// tensor weight
void tensor_weight_y_1(
		hls::stream< ap_uint<192> > &Input_1,
		hls::stream< ap_uint<192> > &Output_1)
{
#pragma HLS interface axis register port=Input_1
#pragma HLS interface axis register port=Output_1
#ifdef RISCV
  hls::LineBuffer<3,MAX_WIDTH,outer_t> buf;
#else
  xf::cv::LineBuffer<3,MAX_WIDTH,outer_t> buf;
#endif
  const pixel_t TENSOR_FILTER[] = {0.3243, 0.3513, 0.3243};
  TENSOR_WEIGHT_Y_OUTER: for(int r=0; r<MAX_HEIGHT+1; r++)
  {
    TENSOR_WEIGHT_Y_INNER: for(int c=0; c<MAX_WIDTH; c++)
    {
#pragma HLS pipeline II=1

      outer_t tmp;
      #pragma HLS data_pack variable=tmp
      #pragma HLS data_pack variable=buf.val[0]
      buf.shift_pixels_up(c);
      if(r<MAX_HEIGHT)
      {
        ap_uint<192> in_tmp;
        in_tmp = Input_1.read();
        tmp.val[0](31,0)  = in_tmp(31,   0);
        tmp.val[1](31,0)  = in_tmp(63,  32);
        tmp.val[2](31,0)  = in_tmp(95,  64);
        tmp.val[3](31,0)  = in_tmp(127, 96);
        tmp.val[4](31,0)  = in_tmp(159,128);
        tmp.val[5](31,0)  = in_tmp(191,160);
      }
      else
      {
        TENSOR_WEIGHT_Y_TMP_INIT: for(int i=0; i<6; i++){
#pragma HLS UNROLL
        	tmp.val[i] = 0;
        }
      }
      buf.insert_bottom_row(tmp,c);

      tensor_t acc;
      TENSOR_WEIGHT_Y_ACC_INIT: for(int k =0; k<6; k++){
#pragma HLS UNROLL
    	  acc.val[k] = 0;
      }

      if (r >= 2 && r < MAX_HEIGHT)
      {
        TENSOR_WEIGHT_Y_TMP_OUTER: for(int i=0; i<3; i++)
        {
#pragma HLS UNROLL
          tmp = buf.getval(i,c);
          pixel_t k = TENSOR_FILTER[i];
          TENSOR_WEIGHT_Y_TMP_INNER: for(int component=0; component<6; component++)
          {
#pragma HLS UNROLL
            acc.val[component] = acc.val[component] + tmp.val[component]*k;
          }
        }
      }
      if(r >= 1)
      {
        ap_uint<192> widetemp;
        widetemp(31,    0) = acc.val[0](31, 0);
        widetemp(63,   32) = acc.val[1](31, 0);
        widetemp(95,   64) = acc.val[2](31, 0);
        widetemp(127,  96) = acc.val[3](31, 0);
        widetemp(159, 128) = acc.val[4](31, 0);
        widetemp(191, 160) = acc.val[5](31, 0);
        Output_1.write(widetemp);
      }
    }
  }
}

