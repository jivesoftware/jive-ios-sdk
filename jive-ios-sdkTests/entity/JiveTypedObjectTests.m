//
//  JiveTypedObjectTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 2/25/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
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
    self.typedObject = [[JiveTypedObject alloc] init];
}

- (void)tearDown {
    self.typedObject = nil;
    [JiveTypedObject registerClass:nil forType:testType];
    [JiveTypedObject registerClass:nil forType:alternateType];
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
