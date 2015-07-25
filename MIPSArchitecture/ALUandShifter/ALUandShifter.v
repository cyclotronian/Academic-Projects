//ALU
module alu( input [31:0] rs, input [31:0] rt, input [2:0] opCode, output reg [31:0] aluOut);
  always @ (rs,rt,opCode)
    case(opCode)
      3'b000: aluOut = 0; 
      3'b001: aluOut = rt + rs;
      3'b010: aluOut = rs - rt;
      3'b011: aluOut = rt & rs;
      3'b100: aluOut = rt | rs;
      3'b101: aluOut = ~rs;
    endcase
  endmodule
  
//MUX 2:1
module mux2to1( input [2:0] in0, input [2:0] in1, input sel, output reg [2:0] muxOut);
  always @ (in0, in1, sel)
    case (sel)
      1'b0: muxOut = in0;
      1'b1: muxOut = in1;
    endcase
  endmodule
  
//MUX 8:1
module mux8to1( input in0, input in1, input in2, input in3, input in4, input in5, input [2:0] sel, output reg muxOut);
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
  
//Shifter
module shifter8bits( input [7:0] rs, input [2:0] opCode, input [2:0] shiftAmt, output [7:0] shiftOut);
  wire [2:0] sel1, sel2, sel3;
  wire [7:0] out1, out2;
  
  mux2to1 S1(3'b000,opCode,shiftAmt[0],sel1); 
  mux2to1 S2(3'b000,opCode,shiftAmt[1],sel2);
  mux2to1 S3(3'b000,opCode,shiftAmt[2],sel3);
      
  mux8to1  M10 (rs[7],rs[7],1'b0,rs[0],rs[6],rs[6],sel1,out1[7]);
  mux8to1  M11 (rs[6],rs[7],rs[7],rs[7],rs[5],rs[5],sel1,out1[6]);
  mux8to1  M12 (rs[5],rs[6],rs[6],rs[6],rs[4],rs[4],sel1,out1[5]);
  mux8to1  M13 (rs[4],rs[5],rs[5],rs[5],rs[3],rs[3],sel1,out1[4]);
  mux8to1  M14 (rs[3],rs[4],rs[4],rs[4],rs[2],rs[2],sel1,out1[3]);
  mux8to1  M15 (rs[2],rs[3],rs[3],rs[3],rs[1],rs[1],sel1,out1[2]);
  mux8to1  M16 (rs[1],rs[2],rs[2],rs[2],rs[0],rs[0],sel1,out1[1]);
  mux8to1  M17 (rs[0],rs[1],rs[1],rs[1],1'b0,rs[7],sel1,out1[0]); 
  
  mux8to1  M20 (out1[7],out1[7],1'b0,out1[1],out1[5],out1[5],sel2,out2[7]);  
  mux8to1  M21 (out1[6],out1[7],1'b0,out1[0],out1[4],out1[4],sel2,out2[6]); 
  mux8to1  M22 (out1[5],out1[7],out1[7],out1[7],out1[3],out1[3],sel2,out2[5]); 
  mux8to1  M23 (out1[4],out1[6],out1[6],out1[6],out1[2],out1[2],sel2,out2[4]); 
  mux8to1  M24 (out1[3],out1[5],out1[5],out1[5],out1[1],out1[1],sel2,out2[3]); 
  mux8to1  M25 (out1[2],out1[4],out1[4],out1[4],out1[0],out1[0],sel2,out2[2]); 
  mux8to1  M26 (out1[1],out1[3],out1[3],out1[3],1'b0,out1[7],sel2,out2[1]); 
  mux8to1  M27 (out1[0],out1[2],out1[2],out1[2],1'b0,out1[6],sel2,out2[0]);
  
  mux8to1  M30 (out2[7],out2[7],1'b0,out2[3],out2[3],out2[3],sel3,shiftOut[7]);
  mux8to1  M31 (out2[6],out2[7],1'b0,out2[2],out2[2],out2[2],sel3,shiftOut[6]);
  mux8to1  M32 (out2[5],out2[7],1'b0,out2[1],out2[1],out2[1],sel3,shiftOut[5]);
  mux8to1  M33 (out2[4],out2[7],1'b0,out2[0],out2[0],out2[0],sel3,shiftOut[4]);
  mux8to1  M34 (out2[3],out2[7],out2[7],out2[7],1'b0,out2[7],sel3,shiftOut[3]);
  mux8to1  M35 (out2[2],out2[6],out2[6],out2[6],1'b0,out2[6],sel3,shiftOut[2]);
  mux8to1  M36 (out2[1],out2[5],out2[5],out2[5],1'b0,out2[5],sel3,shiftOut[1]);
  mux8to1  M37 (out2[0],out2[4],out2[4],out2[4],1'b0,out2[4],sel3,shiftOut[0]);
endmodule

module signExtender( input [7:0] shiftOut, output reg [31:0] signExtOut);
  always @ (shiftOut)
    begin
    signExtOut = {{24{shiftOut[7]}},shiftOut[7:0]};
  end
endmodule
  
module zeroExtender( input [7:0] shiftOut, output reg [31:0] zeroExtOut);
  always @ (shiftOut)
    begin
    zeroExtOut = {{24{1'b0}},shiftOut[7:0]};
  end
endmodule

module mux4to1( input [31:0] zeroInput, input [31:0] ALUOut, input [31:0] signExtOut, input [31:0] zeroExtOut,input [1:0] selOut, output reg [31:0] finalOut);
  always @ (zeroInput, ALUOut, signExtOut, zeroExtOut, selOut)
    case(selOut)
      2'b00: finalOut = zeroInput;
      2'b01: finalOut = ALUOut;
      2'b10: finalOut = signExtOut;
      2'b11: finalOut = zeroExtOut;
    endcase
endmodule

module shifterAndAlu( input [31:0] rs, input [31:0] rt, input [2:0] opCode, input [1:0] selOut, output [31:0] finalOut);
  wire [31:0] aluOut, zeroInput, signExtOut, zeroExtOut;
  wire [7:0] shiftOut;
  
  assign zeroInput = 0;
  alu a1 (rs,rt,opCode,aluOut);
  shifter8bits s1 (rs,opCode,rt[2:0],shiftOut);  
  signExtender sE (shiftOut, signExtOut);
  zeroExtender zE (shiftOut, zeroExtOut);
  mux4to1 M (zeroInput, aluOut, signExtOut, zeroExtOut, selOut, finalOut);
endmodule
  
module testBench();
//inputs
reg [31:0] rs, rt;
reg [2:0] opCode;
reg [1:0] selOut;
//outputs
wire [31:0] finalOut;
shifterAndAlu uut( rs, rt, opCode, selOut, finalOut);
initial
begin rs=32'd17; rt=32'd3; opCode=3'd1; selOut=2'd0;
$monitor("rs = %d, rt = %d, opCode = %d, selOut = %d, finalOut = %d", rs,rt,opCode,selOut,finalOut);
#10 selOut=2'd1;
#10 selOut=2'd1; opCode=3'd2;
#10 selOut=2'd1; opCode=3'd3;
#10 selOut=2'd1; opCode=3'd4;
#10 selOut=2'd1; opCode=3'd5;
#10 selOut=2'd2; opCode=3'd1;
#10 selOut=2'd2; opCode=3'd2;
#10 selOut=2'd2; opCode=3'd3;
#10 selOut=2'd2; opCode=3'd4;
#10 selOut=2'd2; opCode=3'd5;
#10 selOut=2'd3; opCode=3'd1;
#10 selOut=2'd3; opCode=3'd2;
#10 selOut=2'd3; opCode=3'd3;
#10 selOut=2'd3; opCode=3'd4;
#10 selOut=2'd3; opCode=3'd5;
#10 $finish;
end
endmodule
  
  