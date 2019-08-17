CC = fasm
.PHONY: default build run
default: build run
build:
	$(CC) main.asm
run:
	qemu-system-x86_64 -drive file=main.bin,format=raw
