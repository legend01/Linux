###
 # @Description: EVKshell脚本
 # @Author: HLLI8
 # @Date: 2021-09-08 20:53:27
 # @LastEditTime: 2021-09-08 22:07:52
 # @LastEditors: HLLI8
### 
#!/bin/sh
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- distclean
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- imx_alientek_emmc_defconfig
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- all -j12