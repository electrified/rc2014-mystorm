test.bin: test.asm
	z80asm -l -b test.asm
	appmake +rom -b test.bin --org 49152 --ihex

.PHONY clean:
	rm -f *.bin *.err *.hex *.lis *.obj *.o *.out *.rom *.lst *.ihx
