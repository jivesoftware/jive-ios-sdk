//
//  JiveSpaceTests.m
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

#import "JiveSpaceTests.h"

@implementation JiveSpaceTests

- (void)setUp {
    self.place = [[JiveSpace alloc] init];
}

- (JiveSpace *)space {
    return (JiveSpace *)self.place;
}

- (void)testType {
    STAssertEqualObjects(self.space.type, @"space", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.space.type forKey:@"type"];
    
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.space class], @"Space class not registered with JiveTypedObject.");
    STAssertEqualObjects([JivePlace entityClass:typeSpecifier], [self.space class], @"Space class not registered with JivePlace.");
}

- (void)testTaskToJSON {
    NSString *tag = @"wordy";
    NSDictionary *JSON = [self.space toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"space", @"Wrong type");
    
    [self.space setValue:[NSNumber numberWithInt:1] forKey:@"childCount"];
    [self.space setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    JSON = [self.space toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.space.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"childCount"], self.space.childCount, @"Wrong childCount");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
}

- (void)testTaskToJSON_alternate {
    NSString *tag = @"concise";
    
    [self.space setValue:[NSNumber numberWithInt:5] forKey:@"childCount"];
    [self.space setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    NSDictionary *JSON = [self.space toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.space.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"childCount"], self.space.childCount, @"Wrong childCount");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
}

- (void)testPostParsing {
    NSString *tag = @"wordy";
    
    [self.space setValue:[NSNumber numberWithInt:1] forKey:@"childCount"];
    [self.space setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    id JSON = [self.space toJSONDictionary];
    JiveSpace *newPlace = [JiveSpace instanceFromJSON:JSON];
    
    STAssertTrue([[newPlace class] isSubclassOfClass:[self.space class]], @"Wrong item class");
    STAssertEqualObjects(newPlace.type, self.space.type, @"Wrong type");
    STAssertEqualObjects(newPlace.childCount, self.space.childCount, @"Wrong childCount");
    STAssertEquals([newPlace.tags count], [self.space.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newPlace.tags objectAtIndex:0], tag, @"Wrong tag");
}

- (void)testPostParsingAlternate {
    NSString *tag = @"concise";
    
    [self.space setValue:[NSNumber numberWithInt:5] forKey:@"childCount"];
    [self.space setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    id JSON = [self.space toJSONDictionary];
    JiveSpace *newPlace = [JiveSpace instanceFromJSON:JSON];
    
    STAssertTrue([[newPlace class] isSubclassOfClass:[self.space class]], @"Wrong item class");
    STAssertEqualObjects(newPlace.type, self.space.type, @"Wrong type");
    STAssertEqualObjects(newPlace.childCount, self.space.childCount, @"Wrong childCount");
    STAssertEquals([newPlace.tags count], [self.space.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newPlace.tags objectAtIndex:0], tag, @"Wrong tag");
}

@end
