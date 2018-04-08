#! /usr/bin/bash

usage() {
	echo "${0} [-i section_name] [-t number]" >&2
	return 1
}

error() {
	echo ${@} >&2
}

core_interrupts=(
		"isr_nmi"
		"isr_hardfault"
		"isr_memmanage"
		"isr_busfault"
		"isr_usage_fault"
		"isr_svccall"
		"isr_debugmonitor"
		"isr_pendsv"
		"isr_systick"
	)

total_vectors=16
ivt_section="isr_vector"

while getopts "i:t:h" opt; do
	case ${opt} in
		i)
			ivt_section=${OPTARG}
			;;
		t)
			total_vectors=${OPTARG}
			regex='^[0-9]+$'
			[[ ${total_vectors} =~ ${regex} ]] || \
				(error "-t requires numeric argument"; exit 1)
			;;
		h,\?)
			exit usage ${0}
			;;
		:)
			error "-$OPTARG requires an argument."
			exit usage "${0}"
			;;
	esac
done

echo -e "\t.thumb"
echo -e "\t.section .${ivt_section}"
echo ".word _estack"
echo ".word _start"

for vect in ${core_interrupts[@]}; do
	echo ".word ${vect}"
	echo ".weak ${vect}"
	echo ".set ${vect}, __bad_isr"
done

for (( vect=0; vect<${total_vectors}; vect+=1 )); do
	echo ".word __interrupt_vector_${vect}"
	echo ".weak __interrupt_vector_${vect}"
	echo ".set __interrupt_vector_${vect}, __bad_isr"
done

cat << EOF
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
EOF
