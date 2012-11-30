//
//  JiveAutoCategorizeRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveAutoCategorizeRequestOptions.h"

@implementation JiveAutoCategorizeRequestOptions

- (NSString *)toQueryString {
    
    NSString *queryString = [super toQueryString];
    
    if (!self.autoCategorize)
        return queryString;
    
    if (!queryString)
        return @"autoCategorize=true";
    
    return [queryString stringByAppendingString:@"&autoCategorize=true"];
}

@end
