/***************************************************************
描述	   : ZERO-I.MX6UL/I.MX6ULL开发板启动文件，完成C环境初始化，
		 C环境初始化完成以后跳转到C代码。
		 V2.0 2019/1/4 左忠凯修改
		 添加中断相关定义
**************************************************************/

.global _start  				/* 全局标号 */

/*
 * 描述：	_start函数，首先是中断向量表的创建\
 * 参考文档:ARM Cortex-A(armV7)编程手册V4.0.pdf P42，3 ARM Processor Modes and Registers（ARM处理器模型和寄存器）
 * 		 	ARM Cortex-A(armV7)编程手册V4.0.pdf P165 11.1.1 Exception priorities(异常)
 LDR 加载指令 LDR R0, [R1] ;将R1的值加载到R0寄存器中
 CPSID I ;关中断
 MRC  ARM处理器的寄存器中的数据传送到协处理器的寄存器中
mrc是协处理器命令。用于读取协处理器中的寄存器的数据到ARM处理器的寄存器里面。这句话的意思应该
是读协处理器中的寄存器数据到ARM处理器的r0里面。应该是ARM访问MMU，一般cp15就是MMU。
<MCR|MRC>{cond} p#, <expression1>,Rd,cn,cm{, <expression2>}
MRC 2,5,R3,c5,c6 ;请求协处理器2 执行操作5 ，操作数为c5和c6， 
; 传送结果到R3 (单次32位字) 
MCR 6,0,R4,c6 ; 请求协处理器6执行操作0，操作数为R4 
;结果送到c6
BIC―――――位清除指令
BIC{cond}{S} Rd,Rn,operand2 
BIC指令将Rn 的值与操作数operand2 的反码按位逻辑”与”，结果存放到目的寄存器Rd
 */
_start:
	ldr pc, =Reset_Handler		/* 复位中断 					*/	
	ldr pc, =Undefined_Handler	/* 未定义中断 					*/
	ldr pc, =SVC_Handler		/* SVC(Supervisor)中断 		*/
	ldr pc, =PrefAbort_Handler	/* 预取终止中断 					*/
	ldr pc, =DataAbort_Handler	/* 数据终止中断 					*/
	ldr	pc, =NotUsed_Handler	/* 未使用中断					*/
	ldr pc, =IRQ_Handler		/* IRQ中断 					*/
	ldr pc, =FIQ_Handler		/* FIQ(快速中断)未定义中断 			*/

/* 复位中断 */	
Reset_Handler:

	cpsid i						/* 关闭全局中断 */

	/* 关闭I,DCache和MMU 
	 * 采取读-改-写的方式。
	 */
	mrc     p15, 0, r0, c1, c0, 0     /* 读取CP15的C1寄存器到R0中       		        	*/
    bic     r0,  r0, #(0x1 << 12)     /* 清除C1寄存器的bit12位(I位)，关闭I Cache            	*/
    bic     r0,  r0, #(0x1 <<  2)     /* 清除C1寄存器的bit2(C位)，关闭D Cache    				*/
    bic     r0,  r0, #0x2             /* 清除C1寄存器的bit1(A位)，关闭对齐						*/
    bic     r0,  r0, #(0x1 << 11)     /* 清除C1寄存器的bit11(Z位)，关闭分支预测					*/
    bic     r0,  r0, #0x1             /* 清除C1寄存器的bit0(M位)，关闭MMU				       	*/
    mcr     p15, 0, r0, c1, c0, 0     /* 将r0寄存器中的值写入到CP15的C1寄存器中	 				*/

/* 
DSB
	数据同步隔离。比 DMB 严格： 仅当所有在它前面的存储器访问操作
	都执行完毕后，才执行在它后面的指令（亦即任何指令都要等待存储器访问操作
ISB
	指令同步隔离。最严格：它会清洗流水线，以保证所有它前面的指令都执
	行完毕之后，才执行它后面的指令。
mcr p15, 0, r0, c12, c0, 0 请求协处理器15执行操作0, 操作书为R0, 结果送到C12
 */
#if 0
	/* 汇编版本设置中断向量表偏移 */
	ldr r0, =0X87800000

	dsb
	isb
	mcr p15, 0, r0, c12, c0, 0
	dsb
	isb
