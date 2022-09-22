module page_quad_subdivide_p4(
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
    input wire ap_start_1,

    input wire clk_2,
    input wire [48 : 0] din_leaf_bft2interface_2,
    output wire  [48 : 0] dout_leaf_interface2bft_2,
    input wire resend_2,
    input wire reset_2,
    input wire ap_start_2,

    input wire clk_3,
    input wire [48 : 0] din_leaf_bft2interface_3,
    output wire  [48 : 0] dout_leaf_interface2bft_3,
    input wire resend_3,
    input wire reset_3,
    input wire ap_start_3
    );

page_double_bb p0(
    .clk_0(clk_0),
    .din_leaf_bft2interface_0(din_leaf_bft2interface_0),
    .dout_leaf_interface2bft_0(dout_leaf_interface2bft_0),
    .resend_0(resend_0),
    .reset_0(reset_0),
    .ap_start_0(ap_start_0),

    .clk_1(clk_1),
    .din_leaf_bft2interface_1(din_leaf_bft2interface_1),
    .dout_leaf_interface2bft_1(dout_leaf_interface2bft_1),
    .resend_1(resend_1),
    .reset_1(reset_1),
    .ap_start_1(ap_start_1)
    );

page_double_bb p1(
    .clk_0(clk_2),
    .din_leaf_bft2interface_0(din_leaf_bft2interface_2),
    .dout_leaf_interface2bft_0(dout_leaf_interface2bft_2),
    .resend_0(resend_2),
    .reset_0(reset_2),
    .ap_start_0(ap_start_2),

    .clk_1(clk_3),
    .din_leaf_bft2interface_1(din_leaf_bft2interface_3),
    .dout_leaf_interface2bft_1(dout_leaf_interface2bft_3),
    .resend_1(resend_3),
    .reset_1(reset_3),
    .ap_start_1(ap_start_3)
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

module page_double_bb(
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
   
endmodule
