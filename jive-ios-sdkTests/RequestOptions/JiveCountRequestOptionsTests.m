//
//  JiveCountRequestOptionsTests.m
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

#import "JiveCountRequestOptionsTests.h"

@implementation JiveCountRequestOptionsTests

- (JiveCountRequestOptions *)pageOptions {
    
    return (JiveCountRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveCountRequestOptions alloc] init];
}

//- (void)tearDown {
//
//    [super tearDown];
//}

- (void)testCount {
    
    int value = 5;
    
    self.pageOptions.count = value;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"count=5", asString, @"Wrong string contents");
    
    value = 7;
    self.pageOptions.count = value;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"count=7", asString, @"Wrong string contents");
}

- (void)testCountWithField {
    
    int value = 5;
    NSString *testField = @"name";
    
    [self.pageOptions addField:testField];
    self.pageOptions.count = value;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&count=5", asString, @"Wrong string contents");
}

@end
