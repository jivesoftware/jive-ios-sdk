//
//  JiveTrendingContentRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/30/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveTrendingContentRequestOptions.h"

@implementation JiveTrendingContentRequestOptions

- (NSString *)buildFilter {
    
    NSString *filter = [super buildFilter];
    
    if (!self.types)
        return filter;
    
    NSString *typeString = [self.types componentsJoinedByString:@","];
    
    if (filter)
        return [filter stringByAppendingFormat:@",type(%@)", typeString];
    
    return [NSString stringWithFormat:@"type(%@)", typeString];
}

- (void)addType:(NSString *)newType {
    
    if (!self.types)
        self.types = [NSArray arrayWithObject:newType];
    else
        self.types = [self.types arrayByAddingObject:newType];
}

@end
