//
//  JiveDocument.m
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

#import "JiveDocument.h"
#import "JiveAttachment.h"
#import "JivePerson.h"
#import "JiveTypedObject_internal.h"


struct JiveDocumentAttributes const JiveDocumentAttributes = {
    .approvers = @"approvers",
    .attachments = @"attachments",
    .editingBy = @"editingBy",
    .fromQuest = @"fromQuest",
    .restrictComments = @"restrictComments",
    .updater = @"updater",
    
    .authors = @"authors",
    .authorship = @"authorship",
    .categories = @"categories",
    .users = @"users",
    .visibility = @"visibility",
    .outcomeCounts = @"outcomeCounts",
    .outcomeTypeNames = @"outcomeTypeNames",
    .outcomeTypes = @"outcomeTypes",
    .tags = @"tags",
    .visibleToExternalContributors = @"visibleToExternalContributors"
};


@implementation JiveDocument

@synthesize approvers, attachments, fromQuest, restrictComments;
@synthesize updater, editingBy;

NSString * const JiveDocumentType = @"document";

+ (void)load {
    if (self == [JiveDocument class])
        [super registerClass:self forType:JiveDocumentType];
}

- (NSString *)type {
    return JiveDocumentType;
}

- (Class) arrayMappingFor:(NSString*) propertyName {
    if ([propertyName isEqualToString:JiveDocumentAttributes.attachments]) {
        return [JiveAttachment class];
    }
    
    if ([propertyName isEqualToString:JiveDocumentAttributes.approvers]) {
        return [JivePerson class];
    }
    
    return [super arrayMappingFor:propertyName];
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:fromQuest forKey:JiveDocumentAttributes.fromQuest];
    [dictionary setValue:restrictComments forKey:JiveDocumentAttributes.restrictComments];
    [self addArrayElements:attachments
          toJSONDictionary:dictionary
                    forTag:JiveDocumentAttributes.attachments];
    [self addArrayElements:approvers
          toJSONDictionary:dictionary
                    forTag:JiveDocumentAttributes.approvers];
    
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = [super persistentJSON];
    
    [self addArrayElements:approvers
    toPersistentDictionary:dictionary
                    forTag:JiveDocumentAttributes.approvers];
    if (updater) {
        dictionary[JiveDocumentAttributes.updater] = updater.persistentJSON;
    }
    
    if (editingBy) {
        [dictionary setValue:editingBy.persistentJSON forKey:JiveDocumentAttributes.editingBy];
    }
    
    return dictionary;
}

@end
