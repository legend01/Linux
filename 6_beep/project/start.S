/***************************************************************
Copyright © zuozhongkai Co., Ltd. 1998-2019. All rights reserved.
文件名	: 	 start.s
版本	   : V1.0
描述	   : ZERO-I.MX6UL/I.MX6ULL开发板启动文件，完成C环境初始化，
		 C环境初始化完成以后跳转到C代码。
汇编系统预定义了一些段名：
.text 表示代码段
.data 初始化数据段
.bss 未初始化数据段
.rodata 只读数据段

常见的伪操作有：
.byte 	定义单字节数据
.short	定义双字节数据
.long	定义4字节数据
.equ	赋值语句 如:.equ num, 0x12 表示num=0x12
.align	数据字节对齐 如:.align 4表示4字节对齐
.end	表示源文件结束
.global	定义全局符号 

CPSR 程序状态寄存器 Current program status register,在任何处理器模式下被访问

MRS 					//将特殊寄存器CPSR里数据传递到R0中

BIC Rd,Rn,#immed 		Rd = Rn & (~#immed)位清除
ORR Rd,Rn,#immed		Rd = Rn | #immed 按位或

MSR						MSR 指令用来将普通寄存器的数据传递给特殊寄存器，也就是写特殊寄存器，写特殊寄存器只能使用 MSR

//LDR主要用于从存储器中加载数据到寄存器Rx中

B						跳转指令, 用于跳轉函數
**************************************************************/

.global _start  		/* 全局标号 */

/*
 * 描述：	_start函数，程序从此函数开始执行，此函数主要功能是设置C
 *		 运行环境。
 */
_start:
	/* 进入SVC模式 */
	mrs r0, cpsr
	bic r0, r0, #0x1f 	/* 将r0寄存器中的低5位清零，也就是cpsr的M0~M4 	*/
	orr r0, r0, #0x13 	/* r0或上0x13,表示使用SVC模式					*/
	msr cpsr, r0		/* 将r0 的数据写入到cpsr_c中 					*/

	/* 设置栈指针，
	 * 注意：IMX6UL的堆栈是向下增长的！
	 * 堆栈指针地址一定要是4字节地址对齐的！！！
	 * DDR范围:0X80000000~0X9FFFFFFF
	 */

	ldr sp,=0X80200000	/* 设置用户模式下的栈首地址为0X80200000,大小为2MB	  	   			*/
	b main				/* 跳转到main函数 										*/

