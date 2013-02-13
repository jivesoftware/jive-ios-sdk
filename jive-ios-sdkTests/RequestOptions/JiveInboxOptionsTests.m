//
//  JiveInboxOptionsTests.m
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

#import "JiveInboxOptionsTests.h"

@implementation JiveInboxOptionsTests

- (JiveInboxOptions *)inboxOptions {
    
    return (JiveInboxOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveInboxOptions alloc] init];
}

//- (void)tearDown {
//
//    [super tearDown];
//}

- (void)testUnread {
    
    self.inboxOptions.unread = NO;
    STAssertFalse(self.inboxOptions.unread, @"Wrong default value");
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNil(asString, @"Invalid string returned");
    
    self.inboxOptions.unread = YES;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=unread", asString, @"Wrong string contents");
}

- (void)testUnreadWithField {
    
    self.inboxOptions.unread = YES;
    [self.inboxOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=unread", asString, @"Wrong string contents");
}

- (void)testAuthorID {
    
    self.inboxOptions.authorID = @"1005";

    NSString *asString = [self.options toQueryString];

    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=author(/people/1005)", asString, @"Wrong string contents");

    self.inboxOptions.authorID = @"54321";
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=author(/people/54321)", asString, @"Wrong string contents");
}

- (void)testAuthorIDWithOtherOptions {
    
    self.inboxOptions.authorID = @"1005";
    [self.inboxOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=author(/people/1005)", asString, @"Wrong string contents");

    self.inboxOptions.unread = YES;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=unread&filter=author(/people/1005)", asString, @"Wrong string contents");
}

- (void)testType {
    
    [self.inboxOptions addType:@"dm"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=type(dm)", asString, @"Wrong string contents");
    
    [self.inboxOptions addType:@"mention"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=type(dm,mention)", asString, @"Wrong string contents");
    
    [self.inboxOptions addType:@"share"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=type(dm,mention,share)", asString, @"Wrong string contents");
}

- (void)testTypeWithOtherOptions {
    
    [self.inboxOptions addType:@"dm"];
    [self.inboxOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=type(dm)", asString, @"Wrong string contents");
    
    self.inboxOptions.authorID = @"1005";
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=author(/people/1005)&filter=type(dm)", asString, @"Wrong string contents");
    
    self.inboxOptions.unread = YES;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=unread&filter=author(/people/1005)&filter=type(dm)", asString, @"Wrong string contents");
    
    self.inboxOptions.authorID = nil;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=unread&filter=type(dm)", asString, @"Wrong string contents");
}

- (void)testAuthorURL {
    
    self.inboxOptions.authorURL = [NSURL URLWithString:@"http://dummy.com/people/1005"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=author(http://dummy.com/people/1005)", asString, @"Wrong string contents");
    
    self.inboxOptions.authorURL = [NSURL URLWithString:@"http://dummy.com/people/54321"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=author(http://dummy.com/people/54321)", asString, @"Wrong string contents");
}

- (void)testAuthorURLWithOtherOptions {
    
    self.inboxOptions.authorURL = [NSURL URLWithString:@"http://dummy.com/people/54321"];
    [self.inboxOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=author(http://dummy.com/people/54321)", asString, @"Wrong string contents");
    
    [self.inboxOptions addType:@"dm"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=author(http://dummy.com/people/54321)&filter=type(dm)", asString, @"Wrong string contents");
    
    self.inboxOptions.unread = YES;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=unread&filter=author(http://dummy.com/people/54321)&filter=type(dm)", asString, @"Wrong string contents");
}

- (void)testAuthorURLIgnoredWithAuthorID {
    
    self.inboxOptions.authorURL = [NSURL URLWithString:@"http://dummy.com/people/1005"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=author(http://dummy.com/people/1005)", asString, @"Wrong string contents");
    
    self.inboxOptions.authorID = @"54321";
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=author(/people/54321)", asString, @"Wrong string contents");
}

@end
