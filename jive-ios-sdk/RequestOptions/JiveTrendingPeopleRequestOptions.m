//
//  JiveTrendingPeopleRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveTrendingPeopleRequestOptions.h"

@implementation JiveTrendingPeopleRequestOptions

- (NSMutableArray *)buildFilter {
    
    NSMutableArray *filter = [NSMutableArray array];
    
    if (self.url)
        [filter addObject:[NSString stringWithFormat:@"place(%@)", self.url]];
    
    return filter;
}

- (NSString *)toQueryString {
    
    NSString *query = [super toQueryString];
    NSMutableArray *filter = [self buildFilter];
    
    if ([filter count] == 0)
        return query;
    
    NSString *filterString = [filter componentsJoinedByString:@"&filter="];
    
    if (!query)
        return [NSString stringWithFormat:@"filter=%@", filterString];
    
    return [query stringByAppendingFormat:@"&filter=%@", filterString];
}

@end
