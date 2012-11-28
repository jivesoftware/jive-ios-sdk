//
//  JiveAutoCategorizeRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveAutoCategorizeRequestOptionsTests.h"

@implementation JiveAutoCategorizeRequestOptionsTests

- (JiveAutoCategorizeRequestOptions *)categorizedOptions {
    
    return (JiveAutoCategorizeRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveAutoCategorizeRequestOptions alloc] init];
}

- (void)testAutoCategorized {
    
    self.categorizedOptions.autoCategorize = TRUE;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"autoCategorize=true", asString, @"Wrong string contents");
}

- (void)testAutoCategorizedWithField {
    
    NSString *testField = @"name";
    
    [self.categorizedOptions addField:testField];
    self.categorizedOptions.autoCategorize = TRUE;
    
    NSString *asString = [self.options toQueryString];
    
    STAssertNotNil(asString, @"Invalid string returned");
    STAssertEqualObjects(@"fields=name&autoCategorize=true", asString, @"Wrong string contents");
}

@end
