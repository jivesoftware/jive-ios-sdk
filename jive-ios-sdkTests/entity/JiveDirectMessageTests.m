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

- (void)initializeDirectMessage {
    JivePerson *participant = [JivePerson new];
    
    participant.status = @"Doing fine";
    [participant setValue:@"name" forKeyPath:JivePersonAttributes.displayName];
    [self.dm setValue:@[participant] forKey:JiveDirectMessageAttributes.participants];
    [self.dm setValue:@"dm" forKeyPath:JiveDirectMessageAttributes.typeActual];
}

- (void)testDirectMessageToJSON {
    NSDictionary *JSON = [self.dm toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    [self initializeDirectMessage];
    
    JSON = [self.dm toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.dm.type, @"Wrong type");
}

- (void)testToJSON_participants {
    JivePerson *participant1 = [JivePerson new];
    JivePerson *participant2 = [JivePerson new];
    
    participant1.status = @"document";
    participant2.status = @"question";
    [self.dm setValue:[NSArray arrayWithObject:participant1] forKey:JiveDirectMessageAttributes.participants];
    
    NSDictionary *JSON = [self.dm persistentJSON];
    
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
    
    JSON = [self.dm persistentJSON];
    
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
    [self initializeDirectMessage];
    
    id JSON = [self.dm persistentJSON];
    JiveDirectMessage *newContent = [JiveDirectMessage objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.dm class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.dm.type, @"Wrong type");
    STAssertEqualObjects(newContent.typeActual, self.dm.typeActual, @"Wrong typeActual");
    STAssertEquals([newContent.participants count], [self.dm.participants count], @"Wrong number of participant objects");
    if ([newContent.participants count] > 0) {
        JivePerson *convertedObject = newContent.participants[0];
        JivePerson *participant = self.dm.participants[0];
        
        STAssertEquals([convertedObject class], [JivePerson class], @"Wrong participant object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]]) {
            STAssertEqualObjects(convertedObject.status, participant.status, @"Wrong participant status");
            STAssertEqualObjects(convertedObject.displayName, participant.displayName, @"Wrong participant displayName");
        }
    }
}

- (void)testDirectMessageParsingAlternate {
    JivePerson *participant = [JivePerson new];
    
    participant.status = @"Twisting and Turning";
    [participant setValue:@"Shout" forKeyPath:JivePersonAttributes.displayName];
    [self.dm setValue:@[participant] forKey:JiveDirectMessageAttributes.participants];
    [self.dm setValue:@"document" forKeyPath:JiveDirectMessageAttributes.typeActual];
    
    id JSON = [self.dm persistentJSON];
    JiveDirectMessage *newContent = [JiveDirectMessage objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.dm class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.dm.type, @"Wrong type");
    STAssertEqualObjects(newContent.typeActual, self.dm.typeActual, @"Wrong typeActual");
    STAssertEquals([newContent.participants count], [self.dm.participants count], @"Wrong number of participant objects");
    if ([newContent.participants count] > 0) {
        JivePerson *convertedObject = newContent.participants[0];
        
        STAssertEquals([convertedObject class], [JivePerson class], @"Wrong participant object class");
        if ([[convertedObject class] isSubclassOfClass:[JivePerson class]]) {
            STAssertEqualObjects(convertedObject.status, participant.status, @"Wrong participant status");
            STAssertEqualObjects(convertedObject.displayName, participant.displayName, @"Wrong participant displayName");
        }
    }
}

@end
