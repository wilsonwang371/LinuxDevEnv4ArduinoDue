
message ("Searching SAM directory...")
execute_process (COMMAND bash -c "find ~/ -name sam"
                 OUTPUT_VARIABLE POSSIBLE_SAM_DIRS)

execute_process (COMMAND bash -c "for i in \"${POSSIBLE_SAM_DIRS}\"; do find \$i -name cores; done;"
                 OUTPUT_VARIABLE SAM_CORES_DIRS)
separate_arguments (SAM_CORES_DIRS_LIST UNIX_COMMAND ${SAM_CORES_DIRS})
list (GET SAM_CORES_DIRS_LIST 0 SAM_CORES_DIR)
get_filename_component (SAM_DIR ${SAM_CORES_DIR} DIRECTORY)
unset (SAM_CORES_DIRS)
unset (SAM_CORES_DIRS_LIST)
unset (SAM_CORES_DIR)

set (SAM_CORES_DIR "${SAM_DIR}/cores/arduino")
set (SAM_VARIANTS_DIR "${SAM_DIR}/variants/arduino_due_x")
set (SAM_SYSTEM_DIR "${SAM_DIR}/system")
set (SAM_HEADER_FILES_DIR "${SAM_SYSTEM_DIR}/libsam")


set (SAM_CMSIS_DEVICE_HEADER_FILES_DIR "${SAM_SYSTEM_DIR}/CMSIS/Device/ATMEL")
set (SAM_CMSIS_HEADER_FILES_DIR "${SAM_SYSTEM_DIR}/CMSIS/CMSIS/Include")

include_directories("${SAM_CORES_DIR}")
include_directories("${SAM_HEADER_FILES_DIR}")
include_directories("${SAM_CMSIS_DEVICE_HEADER_FILES_DIR}")
include_directories("${SAM_CMSIS_HEADER_FILES_DIR}")
include_directories("${SAM_VARIANTS_DIR}")

aux_source_directory (${SAM_CORES_DIR} SAM_CORES_SRC_FILES)
add_library (sam_cores_lib STATIC ${SAM_CORES_SRC_FILES})
aux_source_directory (${SAM_CORES_DIR}/avr SAM_CORES_AVR_SRC_FILES)
add_library (sam_cores_avr_lib STATIC ${SAM_CORES_AVR_SRC_FILES})
aux_source_directory (${SAM_CORES_DIR}/USB SAM_CORES_USB_SRC_FILES)
add_library (sam_cores_usb_lib STATIC ${SAM_CORES_USB_SRC_FILES})

aux_source_directory (${SAM_VARIANTS_DIR} SAM_VARIANTS_SRC_FILES)
add_library (sam_variants_lib STATIC ${SAM_VARIANTS_SRC_FILES})

add_library (libsam_static STATIC IMPORTED)
set_target_properties(libsam_static PROPERTIES IMPORTED_LOCATION
                      ${SAM_VARIANTS_DIR}/libsam_sam3x8e_gcc_rel.a)

