/**********
Copyright (c) 2018, Xilinx, Inc.
All rights reserved.
Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:
1. Redistributions of source code must retain the above copyright notice,
this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.  3. Neither the name of the copyright holder nor the names of its contributors
may be used to endorse or promote products derived from this software
without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,
EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**********/

#define CL_HPP_CL_1_2_DEFAULT_BUILD
#define CL_HPP_TARGET_OPENCL_VERSION 120
#define CL_HPP_MINIMUM_OPENCL_VERSION 120
#define CL_HPP_ENABLE_PROGRAM_CONSTRUCTION_FROM_ARRAY_COMPATIBILITY 1
#define CL_USE_DEPRECATED_OPENCL_1_2_APIS

#include <vector>
#include <unistd.h>
#include <iostream>
#include <fstream>
#include <CL/cl2.hpp>
#include "typedefs.h"
#include "input_data.h"
#include <sys/time.h>

#define CONFIG_SIZE 12
#define INPUT_SIZE (NUM_3D_TRI/4)
#define OUTPUT_SIZE (NUM_FB/16)
#define WINNER_SIZE 1
#define NUM_TIMES 100
#define SIBLING_CONFIG_SIZE 12

// Forward declaration of utility functions included at the end of this file
std::vector<cl::Device> get_xilinx_devices();
char *read_binary_file(const std::string &xclbin_file_name, unsigned &nb);
void check_results(bit512* output);

