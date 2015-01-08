//
//  JiveFilterTagsRequestOptionsTests.m
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

#import "JiveFilterTagsRequestOptionsTests.h"

@implementation JiveFilterTagsRequestOptionsTests

- (JiveFilterTagsRequestOptions *)tagOptions {
    
    return (JiveFilterTagsRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveFilterTagsRequestOptions alloc] init];
}

- (void)testTags {
    
    [self.tagOptions addTag:@"dm"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=tag(dm)", asString, @"Wrong string contents");
    
    [self.tagOptions addTag:@"mention$"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=tag(dm,mention%24)", asString, @"Wrong string contents");
    
    [self.tagOptions addTag:@"share"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=tag(dm,mention%24,share)", asString, @"Wrong string contents");
}

- (void)testTagWithFields {
    
    [self.tagOptions addTag:@"dm"];
    [self.tagOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=tag(dm)", asString, @"Wrong string contents");
}

@end
