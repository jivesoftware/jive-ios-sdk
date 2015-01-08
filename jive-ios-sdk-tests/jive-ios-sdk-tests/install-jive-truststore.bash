#!/bin/bash -e

#  install-jive-truststore.bash
#  jive-ipad
#
#  Created by Heath Borders on 12/17/12.
#  Copyright (c) 2012 Jive Software. All rights reserved.

for TRUST_STORE_PATH in ~/Library/Developer/CoreSimulator/Devices/*/Data/Library/Keychains/TrustStore.sqlite3; do
echo overwriting $TRUST_STORE_PATH
cp "$PROJECT_DIR"/"$TARGET_NAME"/jive-TrustStore.sqlite3 "$TRUST_STORE_PATH"
done
