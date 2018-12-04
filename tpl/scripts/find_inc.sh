#!/usr/bin/env bash
# find_src.sh <search_root_dir>
if [ $# -ne 1 ]
then
    exit 1
fi

files=$(find "$1" -name '*.h')
final_dirs=""
for i in ${files}
do
    tmpdir=$(dirname $i)
    if [[ "${final_dirs}" == *${tmpdir}:* ]]
    then
        continue
    fi
    final_dirs=${final_dirs}${tmpdir}:
done
#final_dirs=${final_dirs:0:$((${#final_dirs} - 1))}
echo -n ${final_dirs//:/ }
