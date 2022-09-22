module page_double_subdivide_p16_p0(
    input wire clk_0,
    input wire [48 : 0] din_leaf_bft2interface_0,
    output wire  [48 : 0] dout_leaf_interface2bft_0,
    input wire resend_0,
    input wire reset_0,
    input wire ap_start_0,

    input wire clk_1,
    input wire [48 : 0] din_leaf_bft2interface_1,
    output wire  [48 : 0] dout_leaf_interface2bft_1,
    input wire resend_1,
    input wire reset_1,
    input wire ap_start_1
    );

page_bb p0(
    .clk(clk_0),
    .din_leaf_bft2interface(din_leaf_bft2interface_0),
    .dout_leaf_interface2bft(dout_leaf_interface2bft_0),
    .resend(resend_0),
    .reset(reset_0),
    .ap_start(ap_start_0)
    );
    
page_bb p1(
    .clk(clk_1),
    .din_leaf_bft2interface(din_leaf_bft2interface_1),
    .dout_leaf_interface2bft(dout_leaf_interface2bft_1),
    .resend(resend_1),
    .reset(reset_1),
    .ap_start(ap_start_1)
    );

    // dummy logic is necessary for Vivado not to be confused 
    // about parent pblock and children pblock
    (* dont_touch = "true" *) reg dummy;
    always @(posedge clk_0)
        if(reset_0) begin
            dummy <= 0;
        end
        else begin
            dummy <= 1;
        end

   
endmodule

module page_bb(
    input wire clk,
    input wire [48 : 0] din_leaf_bft2interface,
    output wire [48 : 0] dout_leaf_interface2bft,
    input wire resend,
    input wire reset,
    input wire ap_start
    );
    
endmodule
