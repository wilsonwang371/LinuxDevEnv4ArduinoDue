
message ("Searching GCC toolchain for Arduino DUE...")

execute_process (COMMAND bash -c "${CMAKE_SOURCE_DIR}/scripts/find_file.sh \"${ARDUINO_PKG_DIR}\" .*-gcc$ exe"
OUTPUT_VARIABLE CMAKE_C_COMPILER)

execute_process (COMMAND bash -c "${CMAKE_SOURCE_DIR}/scripts/find_file.sh \"${ARDUINO_PKG_DIR}\" .*-gcc$ exe"
OUTPUT_VARIABLE CMAKE_CXX_COMPILER)

execute_process (COMMAND bash -c "${CMAKE_SOURCE_DIR}/scripts/find_file.sh \"${ARDUINO_PKG_DIR}\" .*-ar$ exe"
OUTPUT_VARIABLE CMAKE_AR)

execute_process (COMMAND bash -c "${CMAKE_SOURCE_DIR}/scripts/find_file.sh \"${ARDUINO_PKG_DIR}\" .*-as$ exe"
OUTPUT_VARIABLE CMAKE_ASM_COMPILER)

execute_process (COMMAND bash -c "${CMAKE_SOURCE_DIR}/scripts/find_file.sh \"${ARDUINO_PKG_DIR}\" .*-objcopy$ exe"
OUTPUT_VARIABLE OBJCP)

execute_process (COMMAND bash -c "${CMAKE_SOURCE_DIR}/scripts/find_file.sh \"${ARDUINO_PKG_DIR}\" .*flash.ld$ file"
OUTPUT_VARIABLE LNK_SCRIPT)

message ("    GCC: ${CMAKE_C_COMPILER}")
message ("    G++: ${CMAKE_CXX_COMPILER}")
message ("    AR: ${CMAKE_AR}")
message ("    AS: ${CMAKE_ASM_COMPILER}")
message ("    OBJCOPY: ${OBJCP}")
message ("    LINK SCRIPT: ${LNK_SCRIPT}")

