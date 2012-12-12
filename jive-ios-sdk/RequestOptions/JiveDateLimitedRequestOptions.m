//
//  JiveDateLimitedRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveDateLimitedRequestOptions.h"
#import "NSThread+JiveISO8601DateFormatter.h"
#import "NSString+JiveUTF8PercentEscape.h"

@implementation JiveDateLimitedRequestOptions

@synthesize after, before;

- (NSString *)toQueryString {
    
    NSString *queryString = [super toQueryString];
    
    NSDateFormatter *dateFormatter = [NSThread currentThread].jive_ISO8601DateFormatter;
    if (!after) {
        if (!before) {
            return queryString;
        }
        
        NSString *escapedFormattedBefore = [[dateFormatter stringFromDate:before] jive_encodeWithUTF8PercentEscaping];
        if (queryString) {
            return [NSString stringWithFormat:@"%@&before=%@",
                    queryString,
                    escapedFormattedBefore];
        }
        
        return [NSString stringWithFormat:@"before=%@",
                escapedFormattedBefore];
    }
    
    NSString *escapedFormattedAfter =  [[dateFormatter stringFromDate:after] jive_encodeWithUTF8PercentEscaping];
    if (queryString) {
        return [NSString stringWithFormat:@"%@&after=%@",
                queryString,
                escapedFormattedAfter];
    }
    
    return [NSString stringWithFormat:@"after=%@",
            escapedFormattedAfter];
}

@end
