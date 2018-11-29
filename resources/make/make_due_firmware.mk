#-------------------------------------------------------------------------------
# @author stfwi
# @file make_due_firmware.mk
#
# INCLUDE THIS FILE IN YOUR MAKEFILE USING THE ...
#
#   include <path/to/>make_due_firmware.mk
#
# ... MAKEFILE DIRECTIVE.
#
# You have then the options:
#
#   make all	  : Everything except uploading
#   make binary	  : Makes the binary that can be uploaded (default firmware.bin)
#   make install  : Uploads to the DUE using BOSSA
#   make clean	  : Cleans up the "$OUTPUT_DIR/release" or "$OUTPUT_DIR/debug"
#
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
# CONFIG: OVERWRITE as params to modify
#-------------------------------------------------------------------------------

.SUFFIXES: .o .a .c .s
SHELL = /bin/sh
OUTPUT_NAME = firmware
OUTPUT_DIR = .
PROJECT_DIR = .
UPLOAD_PORT = /dev/ttyACM0
USB_DEFINITIONS = -DUSB_VID=0x2341 -DUSB_PID=0x003e -DUSBCON '-DUSB_MANUFACTURER="Unknown"' '-DUSB_PRODUCT="Arduino Due"'
CORES_DEFINITIONS = -DF_CPU=84000000L -DARDUINO=10806 -DARDUINO_SAM_DUE -DARDUINO_ARCH_SAM -D__SAM3X8E__
VARIANTS_DEFINITIONS = $(CORES_DEFINITIONS)

#-------------------------------------------------------------------------------
# Related directories and files
#-------------------------------------------------------------------------------
ROOT := $(realpath $(shell dirname '$(dir $(lastword $(MAKEFILE_LIST)))'))
vpath %.c $(PROJECT_DIR)
VPATH+=$(PROJECT_DIR)

SAM_ROOT = $(ROOT)/../sam/1.6.11
CORES_DIR = $(SAM_ROOT)/cores/arduino
VARIANTS_DIR = $(SAM_ROOT)/variants/arduino_due_x
SAM_DIR = $(SAM_ROOT)/system/libsam
CMSIS_DIR = $(SAM_ROOT)/system/CMSIS

INCLUDES =
INCLUDES += -I$(ROOT)/include
INCLUDES += -I$(SAM_DIR)
INCLUDES += -I$(CORES_DIR)
INCLUDES += -I$(VARIANTS_DIR)
INCLUDES += -I$(CMSIS_DIR)/CMSIS/Include
INCLUDES += -I$(CMSIS_DIR)/Device/ATMEL

#-------------------------------------------------------------------------------
# Target selection
#-------------------------------------------------------------------------------
ifdef DEBUG
OPTIMIZATION = -g -O0 -DDEBUG
OBJ_DIR=debug
else
OPTIMIZATION = -Os
OBJ_DIR=release
endif

#-------------------------------------------------------------------------------
#  Toolchain
#-------------------------------------------------------------------------------
CROSS_COMPILE = /usr/bin/arm-none-eabi-
AR = $(CROSS_COMPILE)ar
CC = $(CROSS_COMPILE)gcc
CXX = $(CROSS_COMPILE)g++
AS = $(CROSS_COMPILE)as
NM = $(CROSS_COMPILE)nm
LKELF = $(CROSS_COMPILE)g++
OBJCP = $(CROSS_COMPILE)objcopy
RM=rm -Rf
MKDIR=mkdir -p
UPLOAD_BOSSA=$(ROOT)/../bossac/1.6.1-arduino/bossac


#-------------------------------------------------------------------------------
#  Flags
#-------------------------------------------------------------------------------
CFLAGS += -Wall --param max-inline-insns-single=500 -mcpu=cortex-m3 -mthumb -mlong-calls
CFLAGS += -ffunction-sections -fdata-sections -nostdlib -std=gnu99
CFLAGS += $(OPTIMIZATION) $(INCLUDES)
#CFLAGS += -Dprintf=iprintf
CPPFLAGS += -Wall --param max-inline-insns-single=500 -mcpu=cortex-m3 -mthumb -mlong-calls -nostdlib
CPPFLAGS += -ffunction-sections -fdata-sections -fno-rtti -fno-exceptions -std=c++98
CPPFLAGS += $(OPTIMIZATION) $(INCLUDES)
#CPPFLAGS += -Dprintf=iprintf
ASFLAGS = -mcpu=cortex-m3 -mthumb -Wall -g $(OPTIMIZATION) $(INCLUDES)
ARFLAGS = rcs

LNK_SCRIPT=$(SAM_ROOT)/variants/arduino_due_x/linker_scripts/gcc/flash.ld
LIBSAM_ARCHIVE=$(SAM_ROOT)/variants/arduino_due_x/libsam_sam3x8e_gcc_rel.a

UPLOAD_PORT_BASENAME=$(patsubst /dev/%,%,$(UPLOAD_PORT))

