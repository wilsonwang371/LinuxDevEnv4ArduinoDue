execute_process (COMMAND bash -c "${CMAKE_SOURCE_DIR}/scripts/find_file.sh \"${ARDUINO_DIR}\" gcc exe"
OUTPUT_VARIABLE CMAKE_C_COMPILER)

execute_process (COMMAND bash -c "${CMAKE_SOURCE_DIR}/scripts/find_file.sh \"${ARDUINO_DIR}\" gcc exe"
OUTPUT_VARIABLE CMAKE_CXX_COMPILER)

execute_process (COMMAND bash -c "${CMAKE_SOURCE_DIR}/scripts/find_file.sh \"${ARDUINO_DIR}\" -ar exe"
OUTPUT_VARIABLE CMAKE_AR)

execute_process (COMMAND bash -c "${CMAKE_SOURCE_DIR}/scripts/find_file.sh \"${ARDUINO_DIR}\" -as exe"
OUTPUT_VARIABLE CMAKE_ASM_COMPILER)

execute_process (COMMAND bash -c "${CMAKE_SOURCE_DIR}/scripts/find_file.sh \"${ARDUINO_DIR}\" -objcopy exe"
OUTPUT_VARIABLE OBJCP)

message ("    GCC: ${CMAKE_C_COMPILER}")
message ("    G++: ${CMAKE_CXX_COMPILER}")
message ("    AR: ${CMAKE_AR}")
message ("    AS: ${CMAKE_ASM_COMPILER}")
message ("    OBJCOPY: ${OBJCP}")

