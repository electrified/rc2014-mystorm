module rom(input clk, 
input ce, 
input [12:0] addr, // we discard the higher lines so this value will be 0 - 0x2000
output reg [7:0] rdata);
    initial begin
        $readmemh("src/bas.hex", mem);
    end

    reg [7:0] mem [0:'h2000];
    always @(posedge clk) begin
        if (ce)
        begin
            rdata <= mem[addr];
        end
    end
endmodule