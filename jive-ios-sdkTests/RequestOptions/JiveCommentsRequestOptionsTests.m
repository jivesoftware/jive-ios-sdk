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
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"anchor=http://dummy.com/people/1005", asString, @"Wrong string contents");
    
    self.commentsOptions.anchor = [NSURL URLWithString:@"http://dummy.com/people/54321"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"anchor=http://dummy.com/people/54321", asString, @"Wrong string contents");
}

- (void)testAnchorWithField {
    
    self.commentsOptions.anchor = [NSURL URLWithString:@"http://dummy.com/people/1005"];
    [self.commentsOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&anchor=http://dummy.com/people/1005", asString, @"Wrong string contents");
}

@end
