	.thumb
	.section .text
	.globl _start
_start:
_do_copy_data:
_do_clear_bss:
	.extern main
	bl main
	1: b 1b
	.size _start, . - _start
