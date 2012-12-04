//
//  JiveSearchContentsRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/4/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveSearchContentsRequestOptionsTests.h"

@implementation JiveSearchContentsRequestOptionsTests

- (JiveSearchContentsRequestOptions *)contentsOptions {
    
    return (JiveSearchContentsRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveSearchContentsRequestOptions alloc] init];
}

- (void)testSubjectOnly {
    
    self.contentsOptions.subjectOnly = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"filter=subjectonly", asString, @"Wrong string contents");
}

- (void)testSubjectOnlyWithOtherFields {
    
    [self.contentsOptions addField:@"name"];
    self.contentsOptions.subjectOnly = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&filter=subjectonly", asString, @"Wrong string contents");
    
    [self.contentsOptions addSearchTerm:@"mention"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention),subjectonly", asString, @"Wrong string contents");
    
    [self.contentsOptions addType:@"share"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention),type(share),subjectonly", asString, @"Wrong string contents");
}

@end
