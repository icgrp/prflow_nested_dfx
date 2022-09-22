#include "../host/typedefs.h"

void dummy(
		hls::stream<ap_uint<32> > & Input_1,
		hls::stream<ap_uint<32> > & Output_1
		)
{
#pragma HLS INTERFACE axis register port=Input_1
#pragma HLS INTERFACE axis register port=Output_1

	bit32 static temp = 42;
	Output_1.write(temp);
	// temp = Input_1.read();
	if(Input_1.read_nb(temp)){
		temp = 50;
	}
}