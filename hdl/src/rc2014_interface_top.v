`default_nettype none

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
    input BUT1,
    output EX7,
	output uart_tx,
	input clk,
	input greset
    //     // External RAM
    // output        RAMWE_b,
    // output        RAMOE_b,
    // output RAMCS_b,
    // output [17:0] ADR,
    // inout [7:0] DAT,
    );

reg [23:0] led_countdown = 0;
reg ce = 0;

// assign ce = !MRQ && A[15:0] >= 16'h8000;

rom blockram(.clk(CLK), 
  .ce(1),
  .addr(A[12:0]), 
  .rdata(data_out));

reg [7:0] data_in;
reg [7:0] data_out;

// SB_IO #(
//   .PIN_TYPE(6'b 1010_01),
//   .PULLUP(1'b 0)
// ) led_io[7:0] (
//   .PACKAGE_PIN(D[0]),
//   .OUTPUT_ENABLE(DATA_DIR),
//   .D_OUT_0(data_out),
//   .D_IN_0(data_in)
// );

reg [15:0] lastknownaddress = 0;

// !WR &&  && a[7:0] == 8'hC0
always @(posedge CLK)
begin
    ce = (A > 16'hFFFF) && !MRQ && !WR;

    if ((ce || !BUT1) && led_countdown == 0)
    begin
      led_countdown <= 24'hFFFFFF;
    end
    else if(led_countdown > 0)
    begin
      led_countdown <= led_countdown -1;
    end

	if (ce)
	begin
		lastknownaddress <= D;
	end
    // DATA_DIR = (!MRQ && A >= 16'h8000) && WR && !RD ? 1 : 0;

    // RAMWE_b = !WR;
    // RAMOE_b = !RD;
    // RAMCS_b = cs;
    // ADR = A;
    // DAT = D;
    // 0 = input, 1 = output
    // DATA_DIR = ce && !MRQ && WR && !RD ? 1 : 0;
    DATA_DIR = 0; //ce;
    EX7 = 0; //!ce;
end
// 0 when !WR && RD, 1 when WR && !RD
assign LED1 = led_countdown > 0;
assign ADDR_DIR = 0;
assign SIG_DIR = 0;
assign SIG2_DIR = 0;
// assign DATA_DIR = ce && WR && !RD ? 1 : 0;
	

	wire reset;

	reg [26:0]	count;
	
	always @(posedge clk)
	begin
		if (reset) begin
			count 	<= 0;
		end
		else begin
			count	<= count + 1;
		end
	end


	reg [7:0] 	text[0:7];
	reg [3:0]	text_cntr;

	reg 		tx_req;
	reg [7:0]	tx_data;
	wire		tx_ready;

	reg [7:0] asciidigits [0:3];

	// stringy str_inst(.clk(clk), .inputnumber(A[3:0]), .ascii(asciidigits[0]));
	// stringy str2(.clk(clk), .inputnumber(A[7:4]), .ascii(asciidigits[1]));
	// stringy str3(.clk(clk), .inputnumber(A[11:8]), .ascii(asciidigits[2]));
	// stringy str4(.clk(clk), .inputnumber(A[15:12]), .ascii(asciidigits[3]));

	always @(posedge clk) begin
		if (reset) begin
			text[0]  <= "0";
			text[1]  <= "x";
			text[2]  <= "_";
			text[3]  <= "_";
			text[4]  <= "_";
			text[5]  <= "_";
			text[6] <= "\n";
			text[7] <= 'h0d;
			
			text_cntr	<= 0;
			tx_req		<= 1'b0;

			asciidigits[0] <= "s";
			asciidigits[1] <= "c";
			asciidigits[2] <= "r";
			asciidigits[3] <= "w";

		end
		else if (text_cntr == 0) begin
			// asciidigits[0] <= "e";

			text[2]  <= asciidigits[3];
			text[3]  <= asciidigits[2];
			text[4]  <= asciidigits[1];
			text[5]  <= asciidigits[0];

			tx_req		<= 1'b0;

			if (count == 26'h50000) begin

				case (lastknownaddress[3:0])
					4'h0: asciidigits[0] <= "0";
					4'h1: asciidigits[0] <= "1";
					4'h2: asciidigits[0] <= "2";
					4'h3: asciidigits[0] <= "3";
					4'h4: asciidigits[0] <= "4";
					4'h5: asciidigits[0] <= "5";
					4'h6: asciidigits[0] <= "6";
					4'h7: asciidigits[0] <= "7";
					4'h8: asciidigits[0] <= "8";
					4'h9: asciidigits[0] <= "9";
					4'hA: asciidigits[0] <= "A";
					4'hB: asciidigits[0] <= "B";
					4'hC: asciidigits[0] <= "C";
					4'hD: asciidigits[0] <= "D";
					4'hE: asciidigits[0] <= "E";
					4'hF: asciidigits[0] <= "F";
					default: asciidigits[0] <= "Z";
				endcase

				case (lastknownaddress[7:4])
					4'h0: asciidigits[1] <= "0";
					4'h1: asciidigits[1] <= "1";
					4'h2: asciidigits[1] <= "2";
					4'h3: asciidigits[1] <= "3";
					4'h4: asciidigits[1] <= "4";
					4'h5: asciidigits[1] <= "5";
					4'h6: asciidigits[1] <= "6";
					4'h7: asciidigits[1] <= "7";
					4'h8: asciidigits[1] <= "8";
					4'h9: asciidigits[1] <= "9";
					4'hA: asciidigits[1] <= "A";
					4'hB: asciidigits[1] <= "B";
					4'hC: asciidigits[1] <= "C";
					4'hD: asciidigits[1] <= "D";
					4'hE: asciidigits[1] <= "E";
					4'hF: asciidigits[1] <= "F";
					default: asciidigits[1] <= "Z";
				endcase

				case (lastknownaddress[11:8])
					4'h0: asciidigits[2] <= "0";
					4'h1: asciidigits[2] <= "1";
					4'h2: asciidigits[2] <= "2";
					4'h3: asciidigits[2] <= "3";
					4'h4: asciidigits[2] <= "4";
					4'h5: asciidigits[2] <= "5";
					4'h6: asciidigits[2] <= "6";
					4'h7: asciidigits[2] <= "7";
					4'h8: asciidigits[2] <= "8";
					4'h9: asciidigits[2] <= "9";
					4'hA: asciidigits[2] <= "A";
					4'hB: asciidigits[2] <= "B";
					4'hC: asciidigits[2] <= "C";
					4'hD: asciidigits[2] <= "D";
					4'hE: asciidigits[2] <= "E";
					4'hF: asciidigits[2] <= "F";
					default: asciidigits[2] <= "Z";
				endcase

				case (lastknownaddress[15:12])
					4'h0: asciidigits[3] <= "0";
					4'h1: asciidigits[3] <= "1";
					4'h2: asciidigits[3] <= "2";
					4'h3: asciidigits[3] <= "3";
					4'h4: asciidigits[3] <= "4";
					4'h5: asciidigits[3] <= "5";
					4'h6: asciidigits[3] <= "6";
					4'h7: asciidigits[3] <= "7";
					4'h8: asciidigits[3] <= "8";
					4'h9: asciidigits[3] <= "9";
					4'hA: asciidigits[3] <= "A";
					4'hB: asciidigits[3] <= "B";
					4'hC: asciidigits[3] <= "C";
					4'hD: asciidigits[3] <= "D";
					4'hE: asciidigits[3] <= "E";
					4'hF: asciidigits[3] <= "F";
					default: asciidigits[3] <= "Z";
				endcase


				tx_req		<= 1'b1;
				tx_data		<= text[text_cntr];
				text_cntr	<= text_cntr + 1;
			end
		end
		else if (tx_ready) begin
			tx_req		<= 1'b1;
			tx_data		<= text[text_cntr];
			text_cntr	<= text_cntr + 1;

			if (text_cntr == 7) begin
				text_cntr	<= 0;
			end
			else begin
				text_cntr	<= text_cntr + 1;
			end
		end
	end


	sync_reset u_sync_reset(
		.clk(clk),
		.reset_in(greset),
		.reset_out(reset)
	);

	uart_tx u_uart_tx (
		.clk (clk),
		.reset (reset),
		.tx_req(tx_req),
		.tx_ready(tx_ready),
		.tx_data(tx_data),
		.uart_tx(uart_tx)
	);

endmodule
