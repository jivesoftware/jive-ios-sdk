//
//  JiveCommentsRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/30/12.
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
