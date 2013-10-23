//
//  JiveObjectTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/2/13.
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

#import "JiveObjectTests.h"
#import "JiveObject_internal.h"

@interface TestJiveObject : JiveObject

@property (nonatomic, strong) NSString *testProperty;

@end

@implementation TestJiveObject

@synthesize testProperty;

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    dictionary[@"testProperty"] = self.testProperty;
    
    return dictionary;
}

@end

@implementation JiveObjectTests

- (void)testDeserialize_emptyJSON {
    JiveObject *target = [TestJiveObject new];
    NSDictionary *JSON = @{};
    
    STAssertFalse([target deserialize:JSON], @"Reported valid deserialize with empty JSON");
    STAssertFalse(target.extraFieldsDetected, @"Reported extra fields with empty JSON");
    STAssertNil(target.refreshDate, @"Invalid refresh date entered for empty JSON");
}

- (void)testDeserialize_invalidJSON {
    JiveObject *target = [TestJiveObject new];
    NSDictionary *JSON = @{@"dummy key":@"bad value"};
    
    STAssertFalse([target deserialize:JSON], @"Reported valid deserialize with wrong JSON");
    STAssertTrue(target.extraFieldsDetected, @"No extra fields reported with wrong JSON");
    STAssertNil(target.refreshDate, @"Invalid refresh date entered for empty JSON");
}

- (void)testDeserialize_validJSON {
    JiveObject *target = [TestJiveObject new];
    NSString *testValue = @"test value";
    NSString *propertyID = @"testProperty";
    NSDictionary *JSON = @{propertyID:testValue};
    NSDate *testDate = [NSDate date];
    
    STAssertTrue([target deserialize:JSON], @"Reported invalid deserialize with valid JSON");
    STAssertFalse(target.extraFieldsDetected, @"Extra fields reported with valid JSON");
    STAssertNotNil(target.refreshDate, @"A refresh date is reqired with valid JSON");
    STAssertEqualsWithAccuracy([testDate timeIntervalSinceDate:target.refreshDate],
                               (NSTimeInterval)0,
                               (NSTimeInterval)0.1,
                               @"An invalid refresh date was specified");
}

@end
