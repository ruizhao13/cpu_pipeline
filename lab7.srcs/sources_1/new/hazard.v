`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2018 09:41:26 AM
// Design Name: 
// Module Name: hazard
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


module hazard(
    input [4:0] WriteRegM,
    input [4:0] WriteRegW,
    input MemtoRegE,
    input RegWriteM,
    input RegWriteW,
    input [4:0] RsE,
    input [4:0] RtE,
    input [4:0] RsD,
    input [4:0] RtD,
    output reg [2:0] ForwardAE,
    output reg [2:0] ForwardBE,
    output StallF,
    output StallD,
    output FlushE
    );
    always @(*)
    begin
      if ((RsE != 0) & (RsE == WriteRegM) & RegWriteM) begin
        ForwardAE = 10;
      end else if ((RsE != 0) & (RsE == WriteRegW) & RegWriteW) begin
        ForwardAE = 01;
      end else begin
        ForwardAE = 00;
      end
    end
    always @(*)
    begin
      if ((RtE != 0) & (RtE == WriteRegM) & RegWriteM) begin
        ForwardBE = 10;
      end else if ((RtE != 0) & (RtE == WriteRegW) & RegWriteW) begin
        ForwardBE = 01;
      end else begin
        ForwardBE = 00;
      end
    end
    wire lwstall;
    assign lwstall = ((RsD == RtE) | (RtD == RtE)) & MemtoRegE;
    assign StallF = lwstall;
    assign StallD = lwstall;
    assign FlushE = lwstall;




endmodule
