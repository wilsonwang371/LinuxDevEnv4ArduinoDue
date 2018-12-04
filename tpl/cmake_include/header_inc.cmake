
message ("Adding including paths...")

file (STRINGS ${CMAKE_SOURCE_DIR}/includes.list includes_list)

foreach (one_include ${includes_list})
    execute_process (COMMAND bash -c "${CMAKE_SOURCE_DIR}/scripts/find_file.sh \"${ARDUINO_PKG_DIR}\" ${one_include} dir"
        OUTPUT_VARIABLE one_include_root)
    #message ("${ARDUINO_PKG_DIR}")
    execute_process (COMMAND bash -c "${CMAKE_SOURCE_DIR}/scripts/find_inc.sh \"${one_include_root}\""
        OUTPUT_VARIABLE one_include)
    separate_arguments (one_include_list UNIX_COMMAND ${one_include})
    #message (${one_include_list})
    include_directories ("${one_include_list}")
endforeach (one_include)
