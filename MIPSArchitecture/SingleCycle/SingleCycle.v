module ctrlCkt( input [4:0] opcode,output reg regDst, output reg regWrite, output reg aluSrc, output reg aluOp, output reg writeSrc, output reg branch, output reg jump);
  always @ (opcode)
    case (opcode[4:3])
      2'b00:  
        case(opcode[2:0])
          3'b001: begin regDst = 1'b0; regWrite = 1'b1; aluSrc = 1'b1; aluOp = 1'b0; writeSrc = 1'b1 ; branch = 1'b0; jump = 1'b0; end
          3'b010: begin regDst = 1'b0; regWrite = 1'b1; aluSrc = 1'b1; aluOp = 1'b0; writeSrc = 1'b1 ; branch = 1'b0; jump = 1'b0; end
          3'b011: begin regDst = 1'b0; regWrite = 1'b1; aluSrc = 1'b1; aluOp = 1'b0; writeSrc = 1'b1 ; branch = 1'b0; jump = 1'b0; end
          3'b100: begin regDst = 1'b0; regWrite = 1'b1; aluSrc = 1'b1; aluOp = 1'b0; writeSrc = 1'b1 ; branch = 1'b0; jump = 1'b0; end
          3'b101: begin regDst = 1'b0; regWrite = 1'b1; aluSrc = 1'b1; aluOp = 1'b0; writeSrc = 1'b1 ; branch = 1'b0; jump = 1'b0; end
        endcase
      2'b01: 
        case(opcode[2:1])
          2'b00: begin regDst = 1'b1; regWrite = 1'b1; aluSrc = 1'b0; aluOp = 1'b0; writeSrc = 1'b0 ; branch = 1'b0; jump = 1'b0; end
          2'b01: begin regDst = 1'b0; regWrite = 1'b1; aluSrc = 1'b1; aluOp = 1'b0; writeSrc = 1'b0 ; branch = 1'b0; jump = 1'b0; end
          2'b10: begin regDst = 1'b1; regWrite = 1'b1; aluSrc = 1'b0; aluOp = 1'b1; writeSrc = 1'b0 ; branch = 1'b0; jump = 1'b0; end
          2'b11: begin regDst = 1'b0; regWrite = 1'b1; aluSrc = 1'b1; aluOp = 1'b1; writeSrc = 1'b0 ; branch = 1'b0; jump = 1'b0; end
        endcase
      2'b10: begin regDst = 1'b0; regWrite = 1'b0; aluSrc = 1'b1; aluOp = 1'b0; writeSrc = 1'b0 ; branch = 1'b1; jump = 1'b0; end
      2'b11: begin regDst = 1'b0; regWrite = 1'b0; aluSrc = 1'b1; aluOp = 1'b0; writeSrc = 1'b0 ; branch = 1'b0; jump = 1'b1; end
    endcase
endmodule

module D_ff_IM(input clk, input reset, input d, output reg q);
  always@(reset or posedge clk)
    if(reset) q=d;
endmodule

module register_IM(input clk, input reset, input [15:0] d_in,output [15:0] q_out);
  D_ff_IM dIM0 (clk, reset, d_in[0], q_out[0]);
  D_ff_IM dIM1 (clk, reset, d_in[1], q_out[1]);
  D_ff_IM dIM2 (clk, reset, d_in[2], q_out[2]);
  D_ff_IM dIM3 (clk, reset, d_in[3], q_out[3]);
  D_ff_IM dIM4 (clk, reset, d_in[4], q_out[4]);
  D_ff_IM dIM5 (clk, reset, d_in[5], q_out[5]);
  D_ff_IM dIM6 (clk, reset, d_in[6], q_out[6]);
  D_ff_IM dIM7 (clk, reset, d_in[7], q_out[7]);
  D_ff_IM dIM8 (clk, reset, d_in[8], q_out[8]);
  D_ff_IM dIM9 (clk, reset, d_in[9], q_out[9]);
  D_ff_IM dIM10 (clk, reset, d_in[10], q_out[10]);
  D_ff_IM dIM11 (clk, reset, d_in[11], q_out[11]);
  D_ff_IM dIM12 (clk, reset, d_in[12], q_out[12]);
  D_ff_IM dIM13 (clk, reset, d_in[13], q_out[13]);
  D_ff_IM dIM14 (clk, reset, d_in[14], q_out[14]);
  D_ff_IM dIM15 (clk, reset, d_in[15], q_out[15]);
endmodule

module mux32to1( input [15:0] outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7,outR8,outR9,outR10,outR11,outR12,outR13, outR14,outR15,outR16,outR17,outR18,outR19,outR20,outR21,outR22,outR23,outR24,outR25,outR26,outR27,outR28,outR29, outR30,outR31,input [4:0] Sel,output reg [15:0] outBus );
  always@(outR0 or outR1 or outR2 or outR3 or outR4 or outR5 or outR6 or outR7 or outR8 or outR9 or outR10 or outR11 or outR12 or outR13 or outR14 or outR15 or outR16 or outR17 or outR18 or outR19 or outR20 or outR21 or outR22 or outR23 or outR24 or outR25 or outR26 or outR27 or outR28 or outR29 or outR30 or outR31 or Sel)
    case (Sel)
      5'b00000: outBus=outR0; 5'b00001: outBus=outR1; 5'b00010: outBus=outR2; 5'b00011: outBus=outR3;
      5'b00100: outBus=outR4; 5'b00101: outBus=outR5; 5'b00110: outBus=outR6; 5'b00111: outBus=outR7;
      5'b01000: outBus=outR8; 5'b01001: outBus=outR9; 5'b01010: outBus=outR10; 5'b01011: outBus=outR11;
      5'b01100: outBus=outR12; 5'b01101: outBus=outR13; 5'b01110: outBus=outR14; 5'b01111: outBus=outR15;
      5'b10000: outBus=outR16; 5'b10001: outBus=outR17; 5'b10010: outBus=outR18; 5'b10011: outBus=outR19;
      5'b10100: outBus=outR20; 5'b10101: outBus=outR21; 5'b10110: outBus=outR22; 5'b10111: outBus=outR23;
      5'b11000: outBus=outR24; 5'b11001: outBus=outR25; 5'b11010: outBus=outR26; 5'b11011: outBus=outR27;
      5'b11100: outBus=outR28; 5'b11101: outBus=outR29; 5'b11110: outBus=outR30; 5'b11111: outBus=outR31;
    endcase
