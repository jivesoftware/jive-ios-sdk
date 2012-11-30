//
//  JiveSortedRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveSortedRequestOptions.h"

@implementation JiveSortedRequestOptions

@synthesize sort;

- (NSString *)toQueryString {
    
    static const NSString *sortStrings[] = {
        @"dateCreatedDesc",
        @"dateCreatedAsc",
        @"latestActivityDesc",
        @"latestActivityAsc",
        @"titleAsc",
    };
    NSString *queryString = [super toQueryString];
    
    if (!sort)
        return queryString;
    
    if (queryString)
        return [NSString stringWithFormat:@"%@&sort=%@", queryString, sortStrings[sort]];
    
    return [NSString stringWithFormat:@"sort=%@", sortStrings[sort]];
}

@end
