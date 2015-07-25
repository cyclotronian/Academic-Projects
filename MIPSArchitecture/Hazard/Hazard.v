
module D_ff_Mem(input clk, input reset, input init, input writeEn, input d, output reg q);
	always@(negedge clk)
		begin
			if(reset)			q=init;
			else
				if(writeEn==1)	q=d;
		end
endmodule

module Mem8bit(input clk, input reset, input [7:0] init, input writeEn, input [7:0] writeData, output [7:0] outR);
	D_ff_Mem D0(clk, reset, init[0], writeEn, writeData[0], outR[0]);
	D_ff_Mem D1(clk, reset, init[1], writeEn, writeData[1], outR[1]);
	D_ff_Mem D2(clk, reset, init[2], writeEn, writeData[2], outR[2]);
	D_ff_Mem D3(clk, reset, init[3], writeEn, writeData[3], outR[3]);
	D_ff_Mem D4(clk, reset, init[4], writeEn, writeData[4], outR[4]);
	D_ff_Mem D5(clk, reset, init[5], writeEn, writeData[5], outR[5]);
	D_ff_Mem D6(clk, reset, init[6], writeEn, writeData[6], outR[6]);
	D_ff_Mem D7(clk, reset, init[7], writeEn, writeData[7], outR[7]);
endmodule

module MemBlock(input clk, input reset, input [15:0] init0, init1, init2, init3, init4, init5, init6, init7, input MemWrite, input [7:0] decOut, input [15:0] writeData, output [7:0] outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7,outR8,outR9,outR10,outR11,outR12,outR13,outR14,outR15);
	Mem8bit m00(clk, reset, init0[7:0],  MemWrite&decOut[0], writeData[7:0],  outR0);
	Mem8bit m01(clk, reset, init0[15:8], MemWrite&decOut[0], writeData[15:8], outR1);
	Mem8bit m02(clk, reset, init1[7:0],  MemWrite&decOut[1], writeData[7:0],  outR2);
	Mem8bit m03(clk, reset, init1[15:8], MemWrite&decOut[1], writeData[15:8], outR3);	
	Mem8bit m04(clk, reset, init2[7:0],  MemWrite&decOut[2], writeData[7:0],  outR4);
	Mem8bit m05(clk, reset, init2[15:8], MemWrite&decOut[2], writeData[15:8], outR5);
	Mem8bit m06(clk, reset, init3[7:0],  MemWrite&decOut[3], writeData[7:0],  outR6);
	Mem8bit m07(clk, reset, init3[15:8], MemWrite&decOut[3], writeData[15:8], outR7);	
	Mem8bit m08(clk, reset, init4[7:0],  MemWrite&decOut[4], writeData[7:0],  outR8);
	Mem8bit m09(clk, reset, init4[15:8], MemWrite&decOut[4], writeData[15:8], outR9);
	Mem8bit m10(clk, reset, init5[7:0],  MemWrite&decOut[5], writeData[7:0],  outR10);
	Mem8bit m11(clk, reset, init5[15:8], MemWrite&decOut[5], writeData[15:8], outR11);	
	Mem8bit m12(clk, reset, init6[7:0],  MemWrite&decOut[6], writeData[7:0],  outR12);
	Mem8bit m13(clk, reset, init6[15:8], MemWrite&decOut[6], writeData[15:8], outR13);
	Mem8bit m14(clk, reset, init7[7:0],  MemWrite&decOut[7], writeData[7:0],  outR14);
	Mem8bit m15(clk, reset, init7[15:8], MemWrite&decOut[7], writeData[15:8], outR15);
endmodule

module MemDec3to8(input [2:0] MemDest, output reg [7:0] MemDecOut);	 
	 always@(MemDest)
	 	case(MemDest)
			3'b000: MemDecOut=8'b00000001;
			3'b001: MemDecOut=8'b00000010;
			3'b010: MemDecOut=8'b00000100;
			3'b011: MemDecOut=8'b00001000;
			3'b100: MemDecOut=8'b00010000;
			3'b101: MemDecOut=8'b00100000;
			3'b110: MemDecOut=8'b01000000;
			3'b111: MemDecOut=8'b10000000;
		endcase
endmodule
 
