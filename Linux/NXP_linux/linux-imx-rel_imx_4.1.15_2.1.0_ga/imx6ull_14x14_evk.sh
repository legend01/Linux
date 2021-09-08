###
 # @Description: EVKshell脚本
 # @Author: HLLI8
 # @Date: 2021-09-08 20:53:27
 # @LastEditTime: 2021-09-08 20:59:17
 # @LastEditors: HLLI8
### 
#!/bin/sh
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- distclean
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- imx_v7_mfg_defconfig
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- all -j12