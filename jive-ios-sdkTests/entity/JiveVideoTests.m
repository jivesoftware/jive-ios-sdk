//
//  JiveVideoTests.m
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

#import "JiveVideoTests.h"

@implementation JiveVideoTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveVideo alloc] init];
}

- (JiveVideo *)video {
    return (JiveVideo *)self.categorizedContent;
}

- (void)testType {
    STAssertEqualObjects(self.video.type, @"video", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.video.type forKey:@"type"];
    
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.video class], @"Video class not registered with JiveTypedObject.");
    STAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.video class], @"Video class not registered with JiveContent.");
}

- (void)initializeVideo {
    NSString *externalID = @"external id";
    NSString *playerBaseURL = @"http://dummy.com";
    NSNumber *height = @2;
    NSNumber *width = @3;
    NSString *authToken = @"authToken";
    
    [self.video setValue:externalID forKey:JiveVideoAttributes.externalID];
    [self.video setValue:[NSURL URLWithString:playerBaseURL]
                  forKey:JiveVideoAttributes.playerBaseURL];
    [self.video setValue:height forKey:JiveVideoAttributes.height];
    [self.video setValue:width forKey:JiveVideoAttributes.width];
    [self.video setValue:authToken forKey:JiveVideoAttributes.authtoken];
    [self.video setValue:@"<p>http://dummy.com</p>" forKeyPath:JiveVideoAttributes.videoSource];
    [self.video setValue:@"test player" forKey:JiveVideoAttributes.playerName];
    [self.video setValue:@YES forKey:JiveVideoAttributes.autoplay];
    [self.video setValue:[NSURL URLWithString:@"http://dummy.com/stillImage.png"]
                  forKey:JiveVideoAttributes.stillImageURL];
    [self.video setValue:[NSURL URLWithString:@"http://dummy.com/watermark.jpg"]
                  forKey:JiveVideoAttributes.watermarkURL];
    [self.video setValue:@65.5 forKey:JiveVideoAttributes.duration];
    [self.video setValue:@1 forKey:JiveVideoAttributes.hours];
    [self.video setValue:@5 forKey:JiveVideoAttributes.minutes];
    [self.video setValue:@30 forKey:JiveVideoAttributes.seconds];
    [self.video setValue:@"iframeSource" forKey:JiveVideoAttributes.iframeSource];
    [self.video setValue:[NSURL URLWithString:@"http://dummy.com/thumbnail.gif"]
                  forKey:JiveVideoAttributes.videoThumbnail];
    [self.video setValue:@"videoType" forKey:JiveVideoAttributes.videoType];
    [self.video setValue:@"Frank" forKey:JiveVideoAttributes.playerName];
}

- (void)initializeAlternateVideo {
    NSString *externalID = @"internal id";
    NSURL *playerBaseURL = [NSURL URLWithString:@"http://rtd-denver.com"];
    NSNumber *height = @300;
    NSNumber *width = @5;
    NSString *authToken = @"invalid";
    
    [self.video setValue:externalID forKey:JiveVideoAttributes.externalID];
    [self.video setValue:[NSURL URLWithString:@"home.mov" relativeToURL:playerBaseURL]
                  forKey:JiveVideoAttributes.playerBaseURL];
    [self.video setValue:height forKey:JiveVideoAttributes.height];
    [self.video setValue:width forKey:JiveVideoAttributes.width];
    [self.video setValue:authToken forKey:JiveVideoAttributes.authtoken];
    [self.video setValue:@"<p>http://rtd-denver.com</p>" forKeyPath:JiveVideoAttributes.videoSource];
    [self.video setValue:@"alternate player" forKey:JiveVideoAttributes.playerName];
    [self.video setValue:@YES forKey:JiveVideoAttributes.embedded];
    [self.video setValue:[NSURL URLWithString:@"http://smart.com/stillImage.png"]
                  forKey:JiveVideoAttributes.stillImageURL];
    [self.video setValue:[NSURL URLWithString:@"http://smart.com/watermark.jpg"]
                  forKey:JiveVideoAttributes.watermarkURL];
    [self.video setValue:@141.75 forKey:JiveVideoAttributes.duration];
    [self.video setValue:@2 forKey:JiveVideoAttributes.hours];
    [self.video setValue:@21 forKey:JiveVideoAttributes.minutes];
    [self.video setValue:@45 forKey:JiveVideoAttributes.seconds];
    [self.video setValue:@"bad stuff" forKey:JiveVideoAttributes.iframeSource];
    [self.video setValue:[NSURL URLWithString:@"http://smart.com/thumbnail.gif"]
                  forKey:JiveVideoAttributes.videoThumbnail];
    [self.video setValue:@"player" forKey:JiveVideoAttributes.videoType];
    [self.video setValue:@"Bob" forKey:JiveVideoAttributes.playerName];
}

