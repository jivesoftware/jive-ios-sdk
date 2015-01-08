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


struct JiveActivityObjectAttributes const JiveActivityObjectAttributes = {
    .answer = @"answer",
    .author = @"author",
    .canComment = @"canComment",
    .canReply = @"canReply",
    .content = @"content",
    .contentImages = @"contentImages",
    .contentVideos = @"contentVideos",
    .displayName = @"displayName",
    .helpfulCount = @"helpfulCount",
    .image = @"image",
    .jiveId = @"jiveId",
    .jive = @"jive",
    .objectType = @"objectType",
    .published = @"published",
    .question = @"question",
    .resolved = @"resolved",
    .summary = @"summary",
    .updated = @"updated",
    .url = @"url",
};


@implementation JiveActivityObject

@synthesize author, content, contentImages, contentVideos, displayName, jiveId, image, objectType;
@synthesize published, summary, updated, url, question, resolved, answer, canReply, canComment;
@synthesize helpfulCount, jive;

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:content forKey:JiveActivityObjectAttributes.content];
    [dictionary setValue:displayName forKey:JiveActivityObjectAttributes.displayName];
    [dictionary setValue:jiveId forKey:JiveObjectConstants.id];
    [dictionary setValue:objectType forKey:JiveActivityObjectAttributes.objectType];
    [dictionary setValue:summary forKey:JiveActivityObjectAttributes.summary];
    [dictionary setValue:question forKey:JiveActivityObjectAttributes.question];
    [dictionary setValue:resolved forKey:JiveOutcomeTypeNames.resolved];
    if (answer) {
        [dictionary setValue:[answer absoluteString] forKey:JiveActivityObjectAttributes.answer];
    }
    
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = [super persistentJSON];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    [dictionary setValue:canComment forKey:JiveActivityObjectAttributes.canComment];
    [dictionary setValue:canReply forKey:JiveActivityObjectAttributes.canReply];
    [dictionary setValue:[url absoluteString] forKey:JiveActivityObjectAttributes.url];
    [dictionary setValue:[jive persistentJSON] forKey:JiveActivityObjectAttributes.jive];
    if (author) {
        [dictionary setValue:[author persistentJSON] forKey:JiveActivityObjectAttributes.author];
    }
    
    if (image) {
        [dictionary setValue:[image persistentJSON] forKey:JiveActivityObjectAttributes.image];
    }
    
    if (published) {
        [dictionary setValue:[dateFormatter stringFromDate:published]
                      forKey:JiveActivityObjectAttributes.published];
    }
    
    if (updated) {
        [dictionary setValue:[dateFormatter stringFromDate:updated]
                      forKey:JiveActivityObjectAttributes.updated];
    }
    
    if (helpfulCount) {
        [dictionary setValue:helpfulCount forKey:JiveActivityObjectAttributes.helpfulCount];
    }
    
    [self addArrayElements:contentImages
    toPersistentDictionary:dictionary
                    forTag:JiveActivityObjectAttributes.contentImages];
    [self addArrayElements:contentVideos
    toPersistentDictionary:dictionary
                    forTag:JiveActivityObjectAttributes.contentVideos];

    return dictionary;
}

- (Class)arrayMappingFor:(NSString *)propertyName {
    if ([JiveActivityObjectAttributes.contentImages isEqualToString:propertyName]) {
        return [JiveImage class];
    } else if ([JiveActivityObjectAttributes.contentVideos isEqualToString:propertyName]) {
        return [JiveContentVideo class];
    }
    
    return [super arrayMappingFor:propertyName];
}

@end
