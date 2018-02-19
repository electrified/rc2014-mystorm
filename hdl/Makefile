chip.bin: src/rc2014_interface_top.v src/rc2014_interface.pcf
	yosys -q -p "synth_ice40 -blif chip.blif" src/*.v
	arachne-pnr -d 8k -P tq144:4k -p src/rc2014_interface.pcf chip.blif -o chip.txt
	icepack chip.txt chip.bin

.PHONY: upload
upload:
	cp chip.bin /dev/ttyACM0

.PHONY: clean
clean:
	$(RM) -f chip.blif chip.txt chip.ex chip.bin
.PHONY: serial
serial:
	sudo (stty raw -echo;cat) < /dev/ttyACM0 &