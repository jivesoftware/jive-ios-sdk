//
//  JiveTrendingPeopleRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/28/12.
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

#import "JiveTrendingPeopleRequestOptionsTests.h"

@implementation JiveTrendingPeopleRequestOptionsTests

- (JiveTrendingPeopleRequestOptions *)trendingOptions {
    
    return (JiveTrendingPeopleRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveTrendingPeopleRequestOptions alloc] init];
}

//- (void)tearDown {
//
//    [super tearDown];
//}

- (void)testPlaceURL {
    
    self.trendingOptions.url = [NSURL URLWithString:@"http://dummy"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=place(http://dummy)", asString, @"Wrong string contents");
    
    self.trendingOptions.url = [NSURL URLWithString:@"http://alternate/url"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=place(http://alternate/url)", asString, @"Wrong string contents");
}

- (void)testPlaceURLWithField {
    
    NSString *testField = @"name";
    
    [self.trendingOptions addField:testField];
    self.trendingOptions.url = [NSURL URLWithString:@"http://dummy"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=place(http://dummy)", asString, @"Wrong string contents");
}

@end
