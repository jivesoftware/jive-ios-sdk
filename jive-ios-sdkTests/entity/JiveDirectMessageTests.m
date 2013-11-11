//
//  JiveDirectMessageTests.m
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

#import "JiveDirectMessageTests.h"

@implementation JiveDirectMessageTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveDirectMessage alloc] init];
}

- (JiveDirectMessage *)dm {
    return (JiveDirectMessage *)self.content;
}

- (void)testType {
    STAssertEqualObjects(self.dm.type, @"dm", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.dm.type forKey:@"type"];
    
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.dm class], @"Dm class not registered with JiveTypedObject.");
    STAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.dm class], @"Dm class not registered with JiveContent.");
}

- (void)testPostToJSON {
    NSDictionary *JSON = [self.dm toJSONDictionary];
    NSString *tag1 = @"big";
    NSString *tag2 = @"stuff";
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    self.dm.tags = [NSArray arrayWithObjects:tag1, tag2, nil];
    
    JSON = [self.dm toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.dm.type, @"Wrong type");
    
    NSArray *categoriesJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[categoriesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([categoriesJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([categoriesJSON objectAtIndex:0], tag1, @"Wrong value");
    STAssertEqualObjects([categoriesJSON objectAtIndex:1], tag2, @"Wrong value");
}

- (void)testToJSON_participants {
    JivePerson *participant1 = [JivePerson new];
    JivePerson *participant2 = [JivePerson new];
    
    participant1.status = @"document";
    participant2.status = @"question";
    [self.dm setValue:[NSArray arrayWithObject:participant1] forKey:JiveDirectMessageAttributes.participants];
    
    NSDictionary *JSON = [self.dm toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.dm.type, @"Wrong type");
    
    NSArray *array = [JSON objectForKey:JiveDirectMessageAttributes.participants];
    id object1 = [array objectAtIndex:0];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"participants array not converted");
    STAssertEquals([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"attachment object not converted");
    STAssertEqualObjects([object1 objectForKey:@"status"], participant1.status, @"Wrong value");
    
    [self.dm setValue:[self.dm.participants arrayByAddingObject:participant2] forKey:JiveDirectMessageAttributes.participants];
    
    JSON = [self.dm toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.dm.type, @"Wrong type");
    
    array = [JSON objectForKey:JiveDirectMessageAttributes.participants];
    object1 = [array objectAtIndex:0];
    
    id object2 = [array objectAtIndex:1];
    
    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"participants array not converted");
    STAssertEquals([array count], (NSUInteger)2, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"attachment 1 object not converted");
    STAssertEqualObjects([object1 objectForKey:@"status"], participant1.status, @"Wrong value 1");
    STAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"attachment 2 object not converted");
    STAssertEqualObjects([object2 objectForKey:@"status"], participant2.status, @"Wrong value 2");
}

- (void)testDirectMessageParsing {
    JivePerson *participant = [JivePerson new];
    NSString *tag = @"wordy";
    
    participant.status = @"Doing fine";
    [self.dm setValue:[NSArray arrayWithObject:participant] forKey:JiveDirectMessageAttributes.participants];
    [self.dm setValue:[NSArray arrayWithObject:tag] forKey:JiveDirectMessageAttributes.tags];
    [self.dm setValue:[NSNumber numberWithBool:YES] forKey:JiveDirectMessageAttributes.visibleToExternalContributors];
    
    id JSON = [self.dm toJSONDictionary];
    JiveDirectMessage *newContent = [JiveDirectMessage objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.dm class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.dm.type, @"Wrong type");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.dm.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.tags count], [self.dm.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
    STAssertEquals([newContent.participants count], [self.dm.participants count], @"Wrong number of participant objects");
    if ([newContent.participants count] > 0) {
        id convertedObject = [newContent.participants objectAtIndex:0];
        STAssertEquals([convertedObject class], [JivePerson class], @"Wrong participant object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            STAssertEqualObjects([(JivePerson *)convertedObject status], participant.status, @"Wrong participant object");
    }
}

- (void)testDirectMessageParsingAlternate {
    JivePerson *participant = [JivePerson new];
    NSString *tag = @"concise";
    
    participant.status = @"Twisting and Turning";
    [self.dm setValue:[NSArray arrayWithObject:participant] forKey:JiveDirectMessageAttributes.participants];
    [self.dm setValue:[NSArray arrayWithObject:tag] forKey:JiveDirectMessageAttributes.tags];
    
    id JSON = [self.dm toJSONDictionary];
    JiveDirectMessage *newContent = [JiveDirectMessage objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.dm class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.dm.type, @"Wrong type");
    STAssertEqualObjects(newContent.visibleToExternalContributors, self.dm.visibleToExternalContributors, @"Wrong visibleToExternalContributors");
    STAssertEquals([newContent.tags count], [self.dm.tags count], @"Wrong number of tags");
    STAssertEqualObjects([newContent.tags objectAtIndex:0], tag, @"Wrong tag");
    STAssertEquals([newContent.participants count], [self.dm.participants count], @"Wrong number of participant objects");
    if ([newContent.participants count] > 0) {
        id convertedObject = [newContent.participants objectAtIndex:0];
        STAssertEquals([convertedObject class], [JivePerson class], @"Wrong participant object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]])
            STAssertEqualObjects([(JivePerson *)convertedObject status], participant.status, @"Wrong participant object");
    }
}

@end
