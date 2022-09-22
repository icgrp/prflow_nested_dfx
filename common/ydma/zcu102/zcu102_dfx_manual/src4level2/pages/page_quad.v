module page_quad(
    input wire clk_0,
    input wire [48 : 0] din_leaf_bft2interface_0,
    output reg  [48 : 0] dout_leaf_interface2bft_0,
    input wire resend_0,
    input wire reset_0,
    input wire ap_start_0,

    input wire clk_1,
    input wire [48 : 0] din_leaf_bft2interface_1,
    output reg  [48 : 0] dout_leaf_interface2bft_1,
    input wire resend_1,
    input wire reset_1,
    input wire ap_start_1,

    input wire clk_2,
    input wire [48 : 0] din_leaf_bft2interface_2,
    output reg  [48 : 0] dout_leaf_interface2bft_2,
    input wire resend_2,
    input wire reset_2,
    input wire ap_start_2,

    input wire clk_3,
    input wire [48 : 0] din_leaf_bft2interface_3,
    output reg  [48 : 0] dout_leaf_interface2bft_3,
    input wire resend_3,
    input wire reset_3,
    input wire ap_start_3
    );

always@(posedge clk_0)begin
  if(reset_0) begin
    dout_leaf_interface2bft_0 <= 0;
  end else if(resend_0) begin 
    dout_leaf_interface2bft_0 <= din_leaf_bft2interface_0;
  end else begin 
    dout_leaf_interface2bft_0 <= dout_leaf_interface2bft_0;
  end
end

always@(posedge clk_1)begin
  if(reset_1) begin
    dout_leaf_interface2bft_1 <= 0;
  end else if(resend_1) begin 
    dout_leaf_interface2bft_1 <= din_leaf_bft2interface_1;
  end else begin 
    dout_leaf_interface2bft_1 <= dout_leaf_interface2bft_1;
  end
end
   
always@(posedge clk_2)begin
  if(reset_2) begin
    dout_leaf_interface2bft_2 <= 0;
  end else if(resend_2) begin 
    dout_leaf_interface2bft_2 <= din_leaf_bft2interface_2;
  end else begin 
    dout_leaf_interface2bft_2 <= dout_leaf_interface2bft_2;
  end
end

always@(posedge clk_3)begin
  if(reset_3) begin
    dout_leaf_interface2bft_3 <= 0;
  end else if(resend_3) begin 
    dout_leaf_interface2bft_3 <= din_leaf_bft2interface_3;
  end else begin 
    dout_leaf_interface2bft_3 <= dout_leaf_interface2bft_3;
  end
end

endmodule