//
//  JiveDateLimitedRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveDateLimitedRequestOptions.h"
#import "NSThread+JiveISO8601DateFormatter.h"

@implementation JiveDateLimitedRequestOptions

@synthesize after, before;

- (NSString *)toQueryString {
    
    NSString *queryString = [super toQueryString];
    
    NSDateFormatter *dateFormatter = [NSThread currentThread].jive_ISO8601DateFormatter;
    if (!after) {
        if (!before) {
            return queryString;
        }
        
        if (queryString) {
            return [NSString stringWithFormat:@"%@&before=%@",
                    queryString,
                    [dateFormatter stringFromDate:before]];
        }
        
        return [NSString stringWithFormat:@"before=%@",
                [dateFormatter stringFromDate:before]];
    }
    
    if (queryString) {
        return [NSString stringWithFormat:@"%@&after=%@",
                queryString,
                [dateFormatter stringFromDate:after]];
    }
    
    return [NSString stringWithFormat:@"after=%@",
            [dateFormatter stringFromDate:after]];
}

@end
