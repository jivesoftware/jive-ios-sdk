//
//  JiveWelcomeRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveWelcomeRequestOptions.h"

@implementation JiveWelcomeRequestOptions

@synthesize welcome;

- (NSString *)toQueryString {
    
    NSString *queryString = [super toQueryString];
    
    if (!welcome)
        return queryString;
    
    if (!queryString)
        return @"welcome=true";

    return [queryString stringByAppendingString:@"&welcome=true"];
}

@end
