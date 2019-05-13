chip.bin: src/rc2014_interface_top.v src/rc2014_interface.pcf src/rom.v src/debouncer.v  z80
	yosys chip.ys
	nextpnr-ice40 --hx8k --package tq144:4k --pcf src/rc2014_interface.pcf --json chip.json --asc chip.asc
	icepack chip.asc chip.bin
	#iverilog -o blinky_tb blinky_chip.v blinky_tb.v
	#vvp -N ./blinky_tb
z80:  src/test_programs/test.asm
	z80asm -l -b src/test_programs/test.asm
	appmake +rom -b src/test_programs/test.bin --org 0 --ihex
	objcopy -Iihex -Overilog src/test_programs/test.ihx src/test_programs/test.out

.PHONY: upload
upload:
	cp chip.bin /dev/ttyACM0

.PHONY: clean
clean:
	$(RM) -f chip.blif chip.txt chip.ex chip.bin src/test_programs/test.ihx src/test_programs/test.out src/test_programs/test.bin src/test_programs/test.lis src/test_programs/test.o src/test_programs/test.rom
.PHONY: serial

run:
	stty -F /dev/ttyUSB1 115200 raw
	cat /dev/ttyUSB1

serial:
	(stty raw -echo;cat) < /dev/ttyACM0 &

capture:
	sigrok-cli --driver saleae-logic16 --config samplerate=20Mhz --channels 0=D0,1=D1,2=D2,3=D3,4=D4,5=D5,6=D6,7=D7,9=RD,10=WR,11=MREQ,12=CLK,13=M1,14=DATA_OE \
	--samples 10M --output-file z80-fpga.sr