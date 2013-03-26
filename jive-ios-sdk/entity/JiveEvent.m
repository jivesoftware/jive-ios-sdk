//
//  JiveEvent.m
//  jive-ios-sdk
//
//  Created by Chris Gummer on 3/25/13.
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

#import "JiveEvent.h"
#import "JiveTypedObject_internal.h"

@implementation JiveEvent

@synthesize visibleToExternalContributors;

static NSString * const JiveEventType = @"event";

+ (void)initialize {
    if (self == [JiveEvent class])
        [super registerClass:self forType:JiveEventType];
}

- (NSString *)type {
    return JiveEventType;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:self.visibleToExternalContributors forKey:@"visibleToExternalContributors"];
    
    return dictionary;
}

@end
