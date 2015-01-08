//
//  JiveMessage.m
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

#import "JiveMessage.h"
#import "JiveAttachment.h"
#import "JiveTypedObject_internal.h"
#import "JiveOutcomeType.h"
#import "JiveGenericPerson.h"
#import "JiveVia.h"

struct JiveMessageResourceTags {
    __unsafe_unretained NSString *correctAnswer;
} const JiveMessageResourceTags;

struct JiveMessageResourceTags const JiveMessageResourceTags = {
    .correctAnswer = @"correctAnswer",
};

struct JiveMessageAttributes const JiveMessageAttributes = {
    .answer = @"answer",
    .attachments = @"attachments",
    .discussion = @"discussion",
    .fromQuest = @"fromQuest",
    .helpful = @"helpful",
    .onBehalfOf = @"onBehalfOf",
    .via = @"via",
    
    .outcomeTypeNames = @"outcomeTypeNames",
    .outcomeTypes = @"outcomeTypes",
    .tags = @"tags",
    .visibleToExternalContributors = @"visibleToExternalContributors"
};

@implementation JiveMessage

@synthesize answer, attachments, discussion, helpful, fromQuest, onBehalfOf, via;

NSString * const JiveMessageType = @"message";

+ (void)load {
    if (self == [JiveMessage class])
        [super registerClass:self forType:JiveMessageType];
}

- (NSString *)type {
    return JiveMessageType;
}

- (Class) arrayMappingFor:(NSString*) propertyName {
    if ([propertyName isEqualToString:JiveMessageAttributes.attachments]) {
        return [JiveAttachment class];
    } else if ([propertyName isEqualToString:JiveMessageAttributes.outcomeTypes]) {
        return [JiveOutcomeType class];
    }
    
    return [super arrayMappingFor:propertyName];
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:answer forKey:JiveMessageAttributes.answer];
    [dictionary setValue:fromQuest forKey:JiveMessageAttributes.fromQuest];
    [dictionary setValue:helpful forKey:JiveMessageAttributes.helpful];
    [self addArrayElements:attachments
          toJSONDictionary:dictionary
                    forTag:JiveMessageAttributes.attachments];
    if (onBehalfOf)
        [dictionary setValue:[onBehalfOf toJSONDictionary]
                  forKeyPath:JiveMessageAttributes.onBehalfOf];
    
    if (via)
        [dictionary setValue:[via toJSONDictionary] forKeyPath:JiveMessageAttributes.via];
    
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = [super persistentJSON];
    
    [dictionary setValue:discussion forKey:JiveMessageAttributes.discussion];
    [self addArrayElements:attachments
    toPersistentDictionary:dictionary
                    forTag:JiveMessageAttributes.attachments];
    if (onBehalfOf)
        [dictionary setValue:[onBehalfOf persistentJSON]
                  forKeyPath:JiveMessageAttributes.onBehalfOf];
    
    return dictionary;
}

- (NSURL *)correctAnswerRef {
    return [self resourceForTag:JiveMessageResourceTags.correctAnswer].ref;
}

- (BOOL)canMarkAsCorrectAnswer {
    return [self resourceHasPutForTag:JiveMessageResourceTags.correctAnswer];
}

- (BOOL)canClearMarkAsCorrectAnswer {
    return [self resourceHasDeleteForTag:JiveMessageResourceTags.correctAnswer];
}

- (BOOL)correctAnswer {
    return [answer boolValue];
}

- (BOOL)isHelpful {
    return [helpful boolValue];
}

@end