#-------------------------------------------------------------------------------
# High verbosity flags
#-------------------------------------------------------------------------------
ifdef VERBOSE
CFLAGS += -Wall -Wchar-subscripts -Wcomment -Wformat=2 -Wimplicit-int
CFLAGS += -Werror-implicit-function-declaration -Wmain -Wparentheses
CFLAGS += -Wsequence-point -Wreturn-type -Wswitch -Wtrigraphs -Wunused
CFLAGS += -Wuninitialized -Wunknown-pragmas -Wfloat-equal -Wundef
CFLAGS += -Wshadow -Wpointer-arith -Wbad-function-cast -Wwrite-strings
CFLAGS += -Wsign-compare -Waggregate-return -Wstrict-prototypes
CFLAGS += -Wmissing-prototypes -Wmissing-declarations
CFLAGS += -Wformat -Wmissing-format-attribute -Wno-deprecated-declarations
CFLAGS += -Wredundant-decls -Wnested-externs -Winline -Wlong-long
CFLAGS += -Wunreachable-code
CFLAGS += -Wcast-align
CFLAGS += -Wmissing-noreturn
CFLAGS += -Wconversion
CPPFLAGS += -Wall -Wchar-subscripts -Wcomment -Wformat=2
CPPFLAGS += -Wmain -Wparentheses -Wcast-align -Wunreachable-code
CPPFLAGS += -Wsequence-point -Wreturn-type -Wswitch -Wtrigraphs -Wunused
CPPFLAGS += -Wuninitialized -Wunknown-pragmas -Wfloat-equal -Wundef
CPPFLAGS += -Wshadow -Wpointer-arith -Wwrite-strings
CPPFLAGS += -Wsign-compare -Waggregate-return -Wmissing-declarations
CPPFLAGS += -Wformat -Wmissing-format-attribute -Wno-deprecated-declarations
CPPFLAGS += -Wpacked -Wredundant-decls -Winline -Wlong-long
CPPFLAGS += -Wmissing-noreturn
CPPFLAGS += -Wconversion
UPLOAD_VERBOSE_FLAGS += -i -d
endif

