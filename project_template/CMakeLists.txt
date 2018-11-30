project(example C ASM CXX)
cmake_minimum_required(VERSION 3.0)

set (CROSSCOMPILE_TOOLCHAIN "/usr/bin/arm-none-eabi-")
set (CMAKE_C_COMPILER "${CROSSCOMPILE_TOOLCHAIN}gcc")
set (CMAKE_CXX_COMPILER "${CROSSCOMPILE_TOOLCHAIN}gcc")
set (CMAKE_AR "${CROSSCOMPILE_TOOLCHAIN}ar")
set (CMAKE_ASM_COMPILER "${CROSSCOMPILE_TOOLCHAIN}as")

include("${CMAKE_SOURCE_DIR}/cmake_include/libraries.cmake")

include_directories (${CMAKE_SOURCE_DIR}/inc)
aux_source_directory (${CMAKE_SOURCE_DIR}/src OBJ_FILES)
add_library (proj_obj STATIC ${OBJ_FILES})

set (LNK_SCRIPT "${SAM_VARIANTS_DIR}/linker_scripts/gcc/flash.ld")

set (CMAKE_CXX_FLAGS_DEBUG "-MMD -g -O0 -DDEBUG")
set (CMAKE_CXX_FLAGS_RELEASE "-MMD -Os")

set (CMAKE_C_FLAGS_DEBUG "-g -O0 -DDEBUG")
set (CMAKE_C_FLAGS_RELEASE "-Os")

if (CMAKE_BUILD_TYPE EQUAL "Debug")
set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O0")
set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O0")
else (CMAKE_BUILD_TYPE EQUAL "Debug")
set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Os")
set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Os")
endif (CMAKE_BUILD_TYPE EQUAL "Debug")

set (CMAKE_CXX_ARCHIVE_CREATE "<CMAKE_AR> rcs <TARGET> <LINK_FLAGS> <OBJECTS>")
set (CMAKE_C_ARCHIVE_CREATE "<CMAKE_AR> rcs <TARGET> <LINK_FLAGS> <OBJECTS>")

set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DF_CPU=84000000L -DARDUINO=10806 -DARDUINO_SAM_DUE -DARDUINO_ARCH_SAM -D__SAM3X8E__")
set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DUSB_VID=0x2341 -DUSB_PID=0x003e -DUSBCON '-DUSB_MANUFACTURER=\"Unknown\"' '-DUSB_PRODUCT=\"Arduino Due\"'")
set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DF_CPU=84000000L -DARDUINO=10806 -DARDUINO_SAM_DUE -DARDUINO_ARCH_SAM -D__SAM3X8E__")
set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -DUSB_VID=0x2341 -DUSB_PID=0x003e -DUSBCON '-DUSB_MANUFACTURER=\"Unknown\"' '-DUSB_PRODUCT=\"Arduino Due\"'")

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

SET(CMAKE_SHARED_LIBRARY_LINK_CXX_FLAGS "")

SET(CMAKE_EXE_LINKER_FLAGS "-Os -Wl,--gc-sections -mcpu=cortex-m3 \
\"-T${LNK_SCRIPT}\" \"-Wl,-Map,${CMAKE_CURRENT_BINARY_DIR}/firmware.map\" \
\"-L${CMAKE_CURRENT_BINARY_DIR}\" \
-lm -lgcc -mthumb -Wl,--cref -Wl,--check-sections -Wl,--gc-sections \
-Wl,--entry=Reset_Handler -Wl,--unresolved-symbols=report-all -Wl,--warn-common \
-Wl,--warn-section-align -Wl,--warn-unresolved-symbols")

add_custom_command (OUTPUT firmware.elf COMMAND ${CMAKE_CXX_COMPILER} -Os -Wl,--gc-sections -mcpu=cortex-m3 "-T${LNK_SCRIPT}" "-Wl,-Map,${CMAKE_CURRENT_BINARY_DIR}/firmware.map" -o firmware.elf "-L${CMAKE_CURRENT_BINARY_DIR}" -lm -lgcc -mthumb -Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--entry=Reset_Handler -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align -Wl,--warn-unresolved-symbols -Wl,--start-group $<TARGET_FILE:proj_obj> $<TARGET_FILE:all_libs> $<TARGET_FILE:libsam_static> -Wl,--end-group )

add_custom_target(firmware.elf ALL DEPENDS proj_obj all_libs libsam_static)

add_executable(app firmware.elf)

