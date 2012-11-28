//
//  JiveDateLimitedRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveDateLimitedRequestOptions.h"

@implementation JiveDateLimitedRequestOptions

@synthesize after, before;

- (NSString *)toQueryString {
    
    NSString *queryString = [super toQueryString];
    
    if (!after)
    {
        if (!before)
            return queryString;
        
        if (queryString)
            return [NSString stringWithFormat:@"%@&before=%@", queryString, before];
        
        return [NSString stringWithFormat:@"before=%@", before];
    }
    
    if (queryString)
        return [NSString stringWithFormat:@"%@&after=%@", queryString, after];
    
    return [NSString stringWithFormat:@"after=%@", after];
}

@end
