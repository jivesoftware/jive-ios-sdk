//
//  JiveUpdateTests.m
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

#import "JiveUpdateTests.h"

@implementation JiveUpdateTests

- (void)setUp {
    self.content = [[JiveUpdate alloc] init];
}

- (JiveUpdate *)update {
    return (JiveUpdate *)self.content;
}

- (void)testTaskToJSON {
    NSString *tag = @"wordy";
    NSDictionary *JSON = [self.update toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"update", @"Wrong type");
    
    [self.update setValue:[NSNumber numberWithDouble:1.234] forKey:@"latitude"];
    [self.update setValue:[NSNumber numberWithDouble:-0.456] forKey:@"longitude"];
    [self.update setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    self.update.visibleToExternalContributors = [NSNumber numberWithBool:YES];
    
    JSON = [self.update toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.update.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"latitude"], self.update.latitude, @"Wrong latitude");
    STAssertEqualObjects([JSON objectForKey:@"longitude"], self.update.longitude, @"Wrong longitude");
    STAssertEqualObjects([JSON objectForKey:@"visibleToExternalContributors"], self.update.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
}

- (void)testTaskToJSON_alternate {
    NSString *tag = @"concise";
    
    [self.update setValue:[NSNumber numberWithDouble:-123.4] forKey:@"latitude"];
    [self.update setValue:[NSNumber numberWithDouble:22.6] forKey:@"longitude"];
    [self.update setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    NSDictionary *JSON = [self.update toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)4, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.update.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"latitude"], self.update.latitude, @"Wrong latitude");
    STAssertEqualObjects([JSON objectForKey:@"longitude"], self.update.longitude, @"Wrong longitude");
    STAssertEqualObjects([JSON objectForKey:@"visibleToExternalContributors"], self.update.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
}

- (void)testPostParsing {
    NSString *tag = @"wordy";
    
    [self.update setValue:[NSNumber numberWithDouble:1.234] forKey:@"latitude"];
    [self.update setValue:[NSNumber numberWithDouble:-0.456] forKey:@"longitude"];
    [self.update setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    self.update.visibleToExternalContributors = [NSNumber numberWithBool:YES];
    
    id JSON = [self.update toJSONDictionary];
    JiveUpdate *newContent = [JiveUpdate instanceFromJSON:JSON];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.update class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.update.type, @"Wrong type");
    STAssertEqualObjects(newContent.latitude, self.update.latitude, @"Wrong latitude");
    STAssertEqualObjects(newContent.longitude, self.update.longitude, @"Wrong longitude");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.update.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.tags count], [self.update.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
}

- (void)testPostParsingAlternate {
    NSString *tag = @"concise";
    
    [self.update setValue:[NSNumber numberWithDouble:-123.4] forKey:@"latitude"];
    [self.update setValue:[NSNumber numberWithDouble:22.6] forKey:@"longitude"];
    [self.update setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    id JSON = [self.update toJSONDictionary];
    JiveUpdate *newContent = [JiveUpdate instanceFromJSON:JSON];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.update class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.update.type, @"Wrong type");
    STAssertEqualObjects(newContent.latitude, self.update.latitude, @"Wrong latitude");
    STAssertEqualObjects(newContent.longitude, self.update.longitude, @"Wrong longitude");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.update.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.tags count], [self.update.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
}

@end
