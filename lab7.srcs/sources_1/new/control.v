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
    output reg RegWrite,
    output reg MemtoReg,
    output reg MemWrite,
    output reg [5:0] ALUControl,
    output reg ALUSrc,
    output reg RegDst,
    output reg Branch,
    output reg Jump
    );

    	
//parameter	A_ADD	= 5'h01;
parameter   A_ADD 	= 6'b100_000;	
parameter	A_SUB	= 6'b100010;	
parameter	A_AND 	= 6'b100100;
parameter	A_OR  	= 6'b100101;
parameter	A_XOR 	= 6'b100110;
parameter	A_NOR   = 6'b100111;
parameter    IS_POSIT = 6'b111111;

    parameter	  LW	  = 6'b100011;
    parameter	  SW	  = 6'b101011;	
    parameter	  RTYPE	  = 6'b000000;	
    parameter   ADDI  = 6'b001000;
    parameter   BGTZ  =  6'b000111;
    parameter   JUMP  =   6'b000010;
    //parameter	ADDI	= 35;	
    	
    always @ (*)
    begin
      case (Op)
        LW: 
            begin
              MemtoReg <= 1'b1;
              MemWrite <= 1'b0;
              Branch <= 0;
              ALUControl <= A_ADD;
              ALUSrc <= 1;
              RegDst <= 0;
              RegWrite <= 1;
              Jump <= 0;
            end
        RTYPE:
            begin
              
              RegDst <= 1;
              RegWrite <= 1;
              ALUSrc <= 0;
              MemWrite <= 1'b0;
              MemtoReg <= 1'b0;
              ALUControl <= Funct;
              

              Branch <= 0;
              Jump <= 0;
              
            end
        SW:
          begin
              RegDst <= 1;//no use
              RegWrite <= 0; 
              ALUSrc <= 1'b1;
              MemWrite <= 1'b1;
              MemtoReg <= 1'b0;//no use
              ALUControl <= A_ADD;
              

              Branch <= 0;
              Jump <= 0;
              
          end
        ADDI:
          begin
              RegDst <= 1'b0;//no use
              RegWrite <= 1; 
              ALUSrc <= 1'b1;
              MemWrite <= 1'b0;
              MemtoReg <= 1'b0;//no use
              ALUControl <= A_ADD;
              

              Branch <= 0;
              Jump <= 0;
              
          end
        BGTZ:
          begin
              RegDst <= 1'b0;//no use
              RegWrite <= 0; 
              ALUSrc <= 1'b1;
              MemWrite <= 1'b0;
              MemtoReg <= 1'b0;//no use
              ALUControl <= IS_POSIT;
              

              Branch <= 1;
              Jump <= 0;
              
          end  

        JUMP:
          begin
              RegDst <= 1'b0;//no use
              RegWrite <= 0; 
              ALUSrc <= 1'b1;
              MemWrite <= 1'b0;
              MemtoReg <= 1'b0;//no use
              ALUControl <= IS_POSIT;
              

              Branch <= 1;
              Jump <= 1;
              
          end
        default: ;
      endcase
    end



endmodule
