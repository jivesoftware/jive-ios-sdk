//
//  JiveFilterTagsRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveFilterTagsRequestOptions.h"

@implementation JiveFilterTagsRequestOptions

- (NSMutableArray *)buildFilter {
    
    NSMutableArray *filterArray = [NSMutableArray array];
    
    if (self.tags) {
        NSString *tagString = [self.tags componentsJoinedByString:@","];
        
        [filterArray addObject:[NSString stringWithFormat:@"tag(%@)", tagString]];
    }

    return filterArray;
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

- (void)addTag:(NSString *)tag {
    
    if (!self.tags)
        self.tags = [NSArray arrayWithObject:tag];
    else
        self.tags = [self.tags arrayByAddingObject:tag];
}

@end
