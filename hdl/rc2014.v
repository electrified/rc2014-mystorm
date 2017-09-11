module rc2014 (
input iorq,
input wr,
input a0,
input a1,
input a2,
input a3,
input a4,
input a5,
input a6,
input a7,
input d0,
input d1,
input d2,
input d3,
input d4,
input d5,
input d6,
input d7
);
// input iorq;
// input wr;
// input a0;
// input a1;
// input a2;
// input a3;
// input a4;
// input a5;
// input a6;
// input a7;
// input d0;
// input d1;
// input d2;
// input d3;
// input d4;
// input d5;
// input d6;
// input d7;

//when write and iorq
//read address
//ligth leds based on address
//latch for period of time so can see
always @(posedge clk)
    count <= count + 1;
endmodule
