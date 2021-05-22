CROSS_COMPILE 	?= arm-linux-gnueabihf-
TARGET		  	?= int

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
				   bsp/key \
				   bsp/exit \
				   bsp/int
				   			   
SRCDIRS			:= project \
				   bsp/clk \
				   bsp/led \
				   bsp/delay \
				   bsp/beep \
				   bsp/gpio \
				   bsp/key \
				   bsp/exit \
				   bsp/int
				   
#patsubst模式字符串替换 将INCDIRS自动变量中字符串目录加入-I imx6ul -I bsp/clk -I bsp/led -I bsp/delay -I bsp/beep -I bsp/gpio -I bsp/key -I bsp/exit -I bsp/int
INCLUDE			:= $(patsubst %, -I %, $(INCDIRS))
#函数foreach将自动变量SRCDIRS字符串加入到dir中 函数wildcard在project bsp/clk bsp/led bsp/delay bsp/beep bsp/gpio bsp/key bsp/exit bsp/int
#中寻找.S文件 SFILES:=project/start.S
SFILES			:= $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.S))
#CFILES:=bsp/beep/bsp_beep.c bsp/clk/bsp_clk.c bsp/delay/bsp_delay.c bsp/exit/bsp_exit.c bsp/gpio/bsp_gpio.c bsp/int/bsp_int.c bsp/key/bsp_key.c bsp/led/bsp_led.c project/main.c
CFILES			:= $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.c))
#SFILENDIR:=start.S
SFILENDIR		:= $(notdir  $(SFILES))
#CFILENDIR:=bap_beep.c bsp_clk.c bsp_delay.c bsp_exit.c bsp_gpio.c bsp_int.c bsp_key.c bsp_led.c main.c
CFILENDIR		:= $(notdir  $(CFILES))
#SOBJS:=obj/start.O
SOBJS			:= $(patsubst %, obj/%, $(SFILENDIR:.S=.o))
#COBJS:=obj/bsp_beep.o obj/bsp_clk.o obj/bsp_delay.o obj/bsp_eixt.o obj/bsp_gpio.o obj/bsp_int.o obj/bsp_key.o obj/bsp_led.o obj/main.o
COBJS			:= $(patsubst %, obj/%, $(CFILENDIR:.c=.o))
OBJS			:= $(SOBJS) $(COBJS)

VPATH			:= $(SRCDIRS) #指定搜索搜索目录为SRCDIRS

.PHONY: clean
#int.bin:obj/start.o obj/bsp_beep.o obj/bsp_clk.o obj/bsp_delay.o obj/exit.o obj/bsp_gpio.o obj/bsp_int.o obj/bsp_key.o obj/bsp_led.o obj/main.o
#arm-linux-gnueabihf-ld -Timx6ul.lds -o int.elf obj/start.o obj/bsp_beep.o obj/bsp_clk.o obj/bsp_delay.o obj/exit.o obj/bsp_gpio.o obj/bsp_int.o obj/bsp_key.o obj/bsp_led.o obj/main.o
#arm-linux-gnueabihf-objcopy -O binary -S int.elf int.bin
#arm-linux-gnueabihf-objdump -D -m arm int.elf > int.dis
$(TARGET).bin : $(OBJS)
	$(LD) -Timx6ul.lds -o $(TARGET).elf $^
	$(OBJCOPY) -O binary -S $(TARGET).elf $@
	$(OBJDUMP) -D -m arm $(TARGET).elf > $(TARGET).dis
# $@  表示目标文件
# $^  表示所有的依赖文件
# $<  表示第一个依赖文件
# $?  表示比目标还要新的依赖文件列表
#obj/start.o:obj/start.o:start.S
#arm-linux-gnueabihf-gcc -Wall -nostdlib -c -O2 -I imx6ul -I bsp/clk -I bsp/led -I bsp/delay -I bsp/beep -I bsp/gpio -I bsp/int -I bsp/key -I bsp/led -o obj/start.o project/start.o
$(SOBJS) : obj/%.o : %.S
	$(CC) -Wall -nostdlib -c -O2  $(INCLUDE) -o $@ $<
#obj/bsp_beep.o:bsp_beep.c
#arm-linux-gnueabihf-gcc -Wall -nostdlib -c -O2 -I imx6ul -I bsp/clk -I bsp/led -I bsp/delay -I bsp/beep -I bsp/gpio -I bsp/key -I bsp/exit -I bsp/int -o obj/bsp_beep.o bsp/beep/bsp_beep.c
$(COBJS) : obj/%.o : %.c
	$(CC) -Wall -nostdlib -c -O2  $(INCLUDE) -o $@ $<
	
clean:
	rm -rf $(TARGET).elf $(TARGET).dis $(TARGET).bin $(COBJS) $(SOBJS)

	
