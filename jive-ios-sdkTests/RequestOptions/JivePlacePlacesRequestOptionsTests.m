//
//  JivePlacePlacesRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/29/12.
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

#import "JivePlacePlacesRequestOptionsTests.h"

@implementation JivePlacePlacesRequestOptionsTests

- (JivePlacePlacesRequestOptions *)placePlacesOptions {
    
    return (JivePlacePlacesRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JivePlacePlacesRequestOptions alloc] init];
}

- (void)testTypes {
    
    [self.placePlacesOptions addType:@"dm"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=type(dm)", asString, @"Wrong string contents");
    
    [self.placePlacesOptions addType:@"mention"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=type(dm,mention)", asString, @"Wrong string contents");
    
    [self.placePlacesOptions addType:@"share"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=type(dm,mention,share)", asString, @"Wrong string contents");
}

- (void)testTypeWithFields {
    
    [self.placePlacesOptions addType:@"dm"];
    [self.placePlacesOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=type(dm)", asString, @"Wrong string contents");

    [self.placePlacesOptions addTag:@"share"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=tag(share)&filter=type(dm)", asString, @"Wrong string contents");
}

- (void)testSearch {
    
    [self.placePlacesOptions addSearchTerm:@"dm"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=search(dm)", asString, @"Wrong string contents");
    
    [self.placePlacesOptions addSearchTerm:@"mention"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=search(dm,mention)", asString, @"Wrong string contents");
    
    [self.placePlacesOptions addSearchTerm:@"(sh,a\\re)"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=search(dm,mention,\\(sh\\,a\\\\re\\))", asString, @"Wrong string contents");
    
    [self.placePlacesOptions addSearchTerm:@"h)e(j,m"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=search(dm,mention,\\(sh\\,a\\\\re\\),h\\)e\\(j\\,m)", asString, @"Wrong string contents");
}

- (void)testSearchWithFields {
    
    [self.placePlacesOptions addSearchTerm:@"dm"];
    [self.placePlacesOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=search(dm)", asString, @"Wrong string contents");
    
    [self.placePlacesOptions addTag:@"share"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=tag(share)&filter=search(dm)", asString, @"Wrong string contents");
    
    [self.placePlacesOptions addType:@"share"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=tag(share)&filter=type(share)&filter=search(dm)", asString, @"Wrong string contents");
}

@end
