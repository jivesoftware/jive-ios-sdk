//
//  JiveInboxEntryTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/6/12.
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

#import "JiveInboxEntryTests.h"
#import "JiveActivityObject.h"
#import "JiveMediaLink.h"
#import "JiveExtension.h"
#import "JiveOpenSocial.h"
#import "JiveObject_internal.h"

@implementation JiveInboxEntryTests

- (void)setUp {
    [super setUp];
    self.object = [JiveInboxEntry new];
}

- (JiveInboxEntry *)inboxEntry {
    return (JiveInboxEntry *)self.object;
}

- (void)testDescription {
    
    JiveActivityObject *activity = [[JiveActivityObject alloc] init];

    [self.inboxEntry setValue:activity forKey:JiveInboxEntryAttributes.object];
    STAssertEqualObjects(self.inboxEntry.description, @"(null) (null) -'(null)'", @"Empty description");
    
    activity.displayName = @"object";
    STAssertEqualObjects(self.inboxEntry.description, @"(null) (null) -'object'", @"Just a display name");
    
    self.inboxEntry.verb = @"walking";
    STAssertEqualObjects(self.inboxEntry.description, @"(null) walking -'object'", @"Verb and display name");
    
    [activity setValue:[NSURL URLWithString:@"http://test.com"] forKey:@"url"];
    STAssertEqualObjects(self.inboxEntry.description, @"http://test.com walking -'object'", @"URL, verb and display name");
    
    activity.displayName = @"tree";
    STAssertEqualObjects(self.inboxEntry.description, @"http://test.com walking -'tree'", @"A different display name");
    
    self.inboxEntry.verb = @"sitting";
    STAssertEqualObjects(self.inboxEntry.description, @"http://test.com sitting -'tree'", @"A different verb");
    
    [activity setValue:[NSURL URLWithString:@"http://bad.net"] forKey:@"url"];
    STAssertEqualObjects(self.inboxEntry.description, @"http://bad.net sitting -'tree'", @"A different url");
}

- (void)initializeInboxEntry {
    JiveActivityObject *actor = [[JiveActivityObject alloc] init];
    JiveActivityObject *generator = [[JiveActivityObject alloc] init];
    JiveActivityObject *object = [[JiveActivityObject alloc] init];
    JiveActivityObject *provider = [[JiveActivityObject alloc] init];
    JiveActivityObject *target = [[JiveActivityObject alloc] init];
    JiveMediaLink *icon = [[JiveMediaLink alloc] init];
    JiveExtension *jive = [[JiveExtension alloc] init];
    JiveOpenSocial *openSocial = [[JiveOpenSocial alloc] init];
    
    actor.jiveId = @"2345";
    generator.jiveId = @"3456";
    object.jiveId = @"4567";
    provider.jiveId = @"5678";
    target.jiveId = @"6789";
    [icon setValue:[NSURL URLWithString:@"http://dummy.com/icon.png"] forKey:JiveInboxEntryAttributes.url];
    jive.state = JiveExtensionStateValues.accepted;
    [jive setValue:@"12345" forKey:JiveExtensionAttributes.collection];
    [openSocial setValue:@[@"/person/54321"] forKey:@"deliverTo"];
    self.inboxEntry.content = @"text";
    self.inboxEntry.jiveId = @"1234";
    self.inboxEntry.title = @"President";
    self.inboxEntry.verb = @"Running";
    [self.inboxEntry setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:JiveInboxEntryAttributes.published];
    [self.inboxEntry setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:JiveInboxEntryAttributes.updated];
    [self.inboxEntry setValue:[NSURL URLWithString:@"http://dummy.com"] forKey:JiveInboxEntryAttributes.url];
    [self.inboxEntry setValue:actor forKey:JiveInboxEntryAttributes.actor];
    [self.inboxEntry setValue:generator forKey:JiveInboxEntryAttributes.generator];
    [self.inboxEntry setValue:object forKey:JiveInboxEntryAttributes.object];
    [self.inboxEntry setValue:provider forKey:JiveInboxEntryAttributes.provider];
    [self.inboxEntry setValue:target forKey:JiveInboxEntryAttributes.target];
    [self.inboxEntry setValue:icon forKey:JiveInboxEntryAttributes.icon];
    [self.inboxEntry setValue:jive forKey:JiveInboxEntryAttributes.jive];
    [self.inboxEntry setValue:openSocial forKey:JiveInboxEntryAttributes.openSocial];
}

