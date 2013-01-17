//
//  JiveSearchPlacesRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/4/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveSearchPlacesRequestOptions.h"
#import "JiveSearchRequestOptions_internal.h"

@implementation JiveSearchPlacesRequestOptions

- (NSMutableArray *)buildFilter {
    
    NSMutableArray *filter = [super buildFilter];
    
    if (self.nameonly)
        [filter addObject:@"nameonly"];
    
    return filter;
}

@end
