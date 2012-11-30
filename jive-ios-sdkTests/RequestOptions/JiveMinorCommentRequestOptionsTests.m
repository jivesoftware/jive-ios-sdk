//
//  JiveMinorCommentRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/30/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveMinorCommentRequestOptionsTests.h"

@implementation JiveMinorCommentRequestOptionsTests

- (JiveMinorCommentRequestOptions *)commentOptions {
    
    return (JiveMinorCommentRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveMinorCommentRequestOptions alloc] init];
}

- (void)testAuthor {
    
    self.commentOptions.minor = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"minor=true", asString, @"Wrong string contents");
}

- (void)testAuthorWithField {
    
    [self.commentOptions addField:@"name"];
    self.commentOptions.minor = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&minor=true", asString, @"Wrong string contents");
}

@end
