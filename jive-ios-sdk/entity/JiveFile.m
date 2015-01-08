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
    .binaryURL = @"binaryURL",
    .contentType = @"contentType",
    .name = @"name",
    .restrictComments = @"restrictComments",
    .size = @"size",
    
    .authors = @"authors",
    .authorship = @"authorship",
    .categories = @"categories",
    .users = @"users",
    .visibility = @"visibility",
    .tags = @"tags",
    .visibleToExternalContributors = @"visibleToExternalContributors"
};


@implementation JiveFile

@synthesize binaryURL, size, contentType, name, restrictComments;

NSString * const JiveFileType = @"file";

+ (void)load {
    if (self == [JiveFile class])
        [super registerClass:self forType:JiveFileType];
}

- (NSString *)type {
    return JiveFileType;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:restrictComments forKey:JiveFileAttributes.restrictComments];
    
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = [super persistentJSON];
    
    [dictionary setValue:name forKey:JiveFileAttributes.name];
    [dictionary setValue:[binaryURL absoluteString] forKey:JiveFileAttributes.binaryURL];
    [dictionary setValue:size forKey:JiveFileAttributes.size];
    [dictionary setValue:contentType forKey:JiveFileAttributes.contentType];
    
    return dictionary;
}

- (BOOL)commentsNotAllowed {
    return [self.restrictComments boolValue];
}

@end
