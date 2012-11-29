//
//  JivePeopleRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePeopleRequestOptions.h"

@implementation JivePeopleRequestOptions

- (NSString *)buildFilter {
    
    NSString *filter = [super buildFilter];

    if (!self.title)
        return filter;

    return [self addFilterGroup:@"title" withValue:self.title toFilter:filter];
}

@end
