`timescale 1 ns / 1 ps 

module t2_1 (
        ap_clk,
        ap_rst_n,
        ap_start,
        ap_done,
        ap_idle,
        ap_ready,
        Input_1_V_TDATA,
        Input_1_V_TVALID,
        Input_1_V_TREADY,
        Input_2_V_TDATA,
        Input_2_V_TVALID,
        Input_2_V_TREADY,
        Output_1_V_TDATA,
        Output_1_V_TVALID,
        Output_1_V_TREADY,
        Output_2_V_TDATA,
        Output_2_V_TVALID,
        Output_2_V_TREADY,
        Output_3_V_TDATA,
        Output_3_V_TVALID,
        Output_3_V_TREADY,
        Output_4_V_TDATA,
        Output_4_V_TVALID,
        Output_4_V_TREADY
);

input   ap_clk;
input   ap_rst_n;
input   ap_start;
output   ap_done;
output   ap_idle;
output   ap_ready;
input  [31:0] Input_1_V_TDATA;
input   Input_1_V_TVALID;
output Input_1_V_TREADY;
input  [31:0] Input_2_V_TDATA;
input   Input_2_V_TVALID;
output Input_2_V_TREADY;

output  [31:0] Output_1_V_TDATA;
output  Output_1_V_TVALID;
input   Output_1_V_TREADY;
output  [31:0] Output_2_V_TDATA;
output  Output_2_V_TVALID;
input   Output_2_V_TREADY;
output  [31:0] Output_3_V_TDATA;
output  Output_3_V_TVALID;
input   Output_3_V_TREADY;
output  [31:0] Output_4_V_TDATA;
output  Output_4_V_TVALID;
input   Output_4_V_TREADY;

assign ap_done = 0; // don't care
assign ap_idle = 0; // don't care
assign ap_ready = 0; // don't care

assign Input_1_V_TREADY = Output_1_V_TREADY;
assign Input_2_V_TREADY = Output_3_V_TREADY;

 assign Output_1_V_TDATA = Input_1_V_TDATA; 
 assign Output_2_V_TDATA = Input_1_V_TDATA; 
 assign Output_3_V_TDATA = Input_2_V_TDATA; 
 assign Output_4_V_TDATA = Input_2_V_TDATA; 

 assign Output_1_V_TVALID =  Input_1_V_TVALID;
 assign Output_2_V_TVALID =  Input_1_V_TVALID;
 assign Output_3_V_TVALID =  Input_2_V_TVALID;
 assign Output_4_V_TVALID =  Input_2_V_TVALID;

endmodule
