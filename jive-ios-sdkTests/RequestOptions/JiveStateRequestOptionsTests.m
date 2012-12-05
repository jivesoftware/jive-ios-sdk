//
//  JiveStateRequestOptionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/3/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveStateRequestOptionsTests.h"

@implementation JiveStateRequestOptionsTests

- (JiveStateRequestOptions *)stateOptions {
    
    return (JiveStateRequestOptions *)self.options;
}

- (void)setUp {
    
    self.options = [[JiveStateRequestOptions alloc] init];
}

- (void)testState {
    
    [self.stateOptions addState:@"owner"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"state=owner", asString, @"Wrong string contents");
    
    [self.stateOptions addState:@"banned"];
    asString = [self.options toQueryString];
    STAssertEqualObjects(@"state=owner,banned", asString, @"Wrong string contents");
}

- (void)testStateWithFields {
    
    [self.stateOptions addState:@"owner"];
    [self.stateOptions addField:@"name"];
    
    NSString *asString = [self.options toQueryString];
    
    STAssertEqualObjects(@"fields=name&state=owner", asString, @"Wrong string contents");
}

@end
