#include "../host/typedefs.h"

#define COUNTER 2*10

// void tandem_consumer (
// 		hls::stream<ap_uint<32> > & Input_1,
// 		hls::stream<ap_uint<32> > & Input_2,
// 		hls::stream<ap_uint<32> > & Input_3,
// 		hls::stream<ap_uint<32> > & Input_4,

// 		hls::stream<ap_uint<32> > & Input_5,
// 		hls::stream<ap_uint<32> > & Input_6,
// 		hls::stream<ap_uint<32> > & Input_7,
// 		hls::stream<ap_uint<32> > & Input_8,

// 		hls::stream<ap_uint<32> > & Output_1,
// 		hls::stream<ap_uint<32> > & Output_2,
// 		hls::stream<ap_uint<32> > & Output_3,
// 		hls::stream<ap_uint<32> > & Output_4,

// 		hls::stream<ap_uint<32> > & Output_5
// 		)
// {
// #pragma HLS INTERFACE axis register port=Input_1
// #pragma HLS INTERFACE axis register port=Input_2
// #pragma HLS INTERFACE axis register port=Input_3
// #pragma HLS INTERFACE axis register port=Input_4
// #pragma HLS INTERFACE axis register port=Input_5
// #pragma HLS INTERFACE axis register port=Input_6
// #pragma HLS INTERFACE axis register port=Input_7
// #pragma HLS INTERFACE axis register port=Input_8
// #pragma HLS INTERFACE axis register port=Output_1
// #pragma HLS INTERFACE axis register port=Output_2
// #pragma HLS INTERFACE axis register port=Output_3
// #pragma HLS INTERFACE axis register port=Output_4
// #pragma HLS INTERFACE axis register port=Output_5

// 	bit32 input_1_tmp, input_2_tmp, input_3_tmp, input_4_tmp;
// 	bit32 input_5_tmp, input_6_tmp, input_7_tmp, input_8_tmp;

// 	static int counter_0 = 0;
// 	static int counter_1 = 0;

//     printf("counter_0,%d\n", counter_0);

// 	// read 4 times, and write 4 times for rasterization2_m
// 	if(Input_1.read_nb(input_1_tmp)){
// 		counter_0 = counter_0 + 1;
// 	    printf("Input_1 read, %d\n", counter_0);
// 		Output_1.write(input_1_tmp);
// 	}
// 	// if(Input_1.read_nb(input_1_tmp)){
// 	// 	counter_0 = counter_0 + 1;
// 	//     printf("Input_1 read, %d\n", counter_0);
// 	// 	Output_1.write(input_1_tmp); 
// 	// }


// 	if(Input_2.read_nb(input_2_tmp)){
// 		counter_0 = counter_0 + 1;
// 	    printf("Input_2 read, %d\n", counter_0);
// 		Output_2.write(input_2_tmp); 
// 	}
// 	if(Input_2.read_nb(input_2_tmp)){
// 		counter_0 = counter_0 + 1;
// 	    printf("Input_2 read, %d\n", counter_0);
// 		Output_2.write(input_2_tmp); 
// 	}


// 	if(Input_3.read_nb(input_3_tmp)){
// 		counter_0 = counter_0 + 1;
// 	    printf("Input_3 read, %d\n", counter_0);
// 		Output_3.write(input_3_tmp); 
// 	}
// 	// if(Input_3.read_nb(input_3_tmp)){
// 	// 	counter_0 = counter_0 + 1;
// 	//     printf("Input_3 read, %d\n", counter_0);
// 	// 	Output_3.write(input_3_tmp); 
// 	// }


// 	if(Input_4.read_nb(input_4_tmp)){
// 		counter_0 = counter_0 + 1;
// 	    printf("Input_4 read, %d\n", counter_0);
// 		Output_4.write(input_4_tmp); 
// 	}
// 	if(Input_4.read_nb(input_4_tmp)){
// 		counter_0 = counter_0 + 1;
// 	    printf("Input_4 read, %d\n", counter_0);
// 		Output_4.write(input_4_tmp); 
// 	}

//     printf("counter_0,%d\n", counter_0);
// 	// read 4 times, and write 4 times for rasterization2_m_1
// 	if(Input_5.read_nb(input_5_tmp)){
// 		counter_1 = counter_1 + 1;
// 		// Output_5.write(input_5_tmp);
// 	}
// 	if(Input_5.read_nb(input_5_tmp)){
// 		counter_1 = counter_1 + 1;
// 		// Output_5.write(input_5_tmp);
// 	}


