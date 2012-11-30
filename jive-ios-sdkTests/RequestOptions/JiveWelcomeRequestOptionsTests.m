//
//  JiveWelcomeRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveWelcomeRequestOptionsTests.h"

@implementation JiveWelcomeRequestOptionsTests

- (JiveWelcomeRequestOptions *)welcomeOptions {
    
    return (JiveWelcomeRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveWelcomeRequestOptions alloc] init];
}

- (void)testWelcome {
    
    self.welcomeOptions.welcome = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"welcome=true", asString, @"Wrong string contents");
}

- (void)testWelcomeWithField {
    
    NSString *testField = @"name";
    
    [self.welcomeOptions addField:testField];
    self.welcomeOptions.welcome = YES;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&welcome=true", asString, @"Wrong string contents");
}

@end
