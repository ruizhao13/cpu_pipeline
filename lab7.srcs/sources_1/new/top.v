`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2018 09:36:51 AM
// Design Name: 
// Module Name: top
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


module top(
    input clk,
    input rst_n
    );
    
    Inst_mem u_ins_mem (
      .a(PC[5:0]),      // input wire [5 : 0] a
      //.d(d),      // input wire [31 : 0] d
      //.clk(clk),  // input wire clk
      //.we(),    // input wire we
      .spo(instr)  // output wire [31 : 0] spo
    );

    data_mem u_data_mem (
      .a(ALU_result),        // input wire [7 : 0] a
      .d(read_data2),        // input wire [31 : 0] d
      .dpra(ALU_result),  // input wire [7 : 0] dpra
      .clk(clk),    // input wire clk
      .we(MemWrite),      // input wire we
      .dpo(mem_read_data)    // output wire [31 : 0] dpo
    );

    
    
    
    
    
    
    
    
    
    
    
    
    
    
endmodule
