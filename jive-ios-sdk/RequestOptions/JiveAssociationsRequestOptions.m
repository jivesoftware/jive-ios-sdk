//
//  JiveAssociationsRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/7/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveAssociationsRequestOptions.h"

@implementation JiveAssociationsRequestOptions

- (NSMutableArray *)buildFilter {
    
    NSMutableArray *filterArray = [NSMutableArray array];
    
    if (self.types) {
        NSString *tagString = [self.types componentsJoinedByString:@","];
        
        [filterArray addObject:[NSString stringWithFormat:@"type(%@)", tagString]];
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

- (void)addType:(NSString *)newType {
    if (!self.types)
        self.types = [NSArray arrayWithObject:newType];
    else
        self.types = [self.types arrayByAddingObject:newType];
}

@end
