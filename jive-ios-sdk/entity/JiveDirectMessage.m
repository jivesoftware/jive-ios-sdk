//
//  JiveDirectMessage.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
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

#import "JiveDirectMessage.h"
#import "JiveTypedObject_internal.h"

struct JiveDirectMessageAttributes const JiveDirectMessageAttributes = {
	.participants = @"participants",
	.tags = @"tags",
    .visibleToExternalContributors = @"visibleToExternalContributors"
};

@implementation JiveDirectMessage

@synthesize participants, tags, visibleToExternalContributors;

NSString * const JiveDmType = @"dm";

+ (void)load {
    if (self == [JiveDirectMessage class])
        [super registerClass:self forType:JiveDmType];
}

- (NSString *)type {
    return JiveDmType;
}

- (Class) arrayMappingFor:(NSString*) propertyName {
    static NSDictionary *propertyClasses = nil;
    
    if (!propertyClasses)
        propertyClasses = [NSDictionary dictionaryWithObjectsAndKeys:
                           [JivePerson class], @"participants",
                           nil];
    
    return [propertyClasses objectForKey:propertyName];
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:visibleToExternalContributors
                  forKey:JiveDirectMessageAttributes.visibleToExternalContributors];
    [self addArrayElements:participants
          toJSONDictionary:dictionary
                    forTag:JiveDirectMessageAttributes.participants];
    if (self.tags.count > 0)
        [dictionary setValue:self.tags forKey:JiveDirectMessageAttributes.tags];
    
    return dictionary;
}

@end
