#!/usr/bin/env bash

echo -n "New project directory name:"
read proj_name
dir_name="$( cd "$(dirname "$0")" ; pwd -P )"
cp -R "${dir_name}/tpl" "${dir_name}/${proj_name}"

