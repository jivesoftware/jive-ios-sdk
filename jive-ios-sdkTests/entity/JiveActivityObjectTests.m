//
//  JiveActivityObjectTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/26/12.
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

#import "JiveActivityObjectTests.h"
#import "JiveActivityObject.h"
#import "JiveMediaLink.h"

@implementation JiveActivityObjectTests

- (void)setUp {
    [super setUp];
    self.object = [JiveActivityObject new];
}

- (JiveActivityObject *)activity {
    return (JiveActivityObject *)self.object;
}

- (void)testToJSON {
    JiveActivityObject *author = [[JiveActivityObject alloc] init];
    JiveMediaLink *image = [[JiveMediaLink alloc] init];
    NSDictionary *JSON = [self.activity toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    author.jiveId = @"3456";
    [image setValue:[NSURL URLWithString:@"http://dummy.com/icon.png"] forKey:@"url"];
    self.activity.content = @"text";
    self.activity.jiveId = @"1234";
    self.activity.displayName = @"President";
    self.activity.objectType = @"Running";
    self.activity.summary = @"summary";
    [self.activity setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [self.activity setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    [self.activity setValue:[NSURL URLWithString:@"http://dummy.com"] forKey:@"url"];
    [self.activity setValue:author forKey:@"author"];
    [self.activity setValue:image forKey:@"image"];
    
    JSON = [self.activity toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)10, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"content"], self.activity.content, @"Wrong content.");
    STAssertEqualObjects([JSON objectForKey:@"id"], self.activity.jiveId, @"Wrong jive id.");
    STAssertEqualObjects([JSON objectForKey:@"displayName"], self.activity.displayName, @"Wrong displayName.");
    STAssertEqualObjects([JSON objectForKey:@"objectType"], self.activity.objectType, @"Wrong objectType.");
    STAssertEqualObjects([JSON objectForKey:@"summary"], self.activity.summary, @"Wrong summary");
    STAssertEqualObjects([JSON objectForKey:@"published"], @"1970-01-01T00:00:00.000+0000", @"Wrong published");
    STAssertEqualObjects([JSON objectForKey:@"updated"], @"1970-01-01T00:16:40.123+0000", @"Wrong updated");
    STAssertEqualObjects([JSON objectForKey:@"url"], [self.activity.url absoluteString], @"Wrong url.");
    
    NSDictionary *authorJSON = [JSON objectForKey:@"author"];
    
    STAssertTrue([[authorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([authorJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([authorJSON objectForKey:@"id"], author.jiveId, @"Wrong value");
    
    NSDictionary *imageJSON = [JSON objectForKey:@"image"];
    
    STAssertTrue([[imageJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([imageJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([imageJSON objectForKey:@"url"], [image.url absoluteString], @"Wrong value");
}

- (void)testToJSON_alternate {
    JiveActivityObject *author = [[JiveActivityObject alloc] init];
    JiveMediaLink *image = [[JiveMediaLink alloc] init];
    NSDictionary *JSON = [self.activity toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    author.jiveId = @"9876";
    [image setValue:[NSURL URLWithString:@"http://super.com/icon.png"] forKey:@"url"];
    self.activity.content = @"html";
    self.activity.jiveId = @"4321";
    self.activity.displayName = @"Grunt";
    self.activity.objectType = @"Toil";
    self.activity.summary = @"wrong";
    [self.activity setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [self.activity setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [self.activity setValue:[NSURL URLWithString:@"http://super.com"] forKey:@"url"];
    [self.activity setValue:author forKey:@"author"];
    [self.activity setValue:image forKey:@"image"];
    
    JSON = [self.activity toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)10, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"content"], self.activity.content, @"Wrong content.");
    STAssertEqualObjects([JSON objectForKey:@"id"], self.activity.jiveId, @"Wrong jive id.");
    STAssertEqualObjects([JSON objectForKey:@"displayName"], self.activity.displayName, @"Wrong displayName.");
    STAssertEqualObjects([JSON objectForKey:@"objectType"], self.activity.objectType, @"Wrong objectType.");
    STAssertEqualObjects([JSON objectForKey:@"summary"], self.activity.summary, @"Wrong summary");
    STAssertEqualObjects([JSON objectForKey:@"published"], @"1970-01-01T00:16:40.123+0000", @"Wrong published");
    STAssertEqualObjects([JSON objectForKey:@"updated"], @"1970-01-01T00:00:00.000+0000", @"Wrong updated");
    STAssertEqualObjects([JSON objectForKey:@"url"], [self.activity.url absoluteString], @"Wrong url.");
    
    NSDictionary *authorJSON = [JSON objectForKey:@"author"];
    
    STAssertTrue([[authorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([authorJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([authorJSON objectForKey:@"id"], author.jiveId, @"Wrong value");
    
    NSDictionary *imageJSON = [JSON objectForKey:@"image"];
    
    STAssertTrue([[imageJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([imageJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([imageJSON objectForKey:@"url"], [image.url absoluteString], @"Wrong value");
}

- (void)testPlaceParsing {
    JiveActivityObject *author = [[JiveActivityObject alloc] init];
    JiveMediaLink *image = [[JiveMediaLink alloc] init];
    
    author.jiveId = @"3456";
    [image setValue:[NSURL URLWithString:@"http://dummy.com/icon.png"] forKey:@"url"];
    self.activity.content = @"text";
    self.activity.jiveId = @"1234";
    self.activity.displayName = @"President";
    self.activity.objectType = @"Running";
    self.activity.summary = @"summary";
    [self.activity setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [self.activity setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    [self.activity setValue:[NSURL URLWithString:@"http://dummy.com"] forKey:@"url"];
    [self.activity setValue:author forKey:@"author"];
    [self.activity setValue:image forKey:@"image"];
    
    id JSON = [self.activity toJSONDictionary];
    JiveActivityObject *newActivity = [JiveActivityObject objectFromJSON:JSON withInstance:self.instance];
    
    STAssertEquals([newActivity class], [self.activity class], @"Wrong item class");
    STAssertEqualObjects(newActivity.jiveId, self.activity.jiveId, @"Wrong id");
    STAssertEqualObjects(newActivity.content, self.activity.content, @"Wrong content");
    STAssertEqualObjects(newActivity.displayName, self.activity.displayName, @"Wrong displayName");
    STAssertEqualObjects(newActivity.objectType, self.activity.objectType, @"Wrong objectType");
    STAssertEqualObjects(newActivity.summary, self.activity.summary, @"Wrong summary");
    STAssertEqualObjects(newActivity.published, self.activity.published, @"Wrong published");
    STAssertEqualObjects(newActivity.updated, self.activity.updated, @"Wrong updated");
    STAssertEqualObjects(newActivity.url, self.activity.url, @"Wrong url");
    STAssertEqualObjects(newActivity.author.jiveId, author.jiveId, @"Wrong author");
    STAssertEqualObjects(newActivity.image.url, image.url, @"Wrong image");
}

- (void)testPlaceParsingAlternate {
    JiveActivityObject *author = [[JiveActivityObject alloc] init];
    JiveMediaLink *image = [[JiveMediaLink alloc] init];
    
    author.jiveId = @"9876";
    [image setValue:[NSURL URLWithString:@"http://super.com/icon.png"] forKey:@"url"];
    self.activity.content = @"html";
    self.activity.jiveId = @"4321";
    self.activity.displayName = @"Grunt";
    self.activity.objectType = @"Toil";
    self.activity.summary = @"wrong";
    [self.activity setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [self.activity setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [self.activity setValue:[NSURL URLWithString:@"http://super.com"] forKey:@"url"];
    [self.activity setValue:author forKey:@"author"];
    [self.activity setValue:image forKey:@"image"];
    
    id JSON = [self.activity toJSONDictionary];
    JiveActivityObject *newActivity = [JiveActivityObject objectFromJSON:JSON withInstance:self.instance];
    
    STAssertEquals([newActivity class], [self.activity class], @"Wrong item class");
    STAssertEqualObjects(newActivity.jiveId, self.activity.jiveId, @"Wrong id");
    STAssertEqualObjects(newActivity.content, self.activity.content, @"Wrong content");
    STAssertEqualObjects(newActivity.displayName, self.activity.displayName, @"Wrong displayName");
    STAssertEqualObjects(newActivity.objectType, self.activity.objectType, @"Wrong objectType");
    STAssertEqualObjects(newActivity.summary, self.activity.summary, @"Wrong summary");
    STAssertEqualObjects(newActivity.published, self.activity.published, @"Wrong published");
    STAssertEqualObjects(newActivity.updated, self.activity.updated, @"Wrong updated");
    STAssertEqualObjects(newActivity.url, self.activity.url, @"Wrong url");
    STAssertEqualObjects(newActivity.author.jiveId, author.jiveId, @"Wrong author");
    STAssertEqualObjects(newActivity.image.url, image.url, @"Wrong image");
}

@end
