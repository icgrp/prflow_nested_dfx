/*===============================================================*/
/*                                                               */
/*                        rendering.cpp                          */
/*                                                               */
/*                 C++ kernel for 3D Rendering                   */
/*                                                               */
/*===============================================================*/

#include "../host/typedefs.h"
#include "../operators/data_redir_m.h"
#include "../operators/data_transfer.h"
#include "../operators/rasterization2_m.h"
#include "../operators/zculling_top.h"
#include "../operators/zculling_bot.h"
#include "../operators/coloringFB_bot_m.h"
#include "../operators/coloringFB_top_m.h"

// #include "../operators/t_1.h"
// #include "../operators/t_2.h"
// #include "../operators/tc_1.h"
// #include "../operators/tc_2.h"
// #include "../operators/tc_3.h"
// #include "../operators/tc_4.h"

#include "../operators/t2_1.h"
#include "../operators/t2c_1.h"
#include "../operators/t2c_2.h"

#include "../operators/tc_all.h"
#include "../operators/rasterization2_m_1.h"
/*======================UTILITY FUNCTIONS========================*/

// #define PROFILE 

#ifdef PROFILE
  int data_redir_m_in_1=0;
  int data_redir_m_out_1=0;
  int data_redir_m_out_2=0;
  int rasterization2_m_in_1=0;
  int rasterization2_m_in_2=0;
  int rasterization2_m_out_1=0;
  int rasterization2_m_out_2=0;
  int rasterization2_m_out_3=0;
  int rasterization2_m_out_4=0;
  int zculling_top_in_1=0;
  int zculling_top_in_2=0;
  int zculling_top_out_1=0;
  int zculling_bot_in_1=0;
  int zculling_bot_in_2=0;
  int zculling_bot_out_1=0;
  int coloringFB_top_m_in_1=0;
  int coloringFB_top_m_in_2=0;
  int coloringFB_top_m_out_1=0;
  int coloringFB_bot_m_in_1=0;
  int coloringFB_bot_m_out_1=0;
#endif

const int default_depth = 128;

void top (
		  hls::stream<ap_uint<512> > & Input_1,
      hls::stream<ap_uint<32> > & Input_2,
		  hls::stream<ap_uint<512> > & Output_1,
      hls::stream<ap_uint<32> > & Output_2
		)

