module prbs_testBench;
  wire [14:0] out;
  reg [14:0] seed;
  wire [3:0] inputHex;
  wire [3:0] hexoutput;
  reg reset,clk,en,load;
  wire xor1,xor2,in;
  
  prbs p (out, clk, reset, xor1 ,en,load,seed,in,xor2,hexoutput);
  test t (clk,in);
  shiftReg s1 (clk,reset,in,inputHex);
  
always begin
  #5 clk<= ~clk;
end

always #40 $display("%g \t %b \t %b \t %b \t %b \t %h \t %h",$time,out,xor1,in,xor2,inputHex,hexoutput);
  
initial 
begin
  $display("time \t output-lfsr \t xor1 \t in-bin \t xor2 \t in-hex \t output-hex");
  clk = 0;
  reset =1;
  #2 reset =0;
  en=1;
  #980 $finish;
end
endmodule
