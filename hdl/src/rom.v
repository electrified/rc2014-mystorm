module rom(input clk, 
input ce, 
input [12:0] addr,
output reg [7:0] rdata);
    initial begin
        $readmemh("src/bas.hex", mem);
    end

    reg [7:0] mem [0:8191];
    always @(posedge clk) begin
        if (ce)
        begin
            rdata <= mem[addr];
        end
    end
endmodule