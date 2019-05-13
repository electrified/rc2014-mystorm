`default_nettype none

module rc2014_interface_top(
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
    input BUT1,
    input fpga_clk
    );

assign SIG_DIR = 0;
assign SIG2_DIR = 0;
assign DATA_DIR = 1;
assign ADDR_DIR = RD;

reg [31:0] led_countdown = 0;
wire led_track;
 
reg [7:0] request_counter =0;
reg ce = 0;

reg [7:0] romval;

rom blockram(.clk(CLK), 
  .ce(1),
  .addr(A[12:0]), 
  .rdata(romval));

reg debounced_CLK;

debouncer clockdebouncer(
  .CLK(fpga_clk),
  .raw_input(CLK),
  .state(debounced_CLK)
);

reg debounced_RD;

debouncer RDdebouncer(
  .CLK(fpga_clk),
  .raw_input(RD),
  .state(debounced_RD)
);

reg debounced_BUT1;

debouncer BUT1debouncer(
  .CLK(CLK),
  .raw_input(BUT1),
  .state(debounced_BUT1)
);


always @(posedge debounced_BUT1)
begin
    // ce = (A >= 16'h0000 && A < 16'h2000) && !MRQ;
  // if (BUT1 == 1'b0)
  //    begin
        // led_countdown <= 0;
	      // // led_track <= 1'b0;
        led_track <= ~led_track;
    //  end
end

assign LED1 = led_track;
endmodule
