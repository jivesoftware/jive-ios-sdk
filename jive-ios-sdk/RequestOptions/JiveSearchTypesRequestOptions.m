//
//  JiveSearchTypesRequestOptions.m
//  
//
//  Created by Orson Bushnell on 12/4/12.
//
//

#import "JiveSearchTypesRequestOptions.h"

@implementation JiveSearchTypesRequestOptions

- (NSString *)buildFilter {
    
    NSString *filter = [super buildFilter];
    
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
    
    if (!self.collapse)
        return query;
    
    if (!query)
        return @"collapse";
    
    return [query stringByAppendingString:@"&collapse"];
}

- (void)addType:(NSString *)type {
    
    if (!self.types)
        self.types = [NSArray arrayWithObject:type];
    else
        self.types = [self.types arrayByAddingObject:type];
}

@end
