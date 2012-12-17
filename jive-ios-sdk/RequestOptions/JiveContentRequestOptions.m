//
//  JiveContentRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/3/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveContentRequestOptions.h"

@implementation JiveContentRequestOptions

- (NSMutableArray *)buildFilter {
    
    NSMutableArray *filter = [super buildFilter];
    NSString *components;
    
    if (self.authors) {
        components = [self.authors componentsJoinedByString:@","];
        [filter addObject:[NSString stringWithFormat:@"author(%@)", components]];
    }
    
    if (self.place)
        [filter addObject:[NSString stringWithFormat:@"place(%@)", [self.place absoluteString]]];
    
    if (self.entityDescriptor) {
        components = [self.entityDescriptor componentsJoinedByString:@","];
        [filter addObject:[NSString stringWithFormat:@"entityDescriptor(%@)", components]];
    }
    
    return filter;
}

- (void)addAuthor:(NSURL *)url {
    
    if (!self.authors)
        self.authors = [NSArray arrayWithObject:url];
    else
        self.authors = [self.authors arrayByAddingObject:url];
}

- (void)addEntityType:(NSString *)entityType descriptor:(NSString *)descriptor {
    
    if (!self.entityDescriptor)
        self.entityDescriptor = [NSArray arrayWithObject:entityType];
    else
        self.entityDescriptor = [self.entityDescriptor arrayByAddingObject:entityType];

    self.entityDescriptor = [self.entityDescriptor arrayByAddingObject:descriptor];
}

@end
