#!/bin/bash -e

if [ $# -eq 1 ]; then
    build="$1"
elif [ -e "$PROJECT_DIR"/.git ]; then
    build=`git describe`
fi

if [[ "${build}" == "" ]]; then
echo "No build number from git"
exit
fi

echo "@\"${build}\"" > jive-ios-sdk/JiveiOSSDKVersion.h
echo "PROJECT_NUMBER = ${build}" >> Documentation/Doxyfile
