//
//  JiveGroup.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/15/12.
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

#import "JiveGroup.h"
#import "JiveTypedObject_internal.h"

@implementation JiveGroup

@synthesize creator, groupType, memberCount, tags;

static NSString * const JiveGroupType = @"group";

+ (void)load {
    if (self == [JiveGroup class])
        [super registerClass:self forType:JiveGroupType];
}

- (NSString *)type {
    return JiveGroupType;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:groupType forKey:@"groupType"];
    [dictionary setValue:memberCount forKey:@"memberCount"];
    if (tags)
        [dictionary setValue:tags forKey:@"tags"];
    
    if (creator)
        [dictionary setValue:[creator toJSONDictionary] forKey:@"creator"];
    
    return dictionary;
}

@end
