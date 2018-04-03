## Board to interface 3.3v FPGA board with RC2014

BOM

5x SN74LVCC3245ADW

LD1117S33TR

100nF 0805 capacitors

10μF 0805 capacitors


OE low = enable
dir rc ->fpga

objcopy -Iihex -Obinary nascom32k_hexloadr.hex out.bin

sigrok-cli --driver saleae-logic16 --config samplerate=20Mhz --channels 0=D0,1=D1,2=D2,3=D3,4=D4,5=D5,6=D6,7=D7,9=RD,10=WR,11=MREQ,13=M1 --samples 1M --output-file z80-fpga

Silkscreen blunders

On the fpga connector, silscreen for M1 and RD should be swapped


https://bitbucket.org/gdevic/a-z80/src/6d6bd4838181ea9e088e6c1f7c68e4f11ce58183/host/basic_de1/basic_de1_fpga.sv?at=master&fileviewer=file-view-default