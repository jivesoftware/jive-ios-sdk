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
    NSString *key = @"type";
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:testType forKey:key];
    SEL selector = @selector(entityClass:);
    
    STAssertEqualObjects([JiveTypedObject performSelector:selector withObject:typeSpecifier],
                         [JiveTypedObject class], @"Out of bounds");
    
    [typeSpecifier setValue:@"Not random" forKey:key];
    STAssertEqualObjects([JiveTypedObject performSelector:selector withObject:typeSpecifier],
                         [JiveTypedObject class], @"Different out of bounds");
}

- (void)testRegisterClassForType {
    NSString *key = @"type";
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:testType forKey:key];
    SEL selector = @selector(entityClass:);
    
    STAssertEqualObjects([JiveTypedObject performSelector:selector withObject:typeSpecifier],
                         [JiveTypedObject class], @"Out of bounds");
    
    STAssertNoThrow([JiveTypedObject registerClass:[DummyTypedObject class] forType:testType], @"registerClass:forType: should not thow");
    STAssertEqualObjects([JiveTypedObject performSelector:selector withObject:typeSpecifier],
                         [DummyTypedObject class], @"Type not registered");
    
    STAssertNoThrow([JiveTypedObject registerClass:nil forType:testType], @"Clearing the type should not throw");
    STAssertEqualObjects([JiveTypedObject performSelector:selector withObject:typeSpecifier],
                         [JiveTypedObject class], @"Type not cleared");
}

- (void)testRegisterClassForTypeAlternate {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:alternateType forKey:@"type"];
    
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [JiveTypedObject class], @"Out of bounds");
    
    STAssertNoThrow([JiveTypedObject registerClass:[DummyTypedObject class] forType:alternateType], @"registerClass:forType: should not thow");
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [DummyTypedObject class], @"Type not registered");
    
    STAssertNoThrow([JiveTypedObject registerClass:nil forType:alternateType], @"Clearing the type should not throw");
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [JiveTypedObject class], @"Type not cleared");
}

@end