#-------------------------------------------------------------------------------
# Source files and objects
#-------------------------------------------------------------------------------
C_SRC = $(wildcard $(PROJECT_DIR)/*.c) $(wildcard ../src/*.c)
C_OBJ = $(patsubst %.c, %.o, $(notdir $(C_SRC)))
CPP_SRC = $(wildcard $(PROJECT_DIR)/*.cpp)
CPP_OBJ = $(patsubst %.cpp, %.o, $(notdir $(CPP_SRC)))
A_SRC = $(wildcard $(PROJECT_DIR)/*.s)
A_OBJ = $(patsubst %.s, %.o, $(notdir $(A_SRC)))


CORES_C_SRC = $(wildcard $(CORES_DIR)/*.c)
CORES_CPP_SRC = $(wildcard $(CORES_DIR)/*.cpp)
CORES_C_OBJ = $(patsubst %.c, %.o, $(notdir $(CORES_C_SRC)))
CORES_CPP_OBJ = $(patsubst %.cpp, %.o, $(notdir $(CORES_CPP_SRC)))

VARIANTS_C_SRC = $(wildcard $(VARIANTS_DIR)/*.c)
VARIANTS_CPP_SRC = $(wildcard $(VARIANTS_DIR)/*.cpp)
VARIANTS_C_OBJ = $(patsubst %.c, %.o, $(notdir $(VARIANTS_C_SRC)))
VARIANTS_CPP_OBJ = $(patsubst %.cpp, %.o, $(notdir $(VARIANTS_CPP_SRC)))


#-------------------------------------------------------------------------------
# Rules
#-------------------------------------------------------------------------------


#-------------------------------------------------------------------------------
all: binary

#-------------------------------------------------------------------------------
.PHONY: clean
clean:
	-@$(RM) $(OBJ_DIR) 1>/dev/null 2>&1
	-@$(RM) $(OUTPUT_DIR)/$(OUTPUT_NAME) 1>/dev/null 2>&1

#-------------------------------------------------------------------------------
.PHONY: prepare
prepare:
	-@$(MKDIR) $(OBJ_DIR) 1>/dev/null 2>&1

#-------------------------------------------------------------------------------
.PHONY: binary
binary: prepare library $(OBJ_DIR)/$(OUTPUT_NAME).bin

library: $(OBJ_DIR)/cores.a

#-------------------------------------------------------------------------------
# .bin ------> UPLOAD TO CONTROLLER
.PHONY: install
install: binary
	-@echo "Touch programming port ..."
	-@stty --file="/dev/$(UPLOAD_PORT_BASENAME)" raw ispeed 1200 ospeed 1200 cs8 -cstopb ignpar eol 255 eof 255
	-@printf "\x00" > "/dev/$(UPLOAD_PORT_BASENAME)"
	-@echo "Waiting before uploading ..."
	-@sleep 1
	-@echo "Uploading ..."
#	$(UPLOAD_BOSSA) $(UPLOAD_VERBOSE_FLAGS) --port="$(UPLOAD_PORT_BASENAME)" -U false -e -w -b "$(OBJ_DIR)/$(OUTPUT_NAME).bin" -R
	$(UPLOAD_BOSSA) $(UPLOAD_VERBOSE_FLAGS) --port="$(UPLOAD_PORT_BASENAME)" -e -w -v -b "$(OBJ_DIR)/$(OUTPUT_NAME).bin" -R
	@echo "Done."


$(addprefix $(OBJ_DIR)/cores_, $(CORES_C_OBJ)): $(OBJ_DIR)/cores_%.o: $(CORES_DIR)/%.c
	"$(CC)" -c $(CFLAGS) $(CORES_DEFINITIONS) $< -o $@

$(addprefix $(OBJ_DIR)/cores_, $(CORES_CPP_OBJ)): $(OBJ_DIR)/cores_%.o: $(CORES_DIR)/%.cpp
	"$(CC)" -xc++ -c $(CPPFLAGS) $(CORES_DEFINITIONS) $< -o $@

$(OBJ_DIR)/cores.a: $(addprefix $(OBJ_DIR)/cores_, $(CORES_C_OBJ)) $(addprefix $(OBJ_DIR)/cores_, $(CORES_CPP_OBJ))
	"$(AR)" $(ARFLAGS) $@ $^
	"$(NM)" $@ > $@.txt


$(addprefix $(OBJ_DIR)/variants_, $(VARIANTS_C_OBJ)): $(OBJ_DIR)/variants_%.o: $(VARIANTS_DIR)/%.c
	"$(CC)" -c $(CFLAGS) $(VARIANTS_DEFINITIONS) $< -o $@

$(addprefix $(OBJ_DIR)/variants_, $(VARIANTS_CPP_OBJ)): $(OBJ_DIR)/variants_%.o: $(VARIANTS_DIR)/%.cpp
	"$(CC)" -xc++ -c $(CPPFLAGS) $(VARIANTS_DEFINITIONS) $< -o $@

$(OBJ_DIR)/variants.a: $(addprefix $(OBJ_DIR)/variants_, $(VARIANTS_C_OBJ)) $(addprefix $(OBJ_DIR)/variants_, $(VARIANTS_CPP_OBJ))
	"$(AR)" $(ARFLAGS) $@ $^
	"$(NM)" $@ > $@.txt



#-------------------------------------------------------------------------------
# .c -> .o
$(addprefix $(OBJ_DIR)/,$(C_OBJ)): $(OBJ_DIR)/%.o: %.c
	"$(CC)" -c $(CFLAGS) $< -o $@

# .cpp -> .o
$(addprefix $(OBJ_DIR)/,$(CPP_OBJ)): $(OBJ_DIR)/%.o: %.cpp
	"$(CC)" -xc++ -c $(CPPFLAGS) $< -o $@

# .s -> .o
$(addprefix $(OBJ_DIR)/,$(A_OBJ)): $(OBJ_DIR)/%.o: %.s
	"$(AS)" -c $(ASFLAGS) $< -o $@

# .o -> .a
$(OBJ_DIR)/$(OUTPUT_NAME).a: $(addprefix $(OBJ_DIR)/, $(C_OBJ)) $(addprefix $(OBJ_DIR)/, $(CPP_OBJ)) $(addprefix $(OBJ_DIR)/, $(A_OBJ))
	"$(AR)" $(ARFLAGS) $@ $^
	"$(NM)" $@ > $@.txt

#  -> .elf
$(OBJ_DIR)/$(OUTPUT_NAME).elf: $(OBJ_DIR)/$(OUTPUT_NAME).a $(OBJ_DIR)/cores.a $(OBJ_DIR)/variants.a 
	"$(LKELF)" -Os -Wl,--gc-sections -mcpu=cortex-m3 \
	  "-T$(LNK_SCRIPT)" "-Wl,-Map,$(OBJ_DIR)/$(OUTPUT_NAME).map" \
	  -o $@ \
	  "-L$(OBJ_DIR)" \
	  -lm -lgcc -mthumb -Wl,--cref -Wl,--check-sections -Wl,--gc-sections \
	  -Wl,--entry=Reset_Handler -Wl,--unresolved-symbols=report-all -Wl,--warn-common \
	  -Wl,--warn-section-align -Wl,--warn-unresolved-symbols \
	  -Wl,--start-group \
	  $^ $(LIBSAM_ARCHIVE) \
	  -Wl,--end-group

# .elf -> .bin
$(OBJ_DIR)/$(OUTPUT_NAME).bin: $(OBJ_DIR)/$(OUTPUT_NAME).elf
	"$(OBJCP)" -O binary $< $@
