#!/bin/bash -e

GHUNIT_CLI=YES WRITE_JUNIT_XML=YES JUNIT_XML_DIR=test-reports xcodebuild -scheme jive-ios-sdk-tests -workspace jive-ios-sdk.xcworkspace -configuration Debug -sdk iphonesimulator clean build

