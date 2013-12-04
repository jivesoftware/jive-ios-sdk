//
//  JivePollTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/28/12.
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

#import "JivePollTests.h"

@implementation JivePollTests

- (void)setUp {
    [super setUp];
    self.object = [[JivePoll alloc] init];
}

- (JivePoll *)poll {
    return (JivePoll *)self.content;
}

- (void)testType {
    STAssertEqualObjects(self.poll.type, @"poll", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.poll.type forKey:@"type"];
    
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.poll class], @"Poll class not registered with JiveTypedObject.");
    STAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.poll class], @"Poll class not registered with JiveContent.");
}

- (void)testAnnouncementToJSON {
    NSString *category = @"category";
    NSString *tag = @"wordy";
    NSString *option = @"option";
    NSString *vote = @"vote";
    NSDictionary *JSON = [self.poll toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"poll", @"Wrong type");
    
    self.poll.categories = [NSArray arrayWithObject:category];
    self.poll.options = [NSArray arrayWithObject:option];
    [self.poll setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.poll setValue:[NSNumber numberWithInt:1] forKey:@"voteCount"];
    [self.poll setValue:[NSArray arrayWithObject:vote] forKey:@"votes"];
    self.poll.visibility = @"hidden";
    self.poll.visibleToExternalContributors = [NSNumber numberWithBool:YES];
    
    JSON = [self.poll toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)8, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.poll.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"voteCount"], self.poll.voteCount, @"Wrong voteCount");
    STAssertEqualObjects([JSON objectForKey:@"visibility"], self.poll.visibility, @"Wrong visibility");
    STAssertEqualObjects([JSON objectForKey:@"visibleToExternalContributors"], self.poll.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
    NSArray *votesJSON = [JSON objectForKey:@"votes"];
    
    STAssertTrue([[votesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([votesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([votesJSON objectAtIndex:0], vote, @"Wrong value");
    
    NSArray *optionsJSON = [JSON objectForKey:@"options"];
    
    STAssertTrue([[optionsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([optionsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([optionsJSON objectAtIndex:0], option, @"Wrong value");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
    
    NSArray *categoriesJSON = [JSON objectForKey:@"categories"];
    
    STAssertTrue([[categoriesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([categoriesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([categoriesJSON objectAtIndex:0], category, @"Wrong value");
}

- (void)testAnnouncementToJSON_alternate {
    NSString *category = @"denomination";
    NSString *tag = @"concise";
    NSString *option = @"option";
    NSString *vote = @"vote";
    
    self.poll.categories = [NSArray arrayWithObject:category];
    self.poll.options = [NSArray arrayWithObject:option];
    [self.poll setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.poll setValue:[NSNumber numberWithInt:2] forKey:@"voteCount"];
    [self.poll setValue:[NSArray arrayWithObject:vote] forKey:@"votes"];
    self.poll.visibility = @"people";
    
    NSDictionary *JSON = [self.poll toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.poll.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"voteCount"], self.poll.voteCount, @"Wrong voteCount");
    STAssertEqualObjects([JSON objectForKey:@"visibility"], self.poll.visibility, @"Wrong visibility");
    STAssertEqualObjects([JSON objectForKey:@"visibleToExternalContributors"], self.poll.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
    NSArray *votesJSON = [JSON objectForKey:@"votes"];
    
    STAssertTrue([[votesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([votesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([votesJSON objectAtIndex:0], vote, @"Wrong value");
    
    NSArray *optionsJSON = [JSON objectForKey:@"options"];
    
    STAssertTrue([[optionsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([optionsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([optionsJSON objectAtIndex:0], option, @"Wrong value");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
    
    NSArray *categoriesJSON = [JSON objectForKey:@"categories"];
    
    STAssertTrue([[categoriesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([categoriesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([categoriesJSON objectAtIndex:0], category, @"Wrong value");
}

- (void)testAnnouncementParsing {
    NSString *category = @"category";
    NSString *tag = @"wordy";
    NSString *option = @"option";
    NSString *vote = @"vote";
    
    self.poll.categories = [NSArray arrayWithObject:category];
    self.poll.options = [NSArray arrayWithObject:option];
    [self.poll setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.poll setValue:[NSNumber numberWithInt:1] forKey:@"voteCount"];
    [self.poll setValue:[NSArray arrayWithObject:vote] forKey:@"votes"];
    self.poll.visibility = @"hidden";
    self.poll.visibleToExternalContributors = [NSNumber numberWithBool:YES];
    
    id JSON = [self.poll toJSONDictionary];
    JivePoll *newContent = [JivePoll objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.poll class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.poll.type, @"Wrong type");
    STAssertEqualObjects(newContent.voteCount, self.poll.voteCount, @"Wrong voteCount");
    STAssertEqualObjects(newContent.visibility, self.poll.visibility, @"Wrong visibility");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.poll.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.tags count], [self.poll.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
    STAssertEquals([newContent.categories count], [self.poll.categories count], @"Wrong number of categories");
    STAssertEqualObjects([newContent.categories objectAtIndex:0], category, @"Wrong category");
    STAssertEquals([newContent.options count], [self.poll.options count], @"Wrong number of options");
    STAssertEqualObjects([newContent.options objectAtIndex:0], option, @"Wrong option");
    STAssertEquals([newContent.votes count], [self.poll.votes count], @"Wrong number of votes");
    STAssertEqualObjects([newContent.votes objectAtIndex:0], vote, @"Wrong vote");
}

- (void)testAnnouncementParsingAlternate {
    NSString *category = @"denomination";
    NSString *tag = @"concise";
    NSString *option = @"option";
    NSString *vote = @"vote";
    
    self.poll.categories = [NSArray arrayWithObject:category];
    self.poll.options = [NSArray arrayWithObject:option];
    [self.poll setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.poll setValue:[NSNumber numberWithInt:2] forKey:@"voteCount"];
    [self.poll setValue:[NSArray arrayWithObject:vote] forKey:@"votes"];
    self.poll.visibility = @"people";
    
    id JSON = [self.poll toJSONDictionary];
    JivePoll *newContent = [JivePoll objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.poll class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.poll.type, @"Wrong type");
    STAssertEqualObjects(newContent.voteCount, self.poll.voteCount, @"Wrong voteCount");
    STAssertEqualObjects(newContent.visibility, self.poll.visibility, @"Wrong visibility");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.poll.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.tags count], [self.poll.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
    STAssertEquals([newContent.categories count], [self.poll.categories count], @"Wrong number of categories");
    STAssertEqualObjects([newContent.categories objectAtIndex:0], category, @"Wrong category");
    STAssertEquals([newContent.options count], [self.poll.options count], @"Wrong number of options");
    STAssertEqualObjects([newContent.options objectAtIndex:0], option, @"Wrong option");
    STAssertEquals([newContent.votes count], [self.poll.votes count], @"Wrong number of votes");
    STAssertEqualObjects([newContent.votes objectAtIndex:0], vote, @"Wrong vote");
}

@end
