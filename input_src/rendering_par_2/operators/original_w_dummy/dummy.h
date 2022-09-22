#include "../host/typedefs.h"

void dummy(
		hls::stream<ap_uint<32> > & Input_1,
		hls::stream<ap_uint<32> > & Output_1
		);
#pragma map_target = HW