#include <stdint.h>

#include <stm32f407.h>

__attribute__((noreturn)) void main(void);

void test_mpu(void);
void drop_privileges(void);

void main(void) {
	volatile uint32_t read_value;
	MPU_RNR = 0;	//配置region 0
	MPU_RBAR = 0x00000000;	//region 0的base address是0x00000000
	MPU_RASR = MPU_REG_CACHEABLE			//(1U << 17)
				| MPU_AP_RWRW		//(0b011U << 24)
				| MPU_REG_SIZE_4GB	//(0b11111U << 1)
				| MPU_REG_ENABLE;	//1U
	//region 0的size是4GB,特权和非特权都是full access(RW),Not shareable	

	MPU_RNR = 1;	//配置region 1
	MPU_RBAR = 0x00000000;	//region 0的base address是0x00000000
	MPU_RASR = MPU_REG_CACHEABLE			//(1U << 17)
				| MPU_AP_RWNA		//(0b001U << 24)
				| MPU_REG_SIZE_512B	//(0b01000U << 1)
				| MPU_REG_ENABLE;	//1U
	//region 1的size是128KB,特权(RW),非特权(no access),Not shareable

	while(1) {
		test_mpu();
		drop_privileges();
	}
}
