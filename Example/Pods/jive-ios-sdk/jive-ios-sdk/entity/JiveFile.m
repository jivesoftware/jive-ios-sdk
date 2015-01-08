//
//  JiveFile.m
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

#import "JiveFile.h"
#import "JivePerson.h"
#import "JiveTypedObject_internal.h"


struct JiveFileAttributes const JiveFileAttributes = {
    .authors = @"authors",
    .authorship = @"authorship",
    .binaryURL = @"binaryURL",
    .categories = @"categories",
    .contentType = @"contentType",
    .name = @"name",
    .restrictComments = @"restrictComments",
    .size = @"size",
    .users = @"users",
    .visibility = @"visibility",
    
    .tags = @"tags",
    .visibleToExternalContributors = @"visibleToExternalContributors"
};


@implementation JiveFile

@synthesize authors, authorship, binaryURL, categories, size, users, visibility, contentType;

NSString * const JiveFileType = @"file";

+ (void)load {
    if (self == [JiveFile class])
        [super registerClass:self forType:JiveFileType];
}

- (NSString *)type {
    return JiveFileType;
}

- (Class) arrayMappingFor:(NSString*) propertyName {
    if ([propertyName isEqualToString:JiveFileAttributes.authors] ||
        [propertyName isEqualToString:JiveFileAttributes.users]) {
        return [JivePerson class];
    }
    
    return [super arrayMappingFor:propertyName];
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:authorship forKey:JiveFileAttributes.authorship];
    [dictionary setValue:[binaryURL absoluteString] forKey:JiveFileAttributes.binaryURL];
    [dictionary setValue:size forKey:JiveFileAttributes.size];
    [dictionary setValue:visibility forKey:JiveFileAttributes.visibility];
    [self addArrayElements:authors toJSONDictionary:dictionary forTag:JiveFileAttributes.authors];
    if (users.count > 0 && [[[users objectAtIndex:0] class] isSubclassOfClass:[NSString class]]) {
        [dictionary setValue:users forKey:JiveFileAttributes.users];
    } else {
        [self addArrayElements:users toJSONDictionary:dictionary forTag:JiveFileAttributes.users];
    }
    
    if (categories) {
        [dictionary setValue:categories forKey:JiveFileAttributes.categories];
    }

    [dictionary setValue:contentType forKey:JiveFileAttributes.contentType];
    
    return dictionary;
}

- (BOOL)commentsNotAllowed {
    return NO;
}

@end
