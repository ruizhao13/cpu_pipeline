`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2018 09:40:40 AM
// Design Name: 
// Module Name: control
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


module control(
    input [5:0]Op,
    input [4:0]Funct,
    output reg RegWriteD,
    output reg MemtoRegD,
    output reg MemWriteD,
    output reg [5:0] ALUControlD,
    output reg RegDstD,
    output reg BranchD
    );
endmodule
