//
//  JiveTrendingPeopleRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveTrendingPeopleRequestOptions.h"

@implementation JiveTrendingPeopleRequestOptions

- (NSString *)buildFilter {
    
    if (!self.url)
        return nil;
    
    return [NSString stringWithFormat:@"place(%@)", self.url];
}

- (NSString *)toQueryString {
    
    NSString *query = [super toQueryString];
    NSString *filter = [self buildFilter];
    
    if (!filter)
        return query;
    
    if (!query)
        return [NSString stringWithFormat:@"filter=%@", filter];
    
    return [query stringByAppendingFormat:@"&filter=%@", filter];
}

@end