// 	if(Input_6.read_nb(input_6_tmp)){
// 		counter_1 = counter_1 + 1;
// 		// Output_6.write(input_6_tmp); 
// 	}
// 	if(Input_6.read_nb(input_6_tmp)){
// 		counter_1 = counter_1 + 1;
// 		// Output_6.write(input_6_tmp); 
// 	}


// 	if(Input_7.read_nb(input_7_tmp)){
// 		counter_1 = counter_1 + 1;
// 		// Output_7.write(input_7_tmp); 
// 	}
// 	if(Input_7.read_nb(input_7_tmp)){
// 		counter_1 = counter_1 + 1;
// 		// Output_7.write(input_7_tmp); 
// 	}

// 	if(Input_8.read_nb(input_8_tmp)){
// 		counter_1 = counter_1 + 1;
// 		// Output_8.write(input_8_tmp); 
// 	}
// 	if(Input_8.read_nb(input_8_tmp)){
// 		counter_1 = counter_1 + 1;
// 		// Output_8.write(input_8_tmp); 
// 	}



// 	if(counter_0 == COUNTER || counter_1 == COUNTER){ // evaluation finished
// 		if(counter_0 == COUNTER){
// 			Output_5.write(1);
// 		}
// 		else{
// 			Output_5.write(2);
// 		}
// 	}

// }



void tandem_consumer (
		hls::stream<ap_uint<32> > & Input_1,
		hls::stream<ap_uint<32> > & Input_2,
		hls::stream<ap_uint<32> > & Input_3,
		hls::stream<ap_uint<32> > & Input_4,

		hls::stream<ap_uint<32> > & Input_5,
		hls::stream<ap_uint<32> > & Input_6,
		hls::stream<ap_uint<32> > & Input_7,
		hls::stream<ap_uint<32> > & Input_8,

		hls::stream<ap_uint<32> > & Output_1,
		hls::stream<ap_uint<32> > & Output_2,
		hls::stream<ap_uint<32> > & Output_3,
		hls::stream<ap_uint<32> > & Output_4,

		hls::stream<ap_uint<32> > & Output_5
		)
{
#pragma HLS INTERFACE axis register port=Input_1
#pragma HLS INTERFACE axis register port=Input_2
#pragma HLS INTERFACE axis register port=Input_3
#pragma HLS INTERFACE axis register port=Input_4
#pragma HLS INTERFACE axis register port=Input_5
#pragma HLS INTERFACE axis register port=Input_6
#pragma HLS INTERFACE axis register port=Input_7
#pragma HLS INTERFACE axis register port=Input_8
#pragma HLS INTERFACE axis register port=Output_1
#pragma HLS INTERFACE axis register port=Output_2
#pragma HLS INTERFACE axis register port=Output_3
#pragma HLS INTERFACE axis register port=Output_4
#pragma HLS INTERFACE axis register port=Output_5

	bit32 input_1_tmp, input_2_tmp, input_3_tmp, input_4_tmp;
	bit32 input_5_tmp, input_6_tmp, input_7_tmp, input_8_tmp;

	static int counter_0 = 0;
	static int counter_1 = 0;


	// read 4 times, and write 4 times for rasterization2_m
	if(Input_1.read_nb(input_1_tmp)){
		counter_0 = counter_0 + 1;
		Output_1.write(input_1_tmp);
	}
	if(Input_2.read_nb(input_2_tmp)){
		counter_0 = counter_0 + 1;
		Output_2.write(input_2_tmp); 
	}
	if(Input_3.read_nb(input_3_tmp)){
		counter_0 = counter_0 + 1;
		Output_3.write(input_3_tmp); 
	}
	if(Input_4.read_nb(input_4_tmp)){
		counter_0 = counter_0 + 1;
		Output_4.write(input_4_tmp); 
	}

	if(Input_5.read_nb(input_5_tmp)){
		counter_1 = counter_1 + 1;
	}
	if(Input_6.read_nb(input_6_tmp)){
		counter_1 = counter_1 + 1;
	}
	if(Input_7.read_nb(input_7_tmp)){
		counter_1 = counter_1 + 1;
	}
	if(Input_8.read_nb(input_8_tmp)){
		counter_1 = counter_1 + 1;
	}


	if(counter_0 == COUNTER || counter_1 == COUNTER){ // evaluation finished
		if(counter_0 == COUNTER){
			Output_5.write(1);
		}
		else{
			Output_5.write(2);
		}
	}

}
