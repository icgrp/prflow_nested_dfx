#include "../host/typedefs.h"

static void tensor_weight_x_1(hls::stream< ap_uint<192> > &Input_1,
         hls::stream< ap_uint<192> > &Output_1)
{
// #pragma HLS interface axis register port=Input_1
// #pragma HLS interface axis register port=Output_1
#ifdef RISCV
  hls::Window<1,3,tensor_t> buf;
#else
  xf::cv::Window<1,3,tensor_t> buf;
#endif
  const pixel_t TENSOR_FILTER[] = {0.3243, 0.3513, 0.3243};
  TENSOR_WEIGHT_X_OUTER: for(int r=0; r<MAX_HEIGHT; r++)
  {
    TENSOR_WEIGHT_X_INNER: for(int c=0; c<MAX_WIDTH+1; c++)
    {
#pragma HLS pipeline II=1

      buf.shift_pixels_left();
      tensor_t tmp;
      if(c<MAX_WIDTH)
      {
          ap_uint<192> widetemp;
          widetemp = Input_1.read();
          tmp.val[0](31, 0) = widetemp(31,    0);
          tmp.val[1](31, 0) = widetemp(63,   32);
          tmp.val[2](31, 0) = widetemp(95,   64);
          tmp.val[3](31, 0) = widetemp(127,  96);
          tmp.val[4](31, 0) = widetemp(159, 128);
          tmp.val[5](31, 0) = widetemp(191, 160);
      }
      else
      {
        TENSOR_WEIGHT_X_TMP_INIT: for(int i=0; i<6; i++)
#pragma HLS UNROLL
          tmp.val[i] = 0;
      }
      buf.insert_pixel(tmp,0,2);

      tensor_t acc;
      TENSOR_WEIGHT_X_ACC_INIT: for(int k =0; k<6; k++)
#pragma HLS UNROLL
        acc.val[k] = 0;
      if (c >= 2 && c < MAX_WIDTH)
      {
        TENSOR_WEIGHT_X_TMP_OUTER: for(int i=0; i<3; i++)
        {
#pragma HLS UNROLL
          tmp = buf.getval(0,i);
          TENSOR_WEIGHT_X_TMP_INNER: for(int component=0; component<6; component++)
          {
#pragma HLS UNROLL
            acc.val[component] = acc.val[component] + tmp.val[component]*TENSOR_FILTER[i];
          }
        }
      }
      if(c>=1)
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


void flow_calc_body(
    hls::stream<ap_uint<192>> &Input_1,
    hls::stream<stdio_t> &Output_1,
    hls::stream<stdio_t> &Output_2)
{
// #pragma HLS interface axis register port=Input_1
// #pragma HLS interface axis register port=Output_1
// #pragma HLS interface axis register port=Output_2

  // static float buf;
  // static float buf[2];
  static outer_pixel_t buf[2];

  FLOW_OUTER: for(int r=0; r<MAX_HEIGHT; r++)
  {
    FLOW_INNER: for(int c=0; c<MAX_WIDTH; c++)
    {
      #pragma HLS pipeline II=1
      tensor_t tmp_tensor;
      ap_uint<192> widetemp;

      widetemp = Input_1.read();
      tmp_tensor.val[0](31, 0) = widetemp(31,    0);
      tmp_tensor.val[1](31, 0) = widetemp(63,   32);
      tmp_tensor.val[2](31, 0) = widetemp(95,   64);
      tmp_tensor.val[3](31, 0) = widetemp(127,  96);
      tmp_tensor.val[4](31, 0) = widetemp(159, 128);
      tmp_tensor.val[5](31, 0) = widetemp(191, 160);

      if(r>=2 && r<MAX_HEIGHT-2 && c>=2 && c<MAX_WIDTH-2)
      {
        calc_pixel_t t1 = (calc_pixel_t) tmp_tensor.val[0];
        calc_pixel_t t2 = (calc_pixel_t) tmp_tensor.val[1];
        calc_pixel_t t3 = (calc_pixel_t) tmp_tensor.val[2];
        calc_pixel_t t4 = (calc_pixel_t) tmp_tensor.val[3];
        calc_pixel_t t5 = (calc_pixel_t) tmp_tensor.val[4];
        calc_pixel_t t6 = (calc_pixel_t) tmp_tensor.val[5];

        calc_pixel_t denom = t1*t2-t4*t4;
        calc_pixel_t numer0 = t6*t4-t5*t2;
        calc_pixel_t numer1 = t5*t4-t6*t1;

        if(denom != 0)
        {
          // buf[0] =(float) numer0 / (float) denom;
          // buf[1] =(float) numer1 / (float) denom;
          //buf =  numer0 / denom;
          buf[0] = numer0 / denom;
          buf[1] = numer1 / denom;
        }
        else
        {
          buf[0] = 0;
          buf[1] = 0;
        }
      }
      else
      {
        buf[0] = 0;
        buf[1] = 0;
      }
      stdio_t tmpframe_0, tmpframe_1;
      vel_pixel_t tmpvel_0, tmpvel_1;

      tmpvel_0 = (vel_pixel_t)buf[0];
      tmpframe_0(31,0) = tmpvel_0(31,0);

      tmpvel_1 = (vel_pixel_t)buf[1];
      tmpframe_1(31,0) = tmpvel_1(31,0);

      Output_1.write(tmpframe_0);
      Output_2.write(tmpframe_1);


      // stdio_t tmpframe_0, tmpframe_1;
      // vel_pixel_t tmpvel_0, tmpvel_1;

      // tmpvel_0 = (vel_pixel_t)buf[0];
      // tmpframe_0(31,0) = tmpvel_0(31,0);

      // tmpvel_1 = (vel_pixel_t)buf[1];
      // tmpframe_1(31,0) = tmpvel_1(31,0);

      // Output_1.write(tmpframe_0);
      // Output_2.write(tmpframe_1);

      //printf("0x%08x,\n", tmpframe.to_int());
    }
  }
}


void flow_calc_1(
        hls::stream< ap_uint<192> > &Input_1,
        hls::stream<stdio_t> &Output_1,
        hls::stream<stdio_t> &Output_2)
{
#pragma HLS interface axis register port=Input_1
#pragma HLS interface axis register port=Output_1
#pragma HLS interface axis register port=Output_2


    static hls::stream<ap_uint<192>> t_w_x1_out("tensor_weight_x1_out_stream");

#pragma HLS dataflow
    tensor_weight_x_1(Input_1,t_w_x1_out);
    flow_calc_body(t_w_x1_out,Output_1,Output_2);

}
