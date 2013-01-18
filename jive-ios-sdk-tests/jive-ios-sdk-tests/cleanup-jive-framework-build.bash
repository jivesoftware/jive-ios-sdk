#!/bin/bash -e

#  cleanup-jive-framework-build.bash
#  jive-ios-sdk-tests
#
#  Created by Heath Borders on 1/17/13.
#  Copyright (c) 2013 Jive Software. All rights reserved.

echo Cleanup Jive Framework build detritis
pushd "${BUILT_PRODUCTS_DIR}"
rm -rf Jive/ JiveHeaders/ libJive.a
popd
