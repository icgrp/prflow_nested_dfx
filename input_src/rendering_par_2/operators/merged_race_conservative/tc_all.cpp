#include "../host/typedefs.h"


void tc_all (
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
// #pragma HLS INTERFACE axis register port=Input_5
#pragma HLS INTERFACE axis register port=Output_1 // winner_final

	static int counter = 0;
	bit32 input_1_tmp, input_2_tmp, input_3_tmp, input_4_tmp;
	static bit32 winner = 0;
	static bool winner_sent = false;

    static int num_tc = 2; // number of tandem consumer units
    // static int num_tc = 0; // number of tandem consumer units
    // if(num_tc == 0){
    //     num_tc = Input_5.read(); // sent from the Host
    // }

	if(Input_1.read_nb(input_1_tmp)){
		winner = input_1_tmp; // possibly overwrite winner register
		counter = counter + 1;
	}
	else if(Input_2.read_nb(input_2_tmp)){
		winner = input_2_tmp; // possibly overwrite winner register
		counter = counter + 1;
	}
	else if(Input_3.read_nb(input_3_tmp)){
		winner = input_3_tmp; // possibly overwrite winner register
		counter = counter + 1;
	}
	else if(Input_4.read_nb(input_4_tmp)){
		winner = input_4_tmp; // possibly overwrite winner register
		counter = counter + 1;
	}
  
	if((counter == num_tc) && (winner_sent == false)){
		Output_1.write(winner); // final winner is the winner
        winner_sent == true;
	}
}
