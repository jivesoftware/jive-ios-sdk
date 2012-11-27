//
//  JiveReturnFieldsRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveReturnFieldsRequestOptionsTests.h"

@implementation JiveReturnFieldsRequestOptionsTests

@synthesize options;

- (void)setUp
{
    options = [[JiveReturnFieldsRequestOptions alloc] init];
}

- (void)tearDown
{
    options = nil;
}

- (void)testNoFields
{
    NSString *asString = [options toQueryString];

    STAssertNil(asString, @"Valid string returned");
}

- (void)testSingleField
{
    NSString *testField = @"name";

    [options addField:testField];

    NSString *asString = [options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name", asString, @"Wrong string contents");
}

- (void)testMultipleFields
{
    NSString *testField1 = @"familyName";
    NSString *testField2 = @"givenName";
    NSString *testField3 = @"emails";
    
    [options addField:testField1];
    [options addField:testField2];
    [options addField:testField3];
    
    NSString *asString = [options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=familyName,givenName,emails", asString, @"Wrong string contents");
}

@end
