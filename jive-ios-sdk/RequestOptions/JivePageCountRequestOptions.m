//
//  JivePageCountRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePageCountRequestOptions.h"

@implementation JivePageCountRequestOptions

@synthesize count;

- (NSString *)toQueryString
{
    NSString *queryString = [super toQueryString];

    if (count == 0)
        return queryString;

    if (queryString.length > 0)
        return [queryString stringByAppendingString:[NSString stringWithFormat:@"&count=%d", count]];

    return [NSString stringWithFormat:@"count=%d", count];
}

@end
