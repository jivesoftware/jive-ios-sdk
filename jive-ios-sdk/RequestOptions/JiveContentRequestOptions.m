//
//  JiveContentRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/3/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveContentRequestOptions.h"

@implementation JiveContentRequestOptions

- (NSString *)buildFilter {
    
    NSString *filter = [super buildFilter];
    
    if (self.authors)
        filter = [self addFilterGroup:@"author"
                            withValue:[self.authors componentsJoinedByString:@","]
                             toFilter:filter];
    
    if (self.place)
        filter = [self addFilterGroup:@"place"
                            withValue:[self.place absoluteString]
                             toFilter:filter];
    
    if (self.entityDescriptor)
        filter = [self addFilterGroup:@"entityDescriptor"
                            withValue:[self.entityDescriptor componentsJoinedByString:@","]
                             toFilter:filter];
    
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
