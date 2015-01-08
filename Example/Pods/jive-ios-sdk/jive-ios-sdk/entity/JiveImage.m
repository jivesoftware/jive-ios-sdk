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

struct JiveImageAttributes const JiveImageAttributes = {
    .jiveId = @"id",
    .size = @"size",
    .contentType = @"contentType",
    .ref = @"ref",
    .name = @"name",
    .height = @"height",
    .tags = @"tags",
    .width = @"width"
};


@implementation JiveImage

@synthesize jiveId, size, contentType, ref, name, width, height, tags;


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
    [dictionary setValue:self.jiveId forKey:JiveImageAttributes.jiveId];

    if (self.tags) {
        [dictionary setValue:self.tags forKey:JiveImageAttributes.tags];
    }
    
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = [super persistentJSON];
    
    [dictionary setValue:self.size forKey:JiveImageAttributes.size];
    [dictionary setValue:self.contentType forKey:JiveImageAttributes.contentType];
    [dictionary setValue:[self.ref absoluteString] forKey:JiveImageAttributes.ref];
    [dictionary setValue:self.name forKey:JiveImageAttributes.name];
    [dictionary setValue:self.width forKey:JiveImageAttributes.width];
    [dictionary setValue:self.height forKey:JiveImageAttributes.height];

    return dictionary;
}

@end