//( bit32 input[3*NUM_3D_TRI], bit32 output[NUM_FB])
{
#pragma HLS INTERFACE ap_hs port=Input_1
#pragma HLS INTERFACE ap_hs port=Input_2
#pragma HLS INTERFACE ap_hs port=Output_1
#pragma HLS INTERFACE ap_hs port=Output_2
#pragma HLS DATAFLOW
  // local variables
  Triangle_2D triangle_2ds;
  Triangle_2D triangle_2ds_same;

  bit16 size_fragment;
  CandidatePixel fragment[500];

  bit16 size_pixels;
  Pixel pixels[500];

  bit8 frame_buffer[MAX_X][MAX_Y];
  bit2 angle = 0;

  bit8 max_min[5];
  bit16 max_index[1];
  bit2 flag;
  hls::stream<ap_uint<32> > Output_redir_odd("sb1");
#pragma HLS STREAM variable=Output_redir_odd depth=default_depth



  hls::stream<ap_uint<32> > Output_redir_even("sb2");
#pragma HLS STREAM variable=Output_redir_even depth=default_depth

  hls::stream<ap_uint<32> > Output_projc_odd("sb3");
#pragma HLS STREAM variable=Output_projc_odd depth=default_depth
  hls::stream<ap_uint<32> > Output_projc_even("sb4");
#pragma HLS STREAM variable=Output_projc_even depth=default_depth
  hls::stream<ap_uint<32> > Output_r1_odd("sb5");
#pragma HLS STREAM variable=Output_r1_odd depth=default_depth
  hls::stream<ap_uint<32> > Output_r1_even("sb6");
#pragma HLS STREAM variable=Output_r1_even depth=default_depth

  hls::stream<ap_uint<32> > Output_r2_odd_top("sb7");
#pragma HLS STREAM variable=Output_r2_odd_top depth=default_depth
  hls::stream<ap_uint<32> > Output_r2_odd_bot("sb8");
#pragma HLS STREAM variable=Output_r2_odd_bot depth=default_depth
  hls::stream<ap_uint<32> > Output_r2_even_top("sb9");
#pragma HLS STREAM variable=Output_r2_even_top depth=default_depth
  hls::stream<ap_uint<32> > Output_r2_even_bot("sb10");
#pragma HLS STREAM variable=Output_r2_even_bot depth=default_depth


  hls::stream<ap_uint<32> > Output_zcu_top("sb11");
#pragma HLS STREAM variable=Output_zcu_top depth=default_depth
  hls::stream<ap_uint<32> > Output_zcu_bot("sb12");
#pragma HLS STREAM variable=Output_zcu_bot depth=default_depth
  hls::stream<ap_uint<32> > Output_cfb_top("sb13");
#pragma HLS STREAM variable=Output_cfb_top depth=default_depth
  hls::stream<ap_uint<128> > Output_cfb_bot("sb14");
#pragma HLS STREAM variable=Output_cfb_bot depth=default_depth

  hls::stream<ap_uint<128> > conv_out("sb16");

  hls::stream<ap_uint<32> > Output_pp("sb15");

  hls::stream<ap_uint<32> > Output_data_m("data_1");


//   hls::stream<ap_uint<32> > Output_tandem_redir_odd;
// #pragma HLS STREAM variable=Output_tandem_redir_odd depth=default_depth
//   hls::stream<ap_uint<32> > Output_tandem_redir_even;
// #pragma HLS STREAM variable=Output_tandem_redir_even depth=default_depth

// tandem
  hls::stream<ap_uint<32> > Output_redir_odd_1;
#pragma HLS STREAM variable=Output_redir_odd_1 depth=default_depth
  hls::stream<ap_uint<32> > Output_redir_odd_2;
#pragma HLS STREAM variable=Output_redir_odd_2 depth=default_depth
  hls::stream<ap_uint<32> > Output_redir_even_1;
#pragma HLS STREAM variable=Output_redir_even_1 depth=default_depth
  hls::stream<ap_uint<32> > Output_redir_even_2;
#pragma HLS STREAM variable=Output_redir_even_2 depth=default_depth

  hls::stream<ap_uint<32> > winner_1;
#pragma HLS STREAM variable=winner_1 depth=default_depth
  hls::stream<ap_uint<32> > winner_2;
#pragma HLS STREAM variable=winner_2 depth=default_depth
  hls::stream<ap_uint<32> > winner_3;
#pragma HLS STREAM variable=winner_3 depth=default_depth
  hls::stream<ap_uint<32> > winner_4;
#pragma HLS STREAM variable=winner_4 depth=default_depth

// rasterization2_m
  hls::stream<ap_uint<32> > Output_r2_odd_top_1;
#pragma HLS STREAM variable=Output_r2_odd_top_1 depth=default_depth
  hls::stream<ap_uint<32> > Output_r2_odd_bot_1;
#pragma HLS STREAM variable=Output_r2_odd_bot_1 depth=default_depth
  hls::stream<ap_uint<32> > Output_r2_even_top_1;
#pragma HLS STREAM variable=Output_r2_even_top_1 depth=default_depth
  hls::stream<ap_uint<32> > Output_r2_even_bot_1;
#pragma HLS STREAM variable=Output_r2_even_bot_1 depth=default_depth

// rasterization2_m_1
  hls::stream<ap_uint<32> > Output_r2_odd_top_2;
#pragma HLS STREAM variable=Output_r2_odd_top_2 depth=default_depth
  hls::stream<ap_uint<32> > Output_r2_odd_bot_2;
#pragma HLS STREAM variable=Output_r2_odd_bot_2 depth=default_depth
  hls::stream<ap_uint<32> > Output_r2_even_top_2;
#pragma HLS STREAM variable=Output_r2_even_top_2 depth=default_depth
  hls::stream<ap_uint<32> > Output_r2_even_bot_2;
#pragma HLS STREAM variable=Output_r2_even_bot_2 depth=default_depth


  data_transfer(Input_1, conv_out);


  // processing NUM_3D_TRI 3D triangles
  TRIANGLES: for (int i = 0; i < NUM_3D_TRI/2; i++)
  {

    // printf("data redir starts\n");
	  data_redir_m(conv_out, Output_redir_odd, Output_redir_even);

    t2_1(Output_redir_odd, Output_redir_even, 
        Output_redir_odd_1, Output_redir_odd_2,
        Output_redir_even_1, Output_redir_even_2);

    // printf("tandem starts\n");
    // tandem(Output_redir_odd, Output_redir_even, 
    //       Output_tandem_output_0_0, Output_tandem_output_0_1,
    //       Output_tandem_output_1_0, Output_tandem_output_1_1);

    // printf("rasterization starts\n");
    rasterization2_m(Output_redir_odd_1, Output_r2_odd_top_1, Output_r2_odd_bot_1,
                    Output_redir_even_1, Output_r2_even_top_1, Output_r2_even_bot_1);

    rasterization2_m_1(Output_redir_odd_2, Output_r2_odd_top_2, Output_r2_odd_bot_2,
                      Output_redir_even_2, Output_r2_even_top_2, Output_r2_even_bot_2);

    t2c_1(Output_r2_odd_top_1, Output_r2_odd_top_2, Output_r2_odd_bot_1, Output_r2_odd_bot_2,
          Output_r2_odd_top, Output_r2_odd_bot, winner_1);
    t2c_2(Output_r2_even_top_1, Output_r2_even_top_2, Output_r2_even_bot_1, Output_r2_even_bot_2,
          Output_r2_even_top, Output_r2_even_bot, winner_2);

    tc_all(winner_1, winner_2, winner_3, winner_4, Output_2);

    // printf("zculling top starts\n");
    zculling_top( Output_r2_odd_top, Output_r2_even_top, Output_zcu_top);
    // printf("zculling bot starts\n");
    zculling_bot(Output_r2_odd_bot, Output_r2_even_bot, Output_zcu_bot);
    // printf("coloringFB bot starts\n");
    coloringFB_bot_m(Output_zcu_bot, Output_cfb_bot);
    // printf("coloringFB top starts\n");
    coloringFB_top_m(Output_zcu_top, Output_cfb_bot, Output_1);

    // printf("zculling top starts\n");
    zculling_top( Output_r2_odd_top, Output_r2_even_top, Output_zcu_top);
    // printf("zculling bot starts\n");
    zculling_bot(Output_r2_odd_bot, Output_r2_even_bot, Output_zcu_bot);
    // printf("coloringFB bot starts\n");
    coloringFB_bot_m(Output_zcu_bot, Output_cfb_bot);
    // printf("coloringFB top starts\n");
    coloringFB_top_m(Output_zcu_top, Output_cfb_bot, Output_1);

  }

  // output values: frame buffer
  //output_FB_dul(Output_cfb_top, Output_cfb_bot,Output_1);

#ifdef PROFILE
  printf("data_redir_m_in_1,%d\n", data_redir_m_in_1);
  printf("data_redir_m_out_1,%d\n", data_redir_m_out_1);
  printf("data_redir_m_out_2,%d\n", data_redir_m_out_2);
  printf("rasterization2_m_in_1,%d\n", rasterization2_m_in_1);
  printf("rasterization2_m_in_2,%d\n", rasterization2_m_in_2);
  printf("rasterization2_m_out_1,%d\n", rasterization2_m_out_1);
  printf("rasterization2_m_out_2,%d\n", rasterization2_m_out_2);
  printf("rasterization2_m_out_3,%d\n", rasterization2_m_out_3);
  printf("rasterization2_m_out_4,%d\n", rasterization2_m_out_4);
  printf("zculling_top_in_1,%d\n", zculling_top_in_1);
  printf("zculling_top_in_2,%d\n", zculling_top_in_2);
  printf("zculling_top_out_1,%d\n", zculling_top_out_1);
  printf("zculling_bot_in_1,%d\n", zculling_bot_in_1);
  printf("zculling_bot_in_2,%d\n", zculling_bot_in_2);
  printf("zculling_bot_out_1,%d\n", zculling_bot_out_1);
  printf("coloringFB_top_in_1,%d\n", coloringFB_top_m_in_1);
  printf("coloringFB_top_in_2,%d\n", coloringFB_top_m_in_2);
  printf("coloringFB_top_out_1,%d\n", coloringFB_top_m_out_1);
  printf("coloringFB_bot_in_1,%d\n", coloringFB_bot_m_in_1);
  printf("coloringFB_bot_out_1,%d\n", coloringFB_bot_m_out_1);
#endif


}




