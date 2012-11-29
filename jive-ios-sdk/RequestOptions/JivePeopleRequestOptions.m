//
//  JivePeopleRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePeopleRequestOptions.h"

@implementation JivePeopleRequestOptions

- (NSString *)toQueryString {
    
    NSString *query = [super toQueryString];
    NSString *filter = nil;
    
    if (self.tags)
        filter = [NSString stringWithFormat:@"tag(%@)", [self.tags componentsJoinedByString:@","]];
    
    if (self.title) {
        if (filter)
            filter = [filter stringByAppendingFormat:@",title(%@)", self.title];
        else
            filter = [NSString stringWithFormat:@"title(%@)", self.title];
    }
    
    if (!filter)
        return query;
    
    if (!query)
        return [NSString stringWithFormat:@"filter=%@", filter];

    return [query stringByAppendingFormat:@"&filter=%@", filter];
}

- (void)addTag:(NSString *)tag {
    
    if (!self.tags)
        self.tags = [NSArray arrayWithObject:tag];
    else
        self.tags = [self.tags arrayByAddingObject:tag];
}

@end
