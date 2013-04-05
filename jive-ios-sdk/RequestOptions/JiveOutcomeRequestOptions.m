//
//  JiveOutcomeRequestOptions.m
//  jive-ios-sdk
//
//  Created by Taylor Case on 4/5/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveOutcomeRequestOptions.h"

@implementation JiveOutcomeRequestOptions

@synthesize includeChildrenOutcomes;

- (NSString *)toQueryString {
    NSMutableString *query = [[NSMutableString alloc] initWithString:@""];
    
    if (self.fields) {
        [query appendString:[NSString stringWithFormat:@"fields=%@", [self.fields componentsJoinedByString:@","]]];
        if (self.includeChildrenOutcomes)
            [query appendString:@"&includeChildOutcomes=true"];
    } else {
        if (self.includeChildrenOutcomes)
            [query appendString:@"includeChildOutcomes=true"];
    }
    
    return query;
}

@end
