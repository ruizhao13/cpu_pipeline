// Copyright 1986-2016 Xilinx, Inc. All Rights Reserved.

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "dist_mem_gen_v8_0_10,Vivado 2016.2" *)
module Inst_mem(a, d, clk, we, spo);
  input [7:0]a;
  input [31:0]d;
  input clk;
  input we;
  output [31:0]spo;
endmodule
