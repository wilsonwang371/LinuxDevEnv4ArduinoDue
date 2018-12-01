set(UPLOAD_BOSSA "")
set(UPLOAD_PORT_BASENAME "ttyACM0")

message ("Searching BOSSA binary...")
execute_process (COMMAND bash -c "find ~/ -name bossac"
                 OUTPUT_VARIABLE possible_bossac)
separate_arguments (possible_bossac_list UNIX_COMMAND ${possible_bossac})
foreach (possible_bossac_item ${possible_bossac_list})
execute_process (COMMAND bash -c "file ${possible_bossac_item} | grep executable"
                 OUTPUT_VARIABLE tmp_type)
if ("${tmp_type}" STREQUAL "")
else ("${tmp_type}" STREQUAL "")
set (UPLOAD_BOSSA "${possible_bossac_item}")
break ()
endif ("${tmp_type}" STREQUAL "")
endforeach (possible_bossac_item)


add_custom_target (binary ALL DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}.bin")

add_custom_command (OUTPUT upload_cmd
DEPENDS binary
COMMAND echo "Touch programming port ..."
COMMAND stty --file="/dev/${UPLOAD_PORT_BASENAME}" raw ispeed 1200 ospeed 1200 cs8 -cstopb ignpar eol 255 eof 255
COMMAND printf "\\x00" > "/dev/${UPLOAD_PORT_BASENAME}"
COMMAND echo "Waiting before uploading ..."
COMMAND sleep 1
COMMAND echo "Uploading ..."
COMMAND ${UPLOAD_BOSSA} -i --port="${UPLOAD_PORT_BASENAME}" -e -w -v -b "${CMAKE_CURRENT_BINARY_DIR}/${TARGET_NAME}.bin" -R
COMMAND echo "Done." )
add_custom_target (upload DEPENDS upload_cmd)

