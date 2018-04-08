OUTPUT_FORMAT(elf32-littlearm)
OUTPUT_ARCH(arm) /*定义处理器架构为ARM*/
ENTRY(_start) 	 /*定义入口函数*/

FLASH_START		=	0x08000000;
FLASH_END		=	0x08100000;
RAM_ORIGIN		=	0x20000000;
RAM_END			=	0x20020000;
RAM_LEN			=	RAM_END - RAM_ORIGIN;
VECTOR_ORIGIN	=	FLASH_START;
VECTOR_LEN		=	512;
PROGRAM_ORIGIN	=	VECTOR_ORIGIN + VECTOR_LEN;
PROGRAM_LEN		=	FLASH_END - PROGRAM_ORIGIN;

/*定义内存组织结构*/
MEMORY {
  /* VECTOR_TABLE	(ARX)	: ORIGIN = VECTOR_ORIGIN,	LENGTH = VECTOR_LEN */
  FLASH			(RX)	: ORIGIN = FLASH_START,	LENGTH = 0x00100000 
  RAM			(RW)	: ORIGIN = RAM_ORIGIN,		LENGTH = RAM_LEN
}

/*定义段*/
SECTIONS {
/*
	.isr_vector : {
		KEEP(*(.isr_vector))
	} > VECTOR_TABLE
*/

	/*在上面将isr_vector注释了,为了保证不然连接器将isr_vector忽略,所以使用keep*/
	.text : {
		KEEP(*(.isr_vector))
		*(.text)
		*(.text*)
		*(.rodata)
		*(.rodata*)

		KEEP(*(.init))
		KEEP(*(.fini))
		/*未在文件中定义_etext_end,但是却使用了,所以使用PROVIDE关键字来*/
		. = ALIGN(4);
		PROVIDE(_etext_end = .);
	} > FLASH /*将text section的内容写到了Flash中*/

	/*PROVIDE_HIDDEN类似于PROVIDE,对于ELF目标,符号被隐藏且不会被输出*/
	/*Elf 可执行文件和共享目标文件都有的一个节是,init _ array.
	  .init _ array节中包含指针,这些指针指向了一些初始化代码.这些初始化代码
	  一般是在main函数之前执行的。
	*/
	.preinit_array : {
		PROVIDE_HIDDEN(__preinit_array_start = .);
		KEEP(*(.preinit_array*))
		PROVIDE_HIDDEN(__preinit_array_end = .);
	} > FLASH

	.init_array : {
		PROVIDE_HIDDEN(__init_array_start = .);
		KEEP(*(SORT(.init_array.*)))
		KEEP(*(.init_array*))
		PROVIDE_HIDDEN(__init_array_end = .);
	} > FLASH

	.fini_array : {
		PROVIDE_HIDDEN(__fini_array_start = .);
		KEEP(*(.fini_array*))
		KEEP(*(SORT(.fini_array.*)))
		PROVIDE_HIDDEN(__fini_array_end = .);
	} > FLASH



   .ARM.extab : { *(.ARM.extab* .gnu.linkonce.armextab.*) } /*>FLASH*/
    .ARM : {
    __exidx_start = .;
      *(.ARM.exidx*)
      __exidx_end = .;
    } >FLASH

	/*data section 定义*/
	.data : {
		_sdata = .;
		*(.data)
		*(.data*)
		. = ALIGN(4);
		_edata = .;
	} > RAM AT > FLASH
	_sidata = LOADADDR(.data); /*返回data section的绝对地址*/
	_eidata = _sidata + SIZEOF(.data);

	.bss : {
		_sbss = .;
		__bss_start__ = _sbss;
		*(.bss)
		*(.bss*)
		*(COMMON)
		_ebss = .;
		__bss_end__ = _ebss;
	} > RAM

	. = ALIGN(4);
	PROVIDE(end = .);
	PROVIDE(_end = .);

	. = RAM_END;
	_estack = .;

  /* Remove information from the standard libraries */

  DISCARD :
  {
    libc.a ( * )
    libm.a ( * )
    libgcc.a ( * )
  }

  .ARM.attributes 0 : { *(.ARM.attributes) }
  .debug  : { *(.debug) }
  .note : { *(.note) }
  .llvm : { *(.llvm) }

}
