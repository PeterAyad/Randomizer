module lfsr (out, clk, reset, xor1 , en, load, seed);

  output reg [14:0] out;
  output xor1;
  input clk, reset,en,load;
  input [14:0] seed;

  assign xor1 = (out[14] ^ out[13]);
  
  always @ (posedge clk) begin
    if(en === 1'b1) begin
        out[14:1] <= out[13:0];
        out[0] <= xor1;
      end
    else if(load === 1'b1) begin
      out[14:0] <= seed[14:0];
      end
  end
  always @ (posedge reset) begin
      out <= 15'b101010001110110; 
  end
endmodule

module prbs (out, clk, reset, xor1 , en, load, seed, in, xor2, hexoutput);

  input in,clk,reset,en,load;
  output wire [14:0] out;
  input [14:0] seed;
  output xor1,xor2;
  output wire [3:0] hexoutput;
  
  reg [3:0] r_reg;
  wire [3:0] r_next;
  
  lfsr lf (out, clk, reset, xor1 ,en,load,seed);
  
  assign xor2 = (xor1 ^ in);
 
  always @(posedge clk)
         r_reg <= r_next;
	
  always @(posedge reset)
         r_reg <= 0;
	
 
  assign r_next = {xor2, r_reg[3:1]};
  assign hexoutput[3] = r_reg[0];
  assign hexoutput[2] = r_reg[1];
  assign hexoutput[1] = r_reg[2];
  assign hexoutput[0] = r_reg[3];
  
endmodule
    
//test cases auto-input
module test (clk,in);

  input clk;
  output reg in;
  reg [3:0] tests [23:0];
  integer i,j;
  
  initial begin
  i=0;
  j=1;
  tests[0]=4'ha;
  tests[1]=4'hc;
  tests[2]=4'hb;
  tests[3]=4'hc;
  tests[4]=4'hd;
  tests[5]=4'h2;
  tests[6]=4'h1;
  tests[7]=4'h1;
  tests[8]=4'h4;
  tests[9]=4'hd;
  tests[10]=4'ha;
  tests[11]=4'he;
  tests[12]=4'h1;
  tests[13]=4'h5;
  tests[14]=4'h7;
  tests[15]=4'h7;
  tests[16]=4'hc;
  tests[17]=4'h6;
  tests[18]=4'hd;
  tests[19]=4'hb;
  tests[20]=4'hf;
  tests[21]=4'h4;
  tests[22]=4'hc;
  tests[23]=4'h9;
  in = tests[0][3];
  end
  
  always @ (posedge clk) begin
    if(j === 3)begin
      in <= tests[i][3-j];
      i<= i+1;
      j<=0;
    end
    else begin
      in <= tests[i][3-j];
      j<=j+1;
    end
  end

endmodule

//reversed shift register
module shiftReg(clk,reset,in,out);
    input wire clk, reset;
    input wire in;
    output wire [3:0] out;
 
  reg [3:0] r_reg;
  wire [3:0] r_next;
 
  always @(posedge clk, posedge reset)
   begin
      if (reset)
         r_reg <= 0;
      else
         r_reg <= r_next;
	end	
 
  assign r_next = {in, r_reg[3:1]};
  assign out[3] = r_reg[0];
  assign out[2] = r_reg[1];
  assign out[1] = r_reg[2];
  assign out[0] = r_reg[3];
 
endmodule