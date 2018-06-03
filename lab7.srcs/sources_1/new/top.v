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
    wire StallF, StallD, ForwardAD, ForwardBD;
    wire [1:0] ForwardAE, ForwardBE;


    /* Fetch section */
    wire [31:0] PC, PCPlus4F;
    reg [31:0] PCF;
    /* Decode segment */
    reg RegWriteE,RegWriteM,RegWriteW;
    reg MemtoRegE,MemtoRegM,MemtoRegW;
    reg MemWriteE,MemWriteM;
    reg [2:0]ALUControlE;
    reg ALUSrcE;
    reg RegDstE;
   
    wire RegWriteD;
    wire MemtoRegD;
    wire MemWriteD;
    wire [2:0]ALUControlD;
    wire ALUSrcD;
    wire RegDstD;
    wire BranchD;
    /* Excute segment */

    /* Memory segment */
    reg [31:0] ALUOutM, WriteDataM;

    /* Write back segment */
    reg[31:0] ReadDataW, ALUOutW;
    reg [4:0] WriteRegW;
    wire[31:0]ResultW;



    /* Fetch section */
    assign PC = PCSrcD ? PCBranchD : PCPlus4F;
    always @(posedge clk)
    begin
      if (~StallF) begin
        PCF <= PC;
      end
    end
    assign PCPlus4F = PCF + 4;


    Inst_mem u_ins_mem (
      .a(PCF[5:0]),      // input wire [5 : 0] a
      //.d(d),      // input wire [31 : 0] d
      //.clk(clk),  // input wire clk
      //.we(),    // input wire we
      .spo(InstrF)  // output wire [31 : 0] spo
    );


    /* Decode segment */
    
    

    control u_control(
    .Op(InstrD[31:26]),
    .Funct(InstrD[5:0]),
    .RegWriteD(RegWriteD),
    .MemtoRegD(MemtoRegD),
    .MemWriteD(MemWriteD),
    .ALUControlD(ALUControlD),
    .ALUSrcD(ALUSrcD),
    .RegDstD(RegDstD),
    .BranchD(BranchD)
    );
    
    wire EqualD;
    wire PCSrcD;
    wire [31:0] reg_rd1D, reg_rd2D;
    assign PCSrcD = BranchD & EqualD;
    wire [31:0] EqualD_a, EqualD_b;
    assign EqualD_a = ForwardAD ? ALUOutM : reg_rd1D;
    assign EqualD_b = ForwardBD ? ALUOutM : reg_rd2D;
    assign EqualD = (EqualD_a == EqualD_b) ? 1 : 0;
    reg [31:0] InstrD;
    reg [31:0] PCPlus4D;

    REG_FILE u_REG_FILE(
    .clk(clk),
    .rst_n(rst_n),
    .A1(InstrD[25:21]),
    .A2(InstrD[20:16]),
    .RD1(reg_rd1D),    
    .RD2(reg_rd2D),
    .A3(WriteRegW),
    .WD3(ResultW),
    .WE3(RegWriteW)
    );

    wire[4:0]RsD, RtD, RdD;
    wire[31:0] SignImmD;

    

    assign RsD = InstrD[25:21];
    assign RtD = InstrD[20:16];
    assign RdD = InstrD[15:11];

    assign SignImmD = {{16{InstrD[15]}}, InstrD[15:0]};
    always@(posedge clk)
    begin
      PCPlus4D <= PCPlus4F;
      InstrD <= InstrF;
    end

    wire [31:0]PCBranchD;
    assign PCBranchD = SignImmD<<2 + PCPlus4D;

    /* Excute segment */

    reg [31:0] reg_rd1E, reg_rd2E;
    reg [31:0] SignImmE;
    reg [4:0]RsE,RtE,RdE;
    always @(posedge clk)
    begin
      RegDstE <= RegDstD;
      MemtoRegE <= MemtoRegD;
      MemWriteE <= MemWriteD;
      ALUControlE <= ALUControlD;
      ALUSrcE <= ALUSrcD;
      RegDstE <= RegDstD;

      reg_rd1E <= reg_rd1D;
      reg_rd2E <= reg_rd2E;

      RsE <= RsD;
      RtE <= RtD;
      RdE <= RdD;

      SignImmE <= SignImmD;
    end
    wire [4:0] WriteRegE;
    wire [31:0] WriteDataE;
    assign WriteRegE = RegDstE ? RdE : RtE;
    assign SrcAE = ForwardAE[1]?ALUOutM:(ForwardAE[0]?ResultW:reg_rd1E);
    assign WriteDataE = ForwardBE[1]?ALUOutM:(ForwardBE[0]?ResultW:reg_rd2E);
    assign SrcBE = ALUSrcE ? SignImmE : WriteDataE;
    wire ALUOutE;
    ALU u_ALU(
      .alu_a(SrcAE),
      .alu_b(SrcBE),
      .alu_op(ALUControlE),
      .alu_out(ALUOutE)
      //.Zero()
    );
    /* Memory segment */
    wire[31:0] ReadDataM;
    data_mem u_data_mem (
      .a(ALUOutM),        // input wire [7 : 0] a
      .d(WriteDataM),        // input wire [31 : 0] d
      .dpra(ALUOutM),  // input wire [7 : 0] dpra
      .clk(clk),    // input wire clk
      .we(MemWriteM),      // input wire we
      .dpo(ReadDataM)    // output wire [31 : 0] dpo
    );
    reg[31:0] WriteRegM;
    wire [31:0] data_mem_out;
    always@(posedge clk)
    begin
      RegWriteM <= RegWriteE;
      MemtoRegM <= MemtoRegE;
      MemWriteM <= MemWriteE;
      ALUOutM <= ALUOutE;
      WriteDataM <= WriteDataE;
      WriteRegM <= WriteRegE;
    end
    /* Write back segment */

    
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
