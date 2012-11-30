//
//  JiveImageURIRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveImageURIRequestOptions.h"

@implementation JiveImageURIRequestOptions

@synthesize uri;

- (NSString *)toQueryString
{
    if (!uri)
        return nil;

    return [NSString stringWithFormat:@"uri=%@", uri];
}

@end