- (void)alternateInitializeInboxEntry {
    JiveActivityObject *actor = [[JiveActivityObject alloc] init];
    JiveActivityObject *generator = [[JiveActivityObject alloc] init];
    JiveActivityObject *object = [[JiveActivityObject alloc] init];
    JiveActivityObject *provider = [[JiveActivityObject alloc] init];
    JiveActivityObject *target = [[JiveActivityObject alloc] init];
    JiveMediaLink *icon = [[JiveMediaLink alloc] init];
    JiveExtension *jive = [[JiveExtension alloc] init];
    JiveOpenSocial *openSocial = [[JiveOpenSocial alloc] init];
    
    actor.jiveId = @"9876";
    generator.jiveId = @"8765";
    object.jiveId = @"7654";
    provider.jiveId = @"6543";
    target.jiveId = @"5432";
    [icon setValue:[NSURL URLWithString:@"http://super.com/icon.png"] forKey:JiveInboxEntryAttributes.url];
    jive.state = JiveExtensionStateValues.rejected;
    [jive setValue:@"54321" forKey:JiveExtensionAttributes.collection];
    [openSocial setValue:@[@"/place/23456"] forKey:@"deliverTo"];
    self.inboxEntry.content = @"html";
    self.inboxEntry.jiveId = @"4321";
    self.inboxEntry.title = @"Grunt";
    self.inboxEntry.verb = @"Toil";
    [self.inboxEntry setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:JiveInboxEntryAttributes.published];
    [self.inboxEntry setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:JiveInboxEntryAttributes.updated];
    [self.inboxEntry setValue:[NSURL URLWithString:@"http://super.com"] forKey:JiveInboxEntryAttributes.url];
    [self.inboxEntry setValue:actor forKey:JiveInboxEntryAttributes.actor];
    [self.inboxEntry setValue:generator forKey:JiveInboxEntryAttributes.generator];
    [self.inboxEntry setValue:object forKey:JiveInboxEntryAttributes.object];
    [self.inboxEntry setValue:provider forKey:JiveInboxEntryAttributes.provider];
    [self.inboxEntry setValue:target forKey:JiveInboxEntryAttributes.target];
    [self.inboxEntry setValue:icon forKey:JiveInboxEntryAttributes.icon];
    [self.inboxEntry setValue:jive forKey:JiveInboxEntryAttributes.jive];
    [self.inboxEntry setValue:openSocial forKey:JiveInboxEntryAttributes.openSocial];
}

