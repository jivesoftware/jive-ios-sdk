#!/bin/bash -e

WORKSPACE_INTERNAL=${1:-"$WORKSPACE"}

rm -rf "$WORKSPACE_INTERNAL"/test-Objects-*
rm -rf "$WORKSPACE_INTERNAL"/junit.xml
rm -rf "$WORKSPACE_INTERNAL"/coverage.xml

"$WORKSPACE_INTERNAL"/lib/xctool/xctool.sh -workspace "$WORKSPACE_INTERNAL"/jive-ios-sdk.xcworkspace/ -scheme jive-ios-sdk -sdk iphonesimulator7.1 -arch x86_64 -reporter junit:"$WORKSPACE_INTERNAL"/junit.xml -reporter plain test GCC_GENERATE_TEST_COVERAGE_FILES=YES GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES OBJECT_FILE_DIR="$WORKSPACE_INTERNAL"/jive-ios-sdk/test-Objects >&1 -destination "name=iPhone Retina (4-inch 64-bit)"
"$WORKSPACE_INTERNAL"/lib/gcovr --xml --object-directory="$WORKSPACE_INTERNAL"/test-Objects-normal/x86_64 --output "$WORKSPACE_INTERNAL"/coverage.xml -r "$WORKSPACE_INTERNAL"/jive-ios-sdk
