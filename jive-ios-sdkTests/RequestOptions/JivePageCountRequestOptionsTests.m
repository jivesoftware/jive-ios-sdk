//
//  JivePageCountRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePageCountRequestOptionsTests.h"

@implementation JivePageCountRequestOptionsTests

- (JivePageCountRequestOptions *)pageOptions
{
    return (JivePageCountRequestOptions *)self.options;
}

- (void)setUp
{
    self.options = [[JivePageCountRequestOptions alloc] init];
}

//- (void)tearDown
//{
//    [super tearDown];
//}

- (void)testCount
{
    int value = 5;

    self.pageOptions.count = value;

    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"count=5", asString, @"Wrong string contents");

    value = 7;
    self.pageOptions.count = value;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"count=7", asString, @"Wrong string contents");
}

- (void)testCountWithField
{
    int value = 5;
    NSString *testField = @"name";
    
    [self.pageOptions addField:testField];
    self.pageOptions.count = value;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&count=5", asString, @"Wrong string contents");
}

@end
