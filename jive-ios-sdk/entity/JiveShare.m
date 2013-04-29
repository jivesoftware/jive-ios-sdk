//
//  JiveShare.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 4/26/13.
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

#import "JiveShare.h"
#import "JiveTypedObject_internal.h"

struct JiveShareAttributes const JiveShareAttributes = {
    .sharedContent = @"sharedContent",
    .sharedPlace = @"sharedPlace",
};

@implementation JiveShare

@synthesize participants, sharedContent, sharedPlace, tags, visibleToExternalContributors;

static NSString * const JiveShareType = @"share";

+ (void)load {
    if (self == [JiveShare class])
        [super registerClass:self forType:JiveShareType];
}

- (NSString *)type {
    return JiveShareType;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    if (sharedContent)
        [dictionary setValue:sharedContent.toJSONDictionary forKey:JiveShareAttributes.sharedContent];
    
    if (sharedPlace)
        [dictionary setValue:sharedPlace.toJSONDictionary forKey:JiveShareAttributes.sharedPlace];
    
    return dictionary;
}

@end
