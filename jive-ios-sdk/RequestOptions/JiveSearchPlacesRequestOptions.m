//
//  JiveSearchPlacesRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/4/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveSearchPlacesRequestOptions.h"

@implementation JiveSearchPlacesRequestOptions

- (NSString *)buildFilter {
    
    NSString *filter = [super buildFilter];
    
    if (self.nameonly) {
        if (filter)
            filter = [filter stringByAppendingString:@",nameonly"];
        else
            filter = @"nameonly";
    }
    
    return filter;
}

@end
