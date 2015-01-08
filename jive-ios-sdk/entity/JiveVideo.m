//
//  JiveVideo.m
//  jive-ios-sdk
//
//  Created by Chris Gummer on 3/20/13.
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

#import "JiveVideo.h"
#import "JiveTypedObject_internal.h"

struct JiveVideoAttributes const JiveVideoAttributes = {
    .authtoken = @"authtoken",
    .externalID = @"externalID",
    .playerBaseURL = @"playerBaseURL",
    .width = @"width",
    .height = @"height",
    .videoSource = @"videoSource",
    .autoplay = @"autoplay",
    .stillImageURL = @"stillImageURL",
    .watermarkURL = @"watermarkURL",
    .duration = @"duration",
    .hours = @"hours",
    .minutes = @"minutes",
    .seconds = @"seconds",
    .iframeSource = @"iframeSource",
    .embedded = @"embedded",
    .videoThumbnail = @"videoThumbnail",
    .videoType = @"videoType",
    .playerName = @"playerName",
    
    .categories = @"categories",
    .users = @"users",
    .visibility = @"visibility",
    .tags = @"tags",
    .visibleToExternalContributors = @"visibleToExternalContributors",
};

@implementation JiveVideo

@synthesize externalID, playerBaseURL, width, height, authtoken, autoplay, embedded, stillImageURL;
@synthesize videoSource, duration, hours, minutes, seconds;
@synthesize iframeSource, videoThumbnail, videoType, playerName, watermarkURL;

NSString * const JiveVideoType = @"video";

+ (void)load {
    if (self == [JiveVideo class])
        [super registerClass:self forType:JiveVideoType];
}

- (NSString *)type {
    return JiveVideoType;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = [super persistentJSON];
    
    [dictionary setValue:externalID forKey:JiveVideoAttributes.externalID];
    [dictionary setValue:authtoken forKey:JiveVideoAttributes.authtoken];
    [dictionary setValue:width forKey:JiveVideoAttributes.width];
    [dictionary setValue:height forKey:JiveVideoAttributes.height];
    [dictionary setValue:[playerBaseURL absoluteString] forKey:JiveVideoAttributes.playerBaseURL];
    [dictionary setValue:[stillImageURL absoluteString] forKey:JiveVideoAttributes.stillImageURL];
    [dictionary setValue:[watermarkURL absoluteString] forKey:JiveVideoAttributes.watermarkURL];
    [dictionary setValue:[videoThumbnail absoluteString] forKey:JiveVideoAttributes.videoThumbnail];
    [dictionary setValue:videoSource forKey:JiveVideoAttributes.videoSource];
    [dictionary setValue:playerName forKey:JiveVideoAttributes.playerName];
    [dictionary setValue:autoplay forKey:JiveVideoAttributes.autoplay];
    [dictionary setValue:duration forKey:JiveVideoAttributes.duration];
    [dictionary setValue:hours forKey:JiveVideoAttributes.hours];
    [dictionary setValue:minutes forKey:JiveVideoAttributes.minutes];
    [dictionary setValue:seconds forKey:JiveVideoAttributes.seconds];
    [dictionary setValue:iframeSource forKey:JiveVideoAttributes.iframeSource];
    [dictionary setValue:embedded forKey:JiveVideoAttributes.embedded];
    [dictionary setValue:videoType forKey:JiveVideoAttributes.videoType];
    
    return dictionary;
}

- (BOOL)shouldAutoPlay {
    return [self.autoplay boolValue];
}

- (BOOL)isEmbeddedVideo {
    return [self.embedded boolValue];
}

@end
