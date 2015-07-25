module DLatch(d,clk,reset,q,qnot);
  input d,clk,reset;
  output q,qnot;
  wire w1,w2,r;
  
  assign r = ~d;
  assign w1 = ~(d&clk);
  assign w2 = ~(r&clk);
  
  assign q = (~(w1&qnot))&~reset;
  assign qnot = ~(w2&q);
  
  
endmodule

module D_FF1(output Q,Q1,input D,clk,rst);
  wire A1,A2,clk1,S,R;
  not N2(clk1,clk);
  not N4(rst1,rst);
  nand NA1(A1,A2,S);
  nand NA2(S,clk1,rst1,A1);
  nand NA3(R,A2,S,clk1);
  nand NA4(A2,R,D,rst1);
  nand NA5(Q,S,Q1);
  nand NA6(Q1,R,Q,rst1);
endmodule

module posedgedFF(d ,clk,reset,q,qnot);
  input d,clk,reset;
  output q,qnot;
  wire w1,w2,clknot;
  
  assign clknot = ~clk;
  
  DLatch l1 (d,~clk,reset,w1,w2);
  DLatch l2 (w1,~clknot,reset,q,qnot);
endmodule
module mux_2to1 (inp1,inp2,select,op);
  input inp1,inp2,select;
  output op;
  
  assign op = (select)?inp1:inp2;
endmodule

module Universal_shift_reg (output [3:0] data_out, input [3:0] data_in, input clk, select, clear);
  
  wire [3:0] w,w1;
  
  mux_2to1 m0 (data_out[0], data_in[0], select, w[0]);
  mux_2to1 m1 (data_out[1], data_in[1], select, w[1]);
  mux_2to1 m2 (data_out[2], data_in[2], select, w[2]);
  mux_2to1 m3 (data_out[3], data_in[3], select, w[3]);
  
  posedgedFF dff0(w[0],clk,clear,data_out[0],w1[0]);
  posedgedFF dff1(w[1],clk,clear,data_out[1],w1[1]);
  posedgedFF dff2(w[2],clk,clear,data_out[2],w1[2]);
  posedgedFF dff3(w[3],clk,clear,data_out[3],w1[3]);
  
endmodule

module decoder (input [1:0]s, input enable, output [3:0]O);
  
  assign O[3] = ~(~s[0]&~s[1]&~enable);
  assign O[2] = ~(s[0]&~s[1]&~enable);
  assign O[1] = ~(~s[0]&s[1]&~enable);
  assign O[0] = ~(s[0]&s[1]&~enable);
  
endmodule

module mux_4to1(Y, A, B, C, D, sel, en);
  output Y;
  input A, B, C, D, en;
  input [1:0] sel;
    assign Y = (en)? 0 :((sel[1])?((sel[0])? D : C) : ((sel[0])? B : A));
endmodule

module memoryblock (input [3:0] InputA, InputB, input [1:0] select, input RW,output [3:0] OutputA,OutputB);
  wire [3:0] w1, w2, w3, w4, w5, w6, w7, w8, w9;
  wire rst,enable;
  assign rst = 1'b0;
  assign enable = 1'b0;
  decoder D1 (select, enable, w1);
  
  Universal_shift_reg word0 (w2, InputA, RW, w1[3], rst);
  Universal_shift_reg word1 (w3, InputA, RW, w1[2], rst);
  Universal_shift_reg word2 (w4, InputA, RW, w1[1], rst);
  Universal_shift_reg word3 (w5, InputA, RW, w1[0], rst);
  Universal_shift_reg word4 (w6, InputB, RW, w1[3], rst);
  Universal_shift_reg word5 (w7, InputB, RW, w1[2], rst);
  Universal_shift_reg word6 (w8, InputB, RW, w1[1], rst);
  Universal_shift_reg word7 (w9, InputB, RW, w1[0], rst);
  
  mux_4to1 digit0 (OutputA[3], w2[3], w3[3], w4[3], w5[3], select, RW);
  mux_4to1 digit1 (OutputA[2], w2[2], w3[2], w4[2], w5[2], select, RW);
  mux_4to1 digit2 (OutputA[1], w2[1], w3[1], w4[1], w5[1], select, RW);
  mux_4to1 digit3 (OutputA[0], w2[0], w3[0], w4[0], w5[0], select, RW);
  mux_4to1 digit4 (OutputB[3], w6[3], w7[3], w8[3], w9[3], select, RW);
  mux_4to1 digit5 (OutputB[2], w6[2], w7[2], w8[2], w9[2], select, RW);
  mux_4to1 digit6 (OutputB[1], w6[1], w7[1], w8[1], w9[1], select, RW);
  mux_4to1 digit7 (OutputB[0], w6[0], w7[0], w8[0], w9[0], select, RW);
