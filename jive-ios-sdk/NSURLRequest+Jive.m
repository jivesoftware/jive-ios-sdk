//
//  NSURLRequest+Jive.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 4/10/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "NSURLRequest+Jive.h"

@implementation NSURLRequest (Jive)

+ (instancetype)requestWithString:(NSString *)string
                    relativeToURL:(NSURL *)URL {
    if ([string length]) {
        if ([string hasPrefix:@"/"]) {
            [NSException raise:@"Absolute Path"
                        format:@"Requests may only use relative paths. String: \"%@\", Base URL: %@",
             string,
             URL];
            return nil;
        } else {
            return [self requestWithURL:[NSURL URLWithString:string
                                               relativeToURL:URL]];
        }
    } else {
        [NSException raise:@"Empty Path"
                    format:@"Requests must have a non-empty path or query. Base URL: %@",
         URL];
        return nil;
    }
}

@end
