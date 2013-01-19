//
//  JiveSearchRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/4/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveSearchRequestOptions_internal.h"
#import "JiveNSString+URLArguments.h"

@implementation JiveSearchRequestOptions

- (NSMutableArray *)buildFilter {
    
    NSMutableArray *filter = [NSMutableArray array];
    
    if (self.search) {
        NSMutableArray *encodedItems = [NSMutableArray arrayWithCapacity:self.search.count];
        
        for (NSString *item in self.search) {
            [encodedItems addObject:[item jive_stringByEscapingForURLArgument]];
        }
        
        NSString *searchTerms = [encodedItems componentsJoinedByString:@","];
        
        [filter addObject:[NSString stringWithFormat:@"search(%@)", searchTerms]];
    }
    
    return filter;
}

- (NSString *)toQueryString {
    
    NSString *query = [super toQueryString];
    NSMutableArray *filterArray = [self buildFilter];
    
    if ([filterArray count] == 0)
        return query;
    
    NSString *filter = [filterArray componentsJoinedByString:@"&filter="];

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
