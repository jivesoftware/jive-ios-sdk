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
#import "JiveOutcomeType.h"
#import "JiveTypedObject_internal.h"

struct JiveDocumentAttributes const JiveDocumentAttributes = {
    .approvers = @"approvers",
    .attachments = @"attachments",
    .authors = @"authors",
    .authorship = @"authorship",
    .categories = @"categories",
    .editingBy = @"editingBy",
    .fromQuest = @"fromQuest",
    .outcomeCounts = @"outcomeCounts",
    .outcomeTypeNames = @"outcomeTypeNames",
    .outcomeTypes = @"outcomeTypes",
    .restrictComments = @"restrictComments",
    .tags = @"tags",
    .updater = @"updater",
    .users = @"users",
    .visibility = @"visibility",
    .visibleToExternalContributors = @"visibleToExternalContributors"
};

@implementation JiveDocument

@synthesize approvers, attachments, authors, authorship, categories, fromQuest, restrictComments;
@synthesize tags, updater, users, visibility, visibleToExternalContributors, outcomeTypes;
@synthesize outcomeTypeNames, outcomeCounts, editingBy;

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
    
    if ([propertyName isEqualToString:JiveDocumentAttributes.approvers] ||
        [propertyName isEqualToString:JiveDocumentAttributes.authors]) {
        return [JivePerson class];
    }
    
    if ([propertyName isEqualToString:JiveDocumentAttributes.outcomeTypes]) {
        return [JiveOutcomeType class];
    }
    
    return nil;
}

- (id)parseArrayNamed:(NSString *)propertyName fromJSON:(id)JSON jiveInstance:(Jive *)jiveInstance {
    if (![propertyName isEqualToString:JiveDocumentAttributes.users]) {
        return [super parseArrayNamed:propertyName fromJSON:JSON jiveInstance:jiveInstance];
    }
    
    if (![[JSON[0] class] isSubclassOfClass:[NSString class]]) {
        return [JivePerson objectsFromJSONList:JSON withInstance:jiveInstance];
    }
    
    return JSON;
}

- (NSDictionary *)parseDictionaryForProperty:(NSString *)property
                                    fromJSON:(id)JSON
                                fromInstance:(Jive *)jiveInstance {
    if ([property isEqualToString:JiveDocumentAttributes.outcomeCounts]) {
        return JSON;
    }
    
    return [super parseDictionaryForProperty:property fromJSON:JSON fromInstance:jiveInstance];
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:authorship forKey:JiveDocumentAttributes.authorship];
    [dictionary setValue:fromQuest forKey:JiveDocumentAttributes.fromQuest];
    [dictionary setValue:restrictComments forKey:JiveDocumentAttributes.restrictComments];
    [dictionary setValue:visibility forKey:JiveDocumentAttributes.visibility];
    [dictionary setValue:outcomeTypeNames forKey:JiveDocumentAttributes.outcomeTypeNames];
    [self addArrayElements:attachments
          toJSONDictionary:dictionary
                    forTag:JiveDocumentAttributes.attachments];
    [self addArrayElements:approvers
          toJSONDictionary:dictionary
                    forTag:JiveDocumentAttributes.approvers];
    [self addArrayElements:authors
          toJSONDictionary:dictionary
                    forTag:JiveDocumentAttributes.authors];
    if ([[users.lastObject class] isSubclassOfClass:[NSString class]])
        [dictionary setValue:users forKey:JiveDocumentAttributes.users];
    else
        [self addArrayElements:users
              toJSONDictionary:dictionary
                        forTag:JiveDocumentAttributes.users];
    
    if (tags)
        [dictionary setValue:tags forKey:JiveDocumentAttributes.tags];
    
    if (categories)
        [dictionary setValue:categories forKey:JiveDocumentAttributes.categories];
    
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = [super persistentJSON];
    
    [self addArrayElements:approvers
    toPersistentDictionary:dictionary
                    forTag:JiveDocumentAttributes.approvers];
    [self addArrayElements:authors
    toPersistentDictionary:dictionary
                    forTag:JiveDocumentAttributes.authors];
    [self addArrayElements:outcomeTypes
    toPersistentDictionary:dictionary
                    forTag:JiveDocumentAttributes.outcomeTypes];
    [dictionary setValue:visibleToExternalContributors
                  forKey:JiveDocumentAttributes.visibleToExternalContributors];
    [dictionary setValue:outcomeCounts forKey:JiveDocumentAttributes.outcomeCounts];
    if (updater) {
        dictionary[JiveDocumentAttributes.updater] = updater.persistentJSON;
    }
    
    if (users.count > 0 && ![[[users objectAtIndex:0] class] isSubclassOfClass:[NSString class]]) {
        [self addArrayElements:users
        toPersistentDictionary:dictionary
                        forTag:JiveDocumentAttributes.users];
    }
    
    if (editingBy) {
        [dictionary setValue:editingBy.persistentJSON forKey:JiveDocumentAttributes.editingBy];
    }
    
    return dictionary;
}

@end
