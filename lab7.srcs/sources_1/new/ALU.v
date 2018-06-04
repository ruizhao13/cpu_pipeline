`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/03/2018 09:41:06 AM
// Design Name: 
// Module Name: ALU
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


module ALU(
  input  signed	    [31:0]	alu_a,
  input  signed	    [31:0]	alu_b,
  input	            [5:0]	alu_op,
  output   reg      [31:0]	alu_out,
  output   wire			Zero
);
parameter	A_NOP	= 3'b000;	 	
parameter   A_ADD 	= 6'b100_000;
parameter	A_ADDU 	= 6'b100_001;	
parameter	A_SUB	= 6'b100_010;	
parameter 	A_SUBU	= 6'b100_011;
parameter	A_AND 	= 6'b100_100;
parameter	A_OR  	= 6'b100_101;
parameter	A_XOR 	= 6'b100_110;
parameter	A_NOR   = 6'b100_111;
parameter 	A_SLT	= 6'b101_010;
parameter    IS_POSIT = 6'b111111;
always@(*)
begin
  case (alu_op)
  	A_NOP:  alu_out = 0;
  	A_ADD:  alu_out = alu_a + alu_b;
	A_ADDU: alu_out = alu_a + alu_b;
  	A_SUB:  alu_out = alu_a - alu_b;
	A_SUBU: alu_out = alu_a - alu_b;
  	A_AND:  alu_out = alu_a & alu_b;
  	A_OR:   alu_out = alu_a | alu_b;
  	A_XOR:  alu_out = alu_a ^ alu_b;
  	A_NOR:  alu_out = ~(alu_a | alu_b);
	A_SLT:	alu_out = (alu_a < alu_b) ? 1 : 0;
	A_SLTU: alu_out = (alu_a < alu_b) ? 1 : 0;
	



	//IS_POSIT: alu_out = alu_a - 1;
  	default:  alu_out = 0;
  endcase
end

assign Zero = (alu_a > 0) ? 1:0;
endmodule

