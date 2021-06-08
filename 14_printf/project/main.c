#include "bsp_clk.h"
#include "bsp_delay.h"
#include "bsp_led.h"
#include "bsp_beep.h"
#include "bsp_key.h"
#include "bsp_int.h"
#include "bsp_uart.h"
#include "stdio.h"

/*
 * @description	: main函数
 * @param 		: 无
 * @return 		: 无
 */
int main(void)
{
	unsigned char state = OFF;
	int a , b;

	int_init(); 				/* 初始化中断(一定要最先调用！) */
	imx6u_clkinit();			/* 初始化系统时钟 			*/
	delay_init();				/* 初始化延时 			*/
	clk_enable();				/* 使能所有的时钟 			*/
	led_init();					/* 初始化led 			*/
	beep_init();				/* 初始化beep	 		*/
	uart_init();				/* 初始化串口，波特率115200 */
	
	while(1)					
	{	
		static int flag = 0;
		printf("Input tow number use space separate");
		scanf("%d %d\r\n", &a, &b);					 		/* 输入两个整数 */
		printf("work number: %d \r\n", flag);
		printf("\r\nData-->%d + %d = %d\r\n\r\n", a, b, a+b);	/* 输出两个数相加的和 */
		flag ++;
		state = !state;
		led_switch(LED0,state);
	}

	return 0;
}
