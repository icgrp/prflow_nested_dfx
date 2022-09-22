#include "../host/typedefs.h"

static void tensor_weight_y2(
        hls::stream< ap_uint<160> > &Input_1,
        hls::stream< ap_uint<160> > &Output_1)
{
#ifdef RISCV
  hls::LineBuffer<3,MAX_WIDTH,outer_half_t> buf;
#else
  xf::cv::LineBuffer<3,MAX_WIDTH,outer_half_t> buf;
#endif
  const pixel_t TENSOR_FILTER[] = {0.3243, 0.3513, 0.3243};
  TENSOR_WEIGHT_Y_OUTER: for(int r=0; r<MAX_HEIGHT+1; r++)
  {
#ifdef RISCV
      print_str("r=");
      print_dec(r);
      print_str("\n");
#endif
    TENSOR_WEIGHT_Y_INNER: for(int c=0; c<MAX_WIDTH; c++)
    {
      #pragma HLS pipeline II=1

      outer_half_t tmp;
      #pragma HLS data_pack variable=tmp
      #pragma HLS data_pack variable=buf.val[0]
      buf.shift_pixels_up(c);
      if(r<MAX_HEIGHT)
      {
        ap_uint<160>  in_tmp;
        in_tmp = Input_1.read();
        tmp.val[0](31,0)  = in_tmp(31,0);
        tmp.val[0](47,32) = in_tmp(47,32);
        tmp.val[1](15,0)  = in_tmp(63,48);
        tmp.val[1](47,16) = in_tmp(95,64);
        tmp.val[2](31,0)  = in_tmp(127,96);
        tmp.val[2](47,32) = in_tmp(143,128);
      }
      else
      {
        TENSOR_WEIGHT_Y_TMP_INIT: for(int i=0; i<3; i++)
          tmp.val[i] = 0;
      }
      buf.insert_bottom_row(tmp,c);

      tensor_half_t acc;
      TENSOR_WEIGHT_Y_ACC_INIT: for(int k =0; k<3; k++)
        acc.val[k] = 0;

      if (r >= 2 && r < MAX_HEIGHT)
      {
        TENSOR_WEIGHT_Y_TMP_OUTER: for(int i=0; i<3; i++)
        {
          tmp = buf.getval(i,c);
          pixel_t k = TENSOR_FILTER[i];
          TENSOR_WEIGHT_Y_TMP_INNER: for(int component=0; component<3; component++)
          {
            acc.val[component] = acc.val[component] + tmp.val[component]*k;
          }
        }
      }
      if(r >= 1)
      {
        ap_uint<160> widetemp;
        widetemp(31,    0) = acc.val[0](31, 0);
        widetemp(47,   32) = acc.val[0](47,32);
        widetemp(63,   48) = acc.val[1](15, 0);
        widetemp(95,   64) = acc.val[1](47,16);
        widetemp(127,  96) = acc.val[2](31, 0);
        widetemp(143, 128) = acc.val[2](47,32);
        widetemp(159, 144) = 0;
        Output_1.write(widetemp);
      }
    }
  }
}

static void tensor_weight_y1(
        hls::stream< ap_uint<160> > &Input_1,
        hls::stream< ap_uint<160> > &Output_1)
{

#ifdef RISCV
  hls::LineBuffer<3,MAX_WIDTH,outer_half_t> buf;
#else
  xf::cv::LineBuffer<3,MAX_WIDTH,outer_half_t> buf;
#endif
  const pixel_t TENSOR_FILTER[] = {0.3243, 0.3513, 0.3243};
  TENSOR_WEIGHT_Y_OUTER: for(int r=0; r<MAX_HEIGHT+1; r++)
  {
#ifdef RISCV
      print_str("r=");
      print_dec(r);
      print_str("\n");
#endif
    TENSOR_WEIGHT_Y_INNER: for(int c=0; c<MAX_WIDTH; c++)
    {
#pragma HLS pipeline II=1
      outer_half_t tmp;
      #pragma HLS data_pack variable=tmp
      #pragma HLS data_pack variable=buf.val[0]
      buf.shift_pixels_up(c);
      if(r<MAX_HEIGHT)
      {
        ap_uint<160> in_tmp;
        in_tmp = Input_1.read();
        tmp.val[0](31,0)  = in_tmp(31,0);
        tmp.val[0](47,32) = in_tmp(47,32);
        tmp.val[1](15,0)  = in_tmp(63,48);
        tmp.val[1](47,16) = in_tmp(95,64);
        tmp.val[2](31,0)  = in_tmp(127,96);
        tmp.val[2](47,32) = in_tmp(143,128);
      }
      else
      {
        TENSOR_WEIGHT_Y_TMP_INIT: for(int i=0; i<3; i++){
#pragma HLS UNROLL
            tmp.val[i] = 0;
        }
      }
      buf.insert_bottom_row(tmp,c);

      tensor_half_t acc;
      TENSOR_WEIGHT_Y_ACC_INIT: for(int k =0; k<3; k++){
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
          TENSOR_WEIGHT_Y_TMP_INNER: for(int component=0; component<3; component++)
          {
#pragma HLS UNROLL
            acc.val[component] = acc.val[component] + tmp.val[component]*k;
          }
        }
      }
      if(r >= 1)
      {
        ap_uint<160> widetemp;
        widetemp(31,    0) = acc.val[0].range(31,0);
        widetemp(47,   32) = acc.val[0].range(47,32);
        widetemp(63,   48) = acc.val[1].range(15, 0);
        widetemp(95,   64) = acc.val[1].range(47, 16);
        widetemp(127,  96) = acc.val[2].range(31, 0);
        widetemp(143, 128) = acc.val[2].range(47, 32);
        widetemp(159, 144) = 0;
        Output_1.write(widetemp);
      }
    }
  }
}


