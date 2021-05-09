CROSS_COMPILE 	?= arm-linux-gnueabihf-
TARGET		  	?= bsp

CC 				:= $(CROSS_COMPILE)gcc
LD				:= $(CROSS_COMPILE)ld
OBJCOPY 		:= $(CROSS_COMPILE)objcopy
OBJDUMP 		:= $(CROSS_COMPILE)objdump

INCDIRS 		:= imx6ul \
				   bsp/clk \
				   bsp/led \
				   bsp/delay 
				   			   
SRCDIRS			:= project \
				   bsp/clk \
				   bsp/led \
				   bsp/delay 
# 其中-I是目录作为第一个寻找头文件的目录 指明头文件目录 INCLUDE：= -I imx6ul -I bsp/clk -I bsp/led -I bsp/delay
INCLUDE			:= $(patsubst %, -I %, $(INCDIRS))			#patsubst 模式字符串替換函數將INCDIRS中所有的文件夾中內容全部替换为 -I % 
# wildcard获取dir目录下所有的.S文件 其中foreach将 $(foreach <var>, <list>, <text>)将<list>中单词取出放到参数<var>中,然后再执行<text>包含的表达式
SFILES			:= $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.S)) #SFILES:=project/start.S
CFILES			:= $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.c)) #CFILES:=project/main.c bsp/clk/bsp_clk.c bsp/led/bsp_led.c bsp/delay/bsp_delay.c

SFILENDIR		:= $(notdir  $(SFILES)) #notdir返回非目录部分SFILENDIR:=start.S
CFILENDIR		:= $(notdir  $(CFILES)) #返回CFILENDIR:=main.c bsp_clk.c bsp_led.c bsp_delay.c

SOBJS			:= $(patsubst %, obj/%, $(SFILENDIR:.S=.o)) #将SFILENDIR中start.S转换为start.o后加入奥obj/start.o中
COBJS			:= $(patsubst %, obj/%, $(CFILENDIR:.c=.o)) #COBJS:=obj/main.o obj/bsp_clk.o obj/bsp_led.o obj/bsp_delay.o
OBJS			:= $(SOBJS) $(COBJS) #OBJS变量是SOBJS和COBJS的集合 编译完成后所有的.o文件都放到obj目录下面

VPATH			:= $(SRCDIRS) #VPATH指定搜索目录,编译时候需要的.S和.c文件都会在SRCDIRS中指定的目录中查找

.PHONY: clean #指定一个伪目标clean
	
$(TARGET).bin : $(OBJS)									#bsp.bin: obj/start.o obj/main.o obj/bsp_clk.o obj/bsp_led.o obj/bsp_delay.o
	$(LD) -Timx6ul.lds -o $(TARGET).elf $^				#arm_linux_gnueabihf-ld -Timx6ul.lds -o bsp.elf obj/start.o obj/main.o obj/bsp_clk.o obj/bsp_led.o obj/bsp_delay.o $^-->所有依赖文件的集合就是OBJS这个变量的值域
	$(OBJCOPY) -O binary -S $(TARGET).elf $@			#arm_linux_gnueabihf-objcopy -O binary -S bsp.elf bsp.bin $@--->目标集合就是bsp.bin
	$(OBJDUMP) -D -m arm $(TARGET).elf > $(TARGET).dis	#arm_linux_gnueabihf-objdump -D -m arm bsp.elf > bsp.dis 反汇编生成bsp.dis

$(SOBJS) : obj/%.o : %.S								#其中obj/start.o : start.S
	$(CC) -Wall -nostdlib -c -O2  $(INCLUDE) -o $@ $<	#arm_linux_gnueabihf-gcc -Wall -nostdlib -c -O2 -I imx6ul -I bsp/clk -I bsp/led -I bsp/delay -o bas.bin start.S

$(COBJS) : obj/%.o : %.c								#其中boj/main.o obj/bsp_clk.o obj/bsp_led.o obj/bsp_delay.o : main.c bap_clk.c bsp_led.c bsp_delay.c
	$(CC) -Wall -nostdlib -c -O2  $(INCLUDE) -o $@ $<	#arm_linux_gnueabihf-gcc -Wall -nostdlib -c -O2 -I imx6ul -I bsp/clk -I bsp/led -I bsp/delay -o bas.bin start.S
	
clean:
	rm -rf $(TARGET).elf $(TARGET).dis $(TARGET).bin $(COBJS) $(SOBJS)

	
