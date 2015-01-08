//
//  JiveAssociationsRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/7/13.
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

#import "JiveAssociationsRequestOptionsTests.h"

@implementation JiveAssociationsRequestOptionsTests

- (JiveAssociationsRequestOptions *)associationsOptions {
    
    return (JiveAssociationsRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveAssociationsRequestOptions alloc] init];
}

- (void)testTags {
    
    [self.associationsOptions addType:@"dm"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(asString, @"filter=type(dm)", @"Wrong string contents");
    
    [self.associationsOptions addType:@"mention"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(asString, @"filter=type(dm,mention)", @"Wrong string contents");
    
    [self.associationsOptions addType:@"share"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(asString, @"filter=type(dm,mention,share)", @"Wrong string contents");
}

- (void)testTagWithFields {
    
    [self.associationsOptions addType:@"dm"];
    [self.associationsOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(asString, @"fields=name&filter=type(dm)", @"Wrong string contents");
    
    self.associationsOptions.startIndex = 5;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(asString, @"fields=name&startIndex=5&filter=type(dm)", @"Wrong string contents");
}

@end
