//
//  JiveAsyncTestCase.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 12/6/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveAsyncTestCase.h"
#import "JAPIRequestOperation.h"

@implementation JiveAsyncTestCase

- (void)waitForTimeout:(void (^)(void(^finishedBlock)(void)))asynchBlock {
    __block BOOL finished = NO;
    void (^finishedBlock)(void) = [^{
        finished = YES;
    } copy];
    
    asynchBlock(finishedBlock);
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:5.0];
    NSDate *dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    
    while (!finished && ([loopUntil timeIntervalSinceNow] > 0)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:dt];
        dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    }
    
    STAssertTrue(finished, @"Asynchronous call never finished.");
}

- (void)runOperation:(NSOperation *)operation {
    STAssertNotNil(operation, @"Invalid operation");
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:5.0];
    NSDate *dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    NSOperationQueue *queue = [NSOperationQueue new];
    
    [queue addOperation:operation];
    while (![operation isFinished] && ([loopUntil timeIntervalSinceNow] > 0)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:dt];
        dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    }
    
    STAssertTrue([operation isFinished], @"Asynchronous call never finished.");
}

@end
