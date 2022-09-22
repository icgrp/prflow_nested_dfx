void update_knn17(hls::stream<ap_uint<32> > & Input_1, hls::stream<ap_uint<32> > & Output_1);
#pragma map_target = HW page_num = 18 inst_mem_size = 65526
#pragma HLS_PR=1 clb =2 ff = 1 bram =1.1 dsp =1.2
#pragma Output_1_depth = 8

