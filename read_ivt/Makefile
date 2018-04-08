ELF		=	attack.elf

LDSCRIPT	=	ldscript/stm32f407.ld

LDFLAGS	=	-nostdlib
SRCDIR	=	src
SRC		=	src/vectortable.S
CPU		=	cortex-m4

CC		=	arm-none-eabi-gcc
AS		=	arm-none-eabi-gcc
LD		=	arm-none-eabi-gcc
OBJCOPY	=	arm-none-eabi-objcopy
SIZE	=	arm-none-eabi-size
STRIP	=	arm-none-eabi-strip

CFLAGS	=	-Iinclude

include Makefile.in

src/vectortable.s: ./scripts/genivt.sh
	@echo -e "  GEN\t$@"
	@./scripts/genivt.sh > src/vectortable.s