endmodule

module t_memoryblock1;
  reg [3:0] t_InputA, t_InputB;
  reg [1:0] t_select;
  reg t_RW; 
  wire [3:0] t_OutputA, t_OutputB;
  
  memoryblock mem(t_InputA, t_InputB, t_select, t_RW, t_OutputA, t_OutputB);
  
  initial # 880 $finish;
  initial begin 
    
    t_InputA <= 4'b1010;
    t_InputB <= 4'b0101;
    t_select <= 2'b00;
    t_RW <= 0;
    
    #10
    t_InputA <= 4'b1010;
    t_InputB <= 4'b0101;
    t_select <= 2'b00;
    t_RW <= 1;
    
    #100
     
    t_InputA <= 4'b1010;
    t_InputB <= 4'b0101;
    t_select <= 2'b01;
    t_RW <= 0;
    
    #10
    t_InputA <= 4'b0000;
    t_InputB <= 4'b1111;
    t_select <= 2'b01;
    t_RW <= 1;
    
    #100
     
    t_InputA <= 4'b1010;
    t_InputB <= 4'b0101;
    t_select <= 2'b10;
    t_RW <= 0;
    
    #10
    t_InputA <= 4'b0011;
    t_InputB <= 4'b1100;
    t_select <= 2'b10;
    t_RW <= 1;
    
     #100
     t_InputA <= 4'b1010;
    t_InputB <= 4'b0101;
    t_select <= 2'b11;
    t_RW <= 0;
    
    #10
    t_InputA <= 4'b0001;
    t_InputB <= 4'b1000;
    t_select <= 2'b11;
    t_RW <= 1;
    
     #100
     
    t_select <= 2'b00;
    t_RW <= 1;
    
    #10
    t_select <= 2'b00;
    t_RW <= 0;
    
     #100
      t_select <= 2'b00;
    t_RW <= 1;
    
    #10
    t_select <= 2'b01;
    t_RW <= 0;
    
     #100
      t_select <= 2'b00;
    t_RW <= 1;
    
    #10
    t_select <= 2'b10;
    t_RW <= 0;

     #100
      t_select <= 2'b00;
    t_RW <= 1;
    
    #10
    t_select <= 2'b11;
    t_RW <= 0;
    
  end
endmodule

module t_memoryblock2;
  reg [3:0] t_InputA, t_InputB;
  reg [1:0] t_select;
  reg t_RW; 
  wire [3:0] t_OutputA, t_OutputB;
  
  memoryblock mem(t_InputA, t_InputB, t_select, t_RW, t_OutputA, t_OutputB);
  
  initial # 840 $finish;
  initial begin 
    
    t_InputA <= 4'b1010;
    t_InputB <= 4'b0101;
    t_select <= 2'b00;
    t_RW <= 0;
    
    #10
    t_InputA <= 4'b1010;
    t_InputB <= 4'b0101;
    t_select <= 2'b00;
    t_RW <= 1;
    
    #100
     
    t_select <= 2'b00;
    t_RW <= 0;
    
    #100
    t_InputA <= 4'b0000;
    t_InputB <= 4'b1111;
    t_select <= 2'b01;
    t_RW <= 0;
    
    #10
    t_InputA <= 4'b0000;
    t_InputB <= 4'b1111;
    t_select <= 2'b01;
    t_RW <= 1;
    
    #100
     
    t_select <= 2'b01;
    t_RW <= 0;
    
    #100
    t_InputA <= 4'b0011;
    t_InputB <= 4'b1100;
    t_select <= 2'b10;
    t_RW <= 0;
    
    #10
    t_InputA <= 4'b0011;
    t_InputB <= 4'b1100;
    t_select <= 2'b10;
    t_RW <= 1;
    
     #100
    t_select <= 2'b10;
    t_RW <= 0;
    
    #100
    t_InputA <= 4'b0001;
    t_InputB <= 4'b1000;
    t_select <= 2'b11;
    t_RW <= 0;
    
    #10
    t_InputA <= 4'b0001;
    t_InputB <= 4'b1000;
    t_select <= 2'b11;
    t_RW <= 1;
    
     #100
     
    t_select <= 2'b11;
    t_RW <= 0;
    
    
  end
endmodule
