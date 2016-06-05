AS=as
LINKER=ld
OBJ=src/power.o

%.o: %.asm
	$(AS) -g -o $@ $<

power: $(OBJ)
	mkdir -p bin
	$(LINKER) -o bin/$@ $^

.PHONY: clean

clean:
	rm $(OBJ)
