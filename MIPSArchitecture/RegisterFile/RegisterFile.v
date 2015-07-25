//DFF
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

//32 bit register  
  module register32bit( input clk, input reset, input regWrite, input decOut1b, input [31:0] writeData,  output  [31:0] outR );    
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


  module registerSet( input clk, input reset, input regWrite, input [7:0] decOut, input [31:0] writeData,    output [31:0] outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7 );  
    register32bit R0(clk,reset,regWrite,decOut[0],writeData,outR0);
    register32bit R1(clk,reset,regWrite,decOut[1],writeData,outR1);
    register32bit R2(clk,reset,regWrite,decOut[2],writeData,outR2);
    register32bit R3(clk,reset,regWrite,decOut[3],writeData,outR3);
    register32bit R4(clk,reset,regWrite,decOut[4],writeData,outR4);
    register32bit R5(clk,reset,regWrite,decOut[5],writeData,outR5);
    register32bit R6(clk,reset,regWrite,decOut[6],writeData,outR6);
    register32bit R7(clk,reset,regWrite,decOut[7],writeData,outR7);
  endmodule
    
  module decoder( input [2:0] destReg, output reg [7:0] decOut);  
    always @ (*)
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
    
  module mux8to1( input [31:0] outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7,   input [2:0] Sel, output reg [31:0] outBus );   
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
  
  module registerFile(input clk, input reset, input regWrite, input [2:0] srcRegA, input [2:0] srcRegB,  input [2:0] destReg,  input [31:0] writeData, output [31:0] outBusA, output [31:0] outBusB ); 
    wire [7:0] decOut;
    wire [31:0] outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7;
    decoder Dec (destReg, decOut);
    registerSet RSet (clk,reset,regWrite,decOut,writeData,outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7); 
    mux8to1 Mux1 (outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7,srcRegA,outBusA);
    mux8to1 Mux2 (outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7,srcRegB,outBusB);
  endmodule
  
module test_registerFile( );     
  //inputs     
  reg clk,reset,regWrite;     
  reg [2:0] srcRegA,srcRegB,destReg;     
  reg [31:0] writeData;     
  //outputs     
  wire [31:0] outBusA;     
  wire [31:0] outBusB;     
  registerFile uut(clk,reset,regWrite,srcRegA,srcRegB,destReg,writeData,outBusA,outBusB);          
  always 
    begin 
      #5 clk=~clk; 
    end          
    initial     
      begin 
        clk=0; 
        reset=1; 
        srcRegA=5'd0; 
        srcRegB=5'd0;     
        
        #5 reset=0; 
        regWrite=1; 
        destReg=3'd0; 
        writeData=32'd8;     
        
        #10 destReg=3'd1; 
        writeData=32'd7;     
        
        #10 destReg=3'd2; 
        writeData=32'd6;     
        
        #10 destReg=3'd3; 
        writeData=32'd5;     
        
        #10 destReg=3'd4; 
        writeData=32'd4;     
        
        #10 destReg=3'd5; 
        writeData=32'd3;     
        
        #10 destReg=3'd6; 
        writeData=32'd2;     
        
        #10 destReg=3'd7; 
        writeData=32'd1;     
        
        #10 regWrite=0; 
        srcRegA=5'd7; 
        srcRegB=5'd6;     
        
        #10 srcRegA=5'd5; 
        srcRegB=5'd4;     
        
        #10 srcRegA=5'd3; 
        srcRegB=5'd2;     
        
        #10 srcRegA=5'd1; 
        srcRegB=5'd0;     
        
        #10 $finish;     
      end 
    endmodule 