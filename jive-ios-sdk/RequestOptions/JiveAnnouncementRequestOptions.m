//
//  JiveAnnouncementRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/31/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveAnnouncementRequestOptions.h"

@implementation JiveAnnouncementRequestOptions

@synthesize activeOnly;

- (NSString *)toQueryString {
    
    NSString *query = [super toQueryString];
    
    if (!self.activeOnly)
        return query;
    
    if (!query)
        return @"activeOnly";
    
    return [query stringByAppendingString:@"&activeOnly"];
}

@end
