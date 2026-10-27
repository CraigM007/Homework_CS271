AS := aarch64-linux-gnu-gcc
OBJCOPY := aarch64-linux-gnu-objcopy
IVERILOG := iverilog
VVP := vvp
ASFLAGS := -c -march=armv8-a

.PHONY: build sim clean

build:
	$(AS) $(ASFLAGS) -o test_lab01.o test_lab01.s
	$(OBJCOPY) -O verilog test_lab01.o test_lab01.mem
	$(IVERILOG) -g2012 -Wall -I runtime/head -y runtime/src -s test_Educore runtime/src/*.v runtime/tests/*.v -o test_Educore.vvp

sim: build
	$(VVP) test_Educore.vvp +TEST_CASE=test_lab01.mem

clean:
	rm -f *.o *.mem *.vvp *.vcd
