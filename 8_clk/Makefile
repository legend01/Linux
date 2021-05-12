CROSS_COMPILE 	?= arm-linux-gnueabihf-
TARGET		  	?= clk

CC 				:= $(CROSS_COMPILE)gcc
LD				:= $(CROSS_COMPILE)ld
OBJCOPY 		:= $(CROSS_COMPILE)objcopy
OBJDUMP 		:= $(CROSS_COMPILE)objdump

INCDIRS 		:= imx6ul \
				   bsp/clk \
				   bsp/led \
				   bsp/delay  \
				   bsp/beep \
				   bsp/gpio \
				   bsp/key
				   			   
SRCDIRS			:= project \
				   bsp/clk \
				   bsp/led \
				   bsp/delay \
				   bsp/beep \
				   bsp/gpio \
				   bsp/key
				   
#patsubst 模式字符串替换 将INCDIRS自动变量中的字符串目录加入 -I imx6ul -I bsp/clk -I bsp/led -I bsp/delay -I bsp/beep -I bsp/gpio -I bsp/key
INCLUDE			:= $(patsubst %, -I %, $(INCDIRS))
#函数foreach 将自动变量SRCDIRS字符串加入到dir中, 函数wildcard再project bsp/clk bsp/led bsp/delay bsp/beep bsp/gpio bsp/key目录下查找.S文件 输入 SFILES:=project/start.S
SFILES			:= $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.S))
CFILES			:= $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.c)) #同理:再SRCDIRS自动变量包含的目录下查找.c文件 CFILES:=project/main.c bsp/clk/bsp_clk.c bsp/led/bsp_led.c ...
#函数notdir 将自动变量SFILES包含的字符串内容删除掉目录前缀 SFILENDIR:=start.S
SFILENDIR		:= $(notdir  $(SFILES))
CFILENDIR		:= $(notdir  $(CFILES))
#$(FSILENDIR:.S = .o) 将start.S 文件转换为 start.o文件 并且利用字符串替换函数将start.o文件转换为obj/start.o
SOBJS			:= $(patsubst %, obj/%, $(SFILENDIR:.S=.o))
COBJS			:= $(patsubst %, obj/%, $(CFILENDIR:.c=.o)) #COBJS:=obj/main.o obj/bsp_beep.o obj/bsp_clk.o obj/bsp_delay.o obj/bsp_gpio.o obj/bsp_key.o obj/bsp_led.o
OBJS			:= $(SOBJS) $(COBJS) #将自动变量整合为同一个自动变量

VPATH			:= $(SRCDIRS) #指定搜索目录为自动变量SRCDIRS指定目录

.PHONY: clean #指定伪目标
#clk.bin:obj/start.o obj/main.o obj/bsp_clk.o obj/bsp_led.o obj/bsp_delay.o obj/bsp_beep.o obj/bsp_gpio.o obj/bsp_key.o
#arm-linux-gnueabihf-ld -Timx6ul.lds -o clk.elf obj/start.o obj/main.o obj/bsp_clk.o obj/bsp_led.o obj/bsp_delay.o obj/bsp_beep.o obj/bsp_gpio.o obj/bsp_key.o
#arm-linux-gnueabihf-objcopy -O binary -S clk.elf clk.bin
#arm-linux-gnueabihf-objdump -D -m arm clk.elf > clk.dis
$(TARGET).bin : $(OBJS)										
	$(LD) -Timx6ul.lds -o $(TARGET).elf $^
	$(OBJCOPY) -O binary -S $(TARGET).elf $@
	$(OBJDUMP) -D -m arm $(TARGET).elf > $(TARGET).dis
#obj/start.o:start.S
#arm-linux-gnueabihf-gcc -Wall -nostdlib -c -O2 -I imx6ul -I bsp/clk -I bsp/led -I bsp/delay -I bsp/beep -I bsp/gpio -I bsp/gpio -I bsp/key -o obj/led -o obj/start.o project/start.S
$(SOBJS) : obj/%.o : %.S
	$(CC) -Wall -nostdlib -c -O2  $(INCLUDE) -o $@ $<
#obj/beep.o:beep.c
#arm-linux-gnueabihf-gcc -Wall -nostdlib -c -O2 -I imx6ul -I bsp/clk -I bsp/led -I bsp/delay -I bsp/beep -I bsp/gpio -I bsp/gpio -I bsp/key -o obj/led -o obj/bsp_beep.o bsp/beep/bsp_beep.c
$(COBJS) : obj/%.o : %.c
	$(CC) -Wall -nostdlib -c -O2  $(INCLUDE) -o $@ $<
	
clean:
	rm -rf $(TARGET).elf $(TARGET).dis $(TARGET).bin $(COBJS) $(SOBJS)

	
