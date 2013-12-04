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

@end
