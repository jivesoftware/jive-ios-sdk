//
//  JiveActivityObject.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
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

#import "JiveActivityObject.h"
#import "JiveTypedObject_internal.h"
#import "JiveMediaLink.h"
#import "JiveImage.h"
#import "JiveContentVideo.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"
#import "JiveOutcomeTypeConstants.h"

@implementation JiveActivityObject

@synthesize author, content, contentImages, contentVideos, displayName, jiveId, image, objectType, published, summary, updated, url, question, resolved, answer, canReply, canComment;

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:content forKey:@"content"];
    [dictionary setValue:displayName forKey:@"displayName"];
    [dictionary setValue:jiveId forKey:@"id"];
    [dictionary setValue:objectType forKey:@"objectType"];
    [dictionary setValue:summary forKey:@"summary"];
    [dictionary setValue:question forKey:@"question"];
    [dictionary setValue:resolved forKey:JiveOutcomeTypeNames.resolved];
    if (answer) {
        [dictionary setValue:[answer absoluteString] forKey:@"answer"];
    }
    
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = [super persistentJSON];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    [dictionary setValue:canComment forKey:@"canComment"];
    [dictionary setValue:canReply forKey:@"canReply"];
    [dictionary setValue:[url absoluteString] forKey:@"url"];
    if (author) {
        [dictionary setValue:[author persistentJSON] forKey:@"author"];
    }
    
    if (image) {
        [dictionary setValue:[image persistentJSON] forKey:@"image"];
    }
    
    if (published) {
        [dictionary setValue:[dateFormatter stringFromDate:published] forKey:@"published"];
    }
    
    if (updated) {
        [dictionary setValue:[dateFormatter stringFromDate:updated] forKey:@"updated"];
    }
    
    [self addArrayElements:contentImages
    toPersistentDictionary:dictionary
                    forTag:@"contentImages"];
    [self addArrayElements:contentVideos
    toPersistentDictionary:dictionary
                    forTag:@"contentVideos"];

    return dictionary;
}

- (Class)arrayMappingFor:(NSString *)propertyName {
    if ([@"contentImages" isEqualToString:propertyName]) {
        return [JiveImage class];
    } else if ([@"contentVideos" isEqualToString:propertyName]) {
        return [JiveContentVideo class];
    }
    
    return [super arrayMappingFor:propertyName];
}

@end
