`default_nettype none

module vga_mem(
    input [15:0] A,
    output [7:0] D,
    input RD,
    input M1,
    input CLK,
    input MRQ,
    input IORQ,
    input RST,
    input INT,
    input WR,
    output ADDR_DIR,
    output SIG_DIR,
    output DATA_DIR,
    output SIG2_DIR,
    output LED1,
    input BUT1,
    );

reg [15:0] led_countdown = 0;
reg ce = 0;

rom blockram(.clk(CLK), 
  .ce(1),
  .addr(A[12:0]), 
  .rdata(D));

always @(posedge CLK)
begin
    ce = (A >= 16'h0000 && A < 16'h1000) && !MRQ;        

    if ((ce || !BUT1) && led_countdown == 0)
    begin
      led_countdown <= 16'hFFFF;
    end
    else if(led_countdown > 0)
    begin
      led_countdown <= led_countdown -1;
    end
end


assign LED1 = led_countdown > 0;

// assign D = 8'hAA;
assign SIG_DIR = 0;
assign SIG2_DIR = 0;
assign DATA_DIR = 1;
assign ADDR_DIR = 0;
endmodule
