`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/01/2020 05:11:01 PM
// Design Name: 
// Module Name: dual_ram
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module single_ram#(
    parameter PAYLOAD_BITS = 32, 
    parameter NUM_BRAM_ADDR_BITS = 7,
    parameter NUM_ADDR_BITS = 7,
    parameter RAM_TYPE = "block",
    localparam BRAM_DEPTH = 2**(NUM_BRAM_ADDR_BITS)
    //localparam BRAM_DEPTH = 128
    )(
    input clk,
    input reset,
    input wea,
    input web,
    input [NUM_ADDR_BITS-1:0] addra,
    input [NUM_ADDR_BITS-1:0] addrb,
    input [PAYLOAD_BITS:0] dina,
    input [PAYLOAD_BITS:0] dinb,
    output [PAYLOAD_BITS:0] doutb
    );

reg valid;  



(* ram_style = "distributed" *) reg vld_mem[0:BRAM_DEPTH-1];
initial begin
    $readmemh("./vld_mem_data.dat", vld_mem);
end



always@(posedge clk) begin
    if(reset) begin
        valid <= 0;
    end else begin
        valid <= vld_mem[addrb];
    end
end

always@(posedge clk) begin
    // In sibling rivalry setup(operator A vs operator A_1), A_1's vld_mem is not properly flushed.
    // If A_1 is faster than A, the system will relink to A_1, and vld_mem has to be flushed to work fine.
    // reset is connected to rising edge of ap_start
    if(reset) begin
        vld_mem[0] <= 0;
        vld_mem[1] <= 0;
        vld_mem[2] <= 0;
        vld_mem[3] <= 0;
        vld_mem[4] <= 0;
        vld_mem[5] <= 0;
        vld_mem[6] <= 0;
        vld_mem[7] <= 0;
        vld_mem[8] <= 0;
        vld_mem[9] <= 0;
        vld_mem[10] <= 0;
        vld_mem[11] <= 0;
        vld_mem[12] <= 0;
        vld_mem[13] <= 0;
        vld_mem[14] <= 0;
        vld_mem[15] <= 0;
        vld_mem[16] <= 0;
        vld_mem[17] <= 0;
        vld_mem[18] <= 0;
        vld_mem[19] <= 0;
        vld_mem[20] <= 0;
        vld_mem[21] <= 0;
        vld_mem[22] <= 0;
        vld_mem[23] <= 0;
        vld_mem[24] <= 0;
        vld_mem[25] <= 0;
        vld_mem[26] <= 0;
        vld_mem[27] <= 0;
        vld_mem[28] <= 0;
        vld_mem[29] <= 0;
        vld_mem[30] <= 0;
        vld_mem[31] <= 0;
        vld_mem[32] <= 0;
        vld_mem[33] <= 0;
        vld_mem[34] <= 0;
        vld_mem[35] <= 0;
        vld_mem[36] <= 0;
        vld_mem[37] <= 0;
        vld_mem[38] <= 0;
        vld_mem[39] <= 0;
        vld_mem[40] <= 0;
        vld_mem[41] <= 0;
        vld_mem[42] <= 0;
        vld_mem[43] <= 0;
        vld_mem[44] <= 0;
        vld_mem[45] <= 0;
        vld_mem[46] <= 0;
        vld_mem[47] <= 0;
        vld_mem[48] <= 0;
        vld_mem[49] <= 0;
        vld_mem[50] <= 0;
        vld_mem[51] <= 0;
        vld_mem[52] <= 0;
        vld_mem[53] <= 0;
        vld_mem[54] <= 0;
        vld_mem[55] <= 0;
        vld_mem[56] <= 0;
        vld_mem[57] <= 0;
        vld_mem[58] <= 0;
        vld_mem[59] <= 0;
        vld_mem[60] <= 0;
        vld_mem[61] <= 0;
        vld_mem[62] <= 0;
        vld_mem[63] <= 0;
    end
    else begin
        if(wea && web) begin
            if(addra == addrb) begin
                vld_mem[addra] = dina[PAYLOAD_BITS];
            end else begin 
                vld_mem[addra] = dina[PAYLOAD_BITS];
                vld_mem[addrb] = dinb[PAYLOAD_BITS];
            end    
        end else if(wea) begin
            vld_mem[addra] = dina[PAYLOAD_BITS];
        end else if(web) begin
            vld_mem[addrb] = dinb[PAYLOAD_BITS];
        end else begin
            vld_mem[addra] = vld_mem[addra];
        end
    end
end

assign doutb[PAYLOAD_BITS] = valid;

ram0 #(
    .DWIDTH(PAYLOAD_BITS),
    .AWIDTH(NUM_ADDR_BITS),
    .RAM_TYPE(RAM_TYPE)
    )dat_mem(                                                         
    .wrclk(clk),                                                  
    .di(dina[PAYLOAD_BITS-1:0]),                                                      
    .wren(wea),                                                  
    .wraddr(addra),                                                                                                
    .rdclk(clk),
    .rden(1'b1),                                                  
    .rdaddr(addrb),                                              
    .do(doutb[PAYLOAD_BITS-1:0])
);             



endmodule
