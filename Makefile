GNU_TOOLCHAIN_PREFIX = aarch64-none-elf-
GCCFLAGS = -Wall -O1 -ffreestanding -nostdinc -nostdlib -nostartfiles

all: test64.elf test64.asm

qemu: test64.elf
	qemu-system-aarch64 -M virt -cpu cortex-a57 -nographic -kernel test64.elf -serial mon:stdio
# -s: run gdb server
qemu-gdb: test64.elf
	qemu-system-aarch64 -M virt -cpu cortex-a57 -nographic -kernel test64.elf -S -s
# -q: remove information, -ex: run gdb command
gdb:
	gdb-multiarch -q -ex 'file test64.elf' -ex 'target remote localhost:1234'

test64.o: test64.c
	$(GNU_TOOLCHAIN_PREFIX)gcc $(GCCFLAGS) -c $< -o $@

startup64.o: startup64.s
	$(GNU_TOOLCHAIN_PREFIX)as -c $< -o $@

test64.elf: test64.o startup64.o
	$(GNU_TOOLCHAIN_PREFIX)ld -nostdlib -Ttest64.ld $^ -o $@

test64.bin: test64.elf
	$(GNU_TOOLCHAIN_PREFIX)objcopy -O binary $< $@

test64.asm: test64.elf
	$(GNU_TOOLCHAIN_PREFIX)objdump -S $< > $@

clean:
	rm -f test64.bin test64.elf startup64.o test64.o test64.asm .gdb*