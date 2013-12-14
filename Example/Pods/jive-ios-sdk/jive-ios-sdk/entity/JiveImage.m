//
//  JiveImage.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 2/27/13.
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

#import "JiveImage.h"
#import "JiveTypedObject_internal.h"

@implementation JiveImage

@synthesize jiveId, size, contentType, ref, name;

static NSString * const JiveImageType = @"image";

+ (void)load {
    if (self == [JiveImage class])
        [super registerClass:self forType:JiveImageType];
}

- (NSString *)type {
    return JiveImageType;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];    
    [dictionary setValue:self.type forKey:@"type"];
    [dictionary setValue:self.size forKey:@"size"];
    [dictionary setValue:self.contentType forKey:@"contentType"];
    [dictionary setValue:[self.ref absoluteString] forKey:@"ref"];
    [dictionary setValue:self.jiveId forKey:@"id"];
    [dictionary setValue:self.name forKey:@"name"];
    return dictionary;
}
@end
