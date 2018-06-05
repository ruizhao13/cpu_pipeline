`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/04/2018 06:46:04 PM
// Design Name: 
// Module Name: test
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


module test();
    reg clk;
    reg rst_n;
    reg [7:0] borad_read_addr;
    wire [1:0] an;
    wire [7:0]seg;
    top test(.clk(clk), .rst_n(rst_n),.borad_read_addr(borad_read_addr),.an(an),.seg(seg));
    always #10
     clk = ~clk;
    
    initial begin
      clk = 0;
      rst_n = 0;
      borad_read_addr = 8'b0000_1000;
      #100;
      rst_n = 1;
      borad_read_addr = 8'b0000_0111;
      
      
    end

endmodule
