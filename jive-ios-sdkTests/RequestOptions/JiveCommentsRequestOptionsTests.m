//
//  JiveCommentsRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/30/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveCommentsRequestOptionsTests.h"

@implementation JiveCommentsRequestOptionsTests

- (JiveCommentsRequestOptions *)commentsOptions {
    
    return (JiveCommentsRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveCommentsRequestOptions alloc] init];
}

- (void)testAnchor {
    
    self.commentsOptions.anchor = [NSURL URLWithString:@"http://dummy.com/people/1005"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"anchor=http://dummy.com/people/1005", asString, @"Wrong string contents");
    
    self.commentsOptions.anchor = [NSURL URLWithString:@"http://dummy.com/people/54321"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"anchor=http://dummy.com/people/54321", asString, @"Wrong string contents");
}

- (void)testAnchorWithField {
    
    self.commentsOptions.anchor = [NSURL URLWithString:@"http://dummy.com/people/1005"];
    [self.commentsOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&anchor=http://dummy.com/people/1005", asString, @"Wrong string contents");
}

- (void)testAuthor {
    
    self.commentsOptions.excludeReplies = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"excludeReplies=true", asString, @"Wrong string contents");
}

- (void)testAuthorWithField {
    
    [self.commentsOptions addField:@"name"];
    self.commentsOptions.excludeReplies = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&excludeReplies=true", asString, @"Wrong string contents");
    
    self.commentsOptions.anchor = [NSURL URLWithString:@"http://dummy.com/people/54321"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&anchor=http://dummy.com/people/54321&excludeReplies=true", asString, @"Wrong string contents");
}

- (void)testHierarchical {
    
    self.commentsOptions.hierarchical = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"hierarchical=true", asString, @"Wrong string contents");
}

- (void)testHierarchicalWithField {
    
    [self.commentsOptions addField:@"name"];
    self.commentsOptions.hierarchical = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&hierarchical=true", asString, @"Wrong string contents");
    
    self.commentsOptions.anchor = [NSURL URLWithString:@"http://dummy.com/people/54321"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&anchor=http://dummy.com/people/54321&hierarchical=true", asString, @"Wrong string contents");
    
    self.commentsOptions.excludeReplies = YES;
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&anchor=http://dummy.com/people/54321&excludeReplies=true&hierarchical=true", asString, @"Wrong string contents");
}

@end
