//
//  JivePixelSizeRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePixelSizeRequestOptions.h"

@implementation JivePixelSizeRequestOptions

@synthesize size;

- (NSString *)toQueryString {
    
    if (!size)
        return nil;
    
    return [NSString stringWithFormat:@"size=%d", size];
}

@end
