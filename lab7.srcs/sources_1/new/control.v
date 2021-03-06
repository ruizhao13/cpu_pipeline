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
    input [5:0]Funct,
    output reg RegWrite,
    output reg MemtoReg,
    output reg MemWrite,
    output reg [5:0] ALUControl,
    output reg ALUSrc,
    output reg RegDst,
    output reg [2:0] Branch,
    output reg Jump,
    output reg Jreg
    );

    	
parameter	  A_NOP	= 3'b000;	 	
parameter   A_ADD 	= 6'b100_000;
parameter	  A_ADDU 	= 6'b100_001;	
parameter	  A_SUB	= 6'b100_010;	
parameter 	A_SUBU	= 6'b100_011;
parameter	  A_AND 	= 6'b100_100;
parameter	  A_OR  	= 6'b100_101;
parameter	  A_XOR 	= 6'b100_110;
parameter	  A_NOR   = 6'b100_111;
parameter 	A_SLT	= 6'b101_010;
parameter 	A_SLTU	= 6'b101_011;

parameter    IS_POSIT = 6'b111111;

    parameter	  LW	  = 6'b100011;
    parameter	  SW	  = 6'b101011;	
    parameter	  RTYPE	= 6'b000000;	
    parameter   ADDI  = 6'b001000;
    parameter   ADDIU = 6'b001001;
    parameter   ANDI  = 6'b001100;//not done
    parameter   BEQ   = 6'b000100;
    parameter   BGTZ  = 6'b000111;
    parameter   JUMP  = 6'b000010;
    
    
    parameter   JR    = 6'b001_000;    
    	
    always @ (*)
    begin
      case (Op)
        LW: 
            begin
              RegWrite <= 1;     
              RegDst <= 0;
              ALUSrc <= 1;
              Branch <= 0;
              MemWrite <= 1'b0;                     
              MemtoReg <= 1'b1;
              ALUControl <= A_ADD;
              Jump <= 0;
            end
        RTYPE:
        begin
          case (Funct)
              JR:
                begin
                  RegWrite <= 0; 
                  RegDst <= 1'b0;//no use
                  ALUSrc <= 1'b0;//no use
                  MemWrite <= 1'b0;
                  MemtoReg <= 1'b0;//no use
                  ALUControl <= A_ADD;//no use
                  Branch <= 3'b111; //no use
                  Jump <= 1;
                  Jreg <= 1;
                end
            	
              default :begin
                RegWrite <= 1;              
                RegDst <= 1;
                ALUSrc <= 0;
                Branch <= 0;              
                MemWrite <= 1'b0;
                MemtoReg <= 1'b0;
                ALUControl <= Funct;
                Jump <= 0;
                end
        endcase
        end
        SW:
          begin
              RegWrite <= 0; 
              RegDst <= 1;//no use
              ALUSrc <= 1'b1;
              Branch <= 0;              
              MemWrite <= 1'b1;
              MemtoReg <= 1'b0;//no use
              ALUControl <= A_ADD;
              Jump <= 0;
          end
        ADDI:
          begin
              RegWrite <= 1; 
              RegDst <= 1'b0;
              ALUSrc <= 1'b1;
              Branch <= 0;
              MemWrite <= 1'b0;
              MemtoReg <= 1'b0;//no use
              ALUControl <= A_ADD;
              Jump <= 0;
          end
        ADDIU:
          begin
              RegWrite <= 1; 
              RegDst <= 1'b0;
              ALUSrc <= 1'b1;
              Branch <= 0;
              MemWrite <= 1'b0;
              MemtoReg <= 1'b0;//no use
              ALUControl <= A_ADDU;
              Jump <= 0;
          end
        ANDI:
          begin
              RegWrite <= 1; 
              RegDst <= 1'b0;
              ALUSrc <= 1'b1;
              Branch <= 0;
              MemWrite <= 1'b0;
              MemtoReg <= 1'b0;//no use
              ALUControl <= A_AND;
              Jump <= 0;
          end
        BEQ:
          begin
              RegWrite <= 0; 
              RegDst <= 1'b0;//no use
              ALUSrc <= 1'b0;
              Branch <= 3'b001;
              MemWrite <= 1'b0;
              MemtoReg <= 1'b0;//no use
              ALUControl <= A_ADD;
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
              

              Branch <= 3'b010;
              Jump <= 0;
              
          end  

        JUMP:
          begin
              RegWrite <= 0; 
              RegDst <= 1'b0;//no use
              ALUSrc <= 1'b0;//no use
              MemWrite <= 1'b0;
              MemtoReg <= 1'b0;//no use
              ALUControl <= A_ADD;//no use
              Branch <= 3'b111; //no use
              Jump <= 1;
              Jreg <= 0;
          end
        default: ;
      endcase
    end



endmodule
