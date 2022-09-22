
#include "../host/typedefs.h"
//data_input_redirection
void data_1_4_2(
		    hls::stream<ap_uint<64> > & Input_1,
			hls::stream<ap_uint<32> > & Input_2,
			hls::stream<ap_uint<32> > & Input_3,
			hls::stream<ap_uint<32> > & Input_4,
			hls::stream<ap_uint<32> > & Input_5,
			hls::stream<ap_uint<32> > & Input_6,

			hls::stream<ap_uint<64> > & Output_1,
			hls::stream<ap_uint<64> > & Output_2,
			hls::stream<ap_uint<64> > & Output_3,
			hls::stream<ap_uint<64> > & Output_4,
			hls::stream<ap_uint<512> > & Output_5
			)
{
#pragma HLS INTERFACE axis register port=Input_1
#pragma HLS INTERFACE axis register port=Input_2
#pragma HLS INTERFACE axis register port=Input_3
#pragma HLS INTERFACE axis register port=Input_4
#pragma HLS INTERFACE axis register port=Input_5
#pragma HLS INTERFACE axis register port=Input_6
#pragma HLS INTERFACE axis register port=Output_1
#pragma HLS INTERFACE axis register port=Output_2
#pragma HLS INTERFACE axis register port=Output_3
#pragma HLS INTERFACE axis register port=Output_4
#pragma HLS INTERFACE axis register port=Output_5

	static int epoch = 0;
        bit64 in_tmp;
        bit64 out_tmp;
        bit32 tmp_data;
  if(epoch < 5)
  {
	  // main loop
	  // in each epoch, go through each training instance in sequence
	  TRAINING_INST: for( int training_id = 0; training_id < NUM_TRAINING; training_id ++ )
	  {
		in_tmp = Input_1.read();
                out_tmp(7,0)=in_tmp(7,0);
		Output_1.write(out_tmp);
		// first reads in the training instance
		READ_TRAINING_DATA_1: for (int i = 0; i < NUM_FEATURES / D_VECTOR_SIZE / 8; i ++ )
		{
#pragma HLS pipeline II=2
		  out_tmp= Input_1.read();
		  Output_1.write(out_tmp);
		}
                out_tmp(7,0)=in_tmp(7,0);
		Output_2.write(out_tmp);
		READ_TRAINING_DATA_2: for (int i = 0; i < NUM_FEATURES / D_VECTOR_SIZE / 8; i ++ )
		{
#pragma HLS pipeline II=2
		  out_tmp= Input_1.read();
		  Output_2.write(out_tmp);
		}
                out_tmp(7,0)=in_tmp(7,0);
		Output_3.write(out_tmp);
		READ_TRAINING_DATA_3: for (int i = 0; i < NUM_FEATURES / D_VECTOR_SIZE / 8; i ++ )
		{
#pragma HLS pipeline II=2
		  out_tmp= Input_1.read();
		  Output_3.write(out_tmp);
		}
                out_tmp(7,0)=in_tmp(7,0);
		Output_4.write(out_tmp);
		READ_TRAINING_DATA_4: for (int i = 0; i < NUM_FEATURES / D_VECTOR_SIZE / 8; i ++ )
		{
#pragma HLS pipeline II=2
		  out_tmp= Input_1.read();
		  Output_4.write(out_tmp);
		}
	  }
	  epoch++;
  }else{

	  // STREAM_OUT_1: for (int i = 0; i < NUM_FEATURES / F_VECTOR_SIZE /8; i ++ )
	  // {
	  //   #pragma HLS pipeline II=2
		 //  tmp_data= Input_2.read();
		 //  Output_5.write(tmp_data);
		 //  tmp_data= Input_2.read();
		 //  Output_5.write(tmp_data);
	  // }
	  // STREAM_OUT_2: for (int i = 0; i < NUM_FEATURES / F_VECTOR_SIZE /8; i ++ )
	  // {
	  //   #pragma HLS pipeline II=2
		 //  tmp_data= Input_3.read();
		 //  Output_5.write(tmp_data);
		 //  tmp_data= Input_3.read();
		 //  Output_5.write(tmp_data);
	  // }
	  // STREAM_OUT_3: for (int i = 0; i < NUM_FEATURES / F_VECTOR_SIZE /8; i ++ )
	  // {
	  //   #pragma HLS pipeline II=2
		 //  tmp_data= Input_4.read();
		 //  Output_5.write(tmp_data);
		 //  tmp_data= Input_4.read();
		 //  Output_5.write(tmp_data);
	  // }
	  // STREAM_OUT_4: for (int i = 0; i < NUM_FEATURES / F_VECTOR_SIZE /8; i ++ )
	  // {
	  //   #pragma HLS pipeline II=2
		 //  tmp_data= Input_5.read();
		 //  Output_5.write(tmp_data);
		 //  tmp_data= Input_5.read();
		 //  Output_5.write(tmp_data);
	  // }
	  // epoch = 0;

	bit512 out_tmp;

	static unsigned int theta[NUM_FEATURES / F_VECTOR_SIZE * 2];

	STREAM_IN_1: for (int i = 0; i < NUM_FEATURES / F_VECTOR_SIZE; i ++ )
	{
		#pragma HLS pipeline II=1
		theta[i] = Input_6.read(); // from data_1_4_1
	}

	STREAM_IN_2: for (int i = 0; i < NUM_FEATURES / F_VECTOR_SIZE / 4; i ++ )
	{
		#pragma HLS pipeline II=1
		theta[i+NUM_FEATURES / F_VECTOR_SIZE] = Input_2.read();
	}
	STREAM_IN_3: for (int i = 0; i < NUM_FEATURES / F_VECTOR_SIZE / 4; i ++ )
	{
		#pragma HLS pipeline II=1
		theta[i+NUM_FEATURES / F_VECTOR_SIZE + (NUM_FEATURES/F_VECTOR_SIZE/4)] = Input_3.read();
	}
	STREAM_IN_4: for (int i = 0; i < NUM_FEATURES / F_VECTOR_SIZE / 4; i ++ )
	{
		#pragma HLS pipeline II=1
		theta[i+NUM_FEATURES / F_VECTOR_SIZE + 2*(NUM_FEATURES/F_VECTOR_SIZE/4)] = Input_4.read();
	}
	STREAM_IN_5: for (int i = 0; i < NUM_FEATURES / F_VECTOR_SIZE / 4; i ++ )
	{
		#pragma HLS pipeline II=1
		theta[i+NUM_FEATURES / F_VECTOR_SIZE + 3*(NUM_FEATURES/F_VECTOR_SIZE/4)] = Input_5.read();
	}


	//Output_1.write(1025);

	STREAM_OUT: for (int i = 0; i < NUM_FEATURES / F_VECTOR_SIZE*2/16; i ++ )
	{
		#pragma HLS pipeline II=1
		for(int j=0; j<16; j++){
			out_tmp(j*32+31, j*32) = theta[16*i+j];
		}
		Output_5.write(out_tmp);
	}
	epoch = 0;


  }
}
