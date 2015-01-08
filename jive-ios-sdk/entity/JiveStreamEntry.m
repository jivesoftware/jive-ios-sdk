//
//  JiveStream.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/2/13.
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

#import "JiveStreamEntry.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"
#import "JiveResourceEntry.h"
#import "JiveTypedObject_internal.h"

struct JiveStreamEntryAttributes const JiveStreamEntryAttributes = {
    .tags = @"tags",
    .verb = @"verb",
    .visibleToExternalContributors = @"visibleToExternalContributors",
};

@implementation JiveStreamEntry

@synthesize verb;

static NSString * const JiveStreamEntryType = @"entry";

+ (void)load {
    if (self == [JiveStreamEntry class])
        [super registerClass:self forType:JiveStreamEntryType];
}

- (NSString *)type {
    return JiveStreamEntryType;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super persistentJSON];
    
    [dictionary setValue:verb forKey:JiveStreamEntryAttributes.verb];
    return dictionary;
}

@end
