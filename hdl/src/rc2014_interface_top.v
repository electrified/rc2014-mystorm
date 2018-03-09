module vga_mem(
    input [15:0] A,
    inout [7:0] D,
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
    //     // External RAM
    // output        RAMWE_b,
    // output        RAMOE_b,
    // output RAMCS_b,
    // output [17:0] ADR,
    // inout [7:0] DAT,
    );

reg [23:0] led_countdown = 0;
// reg ce;

// assign ce = !MRQ && A[15:0] >= 16'h8000;

ram blockram(.clk(CLK), 
.ce(ce),
.wen(!WR), 
.addr(A[15:0] - 16'h8000), 
.rdata(data_out),
.wdata(data_in));

reg [7:0] data_in;
reg [7:0] data_out;

SB_IO #(
  .PIN_TYPE(6'b 1010_01),
  .PULLUP(1'b 0)
) led_io[7:0] (
  .PACKAGE_PIN(D),
  .OUTPUT_ENABLE(DATA_DIR),
  .D_OUT_0(data_out),
  .D_IN_0(data_in)
);

// !WR &&  && a[7:0] == 8'hC0
always @(posedge CLK)
begin
    if (((!WR && !MRQ && A >= 16'h8000) || !BUT1) && led_countdown == 0)
    begin
      led_countdown <= 24'hFFFFFF;
    end
    else if(led_countdown > 0)
    begin
      led_countdown <= led_countdown -1;
    end

    // DATA_DIR = (!MRQ && A >= 16'h8000) && WR && !RD ? 1 : 0;
    ce = !MRQ && A >= 16'h8000;
    // RAMWE_b = !WR;
    // RAMOE_b = !RD;
    // RAMCS_b = cs;
    // ADR = A;
    // DAT = D;
    DATA_DIR = cs && WR && !RD ? 1 : 0;
end
// 0 when !WR && RD, 1 when WR && !RD
assign LED1 = led_countdown > 0;
assign ADDR_DIR = 0;
assign SIG_DIR = 0;
assign SIG2_DIR = 0;
// assign DATA_DIR = ce && WR && !RD ? 1 : 0;
endmodule
