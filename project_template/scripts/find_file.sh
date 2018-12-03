#!/usr/bin/env bash
# find_file.sh <search_root_dir> <partial_name> [exe, dir]

if [ $# -ne 3 ]
then
    exit 1
fi

files=$(find "$1" | grep "$2")
if [ "$3" == "dir" ]
then
    target="directory"
elif [ "$3" == "exe" ]
then
    target="executable"
fi
if [ "${target}" == "" ]
then
    exit 1
fi
for i in ${files}
do
    tmptype=$(file $i)
    if [[ "${tmptype}" == *${target}* ]]
    then
        echo -n $i
        break
    fi
done
