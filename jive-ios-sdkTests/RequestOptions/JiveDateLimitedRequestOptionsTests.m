//
//  JiveDateLimitedRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveDateLimitedRequestOptionsTests.h"

@implementation JiveDateLimitedRequestOptionsTests

- (JiveDateLimitedRequestOptions *)dateOptions {
    
    return (JiveDateLimitedRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveDateLimitedRequestOptions alloc] init];
}

//- (void)tearDown {
//
//    [super tearDown];
//}

- (void)testCount {
    
    NSDate *testDate = [NSDate dateWithTimeIntervalSince1970:0];
    
    self.dateOptions.after = testDate;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"after=", asString, @"Wrong string contents");
    
    testDate = [NSDate dateWithTimeIntervalSince1970:1000];
    self.dateOptions.after = testDate;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"after=7", asString, @"Wrong string contents");
}

//- (void)testCountWithField {
//    
//    int value = 5;
//    NSString *testField = @"name";
//    
//    [self.dateOptions addField:testField];
//    self.dateOptions.count = value;
//    
//    NSString *asString = [self.options toQueryString];
//    
//    STAssertNotNil(asString, @"Invalid string returned");
//    STAssertEqualObjects(@"fields=name&count=5", asString, @"Wrong string contents");
//}

@end
