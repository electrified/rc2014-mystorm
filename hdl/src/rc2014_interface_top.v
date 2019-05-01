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
    input fpga_clk
    );

reg [15:0] led_countdown = 0;

reg [7:0] request_counter =0;
reg ce = 0;

// wire DATA_OE;
// assign ADDR_DIR = DATA_OE;

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

always @(posedge debounced_CLK)
begin
    ce = (A >= 16'h0000 && A < 16'h2000) && !MRQ;

    if ((ce || !BUT1) && led_countdown == 0)
    begin
      led_countdown <= 16'hFFFF;
    end
    else if(led_countdown > 0)
    begin
      led_countdown <= led_countdown -1;
    end

    case({MRQ, RD, WR})
    3'b001:
      begin
      // DATA_OE <= 0;
      D <= romval;
      end
    3'b101:
    begin
    //  DATA_OE <= 0;
     request_counter <= request_counter + 1;
     D <= request_counter;
    end
    default:
      begin
      // DATA_OE <= 1;
      D[7:0] = {8{1'bz}};
      end
    endcase
end

assign LED1 = led_countdown > 0;

// assign D = 8'hAA;
assign SIG_DIR = 0;
assign SIG2_DIR = 0;
assign DATA_DIR = 1;

// THIS IS ACTUALLY DATA_OE
assign ADDR_DIR = RD;//M1; //debounced_RD; //!(!RD && (!MRQ || !IORQ));  //ce; //0 == output
endmodule
