//
//  JiveDateLimitedRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//
//    Copyright 2013 Jive Software Inc.
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.
//

#import "JiveDateLimitedRequestOptions.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"
#import "JiveNSString+URLArguments.h"

@implementation JiveDateLimitedRequestOptions

@synthesize after, before;

- (NSString *)toQueryString {
    
    NSString *queryString = [super toQueryString];
    
    if (self.collapse) {
        queryString = [NSString jive_concatenateQueries:queryString withQuery:@"collapse=true"];
    }
    
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    if (!after) {
        if (!before) {
            return queryString;
        }
        
        NSString *escapedFormattedBefore = [[dateFormatter stringFromDate:before] jive_stringByEscapingForURLArgument];
        if (queryString) {
            return [NSString stringWithFormat:@"%@&before=%@",
                    queryString,
                    escapedFormattedBefore];
        }
        
        return [NSString stringWithFormat:@"before=%@",
                escapedFormattedBefore];
    }
    
    NSString *escapedFormattedAfter =  [[dateFormatter stringFromDate:after] jive_stringByEscapingForURLArgument];
    if (queryString) {
        return [NSString stringWithFormat:@"%@&after=%@",
                queryString,
                escapedFormattedAfter];
    }
    
    return [NSString stringWithFormat:@"after=%@",
            escapedFormattedAfter];
}

@end
