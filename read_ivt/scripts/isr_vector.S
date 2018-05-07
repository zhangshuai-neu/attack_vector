	.thumb
	.section .isr_vector
.word _estack
.word _start
.word isr_nmi
.weak isr_nmi
.set isr_nmi, __bad_isr
.word isr_hardfault
.weak isr_hardfault
.set isr_hardfault, __bad_isr
.word isr_memmanage
.weak isr_memmanage
.set isr_memmanage, __bad_isr
.word isr_busfault
.weak isr_busfault
.set isr_busfault, __bad_isr
.word isr_usage_fault
.weak isr_usage_fault
.set isr_usage_fault, __bad_isr
.word isr_svccall
.weak isr_svccall
.set isr_svccall, __bad_isr
.word isr_debugmonitor
.weak isr_debugmonitor
.set isr_debugmonitor, __bad_isr
.word isr_pendsv
.weak isr_pendsv
.set isr_pendsv, __bad_isr
.word isr_systick
.weak isr_systick
.set isr_systick, __bad_isr
.word __interrupt_vector_0
.weak __interrupt_vector_0
.set __interrupt_vector_0, __bad_isr
.word __interrupt_vector_1
.weak __interrupt_vector_1
.set __interrupt_vector_1, __bad_isr
.word __interrupt_vector_2
.weak __interrupt_vector_2
.set __interrupt_vector_2, __bad_isr
.word __interrupt_vector_3
.weak __interrupt_vector_3
.set __interrupt_vector_3, __bad_isr
.word __interrupt_vector_4
.weak __interrupt_vector_4
.set __interrupt_vector_4, __bad_isr
.word __interrupt_vector_5
.weak __interrupt_vector_5
.set __interrupt_vector_5, __bad_isr
.word __interrupt_vector_6
.weak __interrupt_vector_6
.set __interrupt_vector_6, __bad_isr
.word __interrupt_vector_7
.weak __interrupt_vector_7
.set __interrupt_vector_7, __bad_isr
.word __interrupt_vector_8
.weak __interrupt_vector_8
.set __interrupt_vector_8, __bad_isr
.word __interrupt_vector_9
.weak __interrupt_vector_9
.set __interrupt_vector_9, __bad_isr
.word __interrupt_vector_10
.weak __interrupt_vector_10
.set __interrupt_vector_10, __bad_isr
.word __interrupt_vector_11
.weak __interrupt_vector_11
.set __interrupt_vector_11, __bad_isr
.word __interrupt_vector_12
.weak __interrupt_vector_12
.set __interrupt_vector_12, __bad_isr
.word __interrupt_vector_13
.weak __interrupt_vector_13
.set __interrupt_vector_13, __bad_isr
.word __interrupt_vector_14
.weak __interrupt_vector_14
.set __interrupt_vector_14, __bad_isr
.word __interrupt_vector_15
.weak __interrupt_vector_15
.set __interrupt_vector_15, __bad_isr
	.section .text.__bad_isr
	.align 2
__bad_isr:
	bl __bad_isr_hook
	1: b 1b
	.size __bad_isr, . - __bad_isr

	.section .text.__bad_isr_hook
	.globl __bad_isr_hook
	.weak __bad_isr_hook
	.type __bad_isr_hook, function
__bad_isr_hook:
	bx lr
