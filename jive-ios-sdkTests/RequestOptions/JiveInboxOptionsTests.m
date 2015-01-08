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
#import "JiveDirectMessage.h"
#import "JiveShare.h"
#import "JiveDiscussion.h"


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
    
    [self.inboxOptions addType:JiveDirectMessageType];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=type(dm)", asString, @"Wrong string contents");
    
    [self.inboxOptions addType:@"mention"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=type(dm,mention)", asString, @"Wrong string contents");
    
    [self.inboxOptions addType:JiveShareType];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=type(dm,mention,share)", asString, @"Wrong string contents");
    
    [self.inboxOptions addType:JiveDirectMessageType];
    [self.inboxOptions addType:JiveShareType];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=type(dm,mention,share)", asString, @"Wrong string contents");
    
    [self.inboxOptions addType:nil];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=type(dm,mention,share)", asString, @"Wrong string contents");
    
    self.inboxOptions.types = @[JiveDiscussionType];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=type(discussion)", asString, @"Wrong string contents");
}

- (void)testTypeWithOtherOptions {
    
    [self.inboxOptions addType:JiveDirectMessageType];
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
    
    [self.inboxOptions addType:JiveDirectMessageType];
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

- (void)testCollapse {
    
    self.inboxOptions.collapse = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, nil);
    STAssertEqualObjects(@"collapse=true", asString, nil);
}

- (void)testCollapseWithOtherOptions {
    
    self.inboxOptions.collapse = YES;
    [self.inboxOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, nil);
    STAssertEqualObjects(@"fields=name&collapse=true", asString, nil);
    
    self.inboxOptions.authorURL = [NSURL URLWithString:@"http://dummy.com/people/54321"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, nil);
    STAssertEqualObjects(@"fields=name&collapse=true&filter=author(http://dummy.com/people/54321)",
                         asString, nil);
    
    [self.inboxOptions addType:JiveDirectMessageType];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, nil);
    STAssertEqualObjects(@"fields=name&collapse=true&filter=author(http://dummy.com/people/54321)&filter=type(dm)",
                         asString, nil);
    
    self.inboxOptions.unread = YES;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, nil);
    STAssertEqualObjects(@"fields=name&collapse=true&filter=unread&filter=author(http://dummy.com/people/54321)&filter=type(dm)",
                         asString, nil);
}

- (void)testOldestUnread {
    
    self.inboxOptions.oldestUnread = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, nil);
    STAssertEqualObjects(@"oldestUnread=true", asString, nil);
}

- (void)testOldestUnreadWithOtherOptions {
    
    self.inboxOptions.oldestUnread = YES;
    [self.inboxOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, nil);
    STAssertEqualObjects(@"fields=name&oldestUnread=true", asString, nil);
    
    self.inboxOptions.collapse = YES;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, nil);
    STAssertEqualObjects(@"fields=name&collapse=true&oldestUnread=true", asString, nil);
    
    self.inboxOptions.authorURL = [NSURL URLWithString:@"http://dummy.com/people/54321"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, nil);
    STAssertEqualObjects(@"fields=name&collapse=true&filter=author(http://dummy.com/people/54321)&oldestUnread=true",
                         asString, nil);
}

- (void)testDirectives {
    
    [self.inboxOptions addDirective:nil];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNil(asString, nil);
    
    [self.inboxOptions addDirective:JiveInboxOptionsDirectives.include_rtc];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, nil);
    STAssertEqualObjects(@"directive=include_rtc", asString, nil);
    
    [self.inboxOptions addDirective:@"test_directive"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, nil);
    STAssertEqualObjects(@"directive=include_rtc,test_directive", asString, nil);
    
    [self.inboxOptions addDirective:JiveInboxOptionsDirectives.include_rtc];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, nil);
    STAssertEqualObjects(@"directive=include_rtc,test_directive", asString, nil);
    
    self.inboxOptions.directives = @[@"alternate"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, nil);
    STAssertEqualObjects(@"directive=alternate", asString, nil);
}

- (void)testDirectivesWithOtherOptions {
    
    [self.inboxOptions addDirective:JiveInboxOptionsDirectives.include_rtc];
    [self.inboxOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, nil);
    STAssertEqualObjects(@"fields=name&directive=include_rtc", asString, nil);
    
    self.inboxOptions.oldestUnread = YES;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, nil);
    STAssertEqualObjects(@"fields=name&directive=include_rtc&oldestUnread=true", asString, nil);
    
    self.inboxOptions.collapse = YES;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, nil);
    STAssertEqualObjects(@"fields=name&collapse=true&directive=include_rtc&oldestUnread=true",
                         asString, nil);
    
    self.inboxOptions.authorURL = [NSURL URLWithString:@"http://dummy.com/people/54321"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, nil);
    STAssertEqualObjects(@"fields=name&collapse=true&filter=author(http://dummy.com/people/54321)&directive=include_rtc&oldestUnread=true",
                         asString, nil);
}

- (void)testCollapseSkip {
    NSString *firstCollectionID = @"10101";
    NSString *secondCollectionID = @"202345";
    
    [self.inboxOptions addCollectionID:firstCollectionID];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, nil);
    STAssertEqualObjects(@"directive=collapseSkip(10101)", asString, nil);
    STAssertNil(self.inboxOptions.directives, @"Don't change the directives when adding a collection id.");
    
    [self.inboxOptions addCollectionID:secondCollectionID];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, nil);
    STAssertEqualObjects(@"directive=collapseSkip(10101,202345)", asString, nil);
    STAssertNil(self.inboxOptions.directives, @"Don't change the directives when adding a collection id.");
    
    [self.inboxOptions addCollectionID:firstCollectionID];
    [self.inboxOptions addCollectionID:secondCollectionID];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, nil);
    STAssertEqualObjects(@"directive=collapseSkip(10101,202345)", asString, nil);
    
    [self.inboxOptions addCollectionID:nil];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, nil);
    STAssertEqualObjects(@"directive=collapseSkip(10101,202345)", asString, nil);
    
    self.inboxOptions.collapseSkipCollectionIDs = @[secondCollectionID];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, nil);
    STAssertEqualObjects(@"directive=collapseSkip(202345)", asString, nil);
    
    [self.inboxOptions addDirective:JiveInboxOptionsDirectives.include_rtc];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, nil);
    STAssertEqualObjects(@"directive=include_rtc,collapseSkip(202345)", asString, nil);
    STAssertEqualObjects(self.inboxOptions.directives, @[JiveInboxOptionsDirectives.include_rtc], nil);
}

@end
