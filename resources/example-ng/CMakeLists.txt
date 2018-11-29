project(example)
cmake_minimum_required(VERSION 3.0)

set (CROSSCOMPILE_TOOLCHAIN "/usr/bin/arm-none-eabi-")
set (CMAKE_C_COMPILER "${CROSSCOMPILE_TOOLCHAIN}gcc")
set (CMAKE_CXX_COMPILER "${CROSSCOMPILE_TOOLCHAIN}gcc")

include("${CMAKE_SOURCE_DIR}/cmake_include/libraries.cmake")

include_directories (${CMAKE_SOURCE_DIR}/inc)
aux_source_directory (${CMAKE_SOURCE_DIR}/src OBJ_FILES)
add_library (OBJ ${OBJ_FILES})

set (CMAKE_CXX_FLAGS_DEBUG "-MMD -g -O0 -DDEBUG")
set (CMAKE_CXX_FLAGS_RELEASE "-MMD -Os")

set (CMAKE_C_FLAGS_DEBUG "-g -O0 -DDEBUG")
set (CMAKE_C_FLAGS_RELEASE "-Os")

add_definitions(-DF_CPU=84000000L -DARDUINO=10806 -DARDUINO_SAM_DUE -DARDUINO_ARCH_SAM -D__SAM3X8E__)
add_definitions(-DUSB_VID=0x2341 -DUSB_PID=0x003e -DUSBCON '-DUSB_MANUFACTURER="Unknown"' '-DUSB_PRODUCT="Arduino Due"')

set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -xc++ -Wall -Wextra --param max-inline-insns-single=500 \
-mcpu=cortex-m3 -mthumb -mlong-calls -nostdlib \
-ffunction-sections -fdata-sections -fno-rtti \
-fno-exceptions -std=c++98 ")
set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Wextra --param max-inline-insns-single=500 \
-mcpu=cortex-m3 -mthumb -mlong-calls \
-ffunction-sections -fdata-sections -nostdlib -std=gnu99 ")

if (CMAKE_VERBOSE_MAKEFILE)
    set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} \
-Wall -Wchar-subscripts -Wcomment -Wformat=2 \
-Wmain -Wparentheses -Wcast-align -Wunreachable-code \
-Wsequence-point -Wreturn-type -Wswitch -Wtrigraphs -Wunused \
-Wuninitialized -Wunknown-pragmas -Wfloat-equal -Wundef \
-Wshadow -Wpointer-arith -Wwrite-strings \
-Wsign-compare -Waggregate-return -Wmissing-declarations \
-Wformat -Wmissing-format-attribute \
-Wno-deprecated-declarations \
-Wpacked -Wredundant-decls -Winline -Wlong-long \
-Wmissing-noreturn \
-Wconversion ")
    set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} \
-Wall -Wchar-subscripts -Wcomment -Wformat=2 -Wimplicit-int \
-Werror-implicit-function-declaration -Wmain -Wparentheses \
-Wsequence-point -Wreturn-type -Wswitch -Wtrigraphs -Wunused \
-Wuninitialized -Wunknown-pragmas -Wfloat-equal -Wundef \
-Wshadow -Wpointer-arith -Wbad-function-cast -Wwrite-strings \
-Wsign-compare -Waggregate-return -Wstrict-prototypes \
-Wmissing-prototypes -Wmissing-declarations \
-Wformat -Wmissing-format-attribute -Wno-deprecated-declarations \
-Wredundant-decls -Wnested-externs -Winline -Wlong-long \
-Wunreachable-code -Wcast-align -Wmissing-noreturn \
-Wconversion ")
endif (CMAKE_VERBOSE_MAKEFILE)

