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
    NSString *asString = [options optionsInURLFormat];

    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"", asString, @"String not empty");
}

- (void)testSingleField
{
    NSString *testField = @"name";

    [options addField:testField];

    NSString *asString = [options optionsInURLFormat];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name", asString, @"String not empty");
}

@end