#endif
    
	/* 设置各个模式下的栈指针，
	 * 注意：IMX6UL的堆栈是向下增长的！
	 * 堆栈指针地址一定要是4字节地址对齐的！！！
	 * DDR范围:0X80000000~0X9FFFFFFF
	 */
	/*
	* 
CPSR 程序状态寄存器(current program status register) 
	ARM每种工作模式除R0~R15共16个寄存器外，还有第17个寄存器CPSR,叫做 当前程序状态寄存器
SPSR程序保存状态寄存器(saved program status register)
	SPSR用于保存CPSR的状态，以便异常返回后恢复异常发生时的工作状态。当特定的异常中断发生时，
	这个寄存器用于存放当前程序状态寄存器的内容。在异常中断退出时，可以用SPSR来恢复CPSR。
MRS 指令:  
	对状态寄存器CPSR和SPSR进行读操作。通过读CPSR可以获得当前处理器的工作状态。
	读SPSR寄存器可以获得进入异常前的处理器状态（因为只有异常模式下有SPSR寄存器）。

MSR指令:    
	对状态寄存器CPSR和SPSR进行写操作。
	与MRS配合使用，可以实现对CPSR或SPSR寄存器的读-修改-写操作，可以切换处理器模式、
	或者允许/禁止IRQ/FIQ中断等。
ORR{条件}{S} 目的寄存器，操作数 1，操作数 2
	ORR 指令用于在两个操作数上进行逻辑或运算，并把结果放置到目的寄存器中。
	* */
	/* 进入IRQ模式 */
	mrs r0, cpsr		/* 读状态寄存器CPSR的数据到R0中 */
	bic r0, r0, #0x1f 	/* 将r0寄存器中的低5位清零(r0&0xE0)，也就是cpsr的M0~M4 	*/
	orr r0, r0, #0x12 	/* r0或上0x13,表示使用IRQ模式					*/
	msr cpsr, r0		/* 将r0 的数据写入到cpsr_c中 					*/
	ldr sp, =0x80600000	/* 设置IRQ模式下的栈首地址为0X80600000,大小为2MB */

	/* 进入SYS模式 */
	mrs r0, cpsr
	bic r0, r0, #0x1f 	/* 将r0寄存器中的低5位清零，也就是cpsr的M0~M4 	*/
	orr r0, r0, #0x1f 	/* r0或上0x13,表示使用SYS模式					*/
	msr cpsr, r0		/* 将r0 的数据写入到cpsr_c中 					*/
	ldr sp, =0x80400000	/* 设置SYS模式下的栈首地址为0X80400000,大小为2MB */

	/* 进入SVC模式 */
	mrs r0, cpsr
	bic r0, r0, #0x1f 	/* 将r0寄存器中的低5位清零，也就是cpsr的M0~M4 	*/
	orr r0, r0, #0x13 	/* r0或上0x13,表示使用SVC模式					*/
	msr cpsr, r0		/* 将r0 的数据写入到cpsr_c中 					*/
	ldr sp, =0X80200000	/* 设置SVC模式下的栈首地址为0X80200000,大小为2MB */

	cpsie i				/* 打开全局中断 */
#if 0
	/* 使能IRQ中断 */
	mrs r0, cpsr		/* 读取cpsr寄存器值到r0中 			*/
	bic r0, r0, #0x80	/* 将r0寄存器中bit7清零，也就是CPSR中的I位清零，表示允许IRQ中断 */
	msr cpsr, r0		/* 将r0重新写入到cpsr中 			*/
#endif

	b main				/* 跳转到main函数 			 	*/

/* 未定义中断 */
Undefined_Handler:
	ldr r0, =Undefined_Handler
	bx r0

/* SVC中断 */
SVC_Handler:
	ldr r0, =SVC_Handler
	bx r0

/* 预取终止中断 */
PrefAbort_Handler:
	ldr r0, =PrefAbort_Handler	
	bx r0

/* 数据终止中断 */
DataAbort_Handler:
	ldr r0, =DataAbort_Handler
	bx r0

/* 未使用的中断 */
NotUsed_Handler:

	ldr r0, =NotUsed_Handler
	bx r0

/* IRQ中断！重点！！！！！ */
IRQ_Handler:
	push {lr}					/* 保存lr地址 */
	push {r0-r3, r12}			/* 保存r0-r3，r12寄存器 */

	mrs r0, spsr				/* 读取spsr寄存器 */
	push {r0}					/* 保存spsr寄存器 */

	mrc p15, 4, r1, c15, c0, 0 /* 从CP15的C0寄存器内的值到R1寄存器中
								* 参考文档ARM Cortex-A(armV7)编程手册V4.0.pdf P49
								* Cortex-A7 Technical ReferenceManua.pdf P68 P138
								*/							
	add r1, r1, #0X2000			/* GIC基地址加0X2000，也就是GIC的CPU接口端基地址 */
	ldr r0, [r1, #0XC]			/* GIC的CPU接口端基地址加0X0C就是GICC_IAR寄存器，
								 * GICC_IAR寄存器保存这当前发生中断的中断号，我们要根据
								 * 这个中断号来绝对调用哪个中断服务函数
								 */
	push {r0, r1}				/* 保存r0,r1 */
	
	cps #0x13					/* 进入SVC模式，允许其他中断再次进去 */
	
	push {lr}					/* 保存SVC模式的lr寄存器 */
	ldr r2, =system_irqhandler	/* 加载C语言中断处理函数到r2寄存器中*/
	blx r2						/* 运行C语言中断处理函数，带有一个参数，保存在R0寄存器中 */

	pop {lr}					/* 执行完C语言中断服务函数，lr出栈 */
	cps #0x12					/* 进入IRQ模式 */
	pop {r0, r1}				
	str r0, [r1, #0X10]			/* 中断执行完成，写EOIR */

	pop {r0}						
	msr spsr_cxsf, r0			/* 恢复spsr */

	pop {r0-r3, r12}			/* r0-r3,r12出栈 */
	pop {lr}					/* lr出栈 */
	subs pc, lr, #4				/* 将lr-4赋给pc */
	
	

/* FIQ中断 */
FIQ_Handler:

	ldr r0, =FIQ_Handler	
	bx r0									

