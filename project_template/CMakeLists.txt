project(example C ASM CXX)
cmake_minimum_required(VERSION 3.0)


set (ARDUINO_PKG_DIR "$ENV{HOME}/.arduino15/packages")
set (ARDUINO_LIB_DIR "$ENV{HOME}/arduino-1.8.7/libraries")

set (TARGET_NAME "firmware")

include("${CMAKE_SOURCE_DIR}/cmake_include/toolchain.cmake")
include("${CMAKE_SOURCE_DIR}/cmake_include/libraries.cmake")
include("${CMAKE_SOURCE_DIR}/cmake_include/libraries2.cmake")
include("${CMAKE_SOURCE_DIR}/cmake_include/header_inc.cmake")
include("${CMAKE_SOURCE_DIR}/cmake_include/uploader.cmake")

set (UPLOAD_BOSSA "")
set (UPLOAD_VERBOSE_FLAGS "-i -d")
set (UPLOAD_PORT_BASENAME "ttyACM0")

include_directories ("${CMAKE_SOURCE_DIR}/inc")
aux_source_directory ("${CMAKE_SOURCE_DIR}/src" OBJ_FILES)
add_library (proj_obj STATIC ${OBJ_FILES})

set (LNK_SCRIPT "${SAM_VARIANTS_DIR}/linker_scripts/gcc/flash.ld")

set (CMAKE_CXX_FLAGS_DEBUG "-MMD -g -O0 -DDEBUG")
set (CMAKE_CXX_FLAGS_RELEASE "-MMD -Os")

set (CMAKE_C_FLAGS_DEBUG "-g -O0 -DDEBUG")
set (CMAKE_C_FLAGS_RELEASE "-Os")

if (CMAKE_BUILD_TYPE STREQUAL "Debug")
set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O0")
set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O0")
else (CMAKE_BUILD_TYPE STREQUAL "Debug")
set (CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Os")
set (CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Os")
endif (CMAKE_BUILD_TYPE STREQUAL "Debug")

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
\"-T${LNK_SCRIPT}\" \"-Wl,-Map,${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}.map\" \
\"-L${CMAKE_CURRENT_BINARY_DIR}\" \
-lm -lgcc -mthumb -Wl,--cref -Wl,--check-sections -Wl,--gc-sections \
-Wl,--entry=Reset_Handler -Wl,--unresolved-symbols=report-all -Wl,--warn-common \
-Wl,--warn-section-align -Wl,--warn-unresolved-symbols")

#add_custom_target(${TARGET_NAME}.elf ALL DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}.elf")
add_custom_command (OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}.elf"
DEPENDS proj_obj ${ALL_LIBS}
COMMAND ${CMAKE_CXX_COMPILER} -Os -Wl,--gc-sections -mcpu=cortex-m3 "-T${LNK_SCRIPT}" "-Wl,-Map,${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}.map" -o ${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}.elf "-L${CMAKE_CURRENT_BINARY_DIR}" -lm -lgcc -mthumb -Wl,--cref -Wl,--check-sections -Wl,--gc-sections -Wl,--entry=Reset_Handler -Wl,--unresolved-symbols=report-all -Wl,--warn-common -Wl,--warn-section-align -Wl,--warn-unresolved-symbols -Wl,--start-group $<TARGET_FILE:proj_obj> ${${ALL_LIBS}} -Wl,--end-group )

#add_custom_target(${TARGET_NAME}.bin ALL DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}.elf")
add_custom_command (OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}.bin"
DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}.elf"
COMMAND ${OBJCP} -O binary ${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}.elf ${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}.bin)

