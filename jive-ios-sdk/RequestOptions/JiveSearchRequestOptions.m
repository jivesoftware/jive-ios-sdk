//
//  JiveSearchRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/4/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveSearchRequestOptions.h"

@implementation JiveSearchRequestOptions

- (NSString *)buildFilter {
    
    if (!self.search)
        return nil;
    
    return [NSString stringWithFormat:@"search(%@)", [self.search componentsJoinedByString:@","]];
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

@end