- (void)testPersistentJSON {
    NSDictionary *JSON = [self.inboxEntry persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self initializeInboxEntry];
    JSON = [self.inboxEntry persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)15, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveInboxEntryAttributes.content], self.inboxEntry.content, @"Wrong content.");
    STAssertEqualObjects(JSON[JiveObjectConstants.id], self.inboxEntry.jiveId, @"Wrong jive id.");
    STAssertEqualObjects(JSON[JiveInboxEntryAttributes.title], self.inboxEntry.title, @"Wrong title.");
    STAssertEqualObjects(JSON[JiveInboxEntryAttributes.verb], self.inboxEntry.verb, @"Wrong verb.");
    STAssertEqualObjects(JSON[JiveInboxEntryAttributes.published], @"1970-01-01T00:00:00.000+0000", @"Wrong published");
    STAssertEqualObjects(JSON[JiveInboxEntryAttributes.updated], @"1970-01-01T00:16:40.123+0000", @"Wrong updated");
    STAssertEqualObjects(JSON[JiveInboxEntryAttributes.url], [self.inboxEntry.url absoluteString], @"Wrong url.");
    
    NSDictionary *actorJSON = JSON[JiveInboxEntryAttributes.actor];
    
    STAssertTrue([[actorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([actorJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(actorJSON[JiveObjectConstants.id], self.inboxEntry.actor.jiveId, @"Wrong value");
    
    NSDictionary *generatorJSON = JSON[JiveInboxEntryAttributes.generator];
    
    STAssertTrue([[generatorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([generatorJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(generatorJSON[JiveObjectConstants.id], self.inboxEntry.generator.jiveId, @"Wrong value");
    
    NSDictionary *objectJSON = JSON[JiveInboxEntryAttributes.object];
    
    STAssertTrue([[objectJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([objectJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(objectJSON[JiveObjectConstants.id], self.inboxEntry.object.jiveId, @"Wrong value");
    
    NSDictionary *providerJSON = JSON[JiveInboxEntryAttributes.provider];
    
    STAssertTrue([[providerJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([providerJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(providerJSON[JiveObjectConstants.id], self.inboxEntry.provider.jiveId, @"Wrong value");
    
    NSDictionary *targetJSON = JSON[JiveInboxEntryAttributes.target];
    
    STAssertTrue([[targetJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([targetJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(targetJSON[JiveObjectConstants.id], self.inboxEntry.target.jiveId, @"Wrong value");
    
    NSDictionary *iconJSON = JSON[JiveInboxEntryAttributes.icon];
    
    STAssertTrue([[iconJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([iconJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(iconJSON[@"url"], [self.inboxEntry.icon.url absoluteString], @"Wrong value");
    
    NSDictionary *jiveJSON = JSON[JiveInboxEntryAttributes.jive];
    
    STAssertTrue([[jiveJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([jiveJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(jiveJSON[@"state"], self.inboxEntry.jive.state, @"Wrong value");
    STAssertEqualObjects(jiveJSON[JiveExtensionAttributes.collection],
                         self.inboxEntry.jive.collection, @"Wrong value");
    
    NSDictionary *openSocialJSON = JSON[JiveInboxEntryAttributes.openSocial];
    NSArray *deliverToArray = openSocialJSON[@"deliverTo"];
    
    STAssertTrue([[openSocialJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([openSocialJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertTrue([[deliverToArray class] isSubclassOfClass:[NSArray class]], @"Sub-array not converted");
    STAssertEquals([deliverToArray count], (NSUInteger)1, @"Sub-array had the wrong number of entries");
    STAssertEqualObjects([deliverToArray objectAtIndex:0],
                         [self.inboxEntry.openSocial.deliverTo objectAtIndex:0], @"Wrong value");
}

- (void)testPersistentJSON_alternate {
    NSDictionary *JSON = [self.inboxEntry persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self alternateInitializeInboxEntry];
    JSON = [self.inboxEntry persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)15, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveInboxEntryAttributes.content], self.inboxEntry.content, @"Wrong content.");
    STAssertEqualObjects(JSON[JiveObjectConstants.id], self.inboxEntry.jiveId, @"Wrong jive id.");
    STAssertEqualObjects(JSON[JiveInboxEntryAttributes.title], self.inboxEntry.title, @"Wrong title.");
    STAssertEqualObjects(JSON[JiveInboxEntryAttributes.verb], self.inboxEntry.verb, @"Wrong verb.");
    STAssertEqualObjects(JSON[JiveInboxEntryAttributes.published], @"1970-01-01T00:16:40.123+0000", @"Wrong published");
    STAssertEqualObjects(JSON[JiveInboxEntryAttributes.updated], @"1970-01-01T00:00:00.000+0000", @"Wrong updated");
    STAssertEqualObjects(JSON[JiveInboxEntryAttributes.url], [self.inboxEntry.url absoluteString], @"Wrong url.");
    
    NSDictionary *actorJSON = JSON[JiveInboxEntryAttributes.actor];
    
    STAssertTrue([[actorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([actorJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(actorJSON[JiveObjectConstants.id], self.inboxEntry.actor.jiveId, @"Wrong value");
    
    NSDictionary *generatorJSON = JSON[JiveInboxEntryAttributes.generator];
    
    STAssertTrue([[generatorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([generatorJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(generatorJSON[JiveObjectConstants.id], self.inboxEntry.generator.jiveId, @"Wrong value");
    
    NSDictionary *objectJSON = JSON[JiveInboxEntryAttributes.object];
    
    STAssertTrue([[objectJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([objectJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(objectJSON[JiveObjectConstants.id], self.inboxEntry.object.jiveId, @"Wrong value");
    
    NSDictionary *providerJSON = JSON[JiveInboxEntryAttributes.provider];
    
    STAssertTrue([[providerJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([providerJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(providerJSON[JiveObjectConstants.id], self.inboxEntry.provider.jiveId, @"Wrong value");
    
    NSDictionary *targetJSON = JSON[JiveInboxEntryAttributes.target];
    
    STAssertTrue([[targetJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([targetJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(targetJSON[JiveObjectConstants.id], self.inboxEntry.target.jiveId, @"Wrong value");
    
    NSDictionary *iconJSON = JSON[JiveInboxEntryAttributes.icon];
    
    STAssertTrue([[iconJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([iconJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(iconJSON[@"url"], [self.inboxEntry.icon.url absoluteString], @"Wrong value");
    
    NSDictionary *jiveJSON = JSON[JiveInboxEntryAttributes.jive];
    
    STAssertTrue([[jiveJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([jiveJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(jiveJSON[@"state"], self.inboxEntry.jive.state, @"Wrong value");
    STAssertEqualObjects(jiveJSON[JiveExtensionAttributes.collection],
                         self.inboxEntry.jive.collection, @"Wrong value");
    
    NSDictionary *openSocialJSON = JSON[JiveInboxEntryAttributes.openSocial];
    NSArray *deliverToArray = openSocialJSON[@"deliverTo"];
    
    STAssertTrue([[openSocialJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([openSocialJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertTrue([[deliverToArray class] isSubclassOfClass:[NSArray class]], @"Sub-array not converted");
    STAssertEquals([deliverToArray count], (NSUInteger)1, @"Sub-array had the wrong number of entries");
    STAssertEqualObjects([deliverToArray objectAtIndex:0],
                         [self.inboxEntry.openSocial.deliverTo objectAtIndex:0], @"Wrong value");
}

- (void)testToJSON {
    NSDictionary *JSON = [self.inboxEntry toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self initializeInboxEntry];
    JSON = [self.inboxEntry toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)4, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveInboxEntryAttributes.content], self.inboxEntry.content, @"Wrong content.");
    STAssertEqualObjects(JSON[JiveObjectConstants.id], self.inboxEntry.jiveId, @"Wrong jive id.");
    STAssertEqualObjects(JSON[JiveInboxEntryAttributes.title], self.inboxEntry.title, @"Wrong title.");
    STAssertEqualObjects(JSON[JiveInboxEntryAttributes.verb], self.inboxEntry.verb, @"Wrong verb.");
}

- (void)testToJSON_alternate {
    NSDictionary *JSON = [self.inboxEntry toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self alternateInitializeInboxEntry];
    JSON = [self.inboxEntry toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)4, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveInboxEntryAttributes.content], self.inboxEntry.content, @"Wrong content.");
    STAssertEqualObjects(JSON[JiveObjectConstants.id], self.inboxEntry.jiveId, @"Wrong jive id.");
    STAssertEqualObjects(JSON[JiveInboxEntryAttributes.title], self.inboxEntry.title, @"Wrong title.");
    STAssertEqualObjects(JSON[JiveInboxEntryAttributes.verb], self.inboxEntry.verb, @"Wrong verb.");
}

- (void)testPlaceParsing {
    [self initializeInboxEntry];
    
    id JSON = [self.inboxEntry persistentJSON];
    JiveInboxEntry *entry = [JiveInboxEntry objectFromJSON:JSON withInstance:self.instance];
    
    STAssertEquals([entry class], [self.inboxEntry class], @"Wrong item class");
    STAssertEqualObjects(entry.jiveId, self.inboxEntry.jiveId, @"Wrong id");
    STAssertEqualObjects(entry.content, self.inboxEntry.content, @"Wrong content");
    STAssertEqualObjects(entry.title, self.inboxEntry.title, @"Wrong title");
    STAssertEqualObjects(entry.verb, self.inboxEntry.verb, @"Wrong verb");
    STAssertEqualObjects(entry.published, self.inboxEntry.published, @"Wrong published");
    STAssertEqualObjects(entry.updated, self.inboxEntry.updated, @"Wrong updated");
    STAssertEqualObjects(entry.url, self.inboxEntry.url, @"Wrong url");
    STAssertEqualObjects(entry.actor.jiveId, self.inboxEntry.actor.jiveId, @"Wrong actor");
    STAssertEqualObjects(entry.generator.jiveId, self.inboxEntry.generator.jiveId, @"Wrong generator");
    STAssertEqualObjects(entry.object.jiveId, self.inboxEntry.object.jiveId, @"Wrong object");
    STAssertEqualObjects(entry.provider.jiveId, self.inboxEntry.provider.jiveId, @"Wrong provider");
    STAssertEqualObjects(entry.target.jiveId, self.inboxEntry.target.jiveId, @"Wrong target");
    STAssertEqualObjects(entry.icon.url, self.inboxEntry.icon.url, @"Wrong icon");
    STAssertEqualObjects(entry.jive.state, self.inboxEntry.jive.state, @"Wrong jive");
    STAssertEquals([entry.openSocial.deliverTo count], [self.inboxEntry.openSocial.deliverTo count], @"Wrong number of deliverTo objects");
    STAssertEqualObjects([entry.openSocial.deliverTo objectAtIndex:0],
                         [self.inboxEntry.openSocial.deliverTo objectAtIndex:0], @"Wrong deliverTo object");
}

- (void)testPlaceParsingAlternate {
    [self alternateInitializeInboxEntry];
    
    id JSON = [self.inboxEntry persistentJSON];
    JiveInboxEntry *entry = [JiveInboxEntry objectFromJSON:JSON withInstance:self.instance];
    
    STAssertEquals([entry class], [self.inboxEntry class], @"Wrong item class");
    STAssertEqualObjects(entry.jiveId, self.inboxEntry.jiveId, @"Wrong id");
    STAssertEqualObjects(entry.content, self.inboxEntry.content, @"Wrong content");
    STAssertEqualObjects(entry.title, self.inboxEntry.title, @"Wrong title");
    STAssertEqualObjects(entry.verb, self.inboxEntry.verb, @"Wrong verb");
    STAssertEqualObjects(entry.published, self.inboxEntry.published, @"Wrong published");
    STAssertEqualObjects(entry.updated, self.inboxEntry.updated, @"Wrong updated");
    STAssertEqualObjects(entry.url, self.inboxEntry.url, @"Wrong url");
    STAssertEqualObjects(entry.actor.jiveId, self.inboxEntry.actor.jiveId, @"Wrong actor");
    STAssertEqualObjects(entry.generator.jiveId, self.inboxEntry.generator.jiveId, @"Wrong generator");
    STAssertEqualObjects(entry.object.jiveId, self.inboxEntry.object.jiveId, @"Wrong object");
    STAssertEqualObjects(entry.provider.jiveId, self.inboxEntry.provider.jiveId, @"Wrong provider");
    STAssertEqualObjects(entry.target.jiveId, self.inboxEntry.target.jiveId, @"Wrong target");
    STAssertEqualObjects(entry.icon.url, self.inboxEntry.icon.url, @"Wrong icon");
    STAssertEqualObjects(entry.jive.state, self.inboxEntry.jive.state, @"Wrong jive");
    STAssertEquals([entry.openSocial.deliverTo count], [self.inboxEntry.openSocial.deliverTo count], @"Wrong number of deliverTo objects");
    STAssertEqualObjects([entry.openSocial.deliverTo objectAtIndex:0],
                         [self.inboxEntry.openSocial.deliverTo objectAtIndex:0], @"Wrong deliverTo object");
}

@end
