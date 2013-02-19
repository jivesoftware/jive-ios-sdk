//
//  JiveActivityTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/9/13.
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

#import "JiveActivityTests.h"
#import "JiveEmbedded.h"

@implementation JiveActivityTests

@synthesize activity;

- (void)setUp {
    activity = [[JiveActivity alloc] init];
}

- (void)tearDown {
    activity = nil;
}

- (void)testToJSON {
    JiveActivityObject *actor = [[JiveActivityObject alloc] init];
    JiveActivityObject *generator = [[JiveActivityObject alloc] init];
    JiveActivityObject *object = [[JiveActivityObject alloc] init];
    JiveActivityObject *provider = [[JiveActivityObject alloc] init];
    JiveActivityObject *target = [[JiveActivityObject alloc] init];
    JiveMediaLink *icon = [[JiveMediaLink alloc] init];
    JiveExtension *jive = [[JiveExtension alloc] init];
    JiveOpenSocial *openSocial = [[JiveOpenSocial alloc] init];
    JiveEmbedded *embed = [[JiveEmbedded alloc] init];
    NSDictionary *JSON = [activity toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    actor.jiveId = @"3456";
    generator.jiveId = @"2345";
    object.jiveId = @"6543";
    provider.jiveId = @"5432";
    target.jiveId = @"7890";
    [icon setValue:[NSURL URLWithString:@"http://dummy.com/icon.png"] forKey:@"url"];
    jive.state = @"dude";
    [embed setValue:@"previewImage" forKey:@"previewImage"];
    [openSocial setValue:embed forKey:@"embed"];
    [activity setValue:actor forKey:@"actor"];
    activity.content = @"1234";
    [activity setValue:generator forKey:@"generator"];
    activity.icon = icon;
    [activity setValue:@"45678" forKey:@"jiveId"];
    activity.jive = jive;
    activity.object = object;
    activity.openSocial = openSocial;
    [activity setValue:provider forKey:@"provider"];
    [activity setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    activity.target = target;
    activity.title = @"title";
    [activity setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    activity.url = [NSURL URLWithString:@"http://dummy.com"];
    activity.verb = @"verb";
    
    JSON = [activity toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)10, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"content"], activity.content, @"Wrong content.");
    STAssertEqualObjects([JSON objectForKey:@"id"], activity.jiveId, @"Wrong jive id.");
    STAssertEqualObjects([JSON objectForKey:@"title"], activity.title, @"Wrong title.");
    STAssertEqualObjects([JSON objectForKey:@"url"], [activity.url absoluteString], @"Wrong url.");
    STAssertEqualObjects([JSON objectForKey:@"verb"], activity.verb, @"Wrong verb");
    
    NSDictionary *iconJSON = [JSON objectForKey:@"icon"];
    
    STAssertTrue([[iconJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([iconJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([iconJSON objectForKey:@"url"], [icon.url absoluteString], @"Wrong value");
    
    NSDictionary *jiveJSON = [JSON objectForKey:@"jive"];
    
    STAssertTrue([[jiveJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([jiveJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([jiveJSON objectForKey:@"state"], jive.state, @"Wrong value");
    
    NSDictionary *objectJSON = [JSON objectForKey:@"object"];
    
    STAssertTrue([[objectJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([objectJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([objectJSON objectForKey:@"id"], object.jiveId, @"Wrong value");
    
    NSDictionary *openSocialJSON = [JSON objectForKey:@"openSocial"];
    NSDictionary *embedJSON = [openSocialJSON objectForKey:@"embed"];
    
    STAssertTrue([[openSocialJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([openSocialJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertTrue([[embedJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([embedJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([embedJSON objectForKey:@"previewImage"], embed.previewImage, @"Wrong value");
    
    NSDictionary *targetJSON = [JSON objectForKey:@"target"];
    
    STAssertTrue([[targetJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([targetJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([targetJSON objectForKey:@"id"], target.jiveId, @"Wrong value");
}

- (void)testToJSON_alternate {
    JiveActivityObject *actor = [[JiveActivityObject alloc] init];
    JiveActivityObject *generator = [[JiveActivityObject alloc] init];
    JiveActivityObject *object = [[JiveActivityObject alloc] init];
    JiveActivityObject *provider = [[JiveActivityObject alloc] init];
    JiveActivityObject *target = [[JiveActivityObject alloc] init];
    JiveMediaLink *icon = [[JiveMediaLink alloc] init];
    JiveExtension *jive = [[JiveExtension alloc] init];
    JiveOpenSocial *openSocial = [[JiveOpenSocial alloc] init];
    JiveEmbedded *embed = [[JiveEmbedded alloc] init];
    
    actor.jiveId = @"6543";
    generator.jiveId = @"5432";
    object.jiveId = @"3456";
    provider.jiveId = @"2345";
    target.jiveId = @"9876";
    [icon setValue:[NSURL URLWithString:@"http://super.com/icon.png"] forKey:@"url"];
    jive.state = @"flat";
    [embed setValue:@"http://dummy.com/icon.png" forKey:@"previewImage"];
    [openSocial setValue:embed forKey:@"embed"];
    [activity setValue:actor forKey:@"actor"];
    activity.content = @"4321";
    [activity setValue:generator forKey:@"generator"];
    activity.icon = icon;
    [activity setValue:@"87654" forKey:@"jiveId"];
    activity.jive = jive;
    activity.object = object;
    activity.openSocial = openSocial;
    [activity setValue:provider forKey:@"provider"];
    [activity setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    activity.target = target;
    activity.title = @"bad";
    [activity setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    activity.url = [NSURL URLWithString:@"http://super.com"];
    activity.verb = @"longingly";
    
    NSDictionary *JSON = [activity toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)10, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"content"], activity.content, @"Wrong content.");
    STAssertEqualObjects([JSON objectForKey:@"id"], activity.jiveId, @"Wrong jive id.");
    STAssertEqualObjects([JSON objectForKey:@"title"], activity.title, @"Wrong title.");
    STAssertEqualObjects([JSON objectForKey:@"url"], [activity.url absoluteString], @"Wrong url.");
    STAssertEqualObjects([JSON objectForKey:@"verb"], activity.verb, @"Wrong verb");
    
    NSDictionary *iconJSON = [JSON objectForKey:@"icon"];
    
    STAssertTrue([[iconJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([iconJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([iconJSON objectForKey:@"url"], [icon.url absoluteString], @"Wrong value");
    
    NSDictionary *jiveJSON = [JSON objectForKey:@"jive"];
    
    STAssertTrue([[jiveJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([jiveJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([jiveJSON objectForKey:@"state"], jive.state, @"Wrong value");
    
    NSDictionary *objectJSON = [JSON objectForKey:@"object"];
    
    STAssertTrue([[objectJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([objectJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([objectJSON objectForKey:@"id"], object.jiveId, @"Wrong value");
    
    NSDictionary *openSocialJSON = [JSON objectForKey:@"openSocial"];
    NSDictionary *embedJSON = [openSocialJSON objectForKey:@"embed"];
    
    STAssertTrue([[openSocialJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([openSocialJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertTrue([[embedJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([embedJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([embedJSON objectForKey:@"previewImage"], embed.previewImage, @"Wrong value");
    
    NSDictionary *targetJSON = [JSON objectForKey:@"target"];
    
    STAssertTrue([[targetJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([targetJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([targetJSON objectForKey:@"id"], target.jiveId, @"Wrong value");
}

- (void)testPlaceParsing {
    JiveActivityObject *actor = [[JiveActivityObject alloc] init];
    JiveActivityObject *generator = [[JiveActivityObject alloc] init];
    JiveActivityObject *object = [[JiveActivityObject alloc] init];
    JiveActivityObject *provider = [[JiveActivityObject alloc] init];
    JiveActivityObject *target = [[JiveActivityObject alloc] init];
    JiveMediaLink *icon = [[JiveMediaLink alloc] init];
    JiveExtension *jive = [[JiveExtension alloc] init];
    JiveOpenSocial *openSocial = [[JiveOpenSocial alloc] init];
    JiveEmbedded *embed = [[JiveEmbedded alloc] init];
    
    actor.jiveId = @"3456";
    generator.jiveId = @"2345";
    object.jiveId = @"6543";
    provider.jiveId = @"5432";
    target.jiveId = @"7890";
    [icon setValue:[NSURL URLWithString:@"http://dummy.com/icon.png"] forKey:@"url"];
    jive.state = @"dude";
    [embed setValue:@"previewImage" forKey:@"previewImage"];
    [openSocial setValue:embed forKey:@"embed"];
    activity.content = @"1234";
    activity.icon = icon;
    [activity setValue:@"45678" forKey:@"jiveId"];
    activity.jive = jive;
    activity.object = object;
    activity.openSocial = openSocial;
    [activity setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    activity.target = target;
    activity.title = @"title";
    [activity setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    activity.url = [NSURL URLWithString:@"http://dummy.com"];
    activity.verb = @"verb";
    
    NSMutableDictionary *JSON = (NSMutableDictionary *)[activity toJSONDictionary];
    
    [JSON setValue:[actor toJSONDictionary] forKey:@"actor"];
    [JSON setValue:[generator toJSONDictionary] forKey:@"generator"];
    [JSON setValue:activity.jiveId forKey:@"jiveId"];
    [JSON setValue:[provider toJSONDictionary] forKey:@"provider"];
    [JSON setValue:@"1970-01-01T00:00:00.000+0000" forKey:@"published"];
    [JSON setValue:@"1970-01-01T00:16:40.123+0000" forKey:@"updated"];
   
    JiveActivity *newActivity = [JiveActivity instanceFromJSON:JSON];
    
    STAssertEquals([newActivity class], [activity class], @"Wrong item class");
    STAssertEqualObjects(newActivity.actor.jiveId, actor.jiveId, @"Wrong actor");
    STAssertEqualObjects(newActivity.content, activity.content, @"Wrong content");
    STAssertEqualObjects(newActivity.generator.jiveId, generator.jiveId, @"Wrong generator");
    STAssertEqualObjects(newActivity.icon.url, icon.url, @"Wrong icon");
    STAssertEqualObjects(newActivity.jiveId, activity.jiveId, @"Wrong id");
    STAssertEqualObjects(newActivity.jive.state, jive.state, @"Wrong jive");
    STAssertEqualObjects(newActivity.object.jiveId, object.jiveId, @"Wrong object");
    STAssertEqualObjects(newActivity.openSocial.embed.previewImage, openSocial.embed.previewImage, @"Wrong openSocial");
    STAssertEqualObjects(newActivity.provider.jiveId, provider.jiveId, @"Wrong provider");
    STAssertEqualObjects(newActivity.published, activity.published, @"Wrong published");
    STAssertEqualObjects(newActivity.target.jiveId, target.jiveId, @"Wrong target");
    STAssertEqualObjects(newActivity.title, activity.title, @"Wrong title");
    STAssertEqualObjects(newActivity.updated, activity.updated, @"Wrong updated");
    STAssertEqualObjects(newActivity.url, activity.url, @"Wrong url");
    STAssertEqualObjects(newActivity.verb, activity.verb, @"Wrong verb");
}

- (void)testPlaceParsingAlternate {
    JiveActivityObject *actor = [[JiveActivityObject alloc] init];
    JiveActivityObject *generator = [[JiveActivityObject alloc] init];
    JiveActivityObject *object = [[JiveActivityObject alloc] init];
    JiveActivityObject *provider = [[JiveActivityObject alloc] init];
    JiveActivityObject *target = [[JiveActivityObject alloc] init];
    JiveMediaLink *icon = [[JiveMediaLink alloc] init];
    JiveExtension *jive = [[JiveExtension alloc] init];
    JiveOpenSocial *openSocial = [[JiveOpenSocial alloc] init];
    JiveEmbedded *embed = [[JiveEmbedded alloc] init];
    
    actor.jiveId = @"6543";
    generator.jiveId = @"5432";
    object.jiveId = @"3456";
    provider.jiveId = @"2345";
    target.jiveId = @"9876";
    [icon setValue:[NSURL URLWithString:@"http://super.com/icon.png"] forKey:@"url"];
    jive.state = @"flat";
    [embed setValue:@"http://dummy.com/icon.png" forKey:@"previewImage"];
    [openSocial setValue:embed forKey:@"embed"];
    activity.content = @"4321";
    activity.icon = icon;
    [activity setValue:@"87654" forKey:@"jiveId"];
    activity.jive = jive;
    activity.object = object;
    activity.openSocial = openSocial;
    [activity setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    activity.target = target;
    activity.title = @"bad";
    [activity setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    activity.url = [NSURL URLWithString:@"http://super.com"];
    activity.verb = @"longingly";
    
    NSMutableDictionary *JSON = (NSMutableDictionary *)[activity toJSONDictionary];
    
    [JSON setValue:[actor toJSONDictionary] forKey:@"actor"];
    [JSON setValue:[generator toJSONDictionary] forKey:@"generator"];
    [JSON setValue:activity.jiveId forKey:@"jiveId"];
    [JSON setValue:[provider toJSONDictionary] forKey:@"provider"];
    [JSON setValue:@"1970-01-01T00:16:40.123+0000" forKey:@"published"];
    [JSON setValue:@"1970-01-01T00:00:00.000+0000" forKey:@"updated"];
    
    JiveActivity *newActivity = [JiveActivity instanceFromJSON:JSON];
    
    STAssertEquals([newActivity class], [activity class], @"Wrong item class");
    STAssertEqualObjects(newActivity.actor.jiveId, actor.jiveId, @"Wrong actor");
    STAssertEqualObjects(newActivity.content, activity.content, @"Wrong content");
    STAssertEqualObjects(newActivity.generator.jiveId, generator.jiveId, @"Wrong generator");
    STAssertEqualObjects(newActivity.icon.url, icon.url, @"Wrong icon");
    STAssertEqualObjects(newActivity.jiveId, activity.jiveId, @"Wrong id");
    STAssertEqualObjects(newActivity.jive.state, jive.state, @"Wrong jive");
    STAssertEqualObjects(newActivity.object.jiveId, object.jiveId, @"Wrong object");
    STAssertEqualObjects(newActivity.openSocial.embed.previewImage, openSocial.embed.previewImage, @"Wrong openSocial");
    STAssertEqualObjects(newActivity.provider.jiveId, provider.jiveId, @"Wrong provider");
    STAssertEqualObjects(newActivity.published, activity.published, @"Wrong published");
    STAssertEqualObjects(newActivity.target.jiveId, target.jiveId, @"Wrong target");
    STAssertEqualObjects(newActivity.title, activity.title, @"Wrong title");
    STAssertEqualObjects(newActivity.updated, activity.updated, @"Wrong updated");
    STAssertEqualObjects(newActivity.url, activity.url, @"Wrong url");
    STAssertEqualObjects(newActivity.verb, activity.verb, @"Wrong verb");
}

@end
