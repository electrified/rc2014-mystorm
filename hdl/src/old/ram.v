module ram(input clk, 
input wen,
input ce, 
input [16:0] addr, 
input [7:0] wdata, 
output reg [7:0] rdata);
    // initial begin
    //     $readmemh("flag.txt", mem);
    // end

    reg [7:0] mem [0:16383];
    // initial mem[0] = 255;
    always @(posedge clk) begin
        if (ce)
        begin
            if (wen) 
                mem[addr] <= wdata;
            rdata <= mem[addr];
        end
    end
endmodule