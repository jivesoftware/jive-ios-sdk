//
//  JiveSearchPlacesRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/4/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveSearchPlacesRequestOptions.h"

@implementation JiveSearchPlacesRequestOptions

- (NSString *)buildFilter {
    
    NSString *filter = nil;
    
    if (self.search)
        filter = [NSString stringWithFormat:@"search(%@)", [self.search componentsJoinedByString:@","]];
    
    if (self.nameonly) {
        if (filter)
            filter = [filter stringByAppendingString:@",nameonly"];
        else
            filter = @"nameonly";
    }
    
    if (self.types) {
        NSString *typeFilters = [self.types componentsJoinedByString:@","];
        
        if (filter)
            filter = [filter stringByAppendingFormat:@",type(%@)", typeFilters];
        else
            filter = [NSString stringWithFormat:@"type(%@)", typeFilters];
    }
    
    return filter;
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

- (void)addType:(NSString *)type {
    
    if (!self.types)
        self.types = [NSArray arrayWithObject:type];
    else
        self.types = [self.types arrayByAddingObject:type];
}

@end
