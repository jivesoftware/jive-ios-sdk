//
//  JiveDateLimitedRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
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

#import "JiveDateLimitedRequestOptionsTests.h"
#import "JiveObject.h"

@implementation JiveDateLimitedRequestOptionsTests

- (JiveDateLimitedRequestOptions *)dateOptions {
    
    return (JiveDateLimitedRequestOptions *)self.options;
}

- (void)setUp {
    [super setUp];
    
    self.options = [[JiveDateLimitedRequestOptions alloc] init];
}

- (void)testAfter {
    
    NSDate *testDate = [NSDate dateWithTimeIntervalSince1970:0];
    
    self.dateOptions.after = testDate;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"after=1970-01-01T00%3A00%3A00.000%2B0000", asString, @"Wrong string contents");
    
    testDate = [NSDate dateWithTimeIntervalSince1970:1000.123];
    self.dateOptions.after = testDate;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"after=1970-01-01T00%3A16%3A40.123%2B0000", asString, @"Wrong string contents");
}

- (void)testAfterWithField {
    
    NSString *testField = @"name";
    NSDate *testDate = [NSDate dateWithTimeIntervalSince1970:0];
    
    self.dateOptions.after = testDate;
    [self.dateOptions addField:testField];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&after=1970-01-01T00%3A00%3A00.000%2B0000", asString, @"Wrong string contents");
}

- (void)testBefore {
    
    NSDate *testDate = [NSDate dateWithTimeIntervalSince1970:0];
    
    self.dateOptions.before = testDate;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"before=1970-01-01T00%3A00%3A00.000%2B0000", asString, @"Wrong string contents");
    
    testDate = [NSDate dateWithTimeIntervalSince1970:1000.123];
    self.dateOptions.before = testDate;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"before=1970-01-01T00%3A16%3A40.123%2B0000", asString, @"Wrong string contents");
}

- (void)testBeforeWithField {
    
    NSString *testField = @"name";
    NSDate *testDate = [NSDate dateWithTimeIntervalSince1970:0];
    
    self.dateOptions.before = testDate;
    [self.dateOptions addField:testField];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&before=1970-01-01T00%3A00%3A00.000%2B0000", asString, @"Wrong string contents");
}

- (void)testBeforeAndAfter {
    
    NSString *testField = @"name";
    NSDate *testAfter = [NSDate dateWithTimeIntervalSince1970:0];
    NSDate *testBefore = [NSDate dateWithTimeIntervalSince1970:1000];
    
    self.dateOptions.after = testAfter;
    self.dateOptions.before = testBefore;
    [self.dateOptions addField:testField];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&after=1970-01-01T00%3A00%3A00.000%2B0000", asString, @"Wrong string contents");
}

- (void)testCollapse {
    NSString *testField = @"name";
    NSDate *testAfter = [NSDate dateWithTimeIntervalSince1970:0];
    NSDate *testBefore = [NSDate dateWithTimeIntervalSince1970:1000];
    
    self.dateOptions.after = testAfter;
    self.dateOptions.before = testBefore;
    self.dateOptions.collapse = YES;
    [self.dateOptions addField:testField];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&collapse=true&after=1970-01-01T00%3A00%3A00.000%2B0000", asString, @"Wrong string contents");
}

@end
