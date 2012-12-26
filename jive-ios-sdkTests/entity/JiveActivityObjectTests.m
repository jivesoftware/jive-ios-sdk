//
//  JiveActivityObjectTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/26/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveActivityObjectTests.h"
#import "JiveActivityObject.h"
#import "JiveMediaLink.h"

@implementation JiveActivityObjectTests

- (void)testToJSON {
    JiveActivityObject *activity = [[JiveActivityObject alloc] init];
    JiveActivityObject *author = [[JiveActivityObject alloc] init];
    JiveMediaLink *image = [[JiveMediaLink alloc] init];
    NSDictionary *JSON = [activity toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    author.jiveId = @"3456";
    [image setValue:[NSURL URLWithString:@"http://dummy.com/icon.png"] forKey:@"url"];
    activity.content = @"text";
    activity.jiveId = @"1234";
    activity.displayName = @"President";
    activity.objectType = @"Running";
    activity.summary = @"summary";
    [activity setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [activity setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    [activity setValue:[NSURL URLWithString:@"http://dummy.com"] forKey:@"url"];
    [activity setValue:author forKey:@"author"];
    [activity setValue:image forKey:@"image"];
    
    JSON = [activity toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)10, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"content"], activity.content, @"Wrong content.");
    STAssertEqualObjects([JSON objectForKey:@"id"], activity.jiveId, @"Wrong jive id.");
    STAssertEqualObjects([JSON objectForKey:@"displayName"], activity.displayName, @"Wrong displayName.");
    STAssertEqualObjects([JSON objectForKey:@"objectType"], activity.objectType, @"Wrong objectType.");
    STAssertEqualObjects([JSON objectForKey:@"summary"], activity.summary, @"Wrong summary");
    STAssertEqualObjects([JSON objectForKey:@"published"], @"1970-01-01T00:00:00.000+0000", @"Wrong published");
    STAssertEqualObjects([JSON objectForKey:@"updated"], @"1970-01-01T00:16:40.123+0000", @"Wrong updated");
    STAssertEqualObjects([JSON objectForKey:@"url"], [activity.url absoluteString], @"Wrong url.");
    
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
    JiveActivityObject *activity = [[JiveActivityObject alloc] init];
    JiveActivityObject *author = [[JiveActivityObject alloc] init];
    JiveMediaLink *image = [[JiveMediaLink alloc] init];
    NSDictionary *JSON = [activity toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    author.jiveId = @"9876";
    [image setValue:[NSURL URLWithString:@"http://super.com/icon.png"] forKey:@"url"];
    activity.content = @"html";
    activity.jiveId = @"4321";
    activity.displayName = @"Grunt";
    activity.objectType = @"Toil";
    activity.summary = @"wrong";
    [activity setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [activity setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [activity setValue:[NSURL URLWithString:@"http://super.com"] forKey:@"url"];
    [activity setValue:author forKey:@"author"];
    [activity setValue:image forKey:@"image"];
    
    JSON = [activity toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)10, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"content"], activity.content, @"Wrong content.");
    STAssertEqualObjects([JSON objectForKey:@"id"], activity.jiveId, @"Wrong jive id.");
    STAssertEqualObjects([JSON objectForKey:@"displayName"], activity.displayName, @"Wrong displayName.");
    STAssertEqualObjects([JSON objectForKey:@"objectType"], activity.objectType, @"Wrong objectType.");
    STAssertEqualObjects([JSON objectForKey:@"summary"], activity.summary, @"Wrong summary");
    STAssertEqualObjects([JSON objectForKey:@"published"], @"1970-01-01T00:16:40.123+0000", @"Wrong published");
    STAssertEqualObjects([JSON objectForKey:@"updated"], @"1970-01-01T00:00:00.000+0000", @"Wrong updated");
    STAssertEqualObjects([JSON objectForKey:@"url"], [activity.url absoluteString], @"Wrong url.");
    
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
    JiveActivityObject *baseActivity = [[JiveActivityObject alloc] init];
    JiveActivityObject *author = [[JiveActivityObject alloc] init];
    JiveMediaLink *image = [[JiveMediaLink alloc] init];
    
    author.jiveId = @"3456";
    [image setValue:[NSURL URLWithString:@"http://dummy.com/icon.png"] forKey:@"url"];
    baseActivity.content = @"text";
    baseActivity.jiveId = @"1234";
    baseActivity.displayName = @"President";
    baseActivity.objectType = @"Running";
    baseActivity.summary = @"summary";
    [baseActivity setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [baseActivity setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    [baseActivity setValue:[NSURL URLWithString:@"http://dummy.com"] forKey:@"url"];
    [baseActivity setValue:author forKey:@"author"];
    [baseActivity setValue:image forKey:@"image"];
    
    id JSON = [baseActivity toJSONDictionary];
    JiveActivityObject *activity = [JiveActivityObject instanceFromJSON:JSON];
    
    STAssertEquals([activity class], [baseActivity class], @"Wrong item class");
    STAssertEqualObjects(activity.jiveId, baseActivity.jiveId, @"Wrong id");
    STAssertEqualObjects(activity.content, baseActivity.content, @"Wrong content");
    STAssertEqualObjects(activity.displayName, baseActivity.displayName, @"Wrong displayName");
    STAssertEqualObjects(activity.objectType, baseActivity.objectType, @"Wrong objectType");
    STAssertEqualObjects(activity.summary, baseActivity.summary, @"Wrong summary");
    STAssertEqualObjects(activity.published, baseActivity.published, @"Wrong published");
    STAssertEqualObjects(activity.updated, baseActivity.updated, @"Wrong updated");
    STAssertEqualObjects(activity.url, baseActivity.url, @"Wrong url");
    STAssertEqualObjects(activity.author.jiveId, author.jiveId, @"Wrong author");
    STAssertEqualObjects(activity.image.url, image.url, @"Wrong image");
}

- (void)testPlaceParsingAlternate {
    JiveActivityObject *baseActivity = [[JiveActivityObject alloc] init];
    JiveActivityObject *author = [[JiveActivityObject alloc] init];
    JiveMediaLink *image = [[JiveMediaLink alloc] init];
    
    author.jiveId = @"9876";
    [image setValue:[NSURL URLWithString:@"http://super.com/icon.png"] forKey:@"url"];
    baseActivity.content = @"html";
    baseActivity.jiveId = @"4321";
    baseActivity.displayName = @"Grunt";
    baseActivity.objectType = @"Toil";
    baseActivity.summary = @"wrong";
    [baseActivity setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [baseActivity setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [baseActivity setValue:[NSURL URLWithString:@"http://super.com"] forKey:@"url"];
    [baseActivity setValue:author forKey:@"author"];
    [baseActivity setValue:image forKey:@"image"];
    
    id JSON = [baseActivity toJSONDictionary];
    JiveActivityObject *activity = [JiveActivityObject instanceFromJSON:JSON];
    
    STAssertEquals([activity class], [baseActivity class], @"Wrong item class");
    STAssertEqualObjects(activity.jiveId, baseActivity.jiveId, @"Wrong id");
    STAssertEqualObjects(activity.content, baseActivity.content, @"Wrong content");
    STAssertEqualObjects(activity.displayName, baseActivity.displayName, @"Wrong displayName");
    STAssertEqualObjects(activity.objectType, baseActivity.objectType, @"Wrong objectType");
    STAssertEqualObjects(activity.summary, baseActivity.summary, @"Wrong summary");
    STAssertEqualObjects(activity.published, baseActivity.published, @"Wrong published");
    STAssertEqualObjects(activity.updated, baseActivity.updated, @"Wrong updated");
    STAssertEqualObjects(activity.url, baseActivity.url, @"Wrong url");
    STAssertEqualObjects(activity.author.jiveId, author.jiveId, @"Wrong author");
    STAssertEqualObjects(activity.image.url, image.url, @"Wrong image");
}

@end
