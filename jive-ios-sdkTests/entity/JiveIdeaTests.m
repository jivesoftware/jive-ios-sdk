//
//  JiveIdeaTests.m
//  jive-ios-sdk
//
//  Created by Chris Gummer on 3/25/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveIdeaTests.h"

@implementation JiveIdeaTests

- (void)setUp {
    self.content = [[JiveIdea alloc] init];
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

- (void)testTaskToJSON {
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

- (void)testTaskToJSON_alternate {
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

- (void)testPostParsing {
    NSString *tag = @"wordy";
    
    [self.idea setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [self.idea setValue:@YES forKey:@"visibleToExternalContributors"];
    
    id JSON = [self.idea toJSONDictionary];
    JiveIdea *newContent = [JiveIdea instanceFromJSON:JSON];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.idea class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.idea.type, @"Wrong type");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.idea.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.tags count], [self.idea.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
}

- (void)testPostParsingAlternate {
    NSString *tag = @"concise";
    
    [self.idea setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    id JSON = [self.idea toJSONDictionary];
    JiveIdea *newContent = [JiveIdea instanceFromJSON:JSON];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.idea class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.idea.type, @"Wrong type");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.idea.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.tags count], [self.idea.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
}

@end
