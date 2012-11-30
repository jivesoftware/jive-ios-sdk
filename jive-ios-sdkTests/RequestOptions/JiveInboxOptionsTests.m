//
//  JiveInboxOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
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
    STAssertEqualObjects(@"fields=name&filter=unread,author(/people/1005)", asString, @"Wrong string contents");
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
    STAssertEqualObjects(@"fields=name&filter=author(/people/1005),type(dm)", asString, @"Wrong string contents");
    
    self.inboxOptions.unread = YES;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=unread,author(/people/1005),type(dm)", asString, @"Wrong string contents");
    
    self.inboxOptions.authorID = nil;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=unread,type(dm)", asString, @"Wrong string contents");
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
    STAssertEqualObjects(@"fields=name&filter=author(http://dummy.com/people/54321),type(dm)", asString, @"Wrong string contents");
    
    self.inboxOptions.unread = YES;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=unread,author(http://dummy.com/people/54321),type(dm)", asString, @"Wrong string contents");
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
