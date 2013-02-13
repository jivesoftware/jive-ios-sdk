//
//  JiveStateRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/3/12.
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

#import "JiveStateRequestOptions.h"

@implementation JiveStateRequestOptions

- (NSString *)toQueryString {
    
    NSString *query = [super toQueryString];
    
    if (self.states)
    {
        NSString *statesString = [self.states componentsJoinedByString:@","];

        if (query)
            query = [query stringByAppendingFormat:@"&state=%@", statesString];
        else
            query = [NSString stringWithFormat:@"state=%@", statesString];
    }

    return query;
}

- (void)addState:(NSString *)state {
    
    if (!self.states)
        self.states = [NSArray arrayWithObject:state];
    else
        self.states = [self.states arrayByAddingObject:state];
}

@end
