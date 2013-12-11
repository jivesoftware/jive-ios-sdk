//
//  JiveTypedObjectTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 2/25/13.
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

#import "JiveTypedObjectTests.h"
#import "Jive_internal.h"

@interface DummyTypedObject : JiveTypedObject

@end

@implementation DummyTypedObject

@end

@implementation JiveTypedObjectTests

static NSString *testType = @"test";
static NSString *alternateType = @"alternate";

- (void)setUp {
    [super setUp];
    self.object = [[JiveTypedObject alloc] init];
}

- (void)tearDown {
    [super tearDown];
    [JiveTypedObject registerClass:nil forType:testType];
    [JiveTypedObject registerClass:nil forType:alternateType];
}

- (JiveTypedObject *)typedObject {
    return (JiveTypedObject *)self.object;
}

- (void)testEntityClass {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:testType
                                                                            forKey:JiveTypedObjectAttributes.type];
    Class testClass = [self.typedObject class];
    
    STAssertEqualObjects([testClass entityClass:typeSpecifier], testClass, @"Out of bounds");
    
    [typeSpecifier setValue:@"Not random" forKey:JiveTypedObjectAttributes.type];
    STAssertEqualObjects([testClass entityClass:typeSpecifier], testClass,
                         @"Different out of bounds");
}

- (void)testRegisterClassForType {
    NSDictionary *typeSpecifier = @{JiveTypedObjectAttributes.type:testType};
    Class testClass = [self.typedObject class];
    Class alternateClass = [DummyTypedObject class];
    
    STAssertEqualObjects([testClass entityClass:typeSpecifier],
                         testClass, @"Out of bounds");
    
    STAssertNoThrow([testClass registerClass:alternateClass forType:testType],
                    @"registerClass:forType: should not thow");
    STAssertEqualObjects([testClass entityClass:typeSpecifier], alternateClass,
                         @"Type not registered");
    
    STAssertNoThrow([testClass registerClass:nil forType:testType],
                    @"Clearing the type should not throw");
    STAssertEqualObjects([testClass entityClass:typeSpecifier],
                         testClass, @"Type not cleared");
}

- (void)testRegisterClassForTypeAlternate {
    NSDictionary *typeSpecifier = @{JiveTypedObjectAttributes.type:alternateType};
    Class testClass = [self.typedObject class];
    Class alternateClass = [DummyTypedObject class];
    
    STAssertEqualObjects([testClass entityClass:typeSpecifier], testClass, @"Out of bounds");
    
    STAssertNoThrow([testClass registerClass:alternateClass forType:alternateType],
                    @"registerClass:forType: should not thow");
    STAssertEqualObjects([testClass entityClass:typeSpecifier], alternateClass,
                         @"Type not registered");
    
    STAssertNoThrow([testClass registerClass:nil forType:alternateType],
                    @"Clearing the type should not throw");
    STAssertEqualObjects([testClass entityClass:typeSpecifier], testClass, @"Type not cleared");
}

- (void)testSelfReferenceParsedBeforeAnythingElse {
    JiveResourceEntry *selfResource = [JiveResourceEntry new];
    JiveResourceEntry *altResource = [JiveResourceEntry new];
    NSString *expectedURL = @"https://hopback.eng.jiveland.com/";
    
    [selfResource setValue:[NSURL URLWithString:[expectedURL stringByAppendingString:@"api/core/v3/person/321"]]
                    forKey:JiveResourceEntryAttributes.ref];
    [selfResource setValue:@[@"GET", @"PUT"]
                    forKey:JiveResourceEntryAttributes.allowed];
    [altResource setValue:[NSURL URLWithString:@"http://brewspace.com/api/core/v3/person/321"]
                   forKey:JiveResourceEntryAttributes.ref];
    [altResource setValue:@[@"GET", @"DELETE"]
                   forKey:JiveResourceEntryAttributes.allowed];
    self.instance.badInstanceURL = nil;
    
    id selfJSON = selfResource.persistentJSON;
    id altJSON = altResource.persistentJSON;
    NSDictionary *firstResourceJSON = @{JiveTypedObjectResourceTags.selfResourceTag:selfJSON,
                                        @"alt":altJSON};
    NSDictionary *firstJSON = @{JiveTypedObjectAttributesHidden.resources:firstResourceJSON};
    
    [[self.object class] objectFromJSON:firstJSON withInstance:self.instance];
    STAssertEqualObjects(self.instance.badInstanceURL, expectedURL, @"SelfRef was not parsed first.");
    
    self.instance.badInstanceURL = nil;
    
    NSDictionary *secondResourceJSON = @{@"alt":altJSON,
                                         JiveTypedObjectResourceTags.selfResourceTag:selfJSON};
    NSDictionary *secondJSON = @{JiveTypedObjectAttributesHidden.resources:secondResourceJSON};
    
    [[self.object class] objectFromJSON:secondJSON withInstance:self.instance];
    STAssertEqualObjects(self.instance.badInstanceURL, expectedURL, @"SelfRef was not parsed first.");
}

@end
