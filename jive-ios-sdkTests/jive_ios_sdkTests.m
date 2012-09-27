//
//  jive_ios_sdkTests.m
//  jive-ios-sdkTests
//
//  Created by Rob Derstadt on 9/27/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "jive_ios_sdkTests.h"

#import <OCMock/OCMock.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import <UIKit/UIKit.h>

@implementation jive_ios_sdkTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    STAssertFalse(1 == 0, @"One should not equal 0.");
   
}

// See http://ocmock.org/#tutorials for examples on how to use OCMock
- (void) testOCMockExample {
  
    id mockString = [OCMockObject mockForClass:[NSMutableString class]];
    
    NSUInteger expectedValue = 10;
    
    [[[mockString stub] andReturnValue:OCMOCK_VALUE(expectedValue)] length];
    
    STAssertEquals(expectedValue, [mockString length], @"Mock string length incorrect.");
    
    
}

@end
