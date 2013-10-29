//
//  JiveSearchTypesRequestOptions.m
//  
//
//  Created by Orson Bushnell on 12/4/12.
//
//

#import "JiveSearchTypesRequestOptions.h"
#import "JiveSearchRequestOptions_internal.h"
#import "JiveNSString+URLArguments.h"

@implementation JiveSearchTypesRequestOptions

- (NSMutableArray *)buildFilter {
    
    NSMutableArray *filter = [super buildFilter];
    
    if (self.types) {
        NSMutableArray *encodedTypes = [NSMutableArray arrayWithCapacity:self.types.count];
        
        for (NSString *item in self.types) {
            [encodedTypes addObject:[item jive_stringByEscapingForURLArgument]];
        }
        
        NSString *typeFilters = [encodedTypes componentsJoinedByString:@","];
        
        [filter addObject:[NSString stringWithFormat:@"type(%@)", typeFilters]];
    }
    
    return filter;
}

- (NSString *)toQueryString {
    
    NSString *query = [super toQueryString];
    
    if (!self.collapse)
        return query;
    
    if (!query)
        return @"collapse=true";
    
    return [query stringByAppendingString:@"&collapse=true"];
}

- (void)addType:(NSString *)type {
    
    if (!self.types)
        self.types = [NSArray arrayWithObject:type];
    else
        self.types = [self.types arrayByAddingObject:type];
}

@end
