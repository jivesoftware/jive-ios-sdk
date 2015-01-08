//
//  JiveDiscusson.m
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

#import "JiveDiscussion.h"
#import "JiveTypedObject_internal.h"
#import "JiveAttachment.h"
#import "JiveGenericPerson.h"
#import "JiveVia.h"


struct JiveDiscussionAttributes const JiveDiscussionAttributes = {
    .answer = @"answer",
    .attachments = @"attachments",
    .categories = @"categories",
    .helpful = @"helpful",
    .onBehalfOf = @"onBehalfOf",
    .resolved = @"resolved",
    .restrictReplies = @"restrictReplies",
    .question = @"question",
    .users = @"users",
    .via = @"via",
    .visibility = @"visibility",
    
    .tags = @"tags",
    .visibleToExternalContributors = @"visibleToExternalContributors"
};

struct JiveDiscussionResolvedState const JiveDiscussionResolvedState = {
    .open = @"open",
    .resolved = @"resolved",
    .assumed_resolved = @"assumed_resolved",
};


@implementation JiveDiscussion

@synthesize answer, attachments, helpful, categories, question, users, visibility, onBehalfOf;
@synthesize resolved, restrictReplies, via;

NSString * const JiveDiscussionType = @"discussion";

+ (void)load {
    if (self == [JiveDiscussion class])
        [super registerClass:self forType:JiveDiscussionType];
}

- (NSString *)type {
    return JiveDiscussionType;
}

- (Class) arrayMappingFor:(NSString*) propertyName {
    if ([propertyName isEqualToString:JiveDiscussionAttributes.attachments]) {
        return [JiveAttachment class];
    }
    if ([propertyName isEqualToString:JiveDiscussionAttributes.users]) {
        return [JivePerson class];
    }
    
    return [super arrayMappingFor:propertyName];
}

- (BOOL)canAddComments {
    return [self canAddMessage];
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:answer forKey:JiveDiscussionAttributes.answer];
    [dictionary setValue:question forKey:JiveDiscussionAttributes.question];
    
    // Only questions can have a state associated with them
    if([question boolValue])
        [dictionary setValue:resolved forKey:JiveDiscussionAttributes.resolved];
    
    [dictionary setValue:visibility forKey:JiveDiscussionAttributes.visibility];
    [self addArrayElements:attachments
          toJSONDictionary:dictionary
                    forTag:JiveDiscussionAttributes.attachments];
    if (users.count > 0 && [[[users objectAtIndex:0] class] isSubclassOfClass:[NSString class]])
        [dictionary setValue:users forKey:JiveDiscussionAttributes.users];
    else
        [self addArrayElements:users
              toJSONDictionary:dictionary
                        forTag:JiveDiscussionAttributes.users];
    
    if (categories)
        [dictionary setValue:categories forKey:JiveDiscussionAttributes.categories];
    
    if (helpful)
        [dictionary setValue:helpful forKey:JiveDiscussionAttributes.helpful];
    
    if (onBehalfOf)
        [dictionary setValue:[onBehalfOf toJSONDictionary]
                      forKey:JiveDiscussionAttributes.onBehalfOf];
    
    if (via)
        [dictionary setValue:[via toJSONDictionary] forKey:JiveDiscussionAttributes.via];
    
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = [super persistentJSON];
    
    [dictionary setValue:restrictReplies forKeyPath:JiveDiscussionAttributes.restrictReplies];
    
    if (onBehalfOf)
        [dictionary setValue:[onBehalfOf persistentJSON]
                      forKey:JiveDiscussionAttributes.onBehalfOf];
    
    return dictionary;
}

- (BOOL)isAQuestion {
    return [question boolValue];
}

- (BOOL)repliesRestricted {
    return [restrictReplies boolValue];
}

@end
