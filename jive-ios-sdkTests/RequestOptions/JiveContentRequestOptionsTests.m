//
//  JiveContentRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/3/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
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
}

- (void)testEntityDescriptor {
    
    [self.contentOptions addEntityType:@"102" descriptor:@"1234"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"filter=entityDescriptor(102,1234)", asString, @"Wrong string contents");

    [self.contentOptions addEntityType:@"37" descriptor:@"2345"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"filter=entityDescriptor(102,1234,37,2345)", asString, @"Wrong string contents");
}

- (void)testEntityDescriptorWithOtherOptions {
    
    [self.contentOptions addEntityType:@"37" descriptor:@"2345"];
    [self.contentOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&filter=entityDescriptor(37,2345)", asString, @"Wrong string contents");
    
    [self.contentOptions addType:@"dm"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=type(dm)&filter=entityDescriptor(37,2345)", asString, @"Wrong string contents");
    
    [self.contentOptions addAuthor:[NSURL URLWithString:@"http://dummy.com/people/54321"]];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=type(dm)&filter=author(http://dummy.com/people/54321)&filter=entityDescriptor(37,2345)", asString, @"Wrong string contents");
    
    self.contentOptions.place = [NSURL URLWithString:@"http://dummy.com/people/1005"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=type(dm)&filter=author(http://dummy.com/people/54321)&filter=place(http://dummy.com/people/1005)&filter=entityDescriptor(37,2345)", asString, @"Wrong string contents");
}

@end
