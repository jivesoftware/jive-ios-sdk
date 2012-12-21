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
    
    if (self.authors) {
        NSString *components = [self.authors componentsJoinedByString:@","];
        
        [filter addObject:[NSString stringWithFormat:@"author(%@)", components]];
    }
    
    if (self.place)
        [filter addObject:[NSString stringWithFormat:@"place(%@)", [self.place absoluteString]]];
    
    return filter;
}

- (void)addAuthor:(NSURL *)url {
    
    if (!self.authors)
        self.authors = [NSArray arrayWithObject:url];
    else
        self.authors = [self.authors arrayByAddingObject:url];
}

@end
