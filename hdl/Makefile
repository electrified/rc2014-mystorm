chip.bin: src/rc2014_interface_top.v src/rc2014_interface.pcf src/rom.v src/test_programs/test.out src/debouncer.v
	yosys -q -p "synth_ice40 -blif chip.blif"  src/rc2014_interface_top.v src/rom.v src/debouncer.v
	arachne-pnr -d 8k -P tq144:4k -p src/rc2014_interface.pcf chip.blif -o chip.txt
	icepack chip.txt chip.bin

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