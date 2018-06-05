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
    wire FlushE;
    wire JumpD;

    /* Fetch section */
    wire [31:0] PC_NEW, PCPlus4F;
    reg [31:0] PCF;
    /* Decode segment */
    reg RegWriteE,RegWriteM,RegWriteW;
    reg MemtoRegE,MemtoRegM,MemtoRegW;
    reg MemWriteE,MemWriteM;
    reg [5:0]ALUControlE;
    reg ALUSrcE;
    reg RegDstE;
   
    wire RegWriteD;
    wire MemtoRegD;
    wire MemWriteD;
    wire [5:0]ALUControlD;
    wire ALUSrcD;
    wire RegDstD;
    wire [2:0] BranchD;
    /* Excute segment */

    /* Memory segment */
    reg [31:0] ALUOutM, WriteDataM;

    /* Write back segment */
    reg[31:0] ReadDataW, ALUOutW;
    reg [4:0] WriteRegW;
    wire[31:0]ResultW;



    /* Fetch section */
    reg [31:0] InstrD;
    wire [31:0] InstrF;
    wire EqualD;
    reg PCSrcD;
    wire [31:0]PCBranchD;    
    wire [31:0] reg_rd1D, reg_rd2D;
    assign PC_NEW = JumpD ? {PCPlus4F[31:28], InstrD[25:0], 2'b00} :(PCSrcD ? PCBranchD : PCPlus4F);
    always @(posedge clk, negedge rst_n)
    begin
      if (~rst_n) begin
        PCF = 0;
      end else if (~StallF) begin
        PCF <= PC_NEW;
      end else begin
        PCF <= PCF;
      end
    end
    assign PCPlus4F = PCF + 4;


    Inst_mem u_ins_mem (
      .a(PCF[7:2]),      // input wire [5 : 0] a
      //.d(d),      // input wire [31 : 0] d
      .clk(clk),  // input wire clk
      //.we(),    // input wire we
      .spo(InstrF)  // output wire [31 : 0] spo
    );


    /* Decode segment */
    
    

    control u_control(
    .Op(InstrD[31:26]),
    .Funct(InstrD[5:0]),
    .RegWrite(RegWriteD),
    .MemtoReg(MemtoRegD),
    .MemWrite(MemWriteD),
    .ALUControl(ALUControlD),
    .ALUSrc(ALUSrcD),
    .RegDst(RegDstD),
    .Branch(BranchD),
    .Jump(JumpD)
    );
    
    wire [31:0] EqualD_a, EqualD_b;

    
    always @(*)
    begin
      if (BranchD == 3'b000) begin
        PCSrcD = 0;
      end else if (BranchD == 3'b001) begin
        PCSrcD = EqualD;
      end else if (BranchD == 3'b010) begin
        PCSrcD = (EqualD_a > 0) ? 1 : 0;
      end else if (BranchD == 3'b111) begin
        //jump
        PCSrcD = 1;
      end begin
        
      end
    end
    assign EqualD_a = ForwardAD ? ALUOutM : reg_rd1D;
    assign EqualD_b = ForwardBD ? ALUOutM : reg_rd2D;
    assign EqualD = (EqualD_a == EqualD_b) ? 1 : 0;
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
    
    always @(posedge clk, negedge rst_n)begin
      if(~rst_n)begin
        InstrD <= 0;
      end else begin
        if(~StallF)begin
          if(PCSrcD  | JumpD)begin
            PCPlus4D <= 0;
            InstrD <= 0;
          end else begin
            PCPlus4D <= PCPlus4F;
            InstrD <= InstrF;
          end
        end else begin
          PCPlus4D <= PCPlus4D;
          InstrD <= InstrD;
        end
      end
    end
    assign PCBranchD = (SignImmD<<2) + PCPlus4D;

    /* Excute segment */

    reg [31:0] reg_rd1E, reg_rd2E;
    reg [31:0] SignImmE;
    reg [4:0]RsE,RtE,RdE;
    always @(posedge clk)
    begin
      if (FlushE) begin
        RegWriteE <= 0;
        MemWriteE <= 0;
        RsE <= 0;
        RtE <= 0;
        RdE <= 0;
      end else begin
        RegWriteE <= RegWriteD;
        MemtoRegE <= MemtoRegD;
        MemWriteE <= MemWriteD;
        ALUControlE <= ALUControlD;
        ALUSrcE <= ALUSrcD;
        RegDstE <= RegDstD;

        reg_rd1E <= reg_rd1D;
        reg_rd2E <= reg_rd2D;

        RsE <= RsD;
        RtE <= RtD;
        RdE <= RdD;

        SignImmE <= SignImmD;
      end
    end
    begin
      
    end
    wire [4:0] WriteRegE;
    wire [31:0] WriteDataE;
    wire [31:0] SrcAE, SrcBE;
    assign WriteRegE = RegDstE ? RdE : RtE;
    assign SrcAE = ForwardAE[1]?ALUOutM:(ForwardAE[0]?ResultW:reg_rd1E);
    assign WriteDataE = ForwardBE[1]?ALUOutM:(ForwardBE[0]?ResultW:reg_rd2E);
    assign SrcBE = ALUSrcE ? SignImmE : WriteDataE;
    wire [31:0]ALUOutE;
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
      .a(ALUOutM>>2),        // input wire [7 : 0] a
      .d(WriteDataM),        // input wire [31 : 0] d
      .dpra(ALUOutM>>2),  // input wire [7 : 0] dpra
      .clk(clk),    // input wire clk
      .we(MemWriteM),      // input wire we
      .dpo(ReadDataM)    // output wire [31 : 0] dpo
    );
    reg[31:0] WriteRegM;
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
      ReadDataW <= ReadDataM;
      RegWriteW <= RegWriteM;
      MemtoRegW <= MemtoRegM;
      ALUOutW <= ALUOutM;
      WriteRegW <= WriteRegM;
    end
    assign ResultW = MemtoRegW ? ReadDataW : ALUOutW;



    hazard u_hazard(
    .WriteRegM(WriteRegM),
    .WriteRegW(WriteRegW),
    .MemtoRegE(MemtoRegE),
    .MemtoRegM(MemtoRegM),
    .RegWriteM(RegWriteM),
    .RegWriteW(RegWriteW),
    .RegWriteE(RegWriteE),
    .WriteRegE(WriteRegE),
    .BranchD(BranchD),
    .RsE(RsE),
    .RtE(RtE),
    .RsD(RsD),
    .RtD(RtD),
    .ForwardAE(ForwardAE),
    .ForwardBE(ForwardBE),
    .ForwardAD(ForwardAD),
    .ForwardBD(ForwardBD),
    .StallF(StallF),
    .StallD(StallD),
    .FlushE(FlushE)
    );


endmodule
