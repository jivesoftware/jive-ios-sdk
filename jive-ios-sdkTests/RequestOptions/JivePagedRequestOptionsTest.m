//
//  JivePagedRequestOptionsTest.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePagedRequestOptionsTest.h"

@implementation JivePagedRequestOptionsTest

- (JivePagedRequestOptions *)pagedOptions {
    
    return (JivePagedRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JivePagedRequestOptions alloc] init];
}

- (void)testCount {
    
    int value = 5;
    
    self.pagedOptions.startIndex = value;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"startIndex=5", asString, @"Wrong string contents");
    
    value = 7;
    self.pagedOptions.startIndex = value;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"startIndex=7", asString, @"Wrong string contents");
}

- (void)testCountWithField {
    
    int value = 5;
    NSString *testField = @"name";
    
    [self.pageOptions addField:testField];
    self.pagedOptions.startIndex = value;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&startIndex=5", asString, @"Wrong string contents");
}


@end
