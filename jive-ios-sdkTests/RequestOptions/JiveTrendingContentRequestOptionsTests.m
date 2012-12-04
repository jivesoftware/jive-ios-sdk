//
//  JiveTrendingContentRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/30/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveTrendingContentRequestOptionsTests.h"

@implementation JiveTrendingContentRequestOptionsTests

- (JiveTrendingContentRequestOptions *)contentOptions {
    
    return (JiveTrendingContentRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveTrendingContentRequestOptions alloc] init];
}

//- (void)tearDown {
//
//    [super tearDown];
//}

- (void)testType {
    
    [self.contentOptions addType:@"document"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=type(document)", asString, @"Wrong string contents");
    
    [self.contentOptions addType:@"discussion"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=type(document,discussion)", asString, @"Wrong string contents");
}

- (void)testTypeWithField {
    
    NSString *testField = @"name";
    
    [self.contentOptions addField:testField];
    [self.contentOptions addType:@"document"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=type(document)", asString, @"Wrong string contents");
    
    self.contentOptions.url = [NSURL URLWithString:@"http://dummy"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=place(http://dummy),type(document)", asString, @"Wrong string contents");
}

@end
