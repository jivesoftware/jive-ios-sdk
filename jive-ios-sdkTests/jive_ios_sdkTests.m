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

#import "JAPIRequestOperation.h"

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
    STAssertFalse(1 == 0, @"One should not equal zero on this computer.");
   
}

// From https://github.com/akisute/SenAsyncTestCase/blob/master/SenAsyncTestCase.m
- (void)waitForTimeout:(NSTimeInterval)timeout
{
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:timeout];
    NSDate *dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    
    while ([loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:dt];
        dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    }
}

// See http://ocmock.org/#tutorials for examples on how to use OCMock
// More examples here: http://svn.mulle-kybernetik.com/OCMock/trunk/Source/OCMockObjectTests.m

- (void) testOCMockExample {
  
    id mockString = [OCMockObject mockForClass:[NSMutableString class]];
    
    NSUInteger expectedValue = 10;
    
    [[[mockString stub] andReturnValue:OCMOCK_VALUE(expectedValue)] length];
    
    STAssertEquals(expectedValue, [mockString length], @"Mock string length incorrect.");
    
}

- (BOOL)hasAcceptableContentType {
    return YES;
}

// API call is to Jive, by removing "throw 'allowIllegalResourceCall is false.';"
- (void) testJAPIRequestOperation {
    
    NSURLRequest* request = [NSURLRequest requestWithURL:
                             [NSURL fileURLWithPath:[[NSBundle bundleForClass:[self class]] pathForResource:@"response" ofType:@"json"]]];
    
    JAPIRequestOperation *operation = [[JAPIRequestOperation alloc] initWithRequest:request];
    
    id mock = [OCMockObject partialMockForObject:operation];
   
    [[[mock stub] andCall:@selector(hasAcceptableContentType) onObject:self] hasAcceptableContentType];
 
    [mock setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Test succeeds if we get here
        STAssertNotNil(responseObject, @"JAPIRequestOperation returned nil response.");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        STFail(@"Unable to load test data. %@", [error localizedDescription]);
    }];
    
    [(JAPIRequestOperation *)mock start];
    
    [self waitForTimeout:5.0];
    
}

@end
