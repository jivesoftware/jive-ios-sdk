#!/bin/bash -e

#  cleanup-jive-framework-build.bash
#  jive-ios-sdk-tests
#
#  Created by Heath Borders on 1/17/13.
#  Copyright (c) 2013 Jive Software. All rights reserved.

#Cleanup Jive Framework build detritis
echo Cleaning BUILT_PRODUCTS_DIR: "${BUILT_PRODUCTS_DIR}"
pushd "${BUILT_PRODUCTS_DIR}"
echo BUILT_PRODUCTS_DIR contents: `ls`
rm -rf Jive/ JiveHeaders/ libJive.a
popd
