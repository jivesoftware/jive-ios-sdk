//
//  JivePagedRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePagedRequestOptions.h"

@implementation JivePagedRequestOptions

@synthesize startIndex;

- (NSString *)toQueryString {
    
    NSString *queryString = [super toQueryString];
    
    if (startIndex == 0)
        return queryString;
    
    if (queryString)
        return [NSString stringWithFormat:@"%@&startIndex=%d", queryString, startIndex];
    
    return [NSString stringWithFormat:@"startIndex=%d", startIndex];
}

@end
