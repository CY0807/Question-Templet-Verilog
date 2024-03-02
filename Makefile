.DEFAULT_GOAL := wave
USE_TOOLS := 1
DIRS := $(shell find . -maxdepth 3 -type d)
INC = ./ $(foreach dir,$(DIRS),$(wildcard $(dir)/*.v))
OUT = ./gen/wave

build:
	mkdir -p gen
ifeq ($(USE_TOOLS),1)
	iverilog -o $(OUT) -y $(INC)
else
	iverilog -o $(OUT) -y ./ Top.v tb_Top.v
endif
	vvp -n $(OUT) -lxt2
	mv wave.vcd ./gen/wave.vcd

wave: build
	gtkwave ./gen/wave.vcd

.PHONY : clean wave

clean:
	-rm -r ./gen/ 2>/dev/null