module MemMux8to1(input [7:0] outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7, input [2:0] Sel, output reg [7:0] outBus);	
	always@(outR0 or outR1 or outR2 or outR3 or outR4 or outR5 or outR6 or outR7 or Sel)
		case (Sel)
			3'b000: outBus=outR0;
			3'b001: outBus=outR1;
			3'b010: outBus=outR2;
			3'b011: outBus=outR3;
			3'b100: outBus=outR4;
			3'b101: outBus=outR5;
			3'b110: outBus=outR6;
			3'b111: outBus=outR7;
		endcase
endmodule 

module MemMux2to1(input [7:0] outBus, input [7:0] zero, input MemRead, output reg [7:0] MemOut);	
	always@(outBus or zero or MemRead)
		case (MemRead)
			1'b0: MemOut=outBus;
			1'b1: MemOut=zero;
		endcase	
endmodule

module Memory(input clk, input reset, input [15:0] init0, init1, init2, init3, init4, init5, init6, init7, input MemWrite, input MemRead, input [15:0] Addr, input [15:0] writeData, output [7:0] MemBus0, output [7:0] MemBus1);
	wire [7:0] MemDecOut, outBus0, outBus1;
	wire [7:0] outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7,outR8,outR9,outR10,outR11,outR12,outR13,outR14,outR15;
	
	MemDec3to8 MD0(Addr[3:1], MemDecOut);		
	MemBlock MB0(clk, reset, init0, init1, init2, init3, init4, init5, init6, init7, MemWrite, MemDecOut,writeData, outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7,outR8,outR9,outR10,outR11,outR12,outR13,outR14,outR15);	
	MemMux8to1 MM8_0(outR0,outR2,outR4,outR6,outR8,outR10,outR12,outR14,Addr[3:1], outBus0);
	MemMux8to1 MM8_1(outR1,outR3,outR5,outR7,outR9,outR11,outR13,outR15,Addr[3:1], outBus1);
	MemMux2to1 MM2_0(8'd0, outBus0, MemRead, MemBus0);
	MemMux2to1 MM2_1(8'd0, outBus1, MemRead, MemBus1);
endmodule

module D_ff_rF(input clk, input reset, input writeEn, input d, output reg q);
	always @ (reset)
		if(reset==1)	q=0;	
	always @ (posedge clk)
		if(writeEn==1)	q=d;	
endmodule

module Register16bit_rF(input clk, input reset, input writeEn, input [15:0] writeData, output  [15:0] outR);
	D_ff_rF d00(clk, reset, writeEn, writeData[0], outR[0]);
	D_ff_rF d01(clk, reset, writeEn, writeData[1], outR[1]);
	D_ff_rF d02(clk, reset, writeEn, writeData[2], outR[2]);
	D_ff_rF d03(clk, reset, writeEn, writeData[3], outR[3]);
	D_ff_rF d04(clk, reset, writeEn, writeData[4], outR[4]);
	D_ff_rF d05(clk, reset, writeEn, writeData[5], outR[5]);
	D_ff_rF d06(clk, reset, writeEn, writeData[6], outR[6]);
	D_ff_rF d07(clk, reset, writeEn, writeData[7], outR[7]);
	D_ff_rF d08(clk, reset, writeEn, writeData[8], outR[8]);
	D_ff_rF d09(clk, reset, writeEn, writeData[9], outR[9]);
	D_ff_rF d10(clk, reset, writeEn, writeData[10], outR[10]);
	D_ff_rF d11(clk, reset, writeEn, writeData[11], outR[11]);
	D_ff_rF d12(clk, reset, writeEn, writeData[12], outR[12]);
	D_ff_rF d13(clk, reset, writeEn, writeData[13], outR[13]);
	D_ff_rF d14(clk, reset, writeEn, writeData[14], outR[14]);
	D_ff_rF d15(clk, reset, writeEn, writeData[15], outR[15]);
endmodule

module RegisterSet(input clk, input reset, input regWrite, input [7:0] decOut, input [15:0] writeData,  output [15:0] outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7 );
	Register16bit_rF r0 (clk, reset, regWrite&decOut[0], writeData, outR0);
	Register16bit_rF r1 (clk, reset, regWrite&decOut[1], writeData, outR1);
	Register16bit_rF r2 (clk, reset, regWrite&decOut[2], writeData, outR2);
	Register16bit_rF r3 (clk, reset, regWrite&decOut[3], writeData, outR3);
	Register16bit_rF r4 (clk, reset, regWrite&decOut[4], writeData, outR4);
	Register16bit_rF r5 (clk, reset, regWrite&decOut[5], writeData, outR5);
	Register16bit_rF r6 (clk, reset, regWrite&decOut[6], writeData, outR6);
	Register16bit_rF r7 (clk, reset, regWrite&decOut[7], writeData, outR7);
endmodule

module Dec3to8(input [2:0] destReg, output reg [7:0] decOut);
	always@(destReg)
		case(destReg)
				3'b000: decOut=8'b00000001; 
				3'b001: decOut=8'b00000010;
				3'b010: decOut=8'b00000100;
				3'b011: decOut=8'b00001000;
				3'b100: decOut=8'b00010000;
				3'b101: decOut=8'b00100000;
				3'b110: decOut=8'b01000000;
				3'b111: decOut=8'b10000000;
		endcase	
endmodule

module Mux8to1(input [15:0] outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7, input [2:0] Sel, output reg [15:0] outBus );	
	always@(outR0 or outR1 or outR2 or outR3 or outR4 or outR5 or outR6 or outR7 or Sel)
		case (Sel)
			3'b000: outBus=outR0;
			3'b001: outBus=outR1;
			3'b010: outBus=outR2;
			3'b011: outBus=outR3;
			3'b100: outBus=outR4;
			3'b101: outBus=outR5;
			3'b110: outBus=outR6;
			3'b111: outBus=outR7;
		endcase	
endmodule

module RegisterFile(input clk, input reset, input regWrite, input [2:0] srcRegA, input [2:0] srcRegB,  input [2:0] destReg,  input [15:0] writeData, output [15:0] outBusA, output [15:0] outBusB );
	wire [7:0] decOut;
	wire [15:0] outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7;
	
	Dec3to8 d0 (destReg,decOut);
	RegisterSet rSet0( clk, reset, regWrite, decOut, writeData, outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7);
	Mux8to1 m1(outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7,srcRegA,outBusA);
	Mux8to1 m2(outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7,srcRegB,outBusB);
endmodule

module D_ff_pR(input clk, input reset, input writeEn, input d, output reg q);
	always @ (negedge clk)
		begin
			if(reset==1)		q=0;
			else
				if(writeEn==1)	q=d;	
		end
endmodule

module Register16bit(input clk, input reset, input writeEn, input [15:0] writeData, output  [15:0] outR);
	D_ff_pR d00(clk, reset, writeEn, writeData[0], outR[0]);
	D_ff_pR d01(clk, reset, writeEn, writeData[1], outR[1]);
	D_ff_pR d02(clk, reset, writeEn, writeData[2], outR[2]);
	D_ff_pR d03(clk, reset, writeEn, writeData[3], outR[3]);
	D_ff_pR d04(clk, reset, writeEn, writeData[4], outR[4]);
	D_ff_pR d05(clk, reset, writeEn, writeData[5], outR[5]);
	D_ff_pR d06(clk, reset, writeEn, writeData[6], outR[6]);
	D_ff_pR d07(clk, reset, writeEn, writeData[7], outR[7]);
	D_ff_pR d08(clk, reset, writeEn, writeData[8], outR[8]);
	D_ff_pR d09(clk, reset, writeEn, writeData[9], outR[9]);
	D_ff_pR d10(clk, reset, writeEn, writeData[10], outR[10]);
	D_ff_pR d11(clk, reset, writeEn, writeData[11], outR[11]);
	D_ff_pR d12(clk, reset, writeEn, writeData[12], outR[12]);
	D_ff_pR d13(clk, reset, writeEn, writeData[13], outR[13]);
	D_ff_pR d14(clk, reset, writeEn, writeData[14], outR[14]);
	D_ff_pR d15(clk, reset, writeEn, writeData[15], outR[15]);
endmodule

module Register3bit(input clk, input reset, input writeEn, input [2:0] writeData, output  [2:0] outR);
	D_ff_pR d00(clk, reset, writeEn, writeData[0], outR[0]);
	D_ff_pR d01(clk, reset, writeEn, writeData[1], outR[1]);
	D_ff_pR d02(clk, reset, writeEn, writeData[2], outR[2]);
endmodule

module Register1bit(input clk, input reset, input writeEn, input writeData, output  outR);
	D_ff_pR d00(clk, reset, writeEn, writeData, outR);
endmodule

module SignExt8to16(input [7:0] in, output  reg [15:0] SignExtOut);
	always@(in)	
		SignExtOut={{8{in[7]}},in[7:0]};
endmodule

module Mux2to1_16bits(input [15:0] in1, input [15:0] in2, input Sel,  output reg [15:0] MuxOut);	
	always@(in1 or in2 or Sel)
		case(Sel)
			0: MuxOut=in1;	
			1: MuxOut=in2;
		endcase
endmodule

module Mux2to1_3bits(input [2:0] in1, input [2:0] in2, input Sel,  output reg [2:0] MuxOut);	
	always@(in1 or in2 or Sel)
	 	case(Sel)
			0: MuxOut=in1;	
			1: MuxOut=in2;
		endcase
endmodule

module ALU(input [15:0] in1, input [15:0] in2, input ALUOp, output reg [15:0] ALUOut);
	always@(in1 or in2 or ALUOp)
		case(ALUOp)
			1'b0:	ALUOut=in1+in2;	
			1'b1:	ALUOut=in1-in2;
		endcase
endmodule

module IF_ID_PipelineRegister(input clk, input reset, input regWrite, input [15:0] instr, output [15:0] IR);
	Register16bit P1r0 (clk, reset, regWrite, instr, IR );	
endmodule

module ID_EX_PipelineRegister(input clk, input reset, input regWrite, input [15:0] BusA, input [15:0] BusB, input [15:0] SignExt8to16Imm, input [2:0] rt, input [2:0] rd, input [2:0] rs, input ALUSrcB, input ALUOp, input RegDst, input MemRead, input MemWrite, input MemToReg, input RegWrite, output [15:0] P2BusA, output [15:0] P2BusB, output [15:0] P2SignExt8to16Imm, output [2:0] P2rt, output [2:0] P2rd, output [2:0] P2rs, output P2ALUSrcB, output P2ALUOp, output P2RegDst, output P2MemRead, output P2MemWrite, output P2MemToReg, output P2RegWrite);
	Register16bit P2r0 (clk, reset, regWrite, BusA, P2BusA);	
	Register16bit P2r1 (clk, reset, regWrite, BusB, P2BusB);	
	Register16bit P2r2 (clk, reset, regWrite, SignExt8to16Imm, P2SignExt8to16Imm);	
	Register3bit P2r3  (clk, reset, regWrite, rt, P2rt);	
	Register3bit P2r4  (clk, reset, regWrite, rd, P2rd);	
	Register3bit P2r12 (clk, reset, regWrite, rs, P2rs);	
	Register1bit P2r5  (clk, reset, regWrite, ALUSrcB, P2ALUSrcB);	
	Register1bit P2r6  (clk, reset, regWrite, ALUOp, P2ALUOp);	
	Register1bit P2r7  (clk, reset, regWrite, RegDst, P2RegDst);	
	Register1bit P2r8  (clk, reset, regWrite, MemRead, P2MemRead);	
	Register1bit P2r9 (clk, reset, regWrite, MemWrite, P2MemWrite);	
	Register1bit P2r10 (clk, reset, regWrite, MemToReg, P2MemToReg);	
	Register1bit P2r11 (clk, reset, regWrite, RegWrite, P2RegWrite);		 
endmodule

module EX_MEM_PipelineRegister(input clk, input reset, input regWrite, input [15:0] ALUOut, input [15:0] BusB, input [2:0] DestReg, input MemRead, input MemWrite, input MemToReg, input RegWrite, output [15:0] P3ALUOut, output [15:0] P3BusB, output [2:0] P3DestReg, output P3MemRead, output P3MemWrite, output P3MemToReg, output P3RegWrite);	
	Register16bit P3r0 (clk, reset, regWrite, ALUOut, P3ALUOut);	
	Register16bit P3r1 (clk, reset, regWrite, BusB, P3BusB);	
	Register3bit P3r2  (clk, reset, regWrite, DestReg, P3DestReg);	
	Register1bit P3r3  (clk, reset, regWrite, MemRead, P3MemRead);	
	Register1bit P3r4  (clk, reset, regWrite, MemWrite, P3MemWrite);	
	Register1bit P3r5  (clk, reset, regWrite, MemToReg, P3MemToReg);	
	Register1bit P3r6  (clk, reset, regWrite, RegWrite, P3RegWrite);	
endmodule

module MEM_WB_PipelineRegister(input clk, input reset, input regWrite, input [15:0] ALUOut, input [15:0] DMOut, input [2:0] DestReg, input RegWrite, input MemToReg, output [15:0] P4ALUOut, output [15:0] P4DMOut, output [2:0] P4DestReg, output P4RegWrite, output P4MemToReg);
	Register16bit P4r0 (clk, reset, regWrite, ALUOut, P4ALUOut);
	Register16bit P4r1 (clk, reset, regWrite, DMOut, P4DMOut);
	Register3bit P4r2  (clk, reset, regWrite, DestReg, P4DestReg);	
	Register1bit P4r3  (clk, reset, regWrite, RegWrite, P4RegWrite);	
	Register1bit P4r4  (clk, reset, regWrite, MemToReg, P4MemToReg);	
endmodule
/*
module forwardUnit ( input P3_regwrite, P4_regwrite, input [2:0] P3_Rd, P2_Rs, P2_Rt, P4_Rd, output reg [1:0] forA, forB);
  always @ (P3_regwrite, P3_Rd, P2_Rs, P2_Rt, P4_Rd, P4_regwrite)
    begin 
      if((P3_regwrite == 1) && (P3_Rd == P2_Rs))
      begin 
        if(P3_Rd == P2_Rs)
        begin P3_Rd =     
      end
  
      if((P3_regwrite == 1) && (P3_Rd == P2_Rt))
      begin forB = 2'b01; end   
      
      if((P4_regwrite == 1) && (P4_Rd == P2_Rs))
      begin forA = 2'b10; end

  
      if((P4_regwrite == 1) && (P4_Rd == P2_Rt))
      begin forB = 2'b10; end
    end
endmodule
*/

module forwardUnit ( input P3_regwrite, P4_regwrite, input [2:0] P3_Rd, P2_Rs, P2_Rt, P4_Rd, output reg [1:0] forA, forB);
  always @ (P3_regwrite, P3_Rd, P2_Rs, P2_Rt, P4_Rd, P4_regwrite)
    begin 
     
      if((P3_regwrite == 1) && (P3_Rd == P2_Rs))
      begin forA = 2'b10; end
    else if(((P4_regwrite == 1) && (P4_Rd == P2_Rs)) )
      begin forA = 2'b01; end
  else
      begin forA = 2'b00; end
      
   if((P3_regwrite == 1) && (P3_Rd == P2_Rt))
      begin forB = 2'b10; end   
    else if(((P4_regwrite == 1) && (P4_Rd == P2_Rt)) )
      begin forB = 2'b01; end
      else
        begin forB = 2'b00; end
      
        
      
    end
endmodule



  module mux_2to1_7bit(input [6:0] CtrlSignal, OtherSignal, input sel, output reg [6:0] Out);
    always @ (CtrlSignal, OtherSignal, sel)
    begin
      case(sel)
        1'b0: Out = CtrlSignal;
        1'b1: Out = OtherSignal;
      endcase
    end
  endmodule



  module mux_4to1_16bit(input [15:0] Bus, EX_MEM, MEM_WB,in4, input [1:0] sel, output reg [15:0] Out);
    always @ (Bus, EX_MEM, MEM_WB, sel)
    begin
      case(sel)
        2'b00: Out = Bus;
        2'b10: Out = EX_MEM;
        2'b01: Out = MEM_WB;
        2'b11: Out = in4;
      endcase
    end
  endmodule



  module hazard( input P2_memrd, input [2:0] P2_Rt, P1_Rs, P1_Rt, output reg PCwrite, output reg P1_regwrite, output reg CtrlSig);
    always @ ( P2_memrd, P2_Rt, P1_Rs, P1_Rt)
    begin
      if((P2_memrd == 1)&&((P2_Rt == P1_Rs) || (P2_Rt == P1_Rt)))
      begin PCwrite = 1'b0; P1_regwrite = 1'b0; CtrlSig = 1'b1; end
      else
      begin PCwrite = 1'b1; P1_regwrite = 1'b1; CtrlSig = 1'b0; end
    end
  endmodule   

module CtrlCkt(input reset, input [15:0] IR, output reg ALUSrcB, output reg ALUOp, output reg RegDst, output reg MemRead, output reg MemWrite, output reg MemToReg, output reg RegWrite);
	always@(IR or reset)
	begin
		if(IR==16'd0||reset==1)
			begin	ALUSrcB=0;  ALUOp=0; RegDst=0; MemRead=0; MemWrite=0; MemToReg=0; RegWrite=0;	end
		else
			begin
				case(IR[15:14])
					2'b00:	begin	ALUSrcB=1;  ALUOp=0; RegDst=0; MemRead=1; MemWrite=0; MemToReg=1; RegWrite=1;	end
					2'b01:	begin	ALUSrcB=1;  ALUOp=0; RegDst=0; MemRead=0; MemWrite=1; MemToReg=0; RegWrite=0;	end
					2'b10:	begin	ALUSrcB=1;  ALUOp=0; RegDst=0; MemRead=0; MemWrite=0; MemToReg=0; RegWrite=1;	end
					2'b11:	begin
									ALUSrcB=0;  RegDst=1; MemRead=0; MemWrite=0; MemToReg=0; RegWrite=1;
									case(IR[0])
										1'b0:	ALUOp=0;	1'b1:	ALUOp=1;
									endcase
								end
				endcase
			end
	end
endmodule

module PCadder(input [15:0] in, output reg [15:0] out);
	always@(in)
		out=in+2;
endmodule

module TopModule(input clk, input reset, output [15:0] RegWriteData);
	
	wire [15:0] PC, PCplus2;
	wire [15:0] IR, P1_IR;
	
	wire ALUSrcB, ALUOp, RegDst, MemRead, MemWrite, MemToReg, RegWrite;
	wire [15:0] BusA, BusB, SignExtOut;
	wire [15:0] P2_BusA, P2_BusB, P2_SignExtOut;
	wire [2:0] P2_rt, P2_rd, P2_rs;
	wire P2_ALUSrcB, P2_ALUOp, P2_RegDst, P2_MemRead, P2_MemWrite, P2_MemToReg, P2_RegWrite;

	wire [15:0] ALUIn2, ALUOut;
	wire [2:0] DestReg;
	wire [15:0] P3_ALUOut, P3_BusB;
	wire [2:0] P3_DestReg;
	wire P3_MemRead, P3_MemWrite, P3_MemToReg, P3_RegWrite;
				
	wire [15:0] DMOut, P4_ALUOut, P4_DMOut;
	wire [2:0] P4_DestReg;
	wire P4_RegWrite, P4_MemToReg;
	wire PCwrite;
	wire IF_IDregwrite;
	wire CtrlSig;
	wire [6:0] Ctrloutput;
	wire [1:0] forA, forB;
	wire [15:0] forAOut, forBOut;
	
	Register16bit PC0 (clk, reset, PCwrite, PCplus2, PC);
	//Register16bit PC0 (clk, reset, 1'b1, PCplus2, PC);	
	PCadder PCA0 (PC, PCplus2);	
	/*
	IM Instantiation for Lab05
	*/
	Memory IM0(clk, reset, 16'h0102,16'hC940,16'hA306,16'hDA81,16'h6C0E,16'hD980,16'h2E00,16'hB5FE, 1'b0, 1'b1, PC, 16'd0, IR[7:0], IR[15:8]);	
	
	/* IM Instantiation for Lab04 */
	//Memory IM0(clk, reset, 16'h0A00F,16'h310E,16'h9207,16'hE5C1,16'h600C,16'hE480,16'hC160,16'h0000, 1'b0, 1'b1, PC, 16'd0, IR[7:0], IR[15:8]);
	IF_ID_PipelineRegister P1(clk, reset, IF_IDregwrite, IR, P1_IR);
	//IF_ID_PipelineRegister P1(clk, reset, 1'b1, IR, P1_IR);
  
  hazard HZ(P2_MemRead, P2_rt, P1_IR[13:11], P1_IR[10:8], PCwrite, IF_IDregwrite, CtrlSig);

	CtrlCkt CC0(reset, P1_IR, ALUSrcB, ALUOp, RegDst, MemRead, MemWrite, MemToReg, RegWrite);
	mux_2to1_7bit MCtrl({ALUSrcB, ALUOp, RegDst, MemRead, MemWrite, MemToReg, RegWrite}, 7'b0000000, CtrlSig, Ctrloutput);
	RegisterFile rF(clk, reset, P4_RegWrite, P1_IR[13:11], P1_IR[10:8], P4_DestReg, RegWriteData, BusA, BusB);
	SignExt8to16 SE(P1_IR[7:0], SignExtOut);
	//ID_EX_PipelineRegister P2(clk, reset, 1'b1, BusA, BusB, SignExtOut, P1_IR[10:8], P1_IR[7:5], ALUSrcB, ALUOp, RegDst, MemRead, MemWrite, MemToReg, RegWrite, P2_BusA, P2_BusB, P2_SignExtOut, P2_rt, P2_rd, P2_ALUSrcB, P2_ALUOp, P2_RegDst, P2_MemRead, P2_MemWrite, P2_MemToReg, P2_RegWrite);
	ID_EX_PipelineRegister P2(clk, reset, 1'b1, BusA, BusB, SignExtOut, P1_IR[10:8], P1_IR[7:5], P1_IR[13:11], Ctrloutput[6], Ctrloutput[5], Ctrloutput[4], Ctrloutput[3], Ctrloutput[2], Ctrloutput[1], Ctrloutput[0], P2_BusA, P2_BusB, P2_SignExtOut, P2_rt, P2_rd, P2_rs, P2_ALUSrcB, P2_ALUOp, P2_RegDst, P2_MemRead, P2_MemWrite, P2_MemToReg, P2_RegWrite);
		
	forwardUnit FU( P3_RegWrite, P4_RegWrite, P3_DestReg, P2_rs, P2_rt, P4_DestReg, forA, forB);	
	mux_4to1_16bit MforA(P2_BusA, P3_ALUOut, RegWriteData,16'd0, forA, forAOut);
	mux_4to1_16bit MforB(P2_BusB, P3_ALUOut, RegWriteData,16'd0, forB, forBOut);
	Mux2to1_16bits m21_16_0(forBOut, P2_SignExtOut, P2_ALUSrcB, ALUIn2);		
	Mux2to1_3bits m21_3_0(P2_rt, P2_rd, P2_RegDst, DestReg);	
	ALU alu(forAOut, ALUIn2, P2_ALUOp, ALUOut);
	EX_MEM_PipelineRegister P3(clk, reset, 1'b1, ALUOut, forBOut, DestReg, P2_MemRead, P2_MemWrite, P2_MemToReg, P2_RegWrite, P3_ALUOut, P3_BusB, P3_DestReg, P3_MemRead, P3_MemWrite,P3_MemToReg,P3_RegWrite);	

	/*
	DM Instantiation for Lab05
	*/
	Memory DM(clk, reset, 16'h000C,16'h0002,16'h0003,16'h0004,16'h0005,16'h0006,16'h0007,16'h0008, P3_MemWrite, P3_MemRead, P3_ALUOut, P3_BusB, DMOut[7:0], DMOut[15:8]);
	
	/* DM Instantiation for Lab04 */
	//Memory DM(clk, reset, 16'h0001,16'h0002,16'h0003,16'h0004,16'h0005,16'h0006,16'h0007,16'h0008, P3_MemWrite, P3_MemRead, P3_ALUOut, P3_BusB, DMOut[7:0], DMOut[15:8]);
	MEM_WB_PipelineRegister P4(clk, reset, 1'b1, P3_ALUOut, DMOut, P3_DestReg, P3_RegWrite, P3_MemToReg, P4_ALUOut, P4_DMOut, P4_DestReg, P4_RegWrite, P4_MemToReg);
	Mux2to1_16bits m16_1(P4_ALUOut, P4_DMOut, P4_MemToReg, RegWriteData);
	
endmodule	

module testBenchHazard;
reg clk, reset;
wire [15:0] RegWriteData;
TopModule uut (.clk(clk), .reset(reset), .RegWriteData(RegWriteData));
always
#5 clk=~clk;
initial begin
clk = 0; reset = 1; 
#10 reset=0;
#130 $finish;
end
endmodule
