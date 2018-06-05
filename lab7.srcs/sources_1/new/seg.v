`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/06/2018 12:31:57 AM
// Design Name: 
// Module Name: seg
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


module seg(
    input clk,
    input rst_n,
    input [15:0] value,
    output reg [1:0] an,
    output [7:0] seg
    );
wire [7:0] data [3:0];
decoder decoder1(value[3:0], data[0]);
decoder decoder2(value[7:4], data[1]); 
decoder decoder3(value[11:8], data[2]); 
decoder decoder4(value[15:12], data[3]);

reg [31:0] cnt; 
localparam period = 50_000_000 / 1000;

always @(posedge clk) begin
  if (~rst_n) begin
    cnt <= 0;
    an <= 0;
  end else begin
    if (cnt == period) begin
      cnt<= 0;
      an <= an + 1;
    end else begin
      cnt <= cnt + 1;
    end
  end
end

assign seg = data[an];


endmodule


module decoder(
    input       [3:0] num, 
    output reg  [7:0] data
);

always @ (*)
begin
  case (num)
    4'h0: data <= 8'b1100_0000;
    4'h1: data <= 8'b1111_1001;
    4'h2: data <= 8'b1010_0100;
    4'h3: data <= 8'b1011_0000;
    4'h4: data <= 8'b1001_1001;
    4'h5: data <= 8'b1001_0010;
    4'h6: data <= 8'b1000_0010;
    4'h7: data <= 8'b1111_1000;
    4'h8: data <= 8'b1000_0000;
    4'h9: data <= 8'b1001_0000;
    4'ha: data <= 8'b1000_1000;
    4'hb: data <= 8'b1000_0011;
    4'hc: data <= 8'b1100_0110;
    4'hd: data <= 8'b1010_0001;
    4'he: data <= 8'b1000_0110;
    4'hf: data <= 8'b1000_1110;
    default:  data <= 8'b11111111;
  endcase
end

endmodule    