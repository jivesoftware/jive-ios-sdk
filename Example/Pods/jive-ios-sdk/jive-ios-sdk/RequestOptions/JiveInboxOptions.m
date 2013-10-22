//
//  JiveInboxOptions.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/25/12.
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

#import "JiveInboxOptions.h"

NSString * const JiveAcclaimInboxType = @"acclaim";

@implementation JiveInboxOptions

- (NSString *)createOrAppend:(NSString *)nextFilter toFilter:(NSString *)filter {
    if (!filter)
        return nextFilter;
    
    return [filter stringByAppendingString:nextFilter];
}

- (NSString *)toQueryString {
    
    NSString *query = [super toQueryString];
    
    if (!self.unread && !self.authorID && !self.authorURL && !self.types)
        return query;
    
    NSString *filter = self.unread ? [NSMutableString stringWithFormat:@"filter=unread&"] : @"";
    
    if (self.authorID)
        filter = [filter stringByAppendingFormat:@"filter=author(/people/%@)&", self.authorID];
    else if (self.authorURL)
        filter = [filter stringByAppendingFormat:@"filter=author(%@)&", self.authorURL];
    
    if (self.types)
        filter = [filter stringByAppendingFormat:@"filter=type(%@)&", [self.types componentsJoinedByString:@","]];
    
    filter = [filter substringToIndex:[filter length] - 1];
    return query ? [query stringByAppendingFormat:@"&%@", filter] : filter;
}

- (void)addType:(NSString *)type {
    
    if (!self.types)
        self.types = [NSArray arrayWithObject:type];
    else
        self.types = [self.types arrayByAddingObject:type];
}

@end
