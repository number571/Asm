CC = fasm
.PHONY: default build conv run
default: build conv run
build:
	$(CC) main.asm
conv:
	dd status=noxfer conv=notrunc if=main.bin of=main.flp
run:
	qemu-system-x86_64 -drive file=main.flp,format=raw
