`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2018 09:40:05 AM
// Design Name: 
// Module Name: REG_FILE
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


module REG_FILE(
    input clk,
    input rst_n,
    input [4:0] A1,
    input [4:0] A2,
    output [31:0] RD1,    
    output [31:0] RD2,
    input [4:0] A3,
    input [31:0] WD3,
    input  WE3
    );
    reg [31:0] regfile[0:31];
    
    assign RD1 = regfile[A1];
    assign RD2 = regfile[A2];

    integer i;
    always @(posedge clk)begin
      
      if ( ~rst_n ) begin
        regfile[0] <= 0;
        regfile[1] <= 0;
        for (i = 2; i < 32; i = i + 1 ) begin
          regfile[i] <= 0;
        end
      end else begin
        if (WE3) begin
          regfile[A3] <= WD3;
        end
      end
    end
endmodule

