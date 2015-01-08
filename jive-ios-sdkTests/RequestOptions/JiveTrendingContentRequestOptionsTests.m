//
//  JiveTrendingContentRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/30/12.
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

#import "JiveTrendingContentRequestOptionsTests.h"

@implementation JiveTrendingContentRequestOptionsTests

- (JiveTrendingContentRequestOptions *)contentOptions {
    
    return (JiveTrendingContentRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveTrendingContentRequestOptions alloc] init];
}

//- (void)tearDown {
//
//    [super tearDown];
//}

- (void)testType {
    
    [self.contentOptions addType:@"document"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=type(document)", asString, @"Wrong string contents");
    
    [self.contentOptions addType:@"discussion"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=type(document,discussion)", asString, @"Wrong string contents");
}

- (void)testTypeWithField {
    
    NSString *testField = @"name";
    
    [self.contentOptions addField:testField];
    [self.contentOptions addType:@"document"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=type(document)", asString, @"Wrong string contents");
    
    self.contentOptions.url = [NSURL URLWithString:@"http://dummy"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=place(http://dummy)&filter=type(document)", asString, @"Wrong string contents");
}

@end
