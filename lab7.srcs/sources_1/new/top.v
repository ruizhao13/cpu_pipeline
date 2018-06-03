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
      .spo(InstrF)  // output wire [31 : 0] spo
    );


    /* Decode segment */
    reg [31:0] InstrD;
    reg [31:0] PCPlus4D;

    REG_FILE u_REG_FILE(
    .clk(clk),
    .rst_n(rst_n),
    .A1(InstrD[25:21]),
    .A2(InstrD[20:16]),
    .RD1(reg_rd1),    
    .RD2(reg_rd2),
    .A3(WriteRegW),
    .WD3(ResultW),
    .WE3(RegWriteW)
    );

    wire[4:0]RsD, RtD, RdE;
    wire[31:0] SignImmD;

    

    assign RsD = InstrD[25:21];
    assign RtD = InstrD[20:16];
    assign RdE = InstrD[15:11];

    assign SignImmD = {{16{InstrD[15]}}, InstrD[15:0]};
    always@(posedge clk)
    begin
      PCPlus4D <= PCPlus4F;
      InstrD <= InstrF;
    end






    data_mem u_data_mem (
      .a(ALU_result),        // input wire [7 : 0] a
      .d(read_data2),        // input wire [31 : 0] d
      .dpra(ALU_result),  // input wire [7 : 0] dpra
      .clk(clk),    // input wire clk
      .we(MemWriteM),      // input wire we
      .dpo(data_mem_out)    // output wire [31 : 0] dpo
    );
    wire [31:0] data_mem_out;


    /* Write back segment */
    reg[31:0] ReadDataW, ALUOutW;
    reg RegWriteW, MemtoRegW;
    reg [4:0] WriteRegW;
    wire[31:0]ResultW;
    
    /**/
    always@(posedge clk)
    begin
      ReadDataW <= data_mem_out;
      RegWriteW <= RegWriteM;
      MemtoRegW <= MemtoRegM;
      ALUOutW <= ALUOutM;
      WriteRegW <= WriteRegM;
    end
    assign ResultW = MemtoRegW ? ReadDataW : ALUOutM;


    
    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
endmodule
