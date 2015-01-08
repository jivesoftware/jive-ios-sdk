//
//  JiveReturnFieldsRequestOptionsTests.m
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

#import "JiveReturnFieldsRequestOptionsTests.h"

@implementation JiveReturnFieldsRequestOptionsTests

@synthesize options;

- (void)setUp {
    
    options = [[JiveReturnFieldsRequestOptions alloc] init];
}

- (void)tearDown {
    
    options = nil;
}

- (void)testNoFields {
    
    NSString *asString = [options toQueryString];
    
    STAssertNil(asString, @"Valid string returned");
}

- (void)testSingleField {
    
    NSString *testField = @"name";
    
    [options addField:testField];
    
    NSString *asString = [options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name", asString, @"Wrong string contents");
}

- (void)testMultipleFields {
    
    NSString *testField1 = @"familyName";
    NSString *testField2 = @"givenName";
    NSString *testField3 = @"emails";
    
    [options addField:testField1];
    [options addField:testField2];
    [options addField:testField3];
    
    NSString *asString = [options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=familyName,givenName,emails", asString, @"Wrong string contents");
}

@end
