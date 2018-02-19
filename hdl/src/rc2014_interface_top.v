module vga_mem(
    input [15:0] A,
    input [7:0] D,
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
    input BUT1
    );

reg [20:0] led_countdown = 0;

// !WR &&  && a[7:0] == 8'hC0
always @(posedge CLK)
begin
    if (((!WR && !IORQ && A[7:0] == 8'hc0) || !BUT1) && led_countdown == 0)
    begin
      led_countdown <= 21'hFFFFFF;
      value <= d;
    end
    else if(led_countdown > 0)
    begin
      led_countdown = led_countdown -1;
    end
end

assign LED1 = led_countdown > 0;
assign ADDR_DIR = 0;
assign SIG_DIR = 0;
assign SIG2_DIR = 0;
assign DATA_DIR = 0;
endmodule
