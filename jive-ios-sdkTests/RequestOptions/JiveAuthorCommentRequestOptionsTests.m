//
//  JiveAuthorCommentRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/30/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveAuthorCommentRequestOptionsTests.h"

@implementation JiveAuthorCommentRequestOptionsTests

- (JiveAuthorCommentRequestOptions *)categorizedOptions {
    
    return (JiveAuthorCommentRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveAuthorCommentRequestOptions alloc] init];
}

- (void)testAuthor {
    
    self.categorizedOptions.author = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"author=true", asString, @"Wrong string contents");
}

- (void)testAuthorWithField {
    
    [self.categorizedOptions addField:@"name"];
    self.categorizedOptions.author = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&author=true", asString, @"Wrong string contents");
}

@end
