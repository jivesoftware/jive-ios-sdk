//
//  JiveRequestOptions.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/25/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveRequestOptions.h"

@implementation JiveRequestOptions
@synthesize beforeDate, afterDate, count;

- (BOOL) isValid {
    
    // Only one of beforeDate OR afterDate can be set
    // At least one option must be set
    return (!(self.beforeDate && self.afterDate)) &&
        (self.beforeDate != nil || self.afterDate != nil || count > 0);
    
}

@end
