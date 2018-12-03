
message ("Searching libraries...")

file (STRINGS ${CMAKE_SOURCE_DIR}/libraries.list libraries_list)

foreach (one_lib ${libraries_list})
separate_arguments (one_lib_list UNIX_COMMAND ${one_lib})
list (GET one_lib_list 0 lib_target_name)
list (GET one_lib_list 1 lib_search_name)
execute_process (COMMAND bash -c "${CMAKE_SOURCE_DIR}/scripts/find_file.sh \"${ARDUINO_PKG_DIR}\" ${lib_search_name} dir"
OUTPUT_VARIABLE lib_dir)
execute_process (COMMAND bash -c "${CMAKE_SOURCE_DIR}/scripts/find_src.sh \"${lib_dir}\""
OUTPUT_VARIABLE src_files)
separate_arguments (src_files_list UNIX_COMMAND ${src_files})
add_library (${lib_target_name} STATIC ${src_files_list})
endforeach (one_lib)

