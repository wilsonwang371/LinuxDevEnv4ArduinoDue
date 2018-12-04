#!/usr/bin/env bash

echo -n "New project directory name:"
read proj_name
dir_name="$( cd "$(dirname "$0")" ; pwd -P )"
pushd ${dir_name}
cp -R tpl "${proj_name}"
popd

