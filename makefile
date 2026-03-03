PROJECT = scheduler
CPU := cortex-m3
BOARD := stm32vldiscovery

OBJS = vector_table.o reset_handler.o systick_handler.o tasks.o kernel.o pendsv_handler.o

qemu:
	arm-none-eabi-as -mthumb -mcpu=$(CPU) -g -c vector_table.s -o vector_table.o
	arm-none-eabi-as -mthumb -mcpu=$(CPU) -g -c reset_handler.s -o reset_handler.o
	arm-none-eabi-as -mthumb -mcpu=$(CPU) -g -c systick_handler.s -o systick_handler.o
	arm-none-eabi-as -mthumb -mcpu=$(CPU) -g -c tasks.s -o tasks.o
	arm-none-eabi-as -mthumb -mcpu=$(CPU) -g -c kernel.s -o kernel.o
	arm-none-eabi-as -mthumb -mcpu=$(CPU) -g -c pendsv_handler.s -o pendsv_handler.o
	arm-none-eabi-ld -Tlinker.ld $(OBJS) -o scheduler.elf
	arm-none-eabi-objdump -D -S scheduler.elf > scheduler.elf.lst
	arm-none-eabi-readelf -a scheduler.elf > scheduler.elf.debug
	qemu-system-arm -S -M $(BOARD) -cpu $(CPU) -nographic -kernel $(PROJECT).elf -gdb tcp::1234

gdb:
	gdb-multiarch -q $(PROJECT).elf -ex "target remote localhost:1234"

clean:
	rm -rf *.out *.elf .gdb_history *.lst *.debug *.o