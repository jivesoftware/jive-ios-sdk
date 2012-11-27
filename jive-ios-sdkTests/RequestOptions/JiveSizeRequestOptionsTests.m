//
//  JiveSizeRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveSizeRequestOptionsTests.h"

@implementation JiveSizeRequestOptionsTests

@synthesize options;

- (void)setUp {
    
    options = [[JiveSizeRequestOptions alloc] init];
}

- (void)tearDown {
    
    options = nil;
}

- (void)testNoFields {
    
    NSString *asString = [options toQueryString];
    
    STAssertNil(asString, @"Valid string returned");
}

- (void)testSize {
    
    int value = 5;
    
    self.options.size = value;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"size=5", asString, @"Wrong string contents");
    
    value = 7;
    self.options.size = value;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"size=7", asString, @"Wrong string contents");
}

@end
