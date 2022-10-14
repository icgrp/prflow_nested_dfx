#include "../host/typedefs.h"
void gradient_weight_x_1(
		       hls::stream<databus_t> &Input_1,
           hls::stream<databus_t> &Input_2,
           hls::stream<databus_t> &Input_3,
    		   hls::stream<databus_t> &Output_1,
           hls::stream<databus_t> &Output_2,
           hls::stream<databus_t> &Output_3)
{
#pragma HLS interface axis register port=Input_1
#pragma HLS interface axis register port=Input_2
#pragma HLS interface axis register port=Input_3
#pragma HLS interface axis register port=Output_1
#pragma HLS interface axis register port=Output_2
#pragma HLS interface axis register port=Output_3
#ifdef RISCV
  hls::Window<1,7,gradient_t> buf;
#else
  xf::cv::Window<1,7,gradient_t> buf;
#endif
  const pixel_t GRAD_FILTER[] = {0.0755, 0.133, 0.1869, 0.2903, 0.1869, 0.133, 0.0755};
  GRAD_WEIGHT_X_OUTER: for(int r=0; r<MAX_HEIGHT; r++)
  {
    GRAD_WEIGHT_X_INNER: for(int c=0; c<MAX_WIDTH+3; c++)
    {
      #pragma HLS pipeline II=1
      buf.shift_pixels_left();
      gradient_t tmp;
      // tmp.x = 0;
      // tmp.y = 0;
      // tmp.z = 0;
      databus_t temp_x, temp_y, temp_z;
      if(c<MAX_WIDTH)
      {
    		temp_x = Input_1.read();
        temp_y = Input_2.read();
        temp_z = Input_3.read();
    		tmp.x(31,0) = temp_x.range(31,0);
        tmp.y(31,0) = temp_y.range(31,0);
        tmp.z(31,0) = temp_z.range(31,0);
      }
      else
      {
        tmp.x = 0;
        tmp.y = 0;
        tmp.z = 0;
      }
      buf.insert_pixel(tmp,0,6);

      gradient_t acc;
      acc.x = 0;
      acc.y = 0;
      acc.z = 0;
      if(c >= 6 && c<MAX_WIDTH)
      {
        GRAD_WEIGHT_X_ACC: for(int i=0; i<7; i++)
        {
          acc.x = acc.x + buf.getval(0,i).x*GRAD_FILTER[i];
          acc.y = acc.y + buf.getval(0,i).y*GRAD_FILTER[i];
          acc.z = acc.z + buf.getval(0,i).z*GRAD_FILTER[i];
        }
        temp_x(31,0) = acc.x.range(31,0);
        temp_y(31,0) = acc.y.range(31,0);
        temp_z(31,0) = acc.z.range(31,0);
        Output_1.write(temp_x);
        Output_2.write(temp_y);
        Output_3.write(temp_z);
      }
      else if(c>=3)
      {
        temp_x(31,0) = acc.x.range(31,0);
        temp_y(31,0) = acc.y.range(31,0);
        temp_z(31,0) = acc.z.range(31,0);
        Output_1.write(temp_x);
        Output_2.write(temp_y);
        Output_3.write(temp_z);
      }
    }
  }
}

