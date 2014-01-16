//
//  JiveStreamTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/2/13.
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

#import "JiveContentTests.h"
#import "JiveStreamEntry.h"

@interface JiveStreamEntryTests : JiveContentTests

@property (nonatomic, readonly) JiveStreamEntry *stream;

@end

@implementation JiveStreamEntryTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveStreamEntry alloc] init];
}

- (JiveStreamEntry *)stream {
    return (JiveStreamEntry *)self.object;
}

- (void)testStreamEntryToJSON {
    NSString *tag = @"wordy";
    NSDictionary *JSON = [self.stream toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.stream.type, @"Wrong type");
    
    self.stream.tags = @[tag];
    [self.stream setValue:@"verb" forKey:JiveStreamEntryAttributes.verb];
    [self.stream setValue:[NSNumber numberWithBool:YES] forKey:JiveStreamEntryAttributes.visibleToExternalContributors];
    
    JSON = [self.stream toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.stream.type, @"Wrong type");
    
    NSArray *tagsJSON = [JSON objectForKey:JiveStreamEntryAttributes.tags];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
}

- (void)testStreamEntryToJSON_alternate {
    NSString *tag = @"concise";
    NSDictionary *JSON = [self.stream toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.stream.type, @"Wrong type");
    
    self.stream.tags = @[tag];
    [self.stream setValue:@"noun" forKey:JiveStreamEntryAttributes.verb];
    
    JSON = [self.stream toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.stream.type, @"Wrong type");
    
    NSArray *tagsJSON = [JSON objectForKey:JiveStreamEntryAttributes.tags];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
}

- (void)testStreamEntryPersistentJSON {
    NSString *tag = @"wordy";
    NSDictionary *JSON = [self.stream toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.stream.type, @"Wrong type");
    
    self.stream.tags = @[tag];
    [self.stream setValue:@"verb" forKey:JiveStreamEntryAttributes.verb];
    [self.stream setValue:[NSNumber numberWithBool:YES] forKey:JiveStreamEntryAttributes.visibleToExternalContributors];
    
    JSON = [self.stream persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)4, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.stream.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:JiveStreamEntryAttributes.verb], self.stream.verb, @"Wrong verb");
    STAssertEqualObjects([JSON objectForKey:JiveStreamEntryAttributes.visibleToExternalContributors], self.stream.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
    NSArray *tagsJSON = [JSON objectForKey:JiveStreamEntryAttributes.tags];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
}

- (void)testStreamEntryPersistentJSON_alternate {
    NSString *tag = @"concise";
    NSDictionary *JSON = [self.stream toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.stream.type, @"Wrong type");

    self.stream.tags = @[tag];
    [self.stream setValue:@"noun" forKey:JiveStreamEntryAttributes.verb];
    
    JSON = [self.stream persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:JiveTypedObjectAttributes.type], self.stream.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:JiveStreamEntryAttributes.verb], self.stream.verb, @"Wrong verb");
    STAssertEqualObjects([JSON objectForKey:JiveStreamEntryAttributes.visibleToExternalContributors], self.stream.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
    NSArray *tagsJSON = [JSON objectForKey:JiveStreamEntryAttributes.tags];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
}

- (void)testStreamEntryParsing {
    NSString *tag = @"wordy";
    
    self.stream.tags = @[tag];
    [self.stream setValue:@"verb" forKey:JiveStreamEntryAttributes.verb];
    [self.stream setValue:[NSNumber numberWithBool:YES] forKey:JiveStreamEntryAttributes.visibleToExternalContributors];
    
    id JSON = [self.stream persistentJSON];
    JiveStreamEntry *newStream = [JiveStreamEntry objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newStream class] isSubclassOfClass:[self.stream class]], @"Wrong item class");
    STAssertEqualObjects(newStream.type, self.stream.type, @"Wrong type");
    STAssertEqualObjects(newStream.verb, self.stream.verb, @"Wrong verb");
    STAssertEqualObjects(newStream.visibleToExternalContributors, self.stream.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newStream.tags count], [self.stream.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newStream.tags objectAtIndex:0], tag, @"Wrong tag");
}

- (void)testStreamEntryParsingAlternate {
    NSString *tag = @"concise";
    
    self.stream.tags = @[tag];
    [self.stream setValue:@"noun" forKey:JiveStreamEntryAttributes.verb];
    
    id JSON = [self.stream persistentJSON];
    JiveStreamEntry *newStream = [JiveStreamEntry objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newStream class] isSubclassOfClass:[self.stream class]], @"Wrong item class");
    STAssertEqualObjects(newStream.type, self.stream.type, @"Wrong type");
    STAssertEqualObjects(newStream.verb, self.stream.verb, @"Wrong verb");
    STAssertEqualObjects(newStream.visibleToExternalContributors, self.stream.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newStream.tags count], [self.stream.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newStream.tags objectAtIndex:0], tag, @"Wrong tag");
}

@end
