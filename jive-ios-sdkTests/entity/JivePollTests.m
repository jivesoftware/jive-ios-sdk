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

NSString * const JivePollTestsOptionsImageImageKey = @"image";

- (void)setUp {
    [super setUp];
    self.object = [[JivePoll alloc] init];
}

- (JivePoll *)poll {
    return (JivePoll *)self.categorizedContent;
}

- (void)testType {
    STAssertEqualObjects(self.poll.type, @"poll", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.poll.type forKey:@"type"];
    
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.poll class], @"Poll class not registered with JiveTypedObject.");
    STAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.poll class], @"Poll class not registered with JiveContent.");
}

- (void)testPollToJSON {
    NSString *tag = @"wordy";
    NSString *option = @"option";
    NSString *vote = @"vote";

    NSMutableDictionary *optionsImages = [NSMutableDictionary new];
    [optionsImages setValue:[JiveImage new] forKey:option];
    
    NSDictionary *JSON = [self.poll toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], @"poll", @"Wrong type");
    
    self.poll.options = [NSArray arrayWithObject:option];
    [self.poll setValue:[NSArray arrayWithObject:tag] forKey:JiveContentAttributes.tags];
    [self.poll setValue:[NSNumber numberWithInt:1] forKey:JivePollAttributes.voteCount];
    [self.poll setValue:[NSArray arrayWithObject:vote] forKey:JivePollAttributes.votes];
    [self.poll setValue:optionsImages forKey:JivePollAttributes.optionsImages];
    self.poll.visibleToExternalContributors = [NSNumber numberWithBool:YES];
    
    JSON = [self.poll toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.poll.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:JivePollAttributes.voteCount], self.poll.voteCount, @"Wrong voteCount");
    STAssertEqualObjects([JSON objectForKey:JiveContentAttributes.visibleToExternalContributors], self.poll.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
    NSArray *votesJSON = [JSON objectForKey:JivePollAttributes.votes];
    
    STAssertTrue([[votesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([votesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([votesJSON objectAtIndex:0], vote, @"Wrong value");
    
    NSArray *optionsJSON = [JSON objectForKey:JivePollAttributes.options];
    
    STAssertTrue([[optionsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([optionsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([optionsJSON objectAtIndex:0], option, @"Wrong value");
    
    NSArray *tagsJSON = [JSON objectForKey:JiveContentAttributes.tags];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
    
    NSArray *optionsImagesJson = [JSON objectForKey:JivePollAttributes.optionsImages];
    STAssertTrue([[optionsImagesJson class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([optionsImagesJson count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertTrue([[[optionsImagesJson objectAtIndex:0] class] isSubclassOfClass:[NSDictionary class]], @"Option image record is not a dictionary");
    
    
    NSDictionary *optionsImagesImageRecord = [optionsImagesJson objectAtIndex:0];
    STAssertEquals([optionsImagesImageRecord objectForKey:option], option, @"Option image had wrong option key");
    STAssertTrue([[[optionsImagesImageRecord objectForKey:JivePollTestsOptionsImageImageKey] class] isSubclassOfClass:[NSDictionary class]], @"Option image record was not a dictionary");
    
}

- (void)testPollToJSON_alternate {
    NSString *tag = @"concise";
    NSString *option = @"option";
    NSString *vote = @"vote";
    
    self.poll.options = [NSArray arrayWithObject:option];
    [self.poll setValue:[NSArray arrayWithObject:tag] forKey:JiveContentAttributes.tags];
    [self.poll setValue:[NSNumber numberWithInt:2] forKey:JivePollAttributes.voteCount];
    [self.poll setValue:[NSArray arrayWithObject:vote] forKey:JivePollAttributes.votes];
    
    NSDictionary *JSON = [self.poll toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.poll.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:JivePollAttributes.voteCount], self.poll.voteCount, @"Wrong voteCount");
    STAssertEqualObjects([JSON objectForKey:JiveContentAttributes.visibleToExternalContributors], self.poll.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
    NSArray *votesJSON = [JSON objectForKey:JivePollAttributes.votes];
    
    STAssertTrue([[votesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([votesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([votesJSON objectAtIndex:0], vote, @"Wrong value");
    
    NSArray *optionsJSON = [JSON objectForKey:JivePollAttributes.options];
    
    STAssertTrue([[optionsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([optionsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([optionsJSON objectAtIndex:0], option, @"Wrong value");
    
    NSArray *tagsJSON = [JSON objectForKey:JiveContentAttributes.tags];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
}

- (void)testPollParsing {
    NSString *tag = @"wordy";
    NSString *option = @"option";
    NSString *vote = @"vote";
    
    self.poll.options = [NSArray arrayWithObject:option];
    [self.poll setValue:[NSArray arrayWithObject:tag] forKey:JiveContentAttributes.tags];
    [self.poll setValue:[NSNumber numberWithInt:1] forKey:JivePollAttributes.voteCount];
    [self.poll setValue:[NSArray arrayWithObject:vote] forKey:JivePollAttributes.votes];
    self.poll.visibleToExternalContributors = [NSNumber numberWithBool:YES];
    
    id JSON = [self.poll toJSONDictionary];
    JivePoll *newContent = [JivePoll objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.poll class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.poll.type, @"Wrong type");
    STAssertEqualObjects(newContent.voteCount, self.poll.voteCount, @"Wrong voteCount");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.poll.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.tags count], [self.poll.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
    STAssertEquals([newContent.options count], [self.poll.options count], @"Wrong number of options");
    STAssertEqualObjects([newContent.options objectAtIndex:0], option, @"Wrong option");
    STAssertEquals([newContent.votes count], [self.poll.votes count], @"Wrong number of votes");
    STAssertEqualObjects([newContent.votes objectAtIndex:0], vote, @"Wrong vote");
}

- (void)testOptionImagesParsed {
    JivePoll *poll = [self pollFromTestData];
    NSDictionary *optionsImages = poll.optionsImages;
    NSUInteger expectedImageCount = 6;
    STAssertEquals([optionsImages count], expectedImageCount, @"Expected six images");
    
    for (NSString *option in poll.options) {
        STAssertNotNil([optionsImages objectForKey:option], @"Did not get an image for an expected option %@", option);
    }
    
    STAssertNil([optionsImages objectForKey:@"abcdefghijklmonop"], @"Got non-null image for an option that does not exist");
    
}

- (void)testPollParsingAlternate {
    NSString *tag = @"concise";
    NSString *option = @"option";
    NSString *vote = @"vote";
    
    self.poll.options = [NSArray arrayWithObject:option];
    [self.poll setValue:[NSArray arrayWithObject:tag] forKey:JiveContentAttributes.tags];
    [self.poll setValue:[NSNumber numberWithInt:2] forKey:JivePollAttributes.voteCount];
    [self.poll setValue:[NSArray arrayWithObject:vote] forKey:JivePollAttributes.votes];
    
    id JSON = [self.poll toJSONDictionary];
    JivePoll *newContent = [JivePoll objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.poll class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.poll.type, @"Wrong type");
    STAssertEqualObjects(newContent.voteCount, self.poll.voteCount, @"Wrong voteCount");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.poll.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.tags count], [self.poll.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
    STAssertEquals([newContent.options count], [self.poll.options count], @"Wrong number of options");
    STAssertEqualObjects([newContent.options objectAtIndex:0], option, @"Wrong option");
    STAssertEquals([newContent.votes count], [self.poll.votes count], @"Wrong number of votes");
    STAssertEqualObjects([newContent.votes objectAtIndex:0], vote, @"Wrong vote");
}

-(void) testCanVote {
    JivePoll *poll = [self pollFromTestData];
    STAssertTrue(poll.canVote, @"Should be able to vote");
}

#pragma mark - Test Object Generator

-(JivePoll*) pollFromTestData {
    NSString* dummyPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"poll"
                                                                           ofType:@"json"];
    
    NSData* dummyContent = [NSData dataWithContentsOfFile:dummyPath];
    
    NSError *error;
    NSMutableDictionary *pollDictionary = [NSJSONSerialization
                                           JSONObjectWithData:dummyContent
                                           options:0
                                           error:&error];
    JivePoll *poll = [JivePoll objectFromJSON:pollDictionary withInstance:self.instance];

    return poll;
}

@end
