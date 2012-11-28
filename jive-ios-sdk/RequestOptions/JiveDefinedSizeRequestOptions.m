//
//  JiveDefinedSizeRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveDefinedSizeRequestOptions.h"

@implementation JiveDefinedSizeRequestOptions

- (NSString *)toQueryString {
    
    int size = self.size;
    static NSString *queryStrings[] = { nil, @"size=medium", @"size=small" };

    if (size < 0 || size > smallImage)
        size = 0;

    return queryStrings[size];
}

@end
