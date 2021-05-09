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

.PHONY: clean
	
$(TARGET).bin : $(OBJS)
	$(LD) -Timx6ul.lds -o $(TARGET).elf $^
	$(OBJCOPY) -O binary -S $(TARGET).elf $@
	$(OBJDUMP) -D -m arm $(TARGET).elf > $(TARGET).dis

$(SOBJS) : obj/%.o : %.S
	$(CC) -Wall -nostdlib -c -O2  $(INCLUDE) -o $@ $<

$(COBJS) : obj/%.o : %.c
	$(CC) -Wall -nostdlib -c -O2  $(INCLUDE) -o $@ $<
	
clean:
	rm -rf $(TARGET).elf $(TARGET).dis $(TARGET).bin $(COBJS) $(SOBJS)

	
