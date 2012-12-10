//
//  JiveDateLimitedRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveDateLimitedRequestOptions.h"
#import "JiveObject.h"

@implementation JiveDateLimitedRequestOptions

@synthesize after, before;

- (NSString *)toQueryString {
    
    NSString *queryString = [super toQueryString];
    NSDateFormatter *dateFormatter = [JiveObject dateFormatter];
    
    if (!after)
    {
        if (!before)
            return queryString;
        
        NSString *beforeString = [NSString stringWithFormat:@"before=%@", [dateFormatter stringFromDate:before]];
        
        if (!queryString)
            return beforeString;
        
        return [queryString stringByAppendingFormat:@"&%@", beforeString];
    }
    
    NSString *afterString = [NSString stringWithFormat:@"after=%@", [dateFormatter stringFromDate:after]];
    
    if (!queryString)
        return afterString;
    
    return [queryString stringByAppendingFormat:@"&%@", afterString];
}

@end
