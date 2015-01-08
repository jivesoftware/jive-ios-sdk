//
//  JiveCommentsRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/30/12.
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

#import "JiveCommentsRequestOptions.h"

@implementation JiveCommentsRequestOptions

- (NSString *)toQueryString {
    
    NSString *query = [super toQueryString];
    
    if (!self.anchor && !self.excludeReplies && !self.hierarchical)
        return query;
    
    if (self.anchor) {
        if (!query)
            query = [NSString stringWithFormat:@"anchor=%@", self.anchor];
        else
            query = [query stringByAppendingFormat:@"&anchor=%@", self.anchor];
    }
    
    if (self.excludeReplies) {
        if (!query)
            query = [NSString stringWithFormat:@"excludeReplies=true"];
        else
            query = [query stringByAppendingFormat:@"&excludeReplies=true"];
    }
    
    if (self.hierarchical) {
        if (!query)
            query = [NSString stringWithFormat:@"hierarchical=true"];
        else
            query = [query stringByAppendingFormat:@"&hierarchical=true"];
    }
    
    return query;
}

@end
