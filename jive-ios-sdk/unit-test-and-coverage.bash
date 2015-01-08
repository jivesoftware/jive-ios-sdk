#!/bin/bash -e

WORKSPACE_INTERNAL=${1:-"$WORKSPACE"}

rm -rf "$WORKSPACE_INTERNAL"/DerivedData
rm -rf "$WORKSPACE_INTERNAL"/junit.xml
rm -rf "$WORKSPACE_INTERNAL"/coverage.xml

"$WORKSPACE_INTERNAL"/lib/xctool/xctool.sh -workspace "$WORKSPACE_INTERNAL"/jive-ios-sdk.xcworkspace/ -scheme jive-ios-sdk-tests -sdk iphonesimulator -destination "name=iPhone 5" -IDECustomDerivedDataLocation="$WORKSPACE_INTERNAL"/DerivedData -reporter junit:"$WORKSPACE_INTERNAL"/junit.xml -reporter plain test GCC_GENERATE_TEST_COVERAGE_FILES=YES GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES >&1
"$WORKSPACE_INTERNAL"/lib/xctool/xctool.sh -workspace "$WORKSPACE_INTERNAL"/jive-ios-sdk.xcworkspace/ -scheme jive-ios-sdk-tests -sdk iphonesimulator -destination "name=iPhone 5s" -IDECustomDerivedDataLocation="$WORKSPACE_INTERNAL"/DerivedData -reporter junit:"$WORKSPACE_INTERNAL"/junit.xml -reporter plain test GCC_GENERATE_TEST_COVERAGE_FILES=YES GCC_INSTRUMENT_PROGRAM_FLOW_ARCS=YES >&1
TEST_OBJECTS_DIR=`find $WORKSPACE_INTERNAL -path "**/Debug-iphonesimulator/jive-ios-sdk.build/Objects*" -type d`
"$WORKSPACE_INTERNAL"/lib/gcovr --xml --object-directory="$TEST_OBJECTS_DIR" --output "$WORKSPACE_INTERNAL"/coverage.xml -r "$WORKSPACE_INTERNAL"/jive-ios-sdk
