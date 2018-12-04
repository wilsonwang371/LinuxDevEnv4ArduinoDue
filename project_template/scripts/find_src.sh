#!/usr/bin/env bash
if [ $# -ne 1 ]
then
    exit 1
fi

files=$(find "$1" -name '*.c' -o -name '*.cpp' -o -name '*.S')
for i in ${files}
do
    echo -n "$i "
done
