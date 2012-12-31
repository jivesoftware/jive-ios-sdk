//
//  JiveBlog.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/15/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveBlog.h"

@implementation JiveBlog

- (id)init {
    if ((self = [super init])) {
        self.type = @"blog";
    }
    
    return self;
}

@end