extern "C" {
	void ydma (
			bit64 * input1,
			bit512 * input2,
			bit64 * output1,
			bit512 * output2,
			int config_size,
			int input_size,
			int output_size,
      bit32 * input3,
      bit32 * winner,
      int winner_size
			)
	{
#pragma HLS INTERFACE m_axi port=input1 bundle=aximm1
#pragma HLS INTERFACE m_axi port=input2 bundle=aximm2
#pragma HLS INTERFACE m_axi port=output1 bundle=aximm1
#pragma HLS INTERFACE m_axi port=output2 bundle=aximm2
#pragma HLS INTERFACE m_axi port=input3 bundle=aximm3
#pragma HLS INTERFACE m_axi port=winner bundle=aximm3

	#pragma HLS DATAFLOW

	  bit64 v1_buffer[256];   // Local memory to store vector1
	  //hls::stream< unsigned int > v1_buffer;
	  #pragma HLS STREAM variable=v1_buffer depth=256

          hls::stream<ap_uint<512> > Input_1("Input_1_str");
          hls::stream<ap_uint<512> > Output_1("Output_str");

          hls::stream<ap_uint<32> > Input_2;
          hls::stream<ap_uint<32> > Output_2;

          for(int i=0; i<config_size; i++){ v1_buffer[i] = input1[i]; }
          for(int i=0; i<config_size; i++){ output1[i] = v1_buffer[i]; }

	        for(int i=0; i<input_size;  i++){ 
            Input_1.write(input2[i]);
          }
	  
          top(Input_1, Input_2, Output_1, Output_2);
          for(int i=0; i<winner_size;  i++){ 
            winner[i] = Output_2.read();
          }
 
          for(int i=0; i<output_size; i++){ 
        	  output2[i] = Output_1.read();
          }
    }
}
