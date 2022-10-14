void outer_product(
    hls::stream<ap_uint<32>> &Input_1,
    hls::stream<ap_uint<32>> &Input_2,
    hls::stream<ap_uint<32>> &Input_3,
    hls::stream< ap_uint<192> > &Output_1);
#pragma map_target=HW