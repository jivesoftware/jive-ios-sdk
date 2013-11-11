//
//  JiveIdeaTests.m
//  jive-ios-sdk
//
//  Created by Chris Gummer on 3/25/13.
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

#import "JiveIdeaTests.h"

@implementation JiveIdeaTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveIdea alloc] init];
}

- (JiveIdea *)idea {
    return (JiveIdea *)self.content;
}

- (void)testType {
    STAssertEqualObjects(self.idea.type, @"idea", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.idea.type forKey:@"type"];
    
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.idea class], @"Idea class not registered with JiveTypedObject.");
    STAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.idea class], @"Idea class not registered with JiveContent.");
}

- (void)testIdeaToJSON {
    NSString *tag = @"wordy";
    NSDictionary *JSON = [self.idea toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"idea", @"Wrong type");
    
    [self.idea setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.idea setValue:@YES forKey:@"visibleToExternalContributors"];
    
    JSON = [self.idea toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.idea.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"visibleToExternalContributors"], self.idea.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
}

- (void)testIdeaToJSON_alternate {
    NSString *tag = @"concise";
    
    [self.idea setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    NSDictionary *JSON = [self.idea toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.idea.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"visibleToExternalContributors"], self.idea.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
}

- (void)testIdeaParsing {
    NSString *tag = @"wordy";
    
    [self.idea setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.idea setValue:@YES forKey:@"visibleToExternalContributors"];
    
    id JSON = [self.idea toJSONDictionary];
    JiveIdea *newContent = [JiveIdea objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.idea class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.idea.type, @"Wrong type");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.idea.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.tags count], [self.idea.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
}

- (void)testIdeaParsingAlternate {
    NSString *tag = @"concise";
    
    [self.idea setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    id JSON = [self.idea toJSONDictionary];
    JiveIdea *newContent = [JiveIdea objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.idea class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.idea.type, @"Wrong type");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.idea.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.tags count], [self.idea.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
}

@end