static void tensor_weight_x2(hls::stream< ap_uint<160> > &Input_1,
             hls::stream< ap_uint<160> > &Output_1)
{
// #pragma HLS interface axis register port=Input_1
// #pragma HLS interface axis register port=Output_1
#ifdef RISCV
  hls::Window<1,3,tensor_half_t> buf;
#else
  xf::cv::Window<1,3,tensor_half_t> buf;
#endif


  const pixel_t TENSOR_FILTER[] = {0.3243, 0.3513, 0.3243};
  TENSOR_WEIGHT_X_OUTER: for(int r=0; r<MAX_HEIGHT; r++)
  {
#ifdef RISCV
      print_str("r=");
      print_dec(r);
      print_str("\n");
#endif
    TENSOR_WEIGHT_X_INNER: for(int c=0; c<MAX_WIDTH+1; c++)
    {
      #pragma HLS pipeline II=1
      buf.shift_pixels_left();
      tensor_half_t tmp;
      if(c<MAX_WIDTH)
      {
       // widebus_t widetemp = Input_1.read();
          ap_uint<160> widetemp;
          widetemp = Input_1.read();
          tmp.val[0](31, 0) = widetemp(31,    0);
          tmp.val[0](47,32) = widetemp(47,   32);
          tmp.val[1](15, 0) = widetemp(63,   48);
          tmp.val[1](47,16) = widetemp(95,   64);
          tmp.val[2](31, 0) = widetemp(127,  96);
          tmp.val[2](47,32) = widetemp(143, 128);
      }
      else
      {
        TENSOR_WEIGHT_X_TMP_INIT: for(int i=0; i<3; i++)
          tmp.val[i] = 0;
      }
      buf.insert_pixel(tmp,0,2);

      tensor_half_t acc;
      TENSOR_WEIGHT_X_ACC_INIT: for(int k =0; k<3; k++)
        acc.val[k] = 0;
      if (c >= 2 && c < MAX_WIDTH)
      {
        TENSOR_WEIGHT_X_TMP_OUTER: for(int i=0; i<3; i++)
        {
          tmp = buf.getval(0,i);
          TENSOR_WEIGHT_X_TMP_INNER: for(int component=0; component<3; component++)
          {
            acc.val[component] = acc.val[component] + tmp.val[component]*TENSOR_FILTER[i];
          }
        }
      }
      if(c>=1)
      {
        ap_uint<160> widetemp;
        widetemp(31,    0) = acc.val[0](31, 0);
        widetemp(47,   32) = acc.val[0](47,32);
        widetemp(63,   48) = acc.val[1](15, 0);
        widetemp(95,   64) = acc.val[1](47,16);
        widetemp(127,  96) = acc.val[2](31, 0);
        widetemp(143, 128) = acc.val[2](47,32);
        widetemp(159, 144) = 0;
        Output_1.write(widetemp);
      }
    }
  }
}

static void tensor_weight_x1(hls::stream< ap_uint<160> > &Input_1,
             hls::stream< ap_uint<160> > &Output_1)
{
// #pragma HLS interface axis register port=Input_1
// #pragma HLS interface axis register port=Output_1
#ifdef RISCV
  hls::Window<1,3,tensor_half_t> buf;
#else
  xf::cv::Window<1,3,tensor_half_t> buf;
#endif

  const pixel_t TENSOR_FILTER[] = {0.3243, 0.3513, 0.3243};
  TENSOR_WEIGHT_X_OUTER: for(int r=0; r<MAX_HEIGHT; r++)
  {
#ifdef RISCV
      print_str("r=");
      print_dec(r);
      print_str("\n");
#endif
    TENSOR_WEIGHT_X_INNER: for(int c=0; c<MAX_WIDTH+1; c++)
    {
      #pragma HLS pipeline II=1
      buf.shift_pixels_left();
      tensor_half_t tmp;
      if(c<MAX_WIDTH)
      {
        //widebus_t widetemp = Input_1.read();
        ap_uint<160> widetemp;
        widetemp = Input_1.read();
        tmp.val[0](31, 0) = widetemp(31,    0);
        tmp.val[0](47,32) = widetemp(47,   32);
        tmp.val[1](15, 0) = widetemp(63,   48);
        tmp.val[1](47,16) = widetemp(95,   64);
        tmp.val[2](31, 0) = widetemp(127,  96);
        tmp.val[2](47,32) = widetemp(143, 128);
      }
      else
      {
        TENSOR_WEIGHT_X_TMP_INIT: for(int i=0; i<3; i++)
          tmp.val[i] = 0;
      }
      buf.insert_pixel(tmp,0,2);

      tensor_half_t acc;
      TENSOR_WEIGHT_X_ACC_INIT: for(int k =0; k<3; k++)
        acc.val[k] = 0;
      if (c >= 2 && c < MAX_WIDTH)
      {
        TENSOR_WEIGHT_X_TMP_OUTER: for(int i=0; i<3; i++)
        {
          tmp = buf.getval(0,i);
          TENSOR_WEIGHT_X_TMP_INNER: for(int component=0; component<3; component++)
          {
            acc.val[component] = acc.val[component] + tmp.val[component]*TENSOR_FILTER[i];
          }
        }
      }
      if(c>=1)
      {
        ap_uint<160> widetemp;
        widetemp(31,    0) = acc.val[0](31, 0);
        widetemp(47,   32) = acc.val[0](47,32);
        widetemp(63,   48) = acc.val[1](15, 0);
        widetemp(95,   64) = acc.val[1](47,16);
        widetemp(127,  96) = acc.val[2](31, 0);
        widetemp(143, 128) = acc.val[2](47,32);
        widetemp(159, 144) = 0;
        Output_1.write(widetemp);
      }
    }
  }
}

