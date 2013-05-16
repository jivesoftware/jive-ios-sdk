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
    self.typedObject = [[JiveVideo alloc] init];
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
    NSString *tag = @"wordy";
    NSDictionary *JSON = [self.video toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"video", @"Wrong type");
    
    [self.video setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.video setValue:@YES forKey:@"visibleToExternalContributors"];
    
    JSON = [self.video toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.video.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"visibleToExternalContributors"], self.video.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
}

- (void)testVideoToJSON_alternate {
    NSString *tag = @"concise";
    
    [self.video setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    NSDictionary *JSON = [self.video toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.video.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"visibleToExternalContributors"], self.video.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
}

- (void)testVideoParsing {
    NSString *tag = @"wordy";
    
    [self.video setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.video setValue:@YES forKey:@"visibleToExternalContributors"];
    
    id JSON = [self.video toJSONDictionary];
    JiveVideo *newContent = [JiveVideo instanceFromJSON:JSON];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.video class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.video.type, @"Wrong type");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.video.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.tags count], [self.video.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
}

- (void)testVideoParsingAlternate {
    NSString *tag = @"concise";
    
    [self.video setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    id JSON = [self.video toJSONDictionary];
    JiveVideo *newContent = [JiveVideo instanceFromJSON:JSON];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.video class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.video.type, @"Wrong type");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.video.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.tags count], [self.video.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
}

@end