// ------------------------------------------------------------------------------------
// Main program
// ------------------------------------------------------------------------------------
int main(int argc, char **argv)
{
    //TARGET_DEVICE macro needs to be passed from gcc command line
    if (argc < 2)
    {
        std::cout << "Usage: " << argv[0] << " <xclbin>" << std::endl;
        return EXIT_FAILURE;
    }

    // Variables for time measurement
    struct timeval start, end, end_0th;
    std::vector<cl::Device> devices;
    cl::Device device;
    std::vector<cl::Platform> platforms;
    bool found_device = false;

    //traversing all Platforms To find Xilinx Platform and targeted
    //Device in Xilinx Platform
    cl::Platform::get(&platforms);
    for (size_t i = 0; (i < platforms.size()) & (found_device == false); i++)
    {
        cl::Platform platform = platforms[i];
        std::string platformName = platform.getInfo<CL_PLATFORM_NAME>();
        if (platformName == "Xilinx")
        {
            devices.clear();
            platform.getDevices(CL_DEVICE_TYPE_ACCELERATOR, &devices);
            if (devices.size())
            {
                device = devices[0];
                found_device = true;
                break;
            }
        }
    }
    if (found_device == false)
    {
        std::cout << "Error: Unable to find Target Device "
                  << device.getInfo<CL_DEVICE_NAME>() << std::endl;
        return EXIT_FAILURE;
    }

    // Creating Context and Command Queue for selected device
    cl::Context context(device);

    // Load xclbin when there are >1 xclbins to load
    for (int i = 1; i < argc-1; i++)
    {
        char *xclbinFilename = argv[i];
        std::cout << "Loading: '" << xclbinFilename << "'\n";
        std::ifstream bin_file(xclbinFilename, std::ifstream::binary);
        bin_file.seekg(0, bin_file.end);
        unsigned nb = bin_file.tellg();
        bin_file.seekg(0, bin_file.beg);
        char *buf = new char[nb];
        bin_file.read(buf, nb);

        // Creating Program from Binary File
        cl::Program::Binaries bins;
        bins.push_back({buf, nb});
        devices.resize(1);
        cl::Program program(context, devices, bins);
    }
    std::cout << "Done!" << std::endl;

    // ------------------------------------------------------------------------------------
    // Step 1: Initialize the OpenCL environment
    // ------------------------------------------------------------------------------------
    cl_int err;
    cl::Kernel krnl_ydma;
    cl::CommandQueue q;

    {
    std::string binaryFile = (argc == 1) ? "ydma.xclbin" : argv[argc-1];
    //std::string binaryFile = argv[argc-1];
    unsigned fileBufSize;
    devices.resize(1);
    //cl::Context context(device, NULL, NULL, NULL, &err);
    char *fileBuf = read_binary_file(binaryFile, fileBufSize);
    cl::Program::Binaries bins{{fileBuf, fileBufSize}};
    cl::Program program(context, devices, bins, NULL, &err);

    q = cl::CommandQueue(context, device, CL_QUEUE_PROFILING_ENABLE, &err);
    // cl::CommandQueue q(context, device, CL_QUEUE_PROFILING_ENABLE | CL_QUEUE_OUT_OF_ORDER_EXEC_MODE_ENABLE, &err);    
    krnl_ydma = cl::Kernel(program, "ydma", &err);
    delete[] fileBuf;
    }


    // ------------------------------------------------------------------------------------
    // Step 2: Create buffers and initialize test values
    // ------------------------------------------------------------------------------------
    // Create the buffers and allocate memory
    cl::Buffer in1_buf[1];
    cl::Buffer in2_buf[NUM_TIMES];
    cl::Buffer out1_buf[1];
    cl::Buffer out2_buf[NUM_TIMES];
    cl::Buffer in3_buf[1];
    cl::Buffer winner_buf[1];

    bit64 *in1[1];
    bit512 *in2[NUM_TIMES];
    bit64 *out1[1];
    bit512 *out2[NUM_TIMES];
    bit32 *in3[1]; // in3 is dummy port
    bit32 *winner[1]; // need winner only in first kernel launch

    for(int idx=0; idx < NUM_TIMES; idx++){
        in2_buf[idx] = cl::Buffer(context, CL_MEM_READ_ONLY, sizeof(bit512) * INPUT_SIZE, NULL, &err);
        out2_buf[idx] = cl::Buffer(context, CL_MEM_WRITE_ONLY, sizeof(bit512) * OUTPUT_SIZE, NULL, &err);

        // Map host-side buffer memory to user-space pointers
        in2[idx] = (bit512 *)q.enqueueMapBuffer(in2_buf[idx], CL_TRUE, CL_MAP_WRITE, 0, sizeof(bit512) * INPUT_SIZE);
        out2[idx] = (bit512 *)q.enqueueMapBuffer(out2_buf[idx], CL_TRUE, CL_MAP_WRITE | CL_MAP_READ, 0, sizeof(bit512) * OUTPUT_SIZE);
    }
    in1_buf[0] = cl::Buffer(context, CL_MEM_READ_ONLY, sizeof(bit64) * CONFIG_SIZE, NULL, &err);
    out1_buf[0] = cl::Buffer(context, CL_MEM_WRITE_ONLY, sizeof(bit64) * CONFIG_SIZE, NULL, &err);
    in3_buf[0] = cl::Buffer(context, CL_MEM_READ_ONLY, sizeof(bit32) * 1, NULL, &err);
    winner_buf[0] = cl::Buffer(context, CL_MEM_WRITE_ONLY, sizeof(bit32) * 1, NULL, &err);

    in1[0] = (bit64 *)q.enqueueMapBuffer(in1_buf[0], CL_TRUE, CL_MAP_WRITE, 0, sizeof(bit64) * CONFIG_SIZE);
    out1[0] = (bit64 *)q.enqueueMapBuffer(out1_buf[0], CL_TRUE, CL_MAP_WRITE | CL_MAP_READ, 0, sizeof(bit64) * CONFIG_SIZE);
    in3[0] = (bit32 *)q.enqueueMapBuffer(in3_buf[0], CL_TRUE, CL_MAP_WRITE, 0, sizeof(bit32) * 1);
    winner[0] = (bit32 *)q.enqueueMapBuffer(winner_buf[0], CL_TRUE, CL_MAP_WRITE | CL_MAP_READ, 0, sizeof(bit32)*1);


    // Initialize the vectors used in the test
    // pack input data for better performance

    // send BFT config size

    in1[0][1].range(63, 32) = 0x00000000;
    in1[0][1].range(31,  0) = INPUT_SIZE;
    // send input data buf size

    // configure packets

    std::cout << "setting up input data... " << std::endl;
    for(int idx=0; idx < NUM_TIMES; idx++){
        for ( int i = 0; i < NUM_3D_TRI/4; i++)
        {
            for (int j=0; j<4; j++){
              in2[idx][i](128*j+7,  128*j+0)   = triangle_3ds[4*i+j].x0;
              in2[idx][i](128*j+15, 128*j+8)   = triangle_3ds[4*i+j].y0;
              in2[idx][i](128*j+23, 128*j+16)  = triangle_3ds[4*i+j].z0;
              in2[idx][i](128*j+31, 128*j+24)  = triangle_3ds[4*i+j].x1;
              in2[idx][i](128*j+39, 128*j+32)  = triangle_3ds[4*i+j].y1;
              in2[idx][i](128*j+47, 128*j+40)  = triangle_3ds[4*i+j].z1;
              in2[idx][i](128*j+55, 128*j+48)  = triangle_3ds[4*i+j].x2;
              in2[idx][i](128*j+63, 128*j+56)  = triangle_3ds[4*i+j].y2;
              in2[idx][i](128*j+71, 128*j+64)  = triangle_3ds[4*i+j].z2;
              in2[idx][i](128*j+127,128*j+72)  = 0;
            }
        }
    }

    in3[0][0] = 77; // random value

    // ------------------------------------------------------------------------------------
    // Step 3: Run the kernel
    // ------------------------------------------------------------------------------------

    ///////////////////////
    // 1st kernel launch //
    ///////////////////////

    // Set kernel arguments
    std::cout << "0th iteration, print winner " << std::endl;
    gettimeofday(&start, NULL);
    krnl_ydma.setArg(0, in1_buf[0]);
    krnl_ydma.setArg(1, in2_buf[0]);
    krnl_ydma.setArg(2, out1_buf[0]);
    krnl_ydma.setArg(3, out2_buf[0]);
    krnl_ydma.setArg(4, CONFIG_SIZE);
    krnl_ydma.setArg(5, INPUT_SIZE);
    krnl_ydma.setArg(6, OUTPUT_SIZE);
    
    krnl_ydma.setArg(7, in3_buf[0]);
    krnl_ydma.setArg(8, winner_buf[0]);
    krnl_ydma.setArg(9, WINNER_SIZE);

    q.enqueueMigrateMemObjects({in1_buf[0], in2_buf[0], in3_buf[0]}, 0 /* 0 means from host*/);
    q.enqueueTask(krnl_ydma);
    q.enqueueMigrateMemObjects({out1_buf[0], out2_buf[0], winner_buf[0]}, CL_MIGRATE_MEM_OBJECT_HOST);
    q.finish();
    gettimeofday(&end_0th, NULL);

    ///////////////////////////
    // non-1st kernel launch //
    ///////////////////////////

    int winner_op = winner[0][0]; // winner is determined after 1st kernel launch

    if(winner_op == 1){ // current operator wins
#ifndef CHECK
        system("./compile_next.sh 1 &");
#endif
        ////////////////////////
        // 2nd~ kernel launch //
        ////////////////////////

        in1[0][0].range(63, 32) = 0x00000000;
        in1[0][0].range(31,  0) = 0x00000000;
        in1[0][1].range(63, 32) = 0x00000000;
        in1[0][1].range(31,  0) = INPUT_SIZE;
        krnl_ydma.setArg(0, in1_buf[0]); // following kernels have the same config data
        krnl_ydma.setArg(4, 2); // CONFIG_SIZE = 2
        krnl_ydma.setArg(9, 0); // WINNER_SIZE = 0

        for (int i=1; i<NUM_TIMES; i++){
            std::cout << i << "th iteration " << std::endl;
            krnl_ydma.setArg(1, in2_buf[i]); // new in_data
            krnl_ydma.setArg(3, out2_buf[i]); // new out_data

            q.enqueueMigrateMemObjects({in1_buf[0], in2_buf[i]}, 0 /* 0 means from host*/);
            q.enqueueTask(krnl_ydma);
            q.enqueueMigrateMemObjects({out1_buf[0], out2_buf[i]}, CL_MIGRATE_MEM_OBJECT_HOST);
        }
    }
    else{ // op_2 wins
#ifndef CHECK
        system("./compile_next.sh 2 &");
#endif
        ///////////////////////
        // 2nd kernel launch //
        ///////////////////////

        // sibling send BFT config size
        in1[0][1].range(63, 32) = 0x00000000;
        in1[0][1].range(31,  0) = INPUT_SIZE;
        // sibling send input data buf size

        // sibling configure packets

        krnl_ydma.setArg(0, in1_buf[0]);
        krnl_ydma.setArg(4, SIBLING_CONFIG_SIZE);
        krnl_ydma.setArg(9, 0); // WINNER_SIZE = 0
        std::cout << 1 << "st iteration " << std::endl;
        krnl_ydma.setArg(1, in2_buf[1]); // new in_data
        krnl_ydma.setArg(3, out2_buf[1]); // new out_data

        q.enqueueMigrateMemObjects({in1_buf[0], in2_buf[1]}, 0 /* 0 means from host*/);
        q.enqueueTask(krnl_ydma);
        q.enqueueMigrateMemObjects({out1_buf[0], out2_buf[1]}, CL_MIGRATE_MEM_OBJECT_HOST);

        ////////////////////////
        // 3rd~ kernel launch //
        ////////////////////////

        in1[0][0].range(63, 32) = 0x00000000;
        in1[0][0].range(31,  0) = 0x00000000;
        in1[0][1].range(63, 32) = 0x00000000;
        in1[0][1].range(31,  0) = INPUT_SIZE;
        krnl_ydma.setArg(0, in1_buf[0]); // following kernels have the same config data
        krnl_ydma.setArg(4, 2); // CONFIG_SIZE = 2
        krnl_ydma.setArg(9, 0); // WINNER_SIZE = 0
        for (int i=2; i<NUM_TIMES; i++){
            std::cout << i << "st iteration, winner: " << winner_op << std::endl;
            krnl_ydma.setArg(1, in2_buf[i]); // new in_data
            krnl_ydma.setArg(3, out2_buf[i]); // new out_data

            q.enqueueMigrateMemObjects({in1_buf[0], in2_buf[i]}, 0 /* 0 means from host*/);
            q.enqueueTask(krnl_ydma);
            q.enqueueMigrateMemObjects({out1_buf[0], out2_buf[i]}, CL_MIGRATE_MEM_OBJECT_HOST);
        }
    }
    
    // Wait for all scheduled operations to finish
    q.finish();
    gettimeofday(&end, NULL);
    std::cout << "finished " << std::endl;


    // ------------------------------------------------------------------------------------
    // Step 4: Check Results and Release Allocated Resources
    // ------------------------------------------------------------------------------------
    bool match = true;
#ifdef CHECK
    std::cout << "check 0th data" << std::endl;    
    check_results(out2[0]); // check 1st data
    std::cout << "check 1st data" << std::endl;    
    check_results(out2[1]); // check 1st data
    std::cout << "check last data" << std::endl;
    check_results(out2[NUM_TIMES-1]); // check last data
#endif
    int max_config = CONFIG_SIZE > 20 ? 20: CONFIG_SIZE;
    for(int i=0; i<max_config; i++){
        printf("%d: %08x_%08x\n", i, (unsigned int)out1[0][i].range(63, 32), (unsigned int) out1[0][i].range(31, 0));
    }
    // delete[] fileBuf;

    // print result
    std::cout << "winner_buf: " << winner_op << std::endl;
    long long elapsed_0th = (end_0th.tv_sec - start.tv_sec) * 1000000LL + end_0th.tv_usec - start.tv_usec;   
    printf("elapsed time(0th kernel): %lld us\n", elapsed_0th);
    long long elapsed = (end.tv_sec - start.tv_sec) * 1000000LL + end.tv_usec - start.tv_usec;   
    printf("elapsed time(all kernels): %lld us\n", elapsed);
#ifndef CHECK
    std::ofstream outfile;
    outfile.open("result.log", std::ios_base::app);
    outfile << "winner_buf: " << winner_op << "\n";
    outfile << "elapsed time(0th kernel): " << elapsed_0th << "us\n";
    outfile << "elapsed time(all kernels): " << elapsed << "us\n";
#endif

    std::cout << "TEST " << (match ? "PASSED" : "FAILED") << std::endl;
    return (match ? EXIT_SUCCESS : EXIT_FAILURE);
}


