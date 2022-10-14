#include "../host/typedefs.h"
void gradient_weight_y_1(
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
  hls::LineBuffer<7,MAX_WIDTH,gradient_t> buf;
#else
  xf::cv::LineBuffer<7,MAX_WIDTH,gradient_t> buf;
#endif

  const pixel_t GRAD_FILTER[] = {0.0755, 0.133, 0.1869, 0.2903, 0.1869, 0.133, 0.0755};
  GRAD_WEIGHT_Y_OUTER: for(int r=0; r<MAX_HEIGHT+3; r++)
  {
    GRAD_WEIGHT_Y_INNER: for(int c=0; c<MAX_WIDTH; c++)
    {
      #pragma HLS pipeline II=1
      #pragma HLS dependence variable=buf inter false

      if(r<MAX_HEIGHT)
      {
        buf.shift_pixels_up(c);
        databus_t temp_x, temp_y, temp_z;
        gradient_t tmp;
        // tmp.x = 0;
        // tmp.y = 0;
        // tmp.z = 0;
      	temp_x = Input_1.read();
        temp_y = Input_2.read();
        temp_z = Input_3.read();
      	tmp.x(31,0) = temp_x(31,0);
        tmp.y(31,0) = temp_y(31,0);
        tmp.z(31,0) = temp_z(31,0);
        buf.insert_bottom_row(tmp,c);
      }
      else
      {
        buf.shift_pixels_up(c);
        gradient_t tmp;
        tmp.x(31,0) = 0;
        tmp.y(31,0) = 0;
        tmp.z(31,0) = 0;
        buf.insert_bottom_row(tmp,c);
      }

      gradient_t acc;
      acc.x = 0;
      acc.y = 0;
      acc.z = 0;
      databus_t temp_x, temp_y, temp_z;
      if(r >= 6 && r<MAX_HEIGHT)
      {
        GRAD_WEIGHT_Y_ACC: for(int i=0; i<7; i++)
        {
          acc.x =  acc.x + buf.getval(i,c).x*GRAD_FILTER[i];
          acc.y =  acc.y + buf.getval(i,c).y*GRAD_FILTER[i];
          acc.z =  acc.z + buf.getval(i,c).z*GRAD_FILTER[i];
        }
    		temp_x(31,0) = acc.x.range(31,0);
        temp_y(31,0) = acc.y.range(31,0);
        temp_z(31,0) = acc.z.range(31,0);
    		Output_1.write(temp_x);
        Output_2.write(temp_y);
        Output_3.write(temp_z);
      }
      else if(r>=3)
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

