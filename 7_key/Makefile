CROSS_COMPILE 	?= arm-linux-gnueabihf-
TARGET		  	?= key

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
				   
#patsubst 将INCDIRS变量中的字符串加上-I,比如 -I imx6ul -I bsp/clk -I bsp/led -I bsp/delay -I bsp/beep -I bsp/gpio -I bsp/key
INCLUDE			:= $(patsubst %, -I %, $(INCDIRS))
#foreach 将SRCDIRS中内容加载到dir变量中,再函数wildcard中进行操纵,找到project/start.S 
SFILES			:= $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.S))
CFILES			:= $(foreach dir, $(SRCDIRS), $(wildcard $(dir)/*.c)) #CFILES:=bsp/beep/bsp_beep.c bsp/clk/bsp_clk.c bsp/delay/bsp_delay.c bsp/gpio/bsp_goio.c bsp/key/bsp_key.c bsp/led/bsp_led.c project/main.c

SFILENDIR		:= $(notdir  $(SFILES)) #将自动变量SFILES和CFILES去除目录
CFILENDIR		:= $(notdir  $(CFILES))
#将自动变量SFILENDIRstart.S转换为start.o,加上obj/start.o
SOBJS			:= $(patsubst %, obj/%, $(SFILENDIR:.S=.o))
COBJS			:= $(patsubst %, obj/%, $(CFILENDIR:.c=.o))
OBJS			:= $(SOBJS) $(COBJS) #将转换后的自动变量SOBJS COBJS全部加入到OBJS中

VPATH			:= $(SRCDIRS) #指定搜索目录为自动变量SRCDIRS包含的目录

.PHONY: clean #伪目标
#key.bin:obj/start.o obj/main.o obj/bsp_beep.o obj/bsp_clk.o obj/bsp_delay.o obj/bsp_gpio.o obj/bsp_led.o obj/bsp_key.o
#arm-linux-gnueabihf-ld -Timx6ul.lds -o key.elf obj/start.o obj/main.o obj/bsp_beep.o obj/bsp_clk.o obj/bsp_delay.o obj/bsp_gpio.o obj/bsp_led.o obj/bsp_key.o
#arm-linux-gnueabihf-objcopy -O binary -S key.elf key.bin
#arm-linux-gnueabihf-objdump -D -m arm key.elf > key.dis
$(TARGET).bin : $(OBJS)
	$(LD) -Timx6ul.lds -o $(TARGET).elf $^
	$(OBJCOPY) -O binary -S $(TARGET).elf $@
	$(OBJDUMP) -D -m arm $(TARGET).elf > $(TARGET).dis

#obj/start.o:start.S 
#arm-linux-gnueabihf-gcc -Wall -nostdlib -c -O2 -I imx6ul -I bsp/clk -I bsp/led -I bsp/delay -I bsp/beep -I bsp/gpio -I bsp/gpio -I bsp/key -o obj/start.o start.S
$(SOBJS) : obj/%.o : %.S
	$(CC) -Wall -nostdlib -c -O2  $(INCLUDE) -o $@ $<
#obj/bsp_beep.o:bsp_beep.c
#arm-linux-gnueabihf-gcc -Wall -nostdlib -c -O2 -I imx6ul -I bsp/clk -I bsp/led -I bsp/delay -I bsp/beep -I bsp/gpio -I bsp/gpio -I bsp/key -o obj/bsp_beep.o bsp_beep.c
#arm-linux-gnueabihf-gcc -Wall -nostdlib -c -O2 -I imx6ul -I bsp/clk -I bsp/led -I bsp/delay -I bsp/beep -I bsp/gpio -I bsp/gpio -I bsp/key -o obj/bsp_clk.o bsp_clk.c
$(COBJS) : obj/%.o : %.c
	$(CC) -Wall -nostdlib -c -O2  $(INCLUDE) -o $@ $<
	
clean:
	rm -rf $(TARGET).elf $(TARGET).dis $(TARGET).bin $(COBJS) $(SOBJS)

	
