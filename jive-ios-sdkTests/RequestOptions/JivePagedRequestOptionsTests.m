//
//  JivePagedRequestOptionsTests.m
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

#import "JivePagedRequestOptionsTests.h"

@implementation JivePagedRequestOptionsTests

- (JivePagedRequestOptions *)pagedOptions {
    
    return (JivePagedRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JivePagedRequestOptions alloc] init];
}

- (void)testStartIndex {
    
    int value = 5;
    
    self.pagedOptions.startIndex = value;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"startIndex=5", asString, @"Wrong string contents");
    
    value = 7;
    self.pagedOptions.startIndex = value;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"startIndex=7", asString, @"Wrong string contents");
}

- (void)testStartIndexWithField {
    
    int value = 5;
    NSString *testField = @"name";
    
    [self.pageOptions addField:testField];
    self.pagedOptions.startIndex = value;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&startIndex=5", asString, @"Wrong string contents");
}


@end
