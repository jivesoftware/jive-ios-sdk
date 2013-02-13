//
//  JiveContentRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/3/12.
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

#import "JiveContentRequestOptionsTests.h"

@implementation JiveContentRequestOptionsTests

- (JiveContentRequestOptions *)contentOptions {
    
    return (JiveContentRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveContentRequestOptions alloc] init];
}

- (void)testAuthorURL {
    
    [self.contentOptions addAuthor:[NSURL URLWithString:@"http://dummy.com/people/1005"]];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"filter=author(http://dummy.com/people/1005)", asString, @"Wrong string contents");
    
    [self.contentOptions addAuthor:[NSURL URLWithString:@"http://dummy.com/people/54321"]];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"filter=author(http://dummy.com/people/1005,http://dummy.com/people/54321)", asString, @"Wrong string contents");
}

- (void)testAuthorURLWithOtherOptions {
    
    [self.contentOptions addAuthor:[NSURL URLWithString:@"http://dummy.com/people/54321"]];
    [self.contentOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&filter=author(http://dummy.com/people/54321)", asString, @"Wrong string contents");
    
    [self.contentOptions addType:@"dm"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=type(dm)&filter=author(http://dummy.com/people/54321)", asString, @"Wrong string contents");
    
    [self.contentOptions addEntityType:@"37" descriptor:@"2345"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=type(dm)&filter=entityDescriptor(37,2345)&filter=author(http://dummy.com/people/54321)", asString, @"Wrong string contents");
}

- (void)testPlace {
    
    self.contentOptions.place = [NSURL URLWithString:@"http://dummy.com/people/1005"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"filter=place(http://dummy.com/people/1005)", asString, @"Wrong string contents");
    
    self.contentOptions.place = [NSURL URLWithString:@"http://dummy.com/people/54321"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"filter=place(http://dummy.com/people/54321)", asString, @"Wrong string contents");
}

- (void)testPlaceWithOtherOptions {
    
    self.contentOptions.place = [NSURL URLWithString:@"http://dummy.com/people/1005"];
    [self.contentOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&filter=place(http://dummy.com/people/1005)", asString, @"Wrong string contents");
    
    [self.contentOptions addType:@"dm"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=type(dm)&filter=place(http://dummy.com/people/1005)", asString, @"Wrong string contents");
    
    [self.contentOptions addAuthor:[NSURL URLWithString:@"http://dummy.com/people/54321"]];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=type(dm)&filter=author(http://dummy.com/people/54321)&filter=place(http://dummy.com/people/1005)", asString, @"Wrong string contents");
    
    [self.contentOptions addEntityType:@"37" descriptor:@"2345"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=type(dm)&filter=entityDescriptor(37,2345)&filter=author(http://dummy.com/people/54321)&filter=place(http://dummy.com/people/1005)", asString, @"Wrong string contents");
}

@end
