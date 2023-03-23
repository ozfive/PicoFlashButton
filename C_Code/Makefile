# Define the toolchain prefix and other compilation flags
PREFIX=arm-none-eabi-
CFLAGS=-mthumb -mcpu=cortex-m0plus -std=c11 -Wall -Wextra -Werror
LDFLAGS=-mthumb -mcpu=cortex-m0plus -nostartfiles

# Define the source and object files
C_SOURCES=$(wildcard C_Code/*.c)
C_OBJECTS=$(patsubst C_Code/%.c, C_Code/%.o, $(C_SOURCES))
ASM_SOURCES=$(wildcard ARM_ASM/*.S)
ASM_OBJECTS=$(patsubst ARM_ASM/%.S, ARM_ASM/%.o, $(ASM_SOURCES))
LINKER_SCRIPTS=$(wildcard ARM_ASM/Linker_Scripts/*.ld)

# Define the output files
TARGET=picoflashbutton
ELF=$(TARGET).elf
BIN=$(TARGET).bin

# Define the rules for compiling C files
C_Code/%.o: C_Code/%.c
	$(PREFIX)gcc $(CFLAGS) -c $< -o $@

# Define the rules for compiling assembly files
ARM_ASM/%.o: ARM_ASM/%.S
	$(PREFIX)gcc $(CFLAGS) -c $< -o $@

# Define the rule for linking the object files into the ELF file
$(ELF): $(ASM_OBJECTS) $(C_OBJECTS) $(LINKER_SCRIPTS)
	$(PREFIX)ld $(LDFLAGS) -T ARM_ASM/Linker_Scripts/pico.ld -o $@ $(ASM_OBJECTS) $(C_OBJECTS)

# Define the rule for creating the binary file from the ELF file
$(BIN): $(ELF)
	$(PREFIX)objcopy -O binary $< $@

# Define the rules for building the project
all: $(BIN)

# Define the rule for cleaning the object files and other generated files
clean:
	rm -f $(ASM_OBJECTS) $(C_OBJECTS) $(ELF) $(BIN)
