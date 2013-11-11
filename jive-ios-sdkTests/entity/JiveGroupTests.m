//
//  JiveGroupTests.m
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

#import "JiveGroupTests.h"
#import "JivePerson.h"

@implementation JiveGroupTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveGroup alloc] init];
}

- (JiveGroup *)group {
    return (JiveGroup *)self.place;
}

- (void)testType {
    STAssertEqualObjects(self.group.type, @"group", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.group.type forKey:@"type"];
    
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.group class], @"Group class not registered with JiveTypedObject.");
    STAssertEqualObjects([JivePlace entityClass:typeSpecifier], [self.group class], @"Group class not registered with JivePlace.");
}

- (void)testTaskToJSON {
    JivePerson *creator = [[JivePerson alloc] init];
    NSString *tag = @"wordy";
    NSDictionary *JSON = [self.group toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"group", @"Wrong type");
    
    creator.location = @"location";
    [self.group setValue:creator forKey:@"creator"];
    self.group.groupType = @"OPEN";
    [self.group setValue:[NSNumber numberWithInt:1] forKey:@"memberCount"];
    [self.group setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    JSON = [self.group toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.group.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"groupType"], self.group.groupType, @"Wrong groupType");
    STAssertEqualObjects([JSON objectForKey:@"memberCount"], self.group.memberCount, @"Wrong memberCount");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
    
    NSDictionary *creatorJSON = [JSON objectForKey:@"creator"];
    
    STAssertTrue([[creatorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([creatorJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([creatorJSON objectForKey:@"location"], creator.location, @"Wrong value");
}

- (void)testTaskToJSON_alternate {
    JivePerson *creator = [[JivePerson alloc] init];
    NSString *tag = @"concise";
    
    creator.location = @"Restaurant";
    [self.group setValue:creator forKey:@"creator"];
    self.group.groupType = @"PRIVATE";
    [self.group setValue:[NSNumber numberWithInt:102] forKey:@"memberCount"];
    [self.group setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    NSDictionary *JSON = [self.group toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.group.type, @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"groupType"], self.group.groupType, @"Wrong groupType");
    STAssertEqualObjects([JSON objectForKey:@"memberCount"], self.group.memberCount, @"Wrong memberCount");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Wrong value");
    
    NSDictionary *creatorJSON = [JSON objectForKey:@"creator"];
    
    STAssertTrue([[creatorJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([creatorJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([creatorJSON objectForKey:@"location"], creator.location, @"Wrong value");
}

- (void)testPostParsing {
    JivePerson *creator = [[JivePerson alloc] init];
    NSString *tag = @"wordy";
    
    creator.location = @"location";
    [self.group setValue:creator forKey:@"creator"];
    self.group.groupType = @"OPEN";
    [self.group setValue:[NSNumber numberWithInt:1] forKey:@"memberCount"];
    [self.group setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    id JSON = [self.group toJSONDictionary];
    JiveGroup *newPlace = [JiveGroup objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newPlace class] isSubclassOfClass:[self.group class]], @"Wrong item class");
    STAssertEqualObjects(newPlace.type, self.group.type, @"Wrong type");
    STAssertEqualObjects(newPlace.groupType, self.group.groupType, @"Wrong groupType");
    STAssertEqualObjects(newPlace.memberCount, self.group.memberCount, @"Wrong memberCount");
    STAssertEquals([newPlace.tags count], [self.group.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newPlace.tags objectAtIndex:0], tag, @"Wrong tag");
    STAssertEqualObjects(newPlace.creator.location, creator.location, @"Wrong creator location");
}

- (void)testPostParsingAlternate {
    JivePerson *creator = [[JivePerson alloc] init];
    NSString *tag = @"concise";
    
    creator.location = @"Restaurant";
    [self.group setValue:creator forKey:@"creator"];
    self.group.groupType = @"PRIVATE";
    [self.group setValue:[NSNumber numberWithInt:102] forKey:@"memberCount"];
    [self.group setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    
    id JSON = [self.group toJSONDictionary];
    JiveGroup *newPlace = [JiveGroup objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newPlace class] isSubclassOfClass:[self.group class]], @"Wrong item class");
    STAssertEqualObjects(newPlace.type, self.group.type, @"Wrong type");
    STAssertEqualObjects(newPlace.groupType, self.group.groupType, @"Wrong groupType");
    STAssertEqualObjects(newPlace.memberCount, self.group.memberCount, @"Wrong memberCount");
    STAssertEquals([newPlace.tags count], [self.group.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newPlace.tags objectAtIndex:0], tag, @"Wrong tag");
    STAssertEqualObjects(newPlace.creator.location, creator.location, @"Wrong creator location");
}

@end
