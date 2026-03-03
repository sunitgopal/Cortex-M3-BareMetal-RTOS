PROJECT = scheduler
CPU := cortex-m3
BOARD := stm32vldiscovery

# Toolchain
CC = arm-none-eabi-gcc
AS = arm-none-eabi-as
LD = arm-none-eabi-gcc
OBJDUMP = arm-none-eabi-objdump
READELF = arm-none-eabi-readelf

# Flags
CFLAGS = -mcpu=$(CPU) -mthumb -O0 -g -Wall  -I./lib
ASFLAGS = -mcpu=$(CPU) -mthumb -g
LDFLAGS = -T linker.ld -nostdlib

# Source Files
ASM_SOURCES = \
    kernel/vector_table.s \
    kernel/reset_handler.s \
    kernel/systick_handler.s \
    kernel/pendsv_handler.s \
    kernel/kernel.s \
    app/tasks.s

C_SOURCES = \
    lib/circular_buffer.c \
    lib/static_pool.c

# Object Files
OBJS = $(ASM_SOURCES:.s=.o) $(C_SOURCES:.c=.o)

all: $(PROJECT).elf

# Rule to compile C files
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Rule to assemble S files
%.o: %.s
	$(AS) $(ASFLAGS) -c $< -o $@

# Linker
$(PROJECT).elf: $(OBJS)
	$(LD) $(LDFLAGS) $(OBJS) -o $@
	$(OBJDUMP) -D -S $@ > $@.lst
	$(READELF) -a $@ > $@.debug

qemu: all
	qemu-system-arm -S -M $(BOARD) -cpu $(CPU) -nographic -kernel $(PROJECT).elf -gdb tcp::1234

gdb:
	gdb-multiarch -q $(PROJECT).elf -ex "target remote localhost:1234"

clean:
	rm -rf $(OBJS) *.out *.elf .gdb_history *.lst *.debug