static void flow_calc_body(
        hls::stream< ap_uint<160> > &Input_1,
        hls::stream< ap_uint<160> > &Input_2,
        hls::stream<stdio_t> &Output_1,
        hls::stream<stdio_t> &Output_2)
{
  // static float buf;
  static float buf[2];
  FLOW_OUTER: for(int r=0; r<MAX_HEIGHT; r++)
  {
    FLOW_INNER: for(int c=0; c<MAX_WIDTH; c++)
    {
      #pragma HLS pipeline II=1
      tensor_t tmp_tensor;
      ap_uint<160> widetemp;

      widetemp = Input_1.read();
      tmp_tensor.val[0](31, 0) = widetemp(31,    0);
      tmp_tensor.val[0](47,32) = widetemp(47,   32);
      tmp_tensor.val[1](15, 0) = widetemp(63,   48);
      tmp_tensor.val[1](47,16) = widetemp(95,   64);
      tmp_tensor.val[2](31, 0) = widetemp(127,  96);
      tmp_tensor.val[2](47,32) = widetemp(143, 128);


      widetemp = Input_2.read();
      tmp_tensor.val[3](31, 0) = widetemp(31,    0);
      tmp_tensor.val[3](47,32) = widetemp(47,   32);
      tmp_tensor.val[4](15, 0) = widetemp(63,   48);
      tmp_tensor.val[4](47,16) = widetemp(95,   64);
      tmp_tensor.val[5](31, 0) = widetemp(127,  96);
      tmp_tensor.val[5](47,32) = widetemp(143, 128);


      if(r>=2 && r<MAX_HEIGHT-2 && c>=2 && c<MAX_WIDTH-2)
      {
          calc_pixel_t t1 = (calc_pixel_t) tmp_tensor.val[0];
          calc_pixel_t t2 = (calc_pixel_t) tmp_tensor.val[1];
          calc_pixel_t t4 = (calc_pixel_t) tmp_tensor.val[2];
          calc_pixel_t t5 = (calc_pixel_t) tmp_tensor.val[4];
          calc_pixel_t t6 = (calc_pixel_t) tmp_tensor.val[5];

          calc_pixel_t denom = t1*t2-t4*t4;
          calc_pixel_t numer0 = t6*t4-t5*t2;
          calc_pixel_t numer1 = t5*t4-t6*t1;


          if(denom != 0)
              {
              buf[0] =(float) numer0 / (float) denom;
              buf[1] =(float) numer1 / (float) denom;
              //buf =  numer0 / denom;
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

      //printf("0x%08x,\n", tmpframe.to_int());
    }
  }


}


void flow_calc_1(
		hls::stream< ap_uint<160> > &Input_1,
		hls::stream< ap_uint<160> > &Input_2,
		hls::stream<stdio_t> &Output_1,
        hls::stream<stdio_t> &Output_2)
{
#pragma HLS interface axis register port=Input_1
#pragma HLS interface axis register port=Input_2
#pragma HLS interface axis register port=Output_1
#pragma HLS interface axis register port=Output_2


    static hls::stream<ap_uint<160>> t_w_y1_out("tensor_weight_y1_out_stream");
    static hls::stream<ap_uint<160>> t_w_y2_out("tensor_weight_y2_out_stream");

    static hls::stream<ap_uint<160>> t_w_x1_out("tensor_weight_x1_out_stream");
    static hls::stream<ap_uint<160>> t_w_x2_out("tensor_weight_x2_out_stream");

#pragma HLS dataflow
    tensor_weight_y1(Input_1,t_w_y1_out);
    tensor_weight_y2(Input_2,t_w_y2_out);

    tensor_weight_x1(t_w_y1_out,t_w_x1_out);
    tensor_weight_x2(t_w_y2_out,t_w_x2_out);

    flow_calc_body(t_w_x1_out,t_w_x2_out,Output_1,Output_2);

}

