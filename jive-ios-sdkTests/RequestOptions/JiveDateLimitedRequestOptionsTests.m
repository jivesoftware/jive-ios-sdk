//
//  JiveDateLimitedRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveDateLimitedRequestOptionsTests.h"
#import "JiveObject.h"

@implementation JiveDateLimitedRequestOptionsTests

- (JiveDateLimitedRequestOptions *)dateOptions {
    
    return (JiveDateLimitedRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveDateLimitedRequestOptions alloc] init];
    [[JiveObject dateFormatter] setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]]; // Make sure there is no time zone confusion.
}

//- (void)tearDown {
//
//    [super tearDown];
//}

- (void)testAfter {
    
    NSDate *testDate = [NSDate dateWithTimeIntervalSince1970:0];
    
    self.dateOptions.after = testDate;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"after=1970-01-01T00:00:00.000+0000", asString, @"Wrong string contents");
    
    testDate = [NSDate dateWithTimeIntervalSince1970:1000];
    self.dateOptions.after = testDate;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"after=1970-01-01T00:16:40.000+0000", asString, @"Wrong string contents");
}

- (void)testAfterWithField {
    
    NSString *testField = @"name";
    NSDate *testDate = [NSDate dateWithTimeIntervalSince1970:0];
    
    self.dateOptions.after = testDate;
    [self.dateOptions addField:testField];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&after=1970-01-01T00:00:00.000+0000", asString, @"Wrong string contents");
}

- (void)testBefore {
    
    NSDate *testDate = [NSDate dateWithTimeIntervalSince1970:0];
    
    self.dateOptions.before = testDate;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"before=1970-01-01T00:00:00.000+0000", asString, @"Wrong string contents");
    
    testDate = [NSDate dateWithTimeIntervalSince1970:1000];
    self.dateOptions.before = testDate;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"before=1970-01-01T00:16:40.000+0000", asString, @"Wrong string contents");
}

- (void)testBeforeWithField {
    
    NSString *testField = @"name";
    NSDate *testDate = [NSDate dateWithTimeIntervalSince1970:0];
    
    self.dateOptions.before = testDate;
    [self.dateOptions addField:testField];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&before=1970-01-01T00:00:00.000+0000", asString, @"Wrong string contents");
}

- (void)testBeforeAndAfter {
    
    NSString *testField = @"name";
    NSDate *testAfter = [NSDate dateWithTimeIntervalSince1970:0];
    NSDate *testBefore = [NSDate dateWithTimeIntervalSince1970:1000];
    
    self.dateOptions.after = testAfter;
    self.dateOptions.before = testBefore;
    [self.dateOptions addField:testField];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&after=1970-01-01T00:00:00.000+0000", asString, @"Wrong string contents");
}

@end
