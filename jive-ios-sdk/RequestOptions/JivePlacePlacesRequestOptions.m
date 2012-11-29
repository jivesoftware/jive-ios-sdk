//
//  JivePlacePlacesRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePlacePlacesRequestOptions.h"

@implementation JivePlacePlacesRequestOptions

- (NSString *)toQueryString {
    
    NSString *query = [super toQueryString];
    
    if (!self.types && !self.tags && !self.search)
        return query;
    
    NSString *filterValues;
    NSString *filter = nil;

    if (self.types)
        filter = [NSString stringWithFormat:@"type(%@)", [self.types componentsJoinedByString:@","]];

    if (self.tags) {
        filterValues = [self.tags componentsJoinedByString:@","];
        if (filter)
            filter = [filter stringByAppendingFormat:@",tag(%@)", filterValues];
        else
            filter = [NSString stringWithFormat:@"tag(%@)", filterValues];
    }
    
    if (self.search) {
        filterValues = [self.search componentsJoinedByString:@","];
        if (filter)
            filter = [filter stringByAppendingFormat:@",search(%@)", filterValues];
        else
            filter = [NSString stringWithFormat:@"search(%@)", filterValues];
    }
    
    if (!query)
        return [NSString stringWithFormat:@"filter=%@", filter];
    
    return [query stringByAppendingFormat:@"&filter=%@", filter];
}

- (void)addType:(NSString *)type {
    
    if (!self.types)
        self.types = [NSArray arrayWithObject:type];
    else
        self.types = [self.types arrayByAddingObject:type];
}

- (void)addTag:(NSString *)tag {
    
    if (!self.tags)
        self.tags = [NSArray arrayWithObject:tag];
    else
        self.tags = [self.tags arrayByAddingObject:tag];
}

- (void)addSearchTerm:(NSString *)term {
    
    term = [term stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    term = [term stringByReplacingOccurrencesOfString:@"," withString:@"\\,"];
    term = [term stringByReplacingOccurrencesOfString:@"(" withString:@"\\("];
    term = [term stringByReplacingOccurrencesOfString:@")" withString:@"\\)"];
    if (!self.search)
        self.search = [NSArray arrayWithObject:term];
    else
        self.search = [self.search arrayByAddingObject:term];
}

@end
