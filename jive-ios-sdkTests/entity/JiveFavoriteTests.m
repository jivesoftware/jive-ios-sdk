//
//  JiveFavoriteTests.m
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

#import "JiveFavoriteTests.h"

@implementation JiveFavoriteTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveFavorite alloc] init];
}

- (JiveFavorite *)favorite {
    return (JiveFavorite *)self.content;
}

- (void)testType {
    STAssertEqualObjects(self.favorite.type, @"favorite", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.favorite.type forKey:@"type"];
    
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.favorite class], @"Favorite class not registered with JiveTypedObject.");
    STAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.favorite class], @"Favorite class not registered with JiveContent.");
}

- (void)testFavoriteToJSON {
    NSString *tag = @"wordy";
    NSDictionary *JSON = [self.favorite toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"favorite", @"Wrong type");
    
    [self.favorite setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    self.favorite.visibleToExternalContributors = [NSNumber numberWithBool:YES];
    
    JSON = [self.favorite toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.favorite.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"visibleToExternalContributors"], self.favorite.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
}

- (void)testFavoriteToJSON_alternate {
    NSString *tag = @"concise";
    
    [self.favorite setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    self.favorite.private = [NSNumber numberWithBool:YES];
    
    NSDictionary *JSON = [self.favorite toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.favorite.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"private"], self.favorite.private, @"Wrong private");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
}

- (void)testPostParsing {
    NSString *tag = @"wordy";
    
    [self.favorite setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    self.favorite.visibleToExternalContributors = [NSNumber numberWithBool:YES];
    
    id JSON = [self.favorite toJSONDictionary];
    JiveFavorite *newContent = [JiveFavorite objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.favorite class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.favorite.type, @"Wrong type");
    STAssertEqualObjects(newContent.private, self.favorite.private, @"Wrong private");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.favorite.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.tags count], [self.favorite.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
}

- (void)testPostParsingAlternate {
    NSString *tag = @"concise";
    
    [self.favorite setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    self.favorite.private = [NSNumber numberWithBool:YES];
    
    id JSON = [self.favorite toJSONDictionary];
    JiveFavorite *newContent = [JiveFavorite objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.favorite class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.favorite.type, @"Wrong type");
    STAssertEqualObjects(newContent.private, self.favorite.private, @"Wrong private");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.favorite.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.tags count], [self.favorite.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
}

@end
