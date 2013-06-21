//
//  JiveRetryingURLConnectionOperation.h
//  jive-ios-sdk
//
//  Created by Heath Borders on 6/20/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "AFURLConnectionOperation.h"
#import "JiveRetryingOperation.h"

@interface JiveRetryingURLConnectionOperation : AFURLConnectionOperation<JiveRetryingOperation>

@end
