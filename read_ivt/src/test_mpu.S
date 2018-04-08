	.thumb
	.section .text.test_mpu
	.align 2
	.globl test_mpu
	.type test_mpu, function
/* It's ridiculous that i have to write this function in assembly, but it turns
 * out that the compiler has a bug... Yes, the compiler has a bug that makes it
 * generate bad code if the line:
 * volatile uint32_t read_data = *((volatile uint32_t*)0x00000000U)
 * is present in the code if it is compiled with an optimization level of -O2
 * or higher. The compiler issues garbage instructions, as in
 * .inst 0xdeff
 * Of course, the assembler proceeds to pick that up and runs with it. When the
 * program is run by the processor core and that point is reached, the core
 * triggers an interrupt because it tried to execute garbage. Since i like my
 * optimization levels, here is some assembly.
 */
test_mpu:
	push {r3, r4}
	/* read from start of flash */
	ldr r3, .Ldata+4
	ldr r4, [r3, #0]
	/* read from banked ivt address */
	ldr r3, .Ldata
	ldr r4, [r3, #0]
	pop {r3, r4}
	bx lr

	.align 4
.Ldata:	.word 0x00000000
		.word 0x08000000
	.size test_mpu, . - test_mpu

	.section .text.drop_privileges
	.align 2
	.globl drop_privileges
	.type drop_privileges, function
drop_privileges:
	push {r3}
	ldr r3, .Lmask
	msr control, r3
	pop {r3}
	bx lr
	.align 4
.Lmask:	.word 0x00000001
	.size drop_privileges, . - drop_privileges
