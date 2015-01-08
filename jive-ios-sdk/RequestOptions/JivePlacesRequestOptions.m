//
//  JivePlacesRequestOptions.m
//  
//
//  Created by Orson Bushnell on 12/19/12.
//
//

#import "JivePlacesRequestOptions.h"

@implementation JivePlacesRequestOptions

- (NSMutableArray *)buildFilter {
    
    NSMutableArray *filter = [super buildFilter];
    
    if (self.entityDescriptor) {
        NSString *components = [self.entityDescriptor componentsJoinedByString:@","];
        
        [filter addObject:[NSString stringWithFormat:@"entityDescriptor(%@)", components]];
    }
    
    return filter;
}

- (void)addEntityType:(NSString *)entityType descriptor:(NSString *)descriptor {
    
    if (!self.entityDescriptor)
        self.entityDescriptor = [NSArray arrayWithObject:entityType];
    else
        self.entityDescriptor = [self.entityDescriptor arrayByAddingObject:entityType];

    self.entityDescriptor = [self.entityDescriptor arrayByAddingObject:descriptor];
}

@end
