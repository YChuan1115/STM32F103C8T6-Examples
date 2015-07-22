PRJ_NAME   = Template
CC         = arm-none-eabi-gcc
SRC        = src/main.c src/system_stm32f4xx.c
ASRC       = src/startup_stm32f407xx.s
OBJ        = $(SRC:.c=.o) $(ASRC:.s=.o)
OBJCOPY    = arm-none-eabi-objcopy
OBJDUMP    = arm-none-eabi-objdump
PROGRAMMER = st-flash
DEVICE     = STM32F407xx
OPTIMIZE   = -O2
LDSCRIPT   = stm32f407.ld
CFLAGS     = -g -Wall $(OPTIMIZE) -mcpu=cortex-m4 -mlittle-endian -mfloat-abi=hard -mfpu=fpv4-sp-d16  -mthumb -I inc/ -D $(DEVICE)
ASFLAGS    =  $(CFLAGS)
#-Wall -mcpu=cortex-m4 -mlittle-endian -mthumb -I inc/ -D $(DEVICE)
LDFLAGS    = -T $(LDSCRIPT) -Wl,--gc-sections

#-Wall,-mcpu=cortex-m4,-mlittle-endian,-mthumb,-T$(LDSCRIPT),-mfloat-abi=hard

all: $(PRJ_NAME).elf

$(PRJ_NAME).elf: $(OBJ)
	$(CC) $(CFLAGS) $(OBJ) -o $@ $(LDFLAGS)
	$(OBJCOPY) -O ihex $(PRJ_NAME).elf $(PRJ_NAME).hex
	$(OBJCOPY) -O binary $(PRJ_NAME).elf $(PRJ_NAME).bin
	arm-none-eabi-size $(PRJ_NAME).elf
.c.o:
	$(CC) -c $(CFLAGS) $< -o $@

.s.o:
	$(CC) -c $(ASFLAGS) $< -o $@

clean:
	rm -f $(OBJ) *.map *.elf *.hex

burn:
	st-flash write $(PRJ_NAME).bin 0x08000000
rst:

fast: all burn
