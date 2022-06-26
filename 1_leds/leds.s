.global _start @全局标号

_start:
    /* 使能所有外设时钟 */
    ldr r0, =0x020c4068 @CCGR0
    ldr r1, =0xffffffff @要向CCGR0写入的数据
    str r1, [r0] @将0xffffffff写入到CCGR0

    ldr r0, =0x020c406c @CCGR1
    str r1, [r0] @将0xffffffff写入到CCGR1

    ldr r0, =0x020c4070 @CCGR2
    str r1, [r0] @将0xffffffff写入到CCGR1

    ldr r0, =0x020c4074 @CCGR3
    str r1, [r0] @将0xffffffff写入到CCGR1

    ldr r0, =0x020c4078 @CCGR4
    str r1, [r0] @将0xffffffff写入到CCGR1

    ldr r0, =0x020c407c @CCGR5
    str r1, [r0] @将0xffffffff写入到CCGR1

    ldr r0, =0x020c4080 @CCGR6
    str r1, [r0] @将0xffffffff写入到CCGR1

    /* 配置 GPIO1_IO3 PIN的复用为GPIO,也就是
    *  设置IOMUXC_SW_MUX_CTL_PAD_GPIO1_IO03 = 0x05
    *  寄存器地址为0x020E0068
     */
    ldr r0, =0x020E0068 @IOMUXC_SW_MUX_CTL_PAD_GPIO1_IO03
    ldr r1, =0x05       @要写入的数据
    str r1, [r0]        @将0x05写入到寄存器IOMUXC_SW_MUX_CTL_PAD_GPIO1_IO03中

    /* 配置GPIO1_IO03的电气属性
    *  IOMUXC_SW_PAD_CTL_PAD_GPIO1_IO03
    *  IOMUXC_SW_PAD_CTL_PAD_GPIO1_IO03寄存器地址为:0x020E02F4
    * bit0: SRE 0 低速率
    * bit5:3 DSE 110 R0/6驱动能力
    * bit6:7 SPEED 10 100M速率
    * bit11  DOE   0  关闭开路输出
    * bit12  PKE   1  使能pull/keeper
    * bit13  PUE   0  keeper 
    * bit15:14 PUS  00 100K下拉
    * bit16    HYS  0  关闭HYS
     */
    ldr r0, =0x020E02F4
    ldr r1, =0x10B0
    str r1, [r0]

    /*
    *  设置GPIO
    *  设置GPIO1_GDIR寄存器,设置GPIO1_GPIO3为输出
    *  GPIO1_GDIR寄存器地址为0x0209C004,设置GPIO1_GDIR寄存器bit3为1
    *  GPIO1_IO03为输出
    */
    ldr r0, =0x0209C004
    ldr r1, =0x08
    str r1, [r0]

    /*
    *  打开LED,设置GPIO1_IO03为0
    *  GPIO1_DR寄存器为0x0209C000
     */
    ldr r0, =0x0209C000
    ldr r1, =0x00
    str r1, [r0]

loop:
    b loop