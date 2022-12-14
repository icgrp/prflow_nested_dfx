// outer product
#include "../host/typedefs.h"
void outer_product1(
    		       hls::stream<databus_t> &Input_1,
		       hls::stream<databus_t> &Input_2,
		       hls::stream<databus_t> &Input_3,
		   hls::stream< ap_uint<96> > &Output_1
		)
{
#pragma HLS interface axis register port=Input_1
#pragma HLS interface axis register port=Input_2
#pragma HLS interface axis register port=Input_3
#pragma HLS interface axis register port=Output_1
  OUTER_OUTER: for(int r=0; r<MAX_HEIGHT; r++)
  {
#ifdef RISCV1
	  print_str("r=");
	  print_dec(r);
	  print_str("\n");
#endif
    OUTER_INNER: for(int c=0; c<MAX_WIDTH; c++)
    {
      #pragma HLS pipeline II=1
      //gradient_t grad = gradient[r][c];
      gradient_t grad;
      databus_t temp_x,temp_y,temp_z;
      temp_x = Input_1.read();
      //printf("in1: %08x\n", temp_x.to_int());
      temp_y = Input_2.read();
      //printf("in2: %08x\n", temp_y.to_int());
      temp_z = Input_3.read();
      //printf("in3: %08x\n", temp_z.to_int());
      grad.x(31,0) = temp_x.range(31,0);
      grad.y(31,0) = temp_y.range(31,0);
      grad.z(31,0) = temp_z.range(31,0);
      outer_pixel_t x = (outer_pixel_t) grad.x;
      outer_pixel_t y = (outer_pixel_t) grad.y;
      outer_pixel_t z = (outer_pixel_t) grad.z;
      outer_t out;
      out.val[0] = (x*x);
      out.val[1] = (y*y);
      out.val[2] = (z*z);

      ap_uint<96> out_tmp;
      out_tmp(31,   0) = out.val[0].range(31,0);
      out_tmp(63,  32) = out.val[1].range(31,0);
      out_tmp(95,  64) = out.val[2].range(31,0);
      Output_1.write(out_tmp);
    }
  }
}

