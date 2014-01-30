#!/bin/bash -e

WORKSPACE_INTERNAL=${1:-"$WORKSPACE"}

rm -rf "$WORKSPACE_INTERNAL"/test-Objects-*
rm -rf "$WORKSPACE_INTERNAL"/junit.xml
rm -rf "$WORKSPACE_INTERNAL"/coverage.xml

"$WORKSPACE_INTERNAL"/lib/xctool/xctool.sh -workspace "$WORKSPACE_INTERNAL"/jive-ios-sdk.xcworkspace/ -scheme jive-ios-sdk -sdk iphonesimulator6.1 -reporter junit:"$WORKSPACE_INTERNAL"/junit.xml -reporter plain test GCC_GENERATE_TEST_COVERAGE_FILES=YES GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES OBJECT_FILE_DIR="$WORKSPACE_INTERNAL"/jive-ios-sdk/test-Objects >&1 ONLY_ACTIVE_ARCH=NO
cp "$WORKSPACE_INTERNAL"/lib/gcovr "$WORKSPACE_INTERNAL"/jive-ios-sdk/test-Objects-*/i386
cd "$WORKSPACE_INTERNAL"/jive-ios-sdk/test-Objects-*/i386
./gcovr --xml --output "$WORKSPACE_INTERNAL"/coverage.xml -r "$WORKSPACE_INTERNAL"/jive-ios-sdk
