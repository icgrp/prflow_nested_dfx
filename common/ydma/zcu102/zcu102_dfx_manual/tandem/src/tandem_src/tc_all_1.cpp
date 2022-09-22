#include "../host/typedefs.h"


void tc_all_1 (
		hls::stream<ap_uint<32> > & Input_1,
		hls::stream<ap_uint<32> > & Input_2,
		hls::stream<ap_uint<32> > & Input_3,
		hls::stream<ap_uint<32> > & Input_4,
		hls::stream<ap_uint<32> > & Output_1
		)
{
#pragma HLS INTERFACE axis register port=Input_1
#pragma HLS INTERFACE axis register port=Input_2
#pragma HLS INTERFACE axis register port=Input_3
#pragma HLS INTERFACE axis register port=Input_4
#pragma HLS INTERFACE axis register port=Output_1 // winner_final

	static int counter_1_1 = 0;
	static int counter_2_1 = 0;
	static int counter_1_2 = 0;
	static int counter_2_2 = 0;
	static int counter_1_3 = 0;
	static int counter_2_3 = 0;
	static int counter_1_4 = 0;
	static int counter_2_4 = 0;

	bit32 input_1_tmp, input_2_tmp, input_3_tmp, input_4_tmp;
	static bit32 winner = 0;
	static bool winner_sent = false;

    static int num_tc = 1; // number of tandem consumer units


	if(Input_1.read_nb(input_1_tmp)){
		if(input_1_tmp == 1){
			counter_1_1 = counter_1_1 + 1;
		}
		else{ // 2
			counter_2_1 = counter_2_1 + 1;			
		}
	}
	if(Input_2.read_nb(input_2_tmp)){
		if(input_2_tmp == 1){
			counter_1_2 = counter_1_2 + 1;
		}
		else{ // 2 
			counter_2_2 = counter_2_2 + 1;			
		}
	}
	if(Input_3.read_nb(input_3_tmp)){
		if(input_3_tmp == 1){
			counter_1_3 = counter_1_3 + 1;
		}
		else{ // 2
			counter_2_3 = counter_2_3 + 1;			
		}
	}
	if(Input_4.read_nb(input_4_tmp)){
		if(input_4_tmp == 1){
			counter_1_4 = counter_1_4 + 1;
		}
		else{ // 2
			counter_2_4 = counter_2_4 + 1;			
		}
	}
 
  	// whichever finishes first wins
    int counter_1_sum = counter_1_1 + counter_1_2 + counter_1_3 + counter_1_4;
    int counter_2_sum = counter_2_1 + counter_2_2 + counter_2_3 + counter_2_4;

  	if((counter_1_sum == num_tc || counter_2_sum == num_tc) && winner_sent == false){
  		if(counter_1_sum == num_tc){
  			Output_1.write(1);
  		}
  		else{
  			Output_1.write(2);
  		}
  		winner_sent = true;
  	}
}
