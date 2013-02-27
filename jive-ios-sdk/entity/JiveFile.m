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

@implementation JiveFile

@synthesize authors, authorship, binaryURL, categories, size, tags, users, visibility;
@synthesize visibleToExternalContributors;

static NSString * const JiveFileType = @"file";

+ (void)initialize {
    [super initialize];
    [super registerClass:self forType:JiveFileType];
}

- (NSString *)type {
    return JiveFileType;
}

- (Class) arrayMappingFor:(NSString*) propertyName {
    if ([propertyName isEqualToString:@"authors"] ||
        [propertyName isEqualToString:@"users"]) {
        return [JivePerson class];
    }
    
    return nil;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:authorship forKey:@"authorship"];
    [dictionary setValue:[binaryURL absoluteString] forKey:@"binaryURL"];
    [dictionary setValue:size forKey:@"size"];
    [dictionary setValue:visibility forKey:@"visibility"];
    [dictionary setValue:visibleToExternalContributors forKey:@"visibleToExternalContributors"];
    [self addArrayElements:authors toJSONDictionary:dictionary forTag:@"authors"];
    if (users.count > 0 && [[[users objectAtIndex:0] class] isSubclassOfClass:[NSString class]]) {
        [dictionary setValue:users forKey:@"users"];
    } else {
        [self addArrayElements:users toJSONDictionary:dictionary forTag:@"users"];
    }
    
    if (tags) {
        [dictionary setValue:tags forKey:@"tags"];
    }
    
    if (categories) {
        [dictionary setValue:categories forKey:@"categories"];
    }
    
    return dictionary;
}

@end
