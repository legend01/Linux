###
 # @Description: 编译脚本
 # @Author: HLLI8
 # @Date: 2021-07-21 21:56:21
 # @LastEditTime: 2021-07-21 22:04:03
 # @LastEditors: HLLI8
### 
#!/bin/bash
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- distclean
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- mx6ull_14x14_ddr512_emmc_defconfig
make V=1 ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- -j8