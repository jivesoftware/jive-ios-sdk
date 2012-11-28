//
//  JiveDefinedSizeRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveDefinedSizeRequestOptionsTests.h"

@implementation JiveDefinedSizeRequestOptionsTests

- (void)setUp {
    
    self.options = [[JiveDefinedSizeRequestOptions alloc] init];
}

- (void)tearDown {
    
    self.options = nil;
}

- (void)testSize {
    
    self.options.size = largeImage;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNil(asString, @"Invalid string returned");
    
    self.options.size = mediumImage;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"size=medium", asString, @"Wrong string contents");
    
    self.options.size = smallImage;
    asString = [self.options toQueryString];
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"size=small", asString, @"Wrong string contents");
}

- (void)testInvalidSize {
    
    self.options.size = (enum JiveImageSizeOption)-1;

    NSString *asString = [self.options toQueryString];
    
    STAssertNil(asString, @"Invalid string returned");

    self.options.size = (enum JiveImageSizeOption)5000;
    asString = [self.options toQueryString];
    STAssertNil(asString, @"Invalid string returned");
}

@end
