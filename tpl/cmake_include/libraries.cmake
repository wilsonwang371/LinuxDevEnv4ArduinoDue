
message ("Searching libraries...")

file (STRINGS ${CMAKE_SOURCE_DIR}/libraries.list libraries_list)

set (ALL_LIBS "")
set (ALL_LIB_PATHS "")

foreach (one_lib ${libraries_list})
separate_arguments (one_lib_list UNIX_COMMAND ${one_lib})
list (GET one_lib_list 0 lib_target_name)
list (GET one_lib_list 1 lib_search_name)
list (GET one_lib_list 2 lib_type)
list (GET one_lib_list 3 lib_static)
if (lib_type STREQUAL "dir")
    execute_process (COMMAND bash -c "${CMAKE_SOURCE_DIR}/scripts/find_file.sh \"${ARDUINO_PKG_DIR}:${ARDUINO_LIB_DIR}:${ARDUINO_OTHER_LIB_DIR}\" ${lib_search_name} ${lib_type}"
        OUTPUT_VARIABLE lib_dir)
        message ("adding library ${lib_dir}")
    execute_process (COMMAND bash -c "${CMAKE_SOURCE_DIR}/scripts/find_src.sh \"${lib_dir}\""
        OUTPUT_VARIABLE src_files)
    separate_arguments (src_files_list UNIX_COMMAND ${src_files})
    if (lib_static STREQUAL "static")
        add_library (${lib_target_name} STATIC ${src_files_list})
        set (ALL_LIBS ${ALL_LIBS} "${lib_target_name}")
        set (ALL_LIB_PATHS ${ALL_LIB_PATHS} "$<TARGET_FILE:${lib_target_name}>")
    else (lib_static STREQUAL "static")
        add_library (${lib_target_name} ${src_files_list})
        set (ALL_LIBS ${ALL_LIBS} "${lib_target_name}")
        set (ALL_LIB_PATHS ${ALL_LIB_PATHS} "$<TARGET_FILE:${lib_target_name}>")
    endif (lib_static STREQUAL "static")
else (lib_type STREQUAL "dir")
    execute_process (COMMAND bash -c "${CMAKE_SOURCE_DIR}/scripts/find_file.sh \"${ARDUINO_PKG_DIR}\" ${lib_search_name} ${lib_type}"
        OUTPUT_VARIABLE lib_path)
    #message ("path ${lib_path}")
    if (lib_static STREQUAL "static")
        add_library (${lib_target_name} STATIC IMPORTED)
        set_target_properties(${lib_target_name} PROPERTIES IMPORTED_LOCATION
                      ${lib_path})
        set (ALL_LIBS ${ALL_LIBS} "${lib_target_name}")
        set (ALL_LIB_PATHS ${ALL_LIB_PATHS} "$<TARGET_FILE:${lib_target_name}>")
    else (lib_static STREQUAL "static")
        add_library (${lib_target_name} IMPORTED)
        set_target_properties(${lib_target_name} PROPERTIES IMPORTED_LOCATION
                      ${lib_path})
        set (ALL_LIBS ${ALL_LIBS} "${lib_target_name}")
        set (ALL_LIB_PATHS ${ALL_LIB_PATHS} "$<TARGET_FILE:${lib_target_name}>")
    endif (lib_static STREQUAL "static")
endif (lib_type STREQUAL "dir")
endforeach (one_lib)