endmodule                  
            
module IM( input clk, input reset, input [31:0] pc, output [15:0] instr );
  wire [15:0] Qout0, Qout1, Qout2, Qout3, Qout4, Qout5, Qout6, Qout7, Qout8, Qout9, Qout10, Qout11, Qout12, Qout13, Qout14, Qout15, Qout16, Qout17, Qout18, Qout19, Qout20, Qout21, Qout22, Qout23, Qout24, Qout25, Qout26, Qout27, Qout28, Qout29, Qout30, Qout31;
    register_IM rIM0 (clk, reset, 16'b01_01_010000_000_001, Qout0); //addi $r1, $r0, 16
    register_IM rIM1 (clk, reset, 16'b01_01_000110_000_111, Qout1); //addi $r7, $r0, 6
    register_IM rIM2 (clk, reset, 16'b00_011_00101_001_001, Qout2); //csr $r1, $r1, 5
    register_IM rIM3 (clk, reset, 16'b00_010_11111_001_010, Qout3); //lsr $r2, $r1, 31
    register_IM rIM4 (clk, reset, 16'b00_001_00001_001_001, Qout4); //asr $r1, $r1, 1
    register_IM rIM5 (clk, reset, 16'b00_101_00010_001_001, Qout5); //csl $r1, $r1, 2
    register_IM rIM6 (clk, reset, 16'b00_100_00001_010_010, Qout6); //lsl $r2, $r2, 1
    register_IM rIM7 (clk, reset, 16'b01_00_000_011_011_010, Qout7); //add $r3, $r3, $r2
    register_IM rIM8 (clk, reset, 16'b01_11_000001_001_001, Qout8); //subi $r1, $r1, 1
    register_IM rIM9 (clk, reset, 16'b10_0000_0000_0000_01, Qout9); //bz 1
    register_IM rIM10 (clk, reset, 16'b11_0000_0000_111_000, Qout10); //jr $r7
    register_IM rIM11 (clk, reset, 16'b01_00_000_101_011_010, Qout11); //add $r5, $r3, $r2
    register_IM rIM12 (clk, reset, 16'b01_10_000_100_011_010, Qout12); //sub $r4, $r3, $r2
    register_IM rIM13 (clk, reset, 16'b01_11_000010_101_101, Qout13); //subi $r5, $r5, 2
    register_IM rIM14 (clk, reset, 16'b00_010_00001_101_110, Qout14); //lsr $r6, $r5, 1
    register_IM rIM15 (clk, reset, 16'b01_00_000_100_100_110, Qout15); //add $r4, $r4, $r6
    register_IM rIM16 (clk, reset, 16'b00_011_00001_010_001, Qout16); //csr $r1, $r2, 1
    register_IM rIM17 (clk, reset, 16'b01_01_111110_011_011, Qout17); //add $r3, $r3, -2
    register_IM rIM18 (clk, reset, 16'b00_100_00001_011_110, Qout18); //lsl $r0, $r3, 1
    register_IM rIM19 (clk, reset, 16'b01_00_000_111_110_001, Qout19); //add $r7, $r6, $r1
    register_IM rIM20 (clk, reset, 16'b01_00_000_000_000_000, Qout20); //add $r0, $r0, $r0
    register_IM rIM21 (clk, reset, 16'b0000000000000000, Qout21);
    register_IM rIM22 (clk, reset, 16'b0000000000000000, Qout22);
    register_IM rIM23 (clk, reset, 16'b0000000000000000, Qout23);
    register_IM rIM24 (clk, reset, 16'b0000000000000000, Qout24);
    register_IM rIM25 (clk, reset, 16'b0000000000000000, Qout25);
    register_IM rIM26 (clk, reset, 16'b0000000000000000, Qout26);
    register_IM rIM27 (clk, reset, 16'b0000000000000000, Qout27);
    register_IM rIM28 (clk, reset, 16'b0000000000000000, Qout28);
    register_IM rIM29 (clk, reset, 16'b0000000000000000, Qout29);
    register_IM rIM30 (clk, reset, 16'b0000000000000000, Qout30);
    register_IM rIM31 (clk, reset, 16'b0000000000000000, Qout31);
    mux32to1 mIM (Qout0,Qout1,Qout2,Qout3,Qout4,Qout5,Qout6,Qout7,Qout8,Qout9,Qout10,Qout11,Qout12,Qout13,Qout14,Qout15,Qout16,Qout17,Qout18,Qout19,Qout20,Qout21,Qout22,Qout23,Qout24,Qout25,Qout26,Qout27,Qout28,Qout29,Qout30,Qout31,pc[4:0],instr);
endmodule    
              
module D_FF( input clk, input reset, input regWrite, input decOut1b , input d, output reg q);  
 always @ (negedge clk)  
   begin  
     if(reset==1)   
       q=0;  
     else   
       if(regWrite == 1 && decOut1b==1)   
         begin    q=d;   
     end   
   end 
endmodule                

module register32bit( input clk, input reset, input regWrite, input decOut1b, input [31:0] writeData,output [31:0] outR );
    D_FF M0(clk,reset,regWrite,decOut1b,writeData[0],outR[0]);
    D_FF M1(clk,reset,regWrite,decOut1b,writeData[1],outR[1]);
    D_FF M2(clk,reset,regWrite,decOut1b,writeData[2],outR[2]);  
    D_FF M3(clk,reset,regWrite,decOut1b,writeData[3],outR[3]); 
    D_FF M4(clk,reset,regWrite,decOut1b,writeData[4],outR[4]); 
    D_FF M5(clk,reset,regWrite,decOut1b,writeData[5],outR[5]); 
    D_FF M6(clk,reset,regWrite,decOut1b,writeData[6],outR[6]); 
    D_FF M7(clk,reset,regWrite,decOut1b,writeData[7],outR[7]); 
    D_FF M8(clk,reset,regWrite,decOut1b,writeData[8],outR[8]); 
    D_FF M9(clk,reset,regWrite,decOut1b,writeData[9],outR[9]); 
    D_FF M10(clk,reset,regWrite,decOut1b,writeData[10],outR[10]); 
    D_FF M11(clk,reset,regWrite,decOut1b,writeData[11],outR[11]); 
    D_FF M12(clk,reset,regWrite,decOut1b,writeData[12],outR[12]); 
    D_FF M13(clk,reset,regWrite,decOut1b,writeData[13],outR[13]); 
    D_FF M14(clk,reset,regWrite,decOut1b,writeData[14],outR[14]); 
    D_FF M15(clk,reset,regWrite,decOut1b,writeData[15],outR[15]); 
    D_FF M16(clk,reset,regWrite,decOut1b,writeData[16],outR[16]); 
    D_FF M17(clk,reset,regWrite,decOut1b,writeData[17],outR[17]); 
    D_FF M18(clk,reset,regWrite,decOut1b,writeData[18],outR[18]); 
    D_FF M19(clk,reset,regWrite,decOut1b,writeData[19],outR[19]); 
    D_FF M20(clk,reset,regWrite,decOut1b,writeData[20],outR[20]); 
    D_FF M21(clk,reset,regWrite,decOut1b,writeData[21],outR[21]); 
    D_FF M22(clk,reset,regWrite,decOut1b,writeData[22],outR[22]); 
    D_FF M23(clk,reset,regWrite,decOut1b,writeData[23],outR[23]); 
    D_FF M24(clk,reset,regWrite,decOut1b,writeData[24],outR[24]); 
    D_FF M25(clk,reset,regWrite,decOut1b,writeData[25],outR[25]); 
    D_FF M26(clk,reset,regWrite,decOut1b,writeData[26],outR[26]); 
    D_FF M27(clk,reset,regWrite,decOut1b,writeData[27],outR[27]); 
    D_FF M28(clk,reset,regWrite,decOut1b,writeData[28],outR[28]); 
    D_FF M29(clk,reset,regWrite,decOut1b,writeData[29],outR[29]); 
    D_FF M30(clk,reset,regWrite,decOut1b,writeData[30],outR[30]); 
    D_FF M31(clk,reset,regWrite,decOut1b,writeData[31],outR[31]); 
endmodule
   
module registerSet( input clk, input reset, input regWrite, input [7:0] decOut, input [31:0] writeData, output [31:0] outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7 );
    register32bit R0(clk,reset,regWrite,decOut[0],writeData,outR0);
    register32bit R1(clk,reset,regWrite,decOut[1],writeData,outR1);
    register32bit R2(clk,reset,regWrite,decOut[2],writeData,outR2);
    register32bit R3(clk,reset,regWrite,decOut[3],writeData,outR3);
    register32bit R4(clk,reset,regWrite,decOut[4],writeData,outR4);
    register32bit R5(clk,reset,regWrite,decOut[5],writeData,outR5);
    register32bit R6(clk,reset,regWrite,decOut[6],writeData,outR6);
    register32bit R7(clk,reset,regWrite,decOut[7],writeData,outR7);
endmodule      

module decoder3to8( input [2:0] destReg,output reg [7:0] decOut);
  always @ (destReg)
      case (destReg)
        3'b000: decOut = 8'b00000001;
        3'b001: decOut = 8'b00000010;
        3'b010: decOut = 8'b00000100;
        3'b011: decOut = 8'b00001000;
        3'b100: decOut = 8'b00010000;
        3'b101: decOut = 8'b00100000;
        3'b110: decOut = 8'b01000000;
        3'b111: decOut = 8'b10000000;
    endcase
endmodule          

module mux8to1( input [31:0] outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7, input [2:0] Sel, output reg [31:0] outBus );    
  always @ ( outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7,Sel)
      case (Sel)
        3'b000: outBus = outR0;
        3'b001: outBus = outR1;
        3'b010: outBus = outR2;
        3'b011: outBus = outR3;
        3'b100: outBus = outR4;
        3'b101: outBus = outR5;
        3'b110: outBus = outR6;
        3'b111: outBus = outR7;
      endcase
endmodule 

   

module registerFile(input clk, input reset, input regWrite, input [2:0]srcRegA, input [2:0] srcRegB, input [2:0] destReg, input [31:0] writeData,output [31:0] outBusA, output [31:0] outBusB );              
    wire [7:0] decOut;
    wire [31:0] outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7;
    decoder Dec (destReg, decOut);
    registerSet RSet (clk,reset,regWrite,decOut,writeData,outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7); 
    mux8to1 Mux1 (outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7,srcRegA,outBusA);
    mux8to1 Mux2 (outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7,srcRegB,outBusB);
endmodule                  
                  
module mux2to1_3bits(input [2:0] in1, input [2:0] in2, input sel,output reg [2:0] muxout);
  always @ ( in1,in2,sel)
    case(sel)
      2'b0: muxout = in1;
      2'b1: muxout = in2;
    endcase
endmodule               
                  
module mux2to1_32bits(input [31:0] in1, input [31:0] in2, input sel,output reg [31:0] muxout);                  
  always @ ( in1,in2,sel)
    case(sel)
      2'b0: muxout = in1;
      2'b1: muxout = in2;
    endcase
endmodule

module signExt6to32( input [5:0] offset,output reg [31:0] signExtOffset);
  always @ (offset)
    begin
    signExtOffset = {{26{offset[5]}},offset[5:0]};
  end
endmodule    

module signExt14to32( input [13:0] offset,output reg [31:0] signExtOffset);              
  always @ (offset)
    begin
    signExtOffset = {{18{offset[13]}},offset[13:0]};
  end
endmodule    

module alu(input [31:0] aluIn1, input [31:0] aluIn2, input aluOp,output reg [31:0] aluResult);
  always @ (aluIn1,aluIn2,aluOp)
    case(aluOp)
      1'b0: aluResult = aluIn1 + aluIn2; 
      1'b0: aluResult = aluIn1 + aluIn2;  //ERROR HERE!!!!
    endcase
endmodule  

module adder(input [31:0] in1, input [31:0] in2,output reg [31:0] adder_out);
  always @(in1, in2)
    adder_out = in1 + in2;            
endmodule

module mux8to1_1bit( input in0, input in1, input in2, input in3, input in4, input in5, input [2:0] sel, output reg muxOut);
  always @ (in0, in1, in2,  in3,  in4,  in5, sel)
    case (sel)
      3'b000: muxOut = in0; 
      3'b001: muxOut = in1;
      3'b010: muxOut = in2;
      3'b011: muxOut = in3;
      3'b100: muxOut = in4;
      3'b101: muxOut = in5;
      3'b110: muxOut = 1'b0;
      3'b111: muxOut = 1'b0;
    endcase
  endmodule

module shifter32b(input [31:0] rs, input [4:0] shiftAmt, input [2:0] opcode, output [31:0] shiftOut);
  wire [2:0] sel1, sel2, sel3, sel4, sel5;
  wire [31:0] out1, out2, out3, out4;
  
  mux2to1_3bits S1(3'b000,opcode,shiftAmt[0],sel1); 
  mux2to1_3bits S2(3'b000,opcode,shiftAmt[1],sel2);
  mux2to1_3bits S3(3'b000,opcode,shiftAmt[2],sel3);
  mux2to1_3bits S4(3'b000,opcode,shiftAmt[3],sel4);
  mux2to1_3bits S5(3'b000,opcode,shiftAmt[4],sel5);
  
  mux8to1_1bit M131 (rs[31],rs[31],1'b0,rs[0],rs[30],rs[30],sel1,out1[31]);
  mux8to1_1bit M130 (rs[30],rs[31],rs[31],rs[31],rs[29],rs[29],sel1,out1[30]);
  mux8to1_1bit M129 (rs[29],rs[30],rs[30],rs[30],rs[28],rs[28],sel1,out1[29]);
  mux8to1_1bit M128 (rs[28],rs[29],rs[29],rs[29],rs[27],rs[27],sel1,out1[28]);
  mux8to1_1bit M127 (rs[27],rs[28],rs[28],rs[28],rs[26],rs[26],sel1,out1[27]);
  mux8to1_1bit M126 (rs[26],rs[27],rs[27],rs[27],rs[25],rs[25],sel1,out1[26]);
  mux8to1_1bit M125 (rs[25],rs[26],rs[26],rs[26],rs[24],rs[24],sel1,out1[25]);
  mux8to1_1bit M124 (rs[24],rs[25],rs[25],rs[25],rs[23],rs[23],sel1,out1[24]);
  mux8to1_1bit M123 (rs[23],rs[24],rs[24],rs[24],rs[22],rs[22],sel1,out1[23]);
  mux8to1_1bit M122 (rs[22],rs[23],rs[23],rs[23],rs[21],rs[21],sel1,out1[22]);
  mux8to1_1bit M121 (rs[21],rs[22],rs[22],rs[22],rs[20],rs[20],sel1,out1[21]);
  mux8to1_1bit M120 (rs[20],rs[21],rs[21],rs[21],rs[19],rs[19],sel1,out1[20]);
  mux8to1_1bit M119 (rs[19],rs[20],rs[20],rs[20],rs[18],rs[18],sel1,out1[19]);
  mux8to1_1bit M118 (rs[18],rs[19],rs[19],rs[19],rs[17],rs[17],sel1,out1[18]);
  mux8to1_1bit M117 (rs[17],rs[18],rs[18],rs[18],rs[16],rs[16],sel1,out1[17]);
  mux8to1_1bit M116 (rs[16],rs[17],rs[17],rs[17],rs[15],rs[15],sel1,out1[16]);
  mux8to1_1bit M115 (rs[15],rs[16],rs[16],rs[16],rs[14],rs[14],sel1,out1[15]);
  mux8to1_1bit M114 (rs[14],rs[15],rs[15],rs[15],rs[13],rs[13],sel1,out1[14]);
  mux8to1_1bit M113 (rs[13],rs[14],rs[14],rs[14],rs[12],rs[12],sel1,out1[13]);
  mux8to1_1bit M112 (rs[12],rs[13],rs[13],rs[13],rs[11],rs[11],sel1,out1[12]);
  mux8to1_1bit M111 (rs[11],rs[12],rs[12],rs[12],rs[10],rs[10],sel1,out1[11]);
  mux8to1_1bit M110 (rs[10],rs[11],rs[11],rs[11],rs[9],rs[9],sel1,out1[10]);
  mux8to1_1bit M19 (rs[9],rs[10],rs[10],rs[10],rs[8],rs[8],sel1,out1[9]);
  mux8to1_1bit M18 (rs[8],rs[9],rs[9],rs[9],rs[7],rs[7],sel1,out1[8]);
  mux8to1_1bit M17 (rs[7],rs[8],rs[8],rs[8],rs[6],rs[6],sel1,out1[7]);
  mux8to1_1bit M16 (rs[6],rs[7],rs[7],rs[7],rs[5],rs[5],sel1,out1[6]);
  mux8to1_1bit M15 (rs[5],rs[6],rs[6],rs[6],rs[4],rs[4],sel1,out1[5]);
  mux8to1_1bit M14 (rs[4],rs[5],rs[5],rs[5],rs[3],rs[3],sel1,out1[4]);
  mux8to1_1bit M13 (rs[3],rs[4],rs[4],rs[4],rs[2],rs[2],sel1,out1[3]);
  mux8to1_1bit M12 (rs[2],rs[3],rs[3],rs[3],rs[1],rs[1],sel1,out1[2]);
  mux8to1_1bit M11 (rs[1],rs[2],rs[2],rs[2],rs[0],rs[0],sel1,out1[1]);
  mux8to1_1bit M10 (rs[0],rs[1],rs[1],rs[1],1'b0,rs[31],sel1,out1[0]);
  
  mux8to1_1bit M231 (out1[31],out1[31],1'b0,out1[1],out1[29],out1[29],sel2,out2[31]);
  mux8to1_1bit M230 (out1[30],out1[31],1'b0,out1[0],out1[28],out1[28],sel2,out2[30]);
  mux8to1_1bit M229 (out1[29],out1[31],out1[31],out1[31],out1[27],out1[27],sel2,out2[29]);
  mux8to1_1bit M228 (out1[28],out1[30],out1[30],out1[30],out1[26],out1[26],sel2,out2[28]);
  mux8to1_1bit M227 (out1[27],out1[29],out1[29],out1[29],out1[25],out1[25],sel2,out2[27]);
  mux8to1_1bit M226 (out1[26],out1[28],out1[28],out1[28],out1[24],out1[24],sel2,out2[26]);
  mux8to1_1bit M225 (out1[25],out1[27],out1[27],out1[27],out1[23],out1[23],sel2,out2[25]);
  mux8to1_1bit M224 (out1[24],out1[26],out1[26],out1[26],out1[22],out1[22],sel2,out2[24]);
  mux8to1_1bit M223 (out1[23],out1[25],out1[25],out1[25],out1[21],out1[21],sel2,out2[23]);
  mux8to1_1bit M222 (out1[22],out1[24],out1[24],out1[24],out1[20],out1[20],sel2,out2[22]);
  mux8to1_1bit M221 (out1[21],out1[23],out1[23],out1[23],out1[19],out1[19],sel2,out2[21]);
  mux8to1_1bit M220 (out1[20],out1[22],out1[22],out1[22],out1[18],out1[18],sel2,out2[20]);
  mux8to1_1bit M219 (out1[19],out1[21],out1[21],out1[21],out1[17],out1[17],sel2,out2[19]);
  mux8to1_1bit M218 (out1[18],out1[20],out1[20],out1[20],out1[16],out1[16],sel2,out2[18]);
  mux8to1_1bit M217 (out1[17],out1[19],out1[19],out1[19],out1[15],out1[15],sel2,out2[17]);
  mux8to1_1bit M216 (out1[16],out1[18],out1[18],out1[18],out1[14],out1[14],sel2,out2[16]);
  mux8to1_1bit M215 (out1[15],out1[17],out1[17],out1[17],out1[13],out1[13],sel2,out2[15]);
  mux8to1_1bit M214 (out1[14],out1[16],out1[16],out1[16],out1[12],out1[12],sel2,out2[14]);
  mux8to1_1bit M213 (out1[13],out1[15],out1[15],out1[15],out1[11],out1[11],sel2,out2[13]);
  mux8to1_1bit M212 (out1[12],out1[14],out1[14],out1[14],out1[10],out1[10],sel2,out2[12]);
  mux8to1_1bit M211 (out1[11],out1[13],out1[13],out1[13],out1[9],out1[9],sel2,out2[11]);
  mux8to1_1bit M210 (out1[10],out1[12],out1[12],out1[12],out1[8],out1[8],sel2,out2[10]);
  mux8to1_1bit M29 (out1[9],out1[11],out1[11],out1[11],out1[7],out1[7],sel2,out2[9]);
  mux8to1_1bit M28 (out1[8],out1[10],out1[10],out1[10],out1[6],out1[6],sel2,out2[8]);
  mux8to1_1bit M27 (out1[7],out1[9],out1[9],out1[9],out1[5],out1[5],sel2,out2[7]);
  mux8to1_1bit M26 (out1[6],out1[8],out1[8],out1[8],out1[4],out1[4],sel2,out2[6]);
  mux8to1_1bit M25 (out1[5],out1[7],out1[7],out1[7],out1[3],out1[3],sel2,out2[5]);
  mux8to1_1bit M24 (out1[4],out1[6],out1[6],out1[6],out1[2],out1[2],sel2,out2[4]);
  mux8to1_1bit M23 (out1[3],out1[5],out1[5],out1[5],out1[1],out1[1],sel2,out2[3]);
  mux8to1_1bit M22 (out1[2],out1[4],out1[4],out1[4],out1[0],out1[0],sel2,out2[2]);
  mux8to1_1bit M21 (out1[1],out1[3],out1[3],out1[3],1'b0,out1[31],sel2,out2[1]);
  mux8to1_1bit M20 (out1[0],out1[2],out1[2],out1[2],1'b0,out1[30],sel2,out2[0]);
    
  mux8to1_1bit M331 (out2[31],out2[31],1'b0,out2[3],out2[27],out2[27],sel3,out3[31]);
  mux8to1_1bit M330 (out2[30],out2[31],1'b0,out2[2],out2[26],out2[26],sel3,out3[30]);
  mux8to1_1bit M329 (out2[29],out2[31],1'b0,out2[1],out2[25],out2[25],sel3,out3[29]);
  mux8to1_1bit M328 (out2[28],out2[31],1'b0,out2[0],out2[24],out2[24],sel3,out3[28]);
  mux8to1_1bit M327 (out2[27],out2[31],out2[31],out2[31],out2[23],out2[23],sel3,out3[27]);
  mux8to1_1bit M326 (out2[26],out2[30],out2[30],out2[30],out2[22],out2[22],sel3,out3[26]);
  mux8to1_1bit M325 (out2[25],out2[29],out2[29],out2[29],out2[21],out2[21],sel3,out3[25]);
  mux8to1_1bit M324 (out2[24],out2[28],out2[28],out2[28],out2[20],out2[20],sel3,out3[24]);
  mux8to1_1bit M323 (out2[23],out2[27],out2[27],out2[27],out2[19],out2[19],sel3,out3[23]);
  mux8to1_1bit M322 (out2[22],out2[26],out2[26],out2[26],out2[18],out2[18],sel3,out3[22]);
  mux8to1_1bit M321 (out2[21],out2[25],out2[25],out2[25],out2[17],out2[17],sel3,out3[21]);
  mux8to1_1bit M320 (out2[20],out2[24],out2[24],out2[24],out2[16],out2[16],sel3,out3[20]);
  mux8to1_1bit M319 (out2[19],out2[23],out2[23],out2[23],out2[15],out2[15],sel3,out3[19]);
  mux8to1_1bit M318 (out2[18],out2[22],out2[22],out2[22],out2[14],out2[14],sel3,out3[18]);
  mux8to1_1bit M317 (out2[17],out2[21],out2[21],out2[21],out2[13],out2[13],sel3,out3[17]);
  mux8to1_1bit M316 (out2[16],out2[20],out2[20],out2[20],out2[12],out2[12],sel3,out3[16]);
  mux8to1_1bit M315 (out2[15],out2[19],out2[19],out2[19],out2[11],out2[11],sel3,out3[15]);
  mux8to1_1bit M314 (out2[14],out2[18],out2[18],out2[18],out2[10],out2[10],sel3,out3[14]);
  mux8to1_1bit M313 (out2[13],out2[17],out2[17],out2[17],out2[9],out2[9],sel3,out3[13]);
  mux8to1_1bit M312 (out2[12],out2[16],out2[16],out2[16],out2[8],out2[8],sel3,out3[12]);
  mux8to1_1bit M311 (out2[11],out2[15],out2[15],out2[15],out2[7],out2[7],sel3,out3[11]);
  mux8to1_1bit M310 (out2[10],out2[14],out2[14],out2[14],out2[6],out2[6],sel3,out3[10]);
  mux8to1_1bit M39 (out2[9],out2[13],out2[13],out2[13],out2[5],out2[5],sel3,out3[9]);
  mux8to1_1bit M38 (out2[8],out2[12],out2[12],out2[12],out2[4],out2[4],sel3,out3[8]);
  mux8to1_1bit M37 (out2[7],out2[11],out2[11],out2[11],out2[3],out2[3],sel3,out3[7]);
  mux8to1_1bit M36 (out2[6],out2[10],out2[10],out2[10],out2[2],out2[2],sel3,out3[6]);
  mux8to1_1bit M35 (out2[5],out2[9],out2[9],out2[9],out2[1],out2[1],sel3,out3[5]);
  mux8to1_1bit M34 (out2[4],out2[8],out2[8],out2[8],out2[0],out2[0],sel3,out3[4]);
  mux8to1_1bit M33 (out2[3],out2[7],out2[7],out2[7],1'b0,out2[31],sel3,out3[3]);
  mux8to1_1bit M32 (out2[2],out2[6],out2[6],out2[6],1'b0,out2[30],sel3,out3[2]);
  mux8to1_1bit M31 (out2[1],out2[5],out2[5],out2[5],1'b0,out2[29],sel3,out3[1]);
  mux8to1_1bit M30 (out2[0],out2[4],out2[4],out2[4],1'b0,out2[28],sel3,out3[0]);
  
  mux8to1_1bit M431 (out3[31],out3[31],1'b0,out3[7],out3[23],out3[23],sel4,out4[31]);
  mux8to1_1bit M430 (out3[30],out3[31],1'b0,out3[6],out3[22],out3[22],sel4,out4[30]);
  mux8to1_1bit M429 (out3[29],out3[31],1'b0,out3[5],out3[21],out3[21],sel4,out4[29]);
  mux8to1_1bit M428 (out3[28],out3[31],1'b0,out3[4],out3[20],out3[20],sel4,out4[28]);
  mux8to1_1bit M427 (out3[27],out3[31],1'b0,out3[3],out3[19],out3[19],sel4,out4[27]);
  mux8to1_1bit M426 (out3[26],out3[31],1'b0,out3[2],out3[18],out3[18],sel4,out4[26]);
  mux8to1_1bit M425 (out3[25],out3[31],1'b0,out3[1],out3[17],out3[17],sel4,out4[25]);
  mux8to1_1bit M424 (out3[24],out3[31],1'b0,out3[0],out3[16],out3[16],sel4,out4[24]);
  mux8to1_1bit M423 (out3[23],out3[31],out3[31],out3[31],out3[15],out3[15],sel4,out4[23]);
  mux8to1_1bit M422 (out3[22],out3[30],out3[30],out3[30],out3[14],out3[14],sel4,out4[22]);
  mux8to1_1bit M421 (out3[21],out3[29],out3[29],out3[29],out3[13],out3[13],sel4,out4[21]);
  mux8to1_1bit M420 (out3[20],out3[28],out3[28],out3[28],out3[12],out3[12],sel4,out4[20]);
  mux8to1_1bit M419 (out3[19],out3[27],out3[27],out3[27],out3[11],out3[11],sel4,out4[19]);
  mux8to1_1bit M418 (out3[18],out3[26],out3[26],out3[26],out3[10],out3[10],sel4,out4[18]);
  mux8to1_1bit M417 (out3[17],out3[25],out3[25],out3[25],out3[9],out3[9],sel4,out4[17]);
  mux8to1_1bit M416 (out3[16],out3[24],out3[24],out3[24],out3[8],out3[8],sel4,out4[16]);
  mux8to1_1bit M415 (out3[15],out3[23],out3[23],out3[23],out3[7],out3[7],sel4,out4[15]);
  mux8to1_1bit M414 (out3[14],out3[22],out3[22],out3[22],out3[6],out3[6],sel4,out4[14]);
  mux8to1_1bit M413 (out3[13],out3[21],out3[21],out3[21],out3[5],out3[5],sel4,out4[13]);
  mux8to1_1bit M412 (out3[12],out3[20],out3[20],out3[20],out3[4],out3[4],sel4,out4[12]);
  mux8to1_1bit M411 (out3[11],out3[19],out3[19],out3[19],out3[3],out3[3],sel4,out4[11]);
  mux8to1_1bit M410 (out3[10],out3[18],out3[18],out3[18],out3[2],out3[2],sel4,out4[10]);
  mux8to1_1bit M49 (out3[9],out3[17],out3[17],out3[17],out3[1],out3[1],sel4,out4[9]);
  mux8to1_1bit M48 (out3[8],out3[16],out3[16],out3[16],out3[0],out3[0],sel4,out4[8]);
  mux8to1_1bit M47 (out3[7],out3[15],out3[15],out3[15],1'b0,out3[31],sel4,out4[7]);
  mux8to1_1bit M46 (out3[6],out3[14],out3[14],out3[14],1'b0,out3[30],sel4,out4[6]);
  mux8to1_1bit M45 (out3[5],out3[13],out3[13],out3[13],1'b0,out3[29],sel4,out4[5]);
  mux8to1_1bit M44 (out3[4],out3[12],out3[12],out3[12],1'b0,out3[28],sel4,out4[4]);
  mux8to1_1bit M43 (out3[3],out3[11],out3[11],out3[11],1'b0,out3[27],sel4,out4[3]);
  mux8to1_1bit M42 (out3[2],out3[10],out3[10],out3[10],1'b0,out3[26],sel4,out4[2]);
  mux8to1_1bit M41 (out3[1],out3[9],out3[9],out3[9],1'b0,out3[25],sel4,out4[1]);
  mux8to1_1bit M40 (out3[0],out3[8],out3[8],out3[8],1'b0,out3[24],sel4,out4[0]);

  mux8to1_1bit M531 (out4[31],out4[31],1'b0,out4[15],out4[15],out4[15],sel5,shiftOut[31]);
  mux8to1_1bit M530 (out4[30],out4[31],1'b0,out4[14],out4[14],out4[14],sel5,shiftOut[30]);
  mux8to1_1bit M529 (out4[29],out4[31],1'b0,out4[13],out4[13],out4[13],sel5,shiftOut[29]);
  mux8to1_1bit M528 (out4[28],out4[31],1'b0,out4[12],out4[12],out4[12],sel5,shiftOut[28]);
  mux8to1_1bit M527 (out4[27],out4[31],1'b0,out4[11],out4[11],out4[11],sel5,shiftOut[27]);
  mux8to1_1bit M526 (out4[26],out4[31],1'b0,out4[10],out4[10],out4[10],sel5,shiftOut[26]);
  mux8to1_1bit M525 (out4[25],out4[31],1'b0,out4[9],out4[9],out4[9],sel5,shiftOut[25]);
  mux8to1_1bit M524 (out4[24],out4[31],1'b0,out4[8],out4[8],out4[8],sel5,shiftOut[24]);
  mux8to1_1bit M523 (out4[23],out4[31],1'b0,out4[7],out4[7],out4[7],sel5,shiftOut[23]);
  mux8to1_1bit M522 (out4[22],out4[31],1'b0,out4[6],out4[6],out4[6],sel5,shiftOut[22]);
  mux8to1_1bit M521 (out4[21],out4[31],1'b0,out4[5],out4[5],out4[5],sel5,shiftOut[21]);
  mux8to1_1bit M520 (out4[20],out4[31],1'b0,out4[4],out4[4],out4[4],sel5,shiftOut[20]);
  mux8to1_1bit M519 (out4[19],out4[31],1'b0,out4[3],out4[3],out4[3],sel5,shiftOut[19]);
  mux8to1_1bit M518 (out4[18],out4[31],1'b0,out4[2],out4[2],out4[2],sel5,shiftOut[18]);
  mux8to1_1bit M517 (out4[17],out4[31],1'b0,out4[1],out4[1],out4[1],sel5,shiftOut[17]);
  mux8to1_1bit M516 (out4[16],out4[31],1'b0,out4[0],out4[0],out4[0],sel5,shiftOut[16]);
  mux8to1_1bit M515 (out4[15],out4[31],out4[31],out4[31],1'b0,out4[31],sel5,shiftOut[15]);
  mux8to1_1bit M514 (out4[14],out4[30],out4[30],out4[30],1'b0,out4[30],sel5,shiftOut[14]);
  mux8to1_1bit M513 (out4[13],out4[29],out4[29],out4[29],1'b0,out4[29],sel5,shiftOut[13]);
  mux8to1_1bit M512 (out4[12],out4[28],out4[28],out4[28],1'b0,out4[28],sel5,shiftOut[12]);
  mux8to1_1bit M511 (out4[11],out4[27],out4[27],out4[27],1'b0,out4[27],sel5,shiftOut[11]);
  mux8to1_1bit M510 (out4[10],out4[26],out4[26],out4[26],1'b0,out4[26],sel5,shiftOut[10]);
  mux8to1_1bit M59 (out4[9],out4[25],out4[25],out4[25],1'b0,out4[25],sel5,shiftOut[9]);
  mux8to1_1bit M58 (out4[8],out4[24],out4[24],out4[24],1'b0,out4[24],sel5,shiftOut[8]);
  mux8to1_1bit M57 (out4[7],out4[23],out4[23],out4[23],1'b0,out4[23],sel5,shiftOut[7]);
  mux8to1_1bit M56 (out4[6],out4[22],out4[22],out4[22],1'b0,out4[22],sel5,shiftOut[6]);
  mux8to1_1bit M55 (out4[5],out4[21],out4[21],out4[21],1'b0,out4[21],sel5,shiftOut[5]);
  mux8to1_1bit M54 (out4[4],out4[20],out4[20],out4[20],1'b0,out4[20],sel5,shiftOut[4]);
  mux8to1_1bit M53 (out4[3],out4[19],out4[19],out4[19],1'b0,out4[19],sel5,shiftOut[3]);
  mux8to1_1bit M52 (out4[2],out4[18],out4[18],out4[18],1'b0,out4[18],sel5,shiftOut[2]);
  mux8to1_1bit M51 (out4[1],out4[17],out4[17],out4[17],1'b0,out4[17],sel5,shiftOut[1]);
  mux8to1_1bit M50 (out4[0],out4[16],out4[16],out4[16],1'b0,out4[16],sel5,shiftOut[0]);
endmodule
               
module setZflag( input [31:0] Result, output reg zero);
  wire orRes,notRes;
  assign orRes = Result[31]|Result[30]|Result[29]|Result[28]|Result[27]|Result[26]|Result[25]|Result[24]|Result[23]|Result[22]|Result[21]|Result[20]|Result[19]|Result[18]|Result[17]|Result[16]|Result[15]|Result[14]|Result[13]|Result[12]|Result[11]|Result[10]|Result[9]|Result[8]|Result[7]|Result[6]|Result[5]|Result[4]|Result[3]|Result[2]|Result[1]|Result[0];                    
  always @(orRes or Result)
      case(orRes)
        1'b0: zero = 1'b0;
        1'b0: zero = 1'b1;
      endcase
endmodule

module singleCycle(input clk, input reset,output [31:0] Result );
  wire [31:0] outR,outBusA,outBusB,PCwriteData,ShiftwriteData,signExtOffset,muxout,aluResult,adder_out,signExtOffset1,adder_out1,BraWrite;
  wire [15:0] instr;
  wire regDst, regWrite, aluSrc, aluOp, writeSrc, branch, jump, zero, q, SelBra;
  wire [2:0]rD;
  // PCwriteData, writeData -> register file
  register32bit PC (clk, reset, 1'b1, 1'b1, PCwriteData, outR );
  IM InstrMem( clk, reset, outR, instr);
  ctrlCkt CC( instr[15:11], regDst,  regWrite,  aluSrc,  aluOp,  writeSrc, branch, jump);
                
  mux2to1_3bits M1 (instr[2:0], instr[8:6],  regDst, rD);                
  registerFile RF (clk, reset, regWrite, instr[5:3], instr[2:0], rD, Result, outBusA, outBusB);              
  shifter32b SR (outBusA, instr[10:6], instr[13:11], ShiftwriteData);
  
  signExt6to32 SE( instr[11:6], signExtOffset);
  mux2to1_32bits M2(outBusB, signExtOffset, aluSrc, muxout);                  

  alu AL(outBusA, muxout, aluOp, aluResult);
  mux2to1_32bits M3(aluResult, ShiftwriteData, writeSrc, Result);
  
  setZflag setF(Result, zero);
  D_FF zFlag( clk, reset, regWrite, regWrite , zero, q);
  assign SelBra = q & branch;
  
  adder PCadder(outR, 32'd1, adder_out);
  signExt14to32 SignE( instr[13:0], signExtOffset1);   
  adder PCadder1 ( signExtOffset1, adder_out, adder_out1);  
  mux2to1_32bits M4(adder_out, adder_out1, SelBra, BraWrite);  
  mux2to1_32bits M5(BraWrite, outBusA, jump, PCwriteData); 
endmodule      

module testBenchDatapath;
  reg clk;
  reg reset;
  wire [31:0] Result;
  singleCycle uut (.clk(clk), .reset(reset), .Result(Result));
  always
  #5 clk=~clk;
  initial
  begin
    clk=0; reset=1;
    #5 reset=0;
    #300 $finish;
  end
endmodule

  
    

  
  

                       
