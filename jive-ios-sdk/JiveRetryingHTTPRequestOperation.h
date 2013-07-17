//
//  JiveRetryingHTTPRequestOperation.h
//  jive-ios-sdk
//
//  Created by Heath Borders on 6/20/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "Jive.h"
#import "AFHTTPRequestOperation.h"
#import "JiveRetryingOperation.h"

@interface JiveRetryingHTTPRequestOperation : AFHTTPRequestOperation<JiveRetryingOperation>

@end
