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
    return (JiveVideo *)self.content;
}

- (void)testType {
    STAssertEqualObjects(self.video.type, @"video", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.video.type forKey:@"type"];
    
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.video class], @"Video class not registered with JiveTypedObject.");
    STAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.video class], @"Video class not registered with JiveContent.");
}

- (void)testVideoToJSON {
    JivePerson *user = [[JivePerson alloc] init];
    NSString *category = @"category";
    NSString *tag = @"wordy";
    NSString *visibility = @"hidden";
    NSString *externalID = @"external id";
    NSString *playerBaseURL = @"http://dummy.com";
    NSNumber *height = @2;
    NSNumber *width = @3;
    NSString *authToken = @"authToken";
    NSDictionary *JSON = [self.video toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], @"video", @"Wrong type");
    
    user.location = @"location";
    self.video.categories = @[category];
    self.video.tags = @[tag];
    self.video.users = @[user];
    self.video.visibility = visibility;
    [self.video setValue:@YES forKey:JiveVideoAttributes.visibleToExternalContributors];
    [self.video setValue:externalID forKey:JiveVideoAttributes.externalID];
    [self.video setValue:[NSURL URLWithString:playerBaseURL] forKey:JiveVideoAttributes.playerBaseURL];
    [self.video setValue:height forKey:JiveVideoAttributes.height];
    [self.video setValue:width forKey:JiveVideoAttributes.width];
    [self.video setValue:authToken forKey:JiveVideoAttributes.authtoken];
    
    JSON = [self.video toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)11, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.video.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:JiveVideoAttributes.visibility], self.video.visibility, @"Wrong visibility");
    STAssertEqualObjects([JSON objectForKey:JiveVideoAttributes.externalID], self.video.externalID, @"Wrong externalID");
    STAssertEqualObjects([JSON objectForKey:JiveVideoAttributes.playerBaseURL], playerBaseURL, @"Wrong playerBaseURL");
    STAssertEqualObjects([JSON objectForKey:JiveVideoAttributes.height], self.video.height, @"Wrong height");
    STAssertEqualObjects([JSON objectForKey:JiveVideoAttributes.width], self.video.width, @"Wrong width");
    STAssertEqualObjects([JSON objectForKey:JiveVideoAttributes.authtoken], self.video.authtoken, @"Wrong authtoken");
    STAssertEqualObjects([JSON objectForKey:JiveVideoAttributes.visibleToExternalContributors], self.video.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
    NSArray *tagsJSON = [JSON objectForKey:JiveVideoAttributes.tags];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
    
    NSArray *usersJSON = [JSON objectForKey:JiveVideoAttributes.users];
    
    STAssertTrue([[usersJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([usersJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(usersJSON[0][JivePersonAttributes.location], user.location, @"Wrong value");
    
    NSArray *categoriesJSON = [JSON objectForKey:JiveVideoAttributes.categories];
    
    STAssertTrue([[categoriesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([categoriesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([categoriesJSON objectAtIndex:0], category, @"Wrong value");
}

- (void)testVideoToJSON_alternate {
    JivePerson *user = [[JivePerson alloc] init];
    NSString *category = @"trivia";
    NSString *tag = @"concise";
    NSString *visibility = @"person";
    NSString *externalID = @"internal id";
    NSString *playerBaseURL = @"http://rtd-denver.com";
    NSNumber *height = @300;
    NSNumber *width = @5;
    NSString *authToken = @"invalid";
    
    user.location = @"location";
    self.video.categories = @[category];
    self.video.tags = @[tag];
    self.video.users = @[user];
    self.video.visibility = visibility;
    [self.video setValue:@NO forKey:JiveVideoAttributes.visibleToExternalContributors];
    [self.video setValue:externalID forKey:JiveVideoAttributes.externalID];
    [self.video setValue:[NSURL URLWithString:playerBaseURL] forKey:JiveVideoAttributes.playerBaseURL];
    [self.video setValue:height forKey:JiveVideoAttributes.height];
    [self.video setValue:width forKey:JiveVideoAttributes.width];
    [self.video setValue:authToken forKey:JiveVideoAttributes.authtoken];
    
    NSDictionary *JSON = [self.video toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)11, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.video.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:JiveVideoAttributes.visibility], self.video.visibility, @"Wrong visibility");
    STAssertEqualObjects([JSON objectForKey:JiveVideoAttributes.externalID], self.video.externalID, @"Wrong externalID");
    STAssertEqualObjects([JSON objectForKey:JiveVideoAttributes.playerBaseURL], playerBaseURL, @"Wrong playerBaseURL");
    STAssertEqualObjects([JSON objectForKey:JiveVideoAttributes.height], self.video.height, @"Wrong height");
    STAssertEqualObjects([JSON objectForKey:JiveVideoAttributes.width], self.video.width, @"Wrong width");
    STAssertEqualObjects([JSON objectForKey:JiveVideoAttributes.authtoken], self.video.authtoken, @"Wrong authtoken");
    STAssertEqualObjects([JSON objectForKey:JiveVideoAttributes.visibleToExternalContributors], self.video.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
    NSArray *tagsJSON = [JSON objectForKey:JiveVideoAttributes.tags];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
    
    NSArray *usersJSON = [JSON objectForKey:JiveVideoAttributes.users];
    
    STAssertTrue([[usersJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([usersJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(usersJSON[0][JivePersonAttributes.location], user.location, @"Wrong value");
    
    NSArray *categoriesJSON = [JSON objectForKey:JiveVideoAttributes.categories];
    
    STAssertTrue([[categoriesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([categoriesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([categoriesJSON objectAtIndex:0], category, @"Wrong value");
}

- (void)testVideoParsing {
    JivePerson *user = [[JivePerson alloc] init];
    NSString *category = @"category";
    NSString *tag = @"wordy";
    NSString *visibility = @"hidden";
    NSString *externalID = @"external id";
    NSString *playerBaseURL = @"http://dummy.com";
    NSNumber *height = @2;
    NSNumber *width = @3;
    NSString *authToken = @"authToken";
    
    user.location = @"location";
    self.video.categories = @[category];
    self.video.tags = @[tag];
    self.video.users = @[user];
    self.video.visibility = visibility;
    [self.video setValue:@YES forKey:JiveVideoAttributes.visibleToExternalContributors];
    [self.video setValue:externalID forKey:JiveVideoAttributes.externalID];
    [self.video setValue:[NSURL URLWithString:playerBaseURL] forKey:JiveVideoAttributes.playerBaseURL];
    [self.video setValue:height forKey:JiveVideoAttributes.height];
    [self.video setValue:width forKey:JiveVideoAttributes.width];
    [self.video setValue:authToken forKey:JiveVideoAttributes.authtoken];
    
    id JSON = [self.video toJSONDictionary];
    JiveVideo *newContent = [JiveVideo objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.video class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.video.type, @"Wrong type");
    STAssertEqualObjects(newContent.visibility, self.video.visibility, @"Wrong visibility");
    STAssertEqualObjects(newContent.externalID, self.video.externalID, @"Wrong externalID");
    STAssertEqualObjects(newContent.playerBaseURL, self.video.playerBaseURL, @"Wrong playerBaseURL");
    STAssertEqualObjects(newContent.height, self.video.height, @"Wrong height");
    STAssertEqualObjects(newContent.width, self.video.width, @"Wrong width");
    STAssertEqualObjects(newContent.authtoken, self.video.authtoken, @"Wrong authtoken");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.video.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.categories count], [self.video.categories count], @"Wrong number of categories");
    STAssertEqualObjects(newContent.categories[0], category, @"Wrong category");
    STAssertEquals([newContent.tags count], [self.video.tags count], @"Wrong number of tags");
    STAssertEqualObjects(newContent.tags[0], tag, @"Wrong tag");
    STAssertEquals([newContent.users count], [self.video.users count], @"Wrong number of users");
    STAssertEqualObjects(newContent.users[0][JivePersonAttributes.location], user.location, @"Wrong user");
}

- (void)testVideoParsingAlternate {
    JivePerson *user = [[JivePerson alloc] init];
    NSString *category = @"trivia";
    NSString *tag = @"concise";
    NSString *visibility = @"person";
    NSString *externalID = @"internal id";
    NSString *playerBaseURL = @"http://rtd-denver.com";
    NSNumber *height = @300;
    NSNumber *width = @5;
    NSString *authToken = @"invalid";
    
    user.location = @"location";
    self.video.categories = @[category];
    self.video.tags = @[tag];
    self.video.users = @[user];
    self.video.visibility = visibility;
    [self.video setValue:@YES forKey:JiveVideoAttributes.visibleToExternalContributors];
    [self.video setValue:externalID forKey:JiveVideoAttributes.externalID];
    [self.video setValue:[NSURL URLWithString:playerBaseURL] forKey:JiveVideoAttributes.playerBaseURL];
    [self.video setValue:height forKey:JiveVideoAttributes.height];
    [self.video setValue:width forKey:JiveVideoAttributes.width];
    [self.video setValue:authToken forKey:JiveVideoAttributes.authtoken];
    
    id JSON = [self.video toJSONDictionary];
    JiveVideo *newContent = [JiveVideo objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.video class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.video.type, @"Wrong type");
    STAssertEqualObjects(newContent.visibility, self.video.visibility, @"Wrong visibility");
    STAssertEqualObjects(newContent.externalID, self.video.externalID, @"Wrong externalID");
    STAssertEqualObjects(newContent.playerBaseURL, self.video.playerBaseURL, @"Wrong playerBaseURL");
    STAssertEqualObjects(newContent.height, self.video.height, @"Wrong height");
    STAssertEqualObjects(newContent.width, self.video.width, @"Wrong width");
    STAssertEqualObjects(newContent.authtoken, self.video.authtoken, @"Wrong authtoken");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.video.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.categories count], [self.video.categories count], @"Wrong number of categories");
    STAssertEqualObjects(newContent.categories[0], category, @"Wrong category");
    STAssertEquals([newContent.tags count], [self.video.tags count], @"Wrong number of tags");
    STAssertEqualObjects(newContent.tags[0], tag, @"Wrong tag");
    STAssertEquals([newContent.users count], [self.video.users count], @"Wrong number of users");
    STAssertEqualObjects(newContent.users[0][JivePersonAttributes.location], user.location, @"Wrong user");
}

@end
