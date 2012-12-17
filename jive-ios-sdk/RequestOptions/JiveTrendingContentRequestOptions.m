//
//  JiveTrendingContentRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/30/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveTrendingContentRequestOptions.h"

@implementation JiveTrendingContentRequestOptions

- (NSMutableArray *)buildFilter {
    
    NSMutableArray *filter = [super buildFilter];
    
    if (self.types) {
        NSString *typeString = [self.types componentsJoinedByString:@","];
        
        [filter addObject:[NSString stringWithFormat:@"type(%@)", typeString]];
    }
    
    return filter;
}

- (void)addType:(NSString *)newType {
    
    if (!self.types)
        self.types = [NSArray arrayWithObject:newType];
    else
        self.types = [self.types arrayByAddingObject:newType];
}

@end
