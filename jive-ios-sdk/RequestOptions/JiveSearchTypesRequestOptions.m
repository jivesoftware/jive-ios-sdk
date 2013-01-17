//
//  JiveSearchTypesRequestOptions.m
//  
//
//  Created by Orson Bushnell on 12/4/12.
//
//

#import "JiveSearchTypesRequestOptions.h"
#import "JiveSearchRequestOptions_internal.h"
#import "NSString+JiveUTF8PercentEscape.h"

@implementation JiveSearchTypesRequestOptions

- (NSMutableArray *)buildFilter {
    
    NSMutableArray *filter = [super buildFilter];
    
    if (self.types) {
        NSMutableArray *encodedTypes = [NSMutableArray arrayWithCapacity:self.types.count];
        
        for (NSString *item in self.types) {
            [encodedTypes addObject:[item jive_encodeWithUTF8PercentEscaping]];
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
