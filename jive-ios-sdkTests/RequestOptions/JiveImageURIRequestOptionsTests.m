//
//  JiveImageURIRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveImageURIRequestOptionsTests.h"

@implementation JiveImageURIRequestOptionsTests

@synthesize options;

- (void)setUp {
    
    options = [[JiveImageURIRequestOptions alloc] init];
}

- (void)tearDown {
    
    options = nil;
}

- (void)testURI {
    
    options.uri = [NSURL URLWithString:@"http://dummy_uri"];
    
    NSString *asString = [options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"uri=http://dummy_uri", asString, @"Wrong string contents");
}

- (void)testAlternateURI {
    
    options.uri = [NSURL URLWithString:@"http://alternate/address"];
    
    NSString *asString = [options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"uri=http://alternate/address", asString, @"Wrong string contents");
}

@end