- (void)testVideoToJSON {
    NSDictionary *JSON = [self.video toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], @"video", @"Wrong type");
    
    [self initializeVideo];
    
    JSON = [self.video toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.video.type, @"Wrong type");
}

- (void)testVideoToJSON_alternate {
    [self initializeAlternateVideo];
    
    NSDictionary *JSON = [self.video toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.video.type, @"Wrong type");
}

- (void)testVideoPersistentJSON {
    NSDictionary *JSON = [self.video persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], @"video", @"Wrong type");
    
    [self initializeVideo];
    
    JSON = [self.video persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)18, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.video.type, @"Wrong type");
    STAssertEqualObjects(JSON[JiveVideoAttributes.externalID], self.video.externalID, @"Wrong externalID");
    STAssertEqualObjects(JSON[JiveVideoAttributes.playerBaseURL],
                         [self.video.playerBaseURL absoluteString], @"Wrong playerBaseURL");
    STAssertEqualObjects(JSON[JiveVideoAttributes.height], self.video.height, @"Wrong height");
    STAssertEqualObjects(JSON[JiveVideoAttributes.width], self.video.width, @"Wrong width");
    STAssertEqualObjects(JSON[JiveVideoAttributes.authtoken], self.video.authtoken, @"Wrong authtoken");
    STAssertEqualObjects(JSON[JiveVideoAttributes.videoSource], self.video.videoSource, @"Wrong videoSource");
    
    if ([self.video shouldAutoPlay]) {
        STAssertEqualObjects(JSON[JiveVideoAttributes.autoplay], self.video.autoplay, @"Wrong autoplay");
    } else {
        STAssertNil(JSON[JiveVideoAttributes.autoplay], @"Wrong autoplay");
    }
    
    if ([self.video isEmbeddedVideo]) {
        STAssertEqualObjects(JSON[JiveVideoAttributes.embedded], self.video.embedded, @"Wrong embedded");
    } else {
        STAssertNil(JSON[JiveVideoAttributes.embedded], @"Wrong embedded");
    }
    STAssertEqualObjects(JSON[JiveVideoAttributes.stillImageURL],
                         [self.video.stillImageURL absoluteString], @"Wrong stillImageURL");
    STAssertEqualObjects(JSON[JiveVideoAttributes.iframeSource], self.video.iframeSource, @"Wrong iframeSource");
    STAssertEqualObjects(JSON[JiveVideoAttributes.playerName], self.video.playerName, @"Wrong playerName");
    STAssertEqualObjects(JSON[JiveVideoAttributes.watermarkURL],
                         [self.video.watermarkURL absoluteString], @"Wrong watermarkURL");
    STAssertEqualObjects(JSON[JiveVideoAttributes.duration], self.video.duration, @"Wrong duration");
    STAssertEqualObjects(JSON[JiveVideoAttributes.hours], self.video.hours, @"Wrong hours");
    STAssertEqualObjects(JSON[JiveVideoAttributes.minutes], self.video.minutes, @"Wrong minutes");
    STAssertEqualObjects(JSON[JiveVideoAttributes.seconds], self.video.seconds, @"Wrong seconds");
    STAssertEqualObjects(JSON[JiveVideoAttributes.videoThumbnail],
                         [self.video.videoThumbnail absoluteString], @"Wrong videoThumbnail");
    STAssertEqualObjects(JSON[JiveVideoAttributes.videoType], self.video.videoType, @"Wrong videoType");
}

