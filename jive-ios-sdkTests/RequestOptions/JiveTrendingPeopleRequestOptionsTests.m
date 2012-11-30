//
//  JiveTrendingPeopleRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveTrendingPeopleRequestOptionsTests.h"

@implementation JiveTrendingPeopleRequestOptionsTests

- (JiveTrendingPeopleRequestOptions *)trendingOptions {
    
    return (JiveTrendingPeopleRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveTrendingPeopleRequestOptions alloc] init];
}

//- (void)tearDown {
//
//    [super tearDown];
//}

- (void)testCount {
    
    self.trendingOptions.url = [NSURL URLWithString:@"http://dummy"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=place(http://dummy)", asString, @"Wrong string contents");
    
    self.trendingOptions.url = [NSURL URLWithString:@"http://alternate/url"];
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"filter=place(http://alternate/url)", asString, @"Wrong string contents");
}

- (void)testCountWithField {
    
    NSString *testField = @"name";
    
    [self.trendingOptions addField:testField];
    self.trendingOptions.url = [NSURL URLWithString:@"http://dummy"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&filter=place(http://dummy)", asString, @"Wrong string contents");
}

@end
