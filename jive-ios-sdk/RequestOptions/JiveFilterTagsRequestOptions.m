//
//  JiveFilterTagsRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveFilterTagsRequestOptions.h"

@implementation JiveFilterTagsRequestOptions

- (NSString *)addFilterGroup:(NSString *)tag withValue:(NSString *)value toFilter:(NSString *)filter {
    
    if (filter)
        return [filter stringByAppendingFormat:@",%@(%@)", tag, value];

    return [NSString stringWithFormat:@"%@(%@)", tag, value];
}

- (NSString *)buildFilter {
    
    if (!self.tags)
        return nil;

    return [NSString stringWithFormat:@"tag(%@)", [self.tags componentsJoinedByString:@","]];
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

- (void)addTag:(NSString *)tag {
    
    if (!self.tags)
        self.tags = [NSArray arrayWithObject:tag];
    else
        self.tags = [self.tags arrayByAddingObject:tag];
}

@end
