//
//  JiveSearchContentsRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/4/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveSearchContentsRequestOptions.h"

@implementation JiveSearchContentsRequestOptions

- (NSString *)buildFilter {
    
    NSString *filter = [super buildFilter];
    
    if (self.types) {
        NSString *typeFilters = [self.types componentsJoinedByString:@","];
        
        if (filter)
            filter = [filter stringByAppendingFormat:@",type(%@)", typeFilters];
        else
            filter = [NSString stringWithFormat:@"type(%@)", typeFilters];
    }
    
    if (self.subjectOnly) {
        if (filter)
            filter = [filter stringByAppendingString:@",subjectonly"];
        else
            filter = @"subjectonly";
    }

    return filter;
}

- (void)addType:(NSString *)type {
    
    if (!self.types)
        self.types = [NSArray arrayWithObject:type];
    else
        self.types = [self.types arrayByAddingObject:type];
}

@end