// ------------------------------------------------------------------------------------
// Utility functions
// ------------------------------------------------------------------------------------
std::vector<cl::Device> get_xilinx_devices()
{
    size_t i;
    cl_int err;
    std::vector<cl::Platform> platforms;
    err = cl::Platform::get(&platforms);
    cl::Platform platform;
    for (i = 0; i < platforms.size(); i++)
    {
        platform = platforms[i];
        std::string platformName = platform.getInfo<CL_PLATFORM_NAME>(&err);
        if (platformName == "Xilinx")
        {
            std::cout << "INFO: Found Xilinx Platform" << std::endl;
            break;
        }
    }
    if (i == platforms.size())
    {
        std::cout << "ERROR: Failed to find Xilinx platform" << std::endl;
        exit(EXIT_FAILURE);
    }

    //Getting ACCELERATOR Devices and selecting 1st such device
    std::vector<cl::Device> devices;
    err = platform.getDevices(CL_DEVICE_TYPE_ACCELERATOR, &devices);
    return devices;
}

char *read_binary_file(const std::string &xclbin_file_name, unsigned &nb)
{
    if (access(xclbin_file_name.c_str(), R_OK) != 0)
    {
        printf("ERROR: %s xclbin not available please build\n", xclbin_file_name.c_str());
        exit(EXIT_FAILURE);
    }
    //Loading XCL Bin into char buffer
    std::cout << "INFO: Loading '" << xclbin_file_name << "'\n";
    std::ifstream bin_file(xclbin_file_name.c_str(), std::ifstream::binary);
    bin_file.seekg(0, bin_file.end);
    nb = bin_file.tellg();
    bin_file.seekg(0, bin_file.beg);
    char *buf = new char[nb];
    bin_file.read(buf, nb);
    return buf;
}

void check_results(bit512* output)
{
    bit8 frame_buffer_print[MAX_X][MAX_Y];

    // read result from the 32-bit output buffer
    for (int i=0; i<NUM_FB/16; i++){
      for(int j=0; j<64; j++){
        int n=i*64+j;
        int row = n/256;
        int col = n%256;
        frame_buffer_print[row][col] = output[i](8*j+7, 8*j);
      }
    }

  // print result
  {
    for (int j = MAX_X - 1; j >= 0; j -- )
    {
      for (int i = 0; i < MAX_Y; i ++ )
      {
        int pix;
        pix = frame_buffer_print[i][j].to_int();
        if (pix){
          std::cout << "1";
        }else{
          std::cout << "0";
        }
      }
      std::cout << std::endl;
    }
  }

}
