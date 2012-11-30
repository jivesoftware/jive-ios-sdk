//
//  JiveTrendingPeopleRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveTrendingPeopleRequestOptions.h"

@implementation JiveTrendingPeopleRequestOptions

- (NSString *)toQueryString {
    
    NSString *query = [super toQueryString];

    if (!self.url)
        return query;

    if (query)
        return [query stringByAppendingFormat:@"&filter=place(%@)", self.url];

    return [NSString stringWithFormat:@"filter=place(%@)", self.url];
}

@end