- (void)testVideoPersistentJSON_alternate {
    [self initializeAlternateVideo];
    
    NSDictionary *JSON = [self.video persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)18, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.video.type, @"Wrong type");
    STAssertEqualObjects(JSON[JiveVideoAttributes.externalID], self.video.externalID, @"Wrong externalID");
    STAssertEqualObjects(JSON[JiveVideoAttributes.playerBaseURL],
                         [self.video.playerBaseURL absoluteString], @"Wrong playerBaseURL");
    STAssertEqualObjects(JSON[JiveVideoAttributes.height], self.video.height, @"Wrong height");
    STAssertEqualObjects(JSON[JiveVideoAttributes.width], self.video.width, @"Wrong width");
    STAssertEqualObjects(JSON[JiveVideoAttributes.authtoken], self.video.authtoken, @"Wrong authtoken");
    STAssertEqualObjects(JSON[JiveVideoAttributes.videoSource], self.video.videoSource, @"Wrong videoSource");
    
    if ([self.video shouldAutoPlay]) {
        STAssertEqualObjects(JSON[JiveVideoAttributes.autoplay], self.video.autoplay, @"Wrong autoplay");
    } else {
        STAssertNil(JSON[JiveVideoAttributes.autoplay], @"Wrong autoplay");
    }
    
    if ([self.video isEmbeddedVideo]) {
        STAssertEqualObjects(JSON[JiveVideoAttributes.embedded], self.video.embedded, @"Wrong embedded");
    } else {
        STAssertNil(JSON[JiveVideoAttributes.embedded], @"Wrong embedded");
    }
    STAssertEqualObjects(JSON[JiveVideoAttributes.stillImageURL],
                         [self.video.stillImageURL absoluteString], @"Wrong stillImageURL");
    STAssertEqualObjects(JSON[JiveVideoAttributes.iframeSource], self.video.iframeSource, @"Wrong iframeSource");
    STAssertEqualObjects(JSON[JiveVideoAttributes.playerName], self.video.playerName, @"Wrong playerName");
    STAssertEqualObjects(JSON[JiveVideoAttributes.watermarkURL],
                         [self.video.watermarkURL absoluteString], @"Wrong watermarkURL");
    STAssertEqualObjects(JSON[JiveVideoAttributes.duration], self.video.duration, @"Wrong duration");
    STAssertEqualObjects(JSON[JiveVideoAttributes.hours], self.video.hours, @"Wrong hours");
    STAssertEqualObjects(JSON[JiveVideoAttributes.minutes], self.video.minutes, @"Wrong minutes");
    STAssertEqualObjects(JSON[JiveVideoAttributes.seconds], self.video.seconds, @"Wrong seconds");
    STAssertEqualObjects(JSON[JiveVideoAttributes.videoThumbnail],
                         [self.video.videoThumbnail absoluteString], @"Wrong videoThumbnail");
    STAssertEqualObjects(JSON[JiveVideoAttributes.videoType], self.video.videoType, @"Wrong videoType");
}

