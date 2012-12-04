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

- (void)testTypes {
    
    [self.contentsOptions addType:@"dm"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"filter=type(dm)", asString, @"Wrong string contents");
    
    [self.contentsOptions addType:@"mention"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"filter=type(dm,mention)", asString, @"Wrong string contents");
    
    [self.contentsOptions addType:@"share"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"filter=type(dm,mention,share)", asString, @"Wrong string contents");
}

- (void)testTypeWithFields {
    
    [self.contentsOptions addType:@"dm"];
    [self.contentsOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&filter=type(dm)", asString, @"Wrong string contents");
    
    [self.contentsOptions addSearchTerm:@"mention"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"fields=name&filter=search(mention),type(dm)", asString, @"Wrong string contents");
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
