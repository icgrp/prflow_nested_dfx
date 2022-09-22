module leaf_quad_3(
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

    leaf_single_bb leaf_single_inst_0(
        .clk(clk_0),
        .din_leaf_bft2interface(din_leaf_bft2interface_0),
        .dout_leaf_interface2bft(dout_leaf_interface2bft_0),
        .resend(resend_0),
        .reset(reset_0),
        .ap_start(ap_start_0)
    );

    leaf_single_bb leaf_single_inst_1(
        .clk(clk_1),
        .din_leaf_bft2interface(din_leaf_bft2interface_1),
        .dout_leaf_interface2bft(dout_leaf_interface2bft_1),
        .resend(resend_1),
        .reset(reset_1),
        .ap_start(ap_start_1)
    );

    leaf_single_bb leaf_single_inst_2(
        .clk(clk_2),
        .din_leaf_bft2interface(din_leaf_bft2interface_2),
        .dout_leaf_interface2bft(dout_leaf_interface2bft_2),
        .resend(resend_2),
        .reset(reset_2),
        .ap_start(ap_start_2)
    );

endmodule

module leaf_single_bb(
    input wire clk,
    input wire [49-1 : 0] din_leaf_bft2interface,
    output wire [49-1 : 0] dout_leaf_interface2bft,
    input wire resend,
    input wire reset,
    input wire ap_start
    );
endmodule