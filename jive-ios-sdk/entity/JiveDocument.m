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

@implementation JiveDocument

@synthesize approvers, attachments, authors, authorship, categories, fromQuest, restrictComments;
@synthesize tags, updater, users, visibility, visibleToExternalContributors;

static NSString * const JiveDocumentType = @"document";

+ (void)initialize {
    if (self == [JiveDocument class])
        [super registerClass:self forType:JiveDocumentType];
}

- (NSString *)type {
    return JiveDocumentType;
}

- (Class) arrayMappingFor:(NSString*) propertyName {
    if ([propertyName isEqualToString:@"attachments"]) {
        return [JiveAttachment class];
    }
    
    if ([propertyName isEqualToString:@"approvers"] ||
        [propertyName isEqualToString:@"authors"] ||
        [propertyName isEqualToString:@"users"]) {
        return [JivePerson class];
    }
    
    return nil;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:authorship forKey:@"authorship"];
    [dictionary setValue:fromQuest forKey:@"fromQuest"];
    [dictionary setValue:restrictComments forKey:@"restrictComments"];
    [dictionary setValue:visibility forKey:@"visibility"];
    [dictionary setValue:visibleToExternalContributors forKey:@"visibleToExternalContributors"];
    [self addArrayElements:attachments toJSONDictionary:dictionary forTag:@"attachments"];
    [self addArrayElements:approvers toJSONDictionary:dictionary forTag:@"approvers"];
    [self addArrayElements:authors toJSONDictionary:dictionary forTag:@"authors"];
    if (users.count > 0 && [[[users objectAtIndex:0] class] isSubclassOfClass:[NSString class]])
        [dictionary setValue:users forKey:@"users"];
    else
        [self addArrayElements:users toJSONDictionary:dictionary forTag:@"users"];
    
    if (tags)
        [dictionary setValue:tags forKey:@"tags"];
    
    if (categories)
        [dictionary setValue:categories forKey:@"categories"];
    
    return dictionary;
}

@end
