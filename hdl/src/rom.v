`default_nettype none

module rom(input clk, 
input ce, 
input [15:0] addr,
output reg [7:0] rdata);
    initial begin
        $readmemh("src/test_programs/test.out", mem);
        // $readmemh("src/bas.hex", mem);
    end

    reg [7:0] mem [0:16'h2000];
    always @(posedge clk) begin
        if (ce)
        begin
            rdata <= mem[addr];
        end
    end
endmodule