- (void)testVideoParsing {
    [self initializeVideo];
    
    id JSON = [self.video persistentJSON];
    JiveVideo *newContent = [JiveVideo objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.video class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.video.type, @"Wrong type");
    STAssertEqualObjects(newContent.externalID, self.video.externalID, @"Wrong externalID");
    STAssertEqualObjects([newContent.playerBaseURL absoluteString],
                         [self.video.playerBaseURL absoluteString], @"Wrong playerBaseURL");
    STAssertEqualObjects(newContent.height, self.video.height, @"Wrong height");
    STAssertEqualObjects(newContent.width, self.video.width, @"Wrong width");
    STAssertEqualObjects(newContent.authtoken, self.video.authtoken, @"Wrong authtoken");
    STAssertEqualObjects(newContent.autoplay, self.video.autoplay, @"Wrong autoplay");
    STAssertEqualObjects(newContent.embedded, self.video.embedded, @"Wrong embedded");
    STAssertEqualObjects([newContent.stillImageURL absoluteString],
                         [self.video.stillImageURL absoluteString], @"Wrong stillImageURL");
    STAssertEqualObjects(newContent.iframeSource, self.video.iframeSource, @"Wrong iframeSource");
    STAssertEqualObjects(newContent.playerName, self.video.playerName, @"Wrong playerName");
    STAssertEqualObjects([newContent.watermarkURL absoluteString],
                         [self.video.watermarkURL absoluteString], @"Wrong watermarkURL");
    STAssertEqualObjects(newContent.duration, self.video.duration, @"Wrong duration");
    STAssertEqualObjects(newContent.hours, self.video.hours, @"Wrong hours");
    STAssertEqualObjects(newContent.minutes, self.video.minutes, @"Wrong minutes");
    STAssertEqualObjects(newContent.seconds, self.video.seconds, @"Wrong seconds");
    STAssertEqualObjects([newContent.videoThumbnail absoluteString],
                         [self.video.videoThumbnail absoluteString], @"Wrong videoThumbnail");
    STAssertEqualObjects(newContent.videoType, self.video.videoType, @"Wrong videoType");
}

- (void)testVideoParsingAlternate {
    [self initializeAlternateVideo];
    
    id JSON = [self.video persistentJSON];
    JiveVideo *newContent = [JiveVideo objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.video class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.video.type, @"Wrong type");
    STAssertEqualObjects(newContent.externalID, self.video.externalID, @"Wrong externalID");
    STAssertEqualObjects([newContent.playerBaseURL absoluteString],
                         [self.video.playerBaseURL absoluteString], @"Wrong playerBaseURL");
    STAssertEqualObjects(newContent.height, self.video.height, @"Wrong height");
    STAssertEqualObjects(newContent.width, self.video.width, @"Wrong width");
    STAssertEqualObjects(newContent.authtoken, self.video.authtoken, @"Wrong authtoken");
    STAssertEqualObjects(newContent.autoplay, self.video.autoplay, @"Wrong autoplay");
    STAssertEqualObjects(newContent.embedded, self.video.embedded, @"Wrong embedded");
    STAssertEqualObjects([newContent.stillImageURL absoluteString],
                         [self.video.stillImageURL absoluteString], @"Wrong stillImageURL");
    STAssertEqualObjects(newContent.iframeSource, self.video.iframeSource, @"Wrong iframeSource");
    STAssertEqualObjects(newContent.playerName, self.video.playerName, @"Wrong playerName");
    STAssertEqualObjects([newContent.watermarkURL absoluteString],
                         [self.video.watermarkURL absoluteString], @"Wrong watermarkURL");
    STAssertEqualObjects(newContent.duration, self.video.duration, @"Wrong duration");
    STAssertEqualObjects(newContent.hours, self.video.hours, @"Wrong hours");
    STAssertEqualObjects(newContent.minutes, self.video.minutes, @"Wrong minutes");
    STAssertEqualObjects(newContent.seconds, self.video.seconds, @"Wrong seconds");
    STAssertEqualObjects([newContent.videoThumbnail absoluteString],
                         [self.video.videoThumbnail absoluteString], @"Wrong videoThumbnail");
    STAssertEqualObjects(newContent.videoType, self.video.videoType, @"Wrong videoType");
}

@end
