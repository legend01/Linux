###
 # @Description: 编译脚本
 # @Author: HLLI8
 # @Date: 2021-09-05 12:17:38
 # @LastEditTime: 2021-09-05 12:29:05
 # @LastEditors: HLLI8
### 
#!/bin/sh

make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- distclean
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- imx_v7_defconfig
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- all -j12