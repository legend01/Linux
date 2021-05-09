CROSS_COMPILE 	?= arm-linux-gnueabihf-
TARGET		  	?= beep

CC 				:= $(CROSS_COMPILE)gcc
LD				:= $(CROSS_COMPILE)ld
OBJCOPY 		:= $(CROSS_COMPILE)objcopy
OBJDUMP 		:= $(CROSS_COMPILE)objdump

INCDIRS 		:= imx6ul \
				   bsp/clk \
				   bsp/led \
				   bsp/delay  \
				   bsp/beep
				   			   
SRCDIRS			:= project \
				   bsp/clk \
				   bsp/led \
				   bsp/delay \
				   bsp/beep
				   
#patsubst模式字符串替换函数 替换为 -I imx6ul -I bsp/clk -I bsp/led -I bsp/delay -I beep
INCLUDE			:= $(patsubst %, -I %, $(INCDIRS))
#foreach <var>, <list>, <text>将list中内容放入到var中,再执行text	wildcard获取dir工作目录下所有.S文件 project/start.S
SFILES			:= $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.S))
CFILES			:= $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.c))

SFILENDIR		:= $(notdir  $(SFILES)) #删除文件目录 start.S
CFILENDIR		:= $(notdir  $(CFILES)) #删除文件目录 bsp_beep.c  bsp_clk.c bsp_delay.c bsp_led.c main.c 

SOBJS			:= $(patsubst %, obj/%, $(SFILENDIR:.S=.o)) #将start.S修改为start.o,并且将其修改为obj/start.o
COBJS			:= $(patsubst %, obj/%, $(CFILENDIR:.c=.o)) #将bsp_beep.c bsp_clk.c bsp_delay.c bsp_led.c main.c修改为bsp_beep.o bsp_clk.o bsp_delay.o bsp_led.o main.o 并且将其增加obj/目录
OBJS			:= $(SOBJS) $(COBJS)

VPATH			:= $(SRCDIRS) #指定搜索路径

.PHONY: clean
	
$(TARGET).bin : $(OBJS) 								#beep.bin : obj/start.o obj/main.o obj/bsp_led.o obj/bsp_delay.o obj/bsp_clk.o obj/bsp_beep.o
	$(LD) -Timx6ul.lds -o $(TARGET).elf $^				#arm-linux-gnueabihf-ld -Timx6ul.lds -o beep.elf $(OBJS)
	$(OBJCOPY) -O binary -S $(TARGET).elf $@			#arm-linux-gnueabihf-objcopy -O binary -S beep.elf beep.bin
	$(OBJDUMP) -D -m arm $(TARGET).elf > $(TARGET).dis	#arm-linux-gnueabihg-objdump -D -m arm beep.elf > beep.dis

$(SOBJS) : obj/%.o : %.S								#obj/start.o : start.S 
	$(CC) -Wall -nostdlib -c -O2  $(INCLUDE) -o $@ $<	#arm-linux-gnueabih-gcc -Wall -nostlib -c -O2 -I imx6ul -I bsp/clk -I bsp/led -I bsp/delay -I bsp/beep

$(COBJS) : obj/%.o : %.c								#obj/bsp_beep.o obj/bsp_clk.o obj/bsp_delay.o obj/bsp_led.o obj/main.o : bsp_beep.c bsp_clk.c bsp_delay.c bsp_led.c main.c
	$(CC) -Wall -nostdlib -c -O2  $(INCLUDE) -o $@ $<
	
clean:
	rm -rf $(TARGET).elf $(TARGET).dis $(TARGET).bin $(COBJS) $(SOBJS)

	
