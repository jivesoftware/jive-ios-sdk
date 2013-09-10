#!/bin/bash -e

if [ $# -eq 1 ]; then
    build="$1"
elif [ -d "$PROJECT_DIR"/.git ]; then
    build=`git describe`
else
    build="SOURCE"
fi

if [[ "${build}" == "" ]]; then
echo "No build number from git"
exit 2
fi

echo "@\"${build}\"" > jive-ios-sdk/JiveiOSSDKVersion.h
