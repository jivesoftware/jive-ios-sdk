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

- (void)runOperation:(NSOperation *)operation untilComplete:(BOOL (^)(void))operationComplete {
    STAssertNotNil(operation, @"Invalid operation");
    STAssertTrue([operation isKindOfClass:[JAPIRequestOperation class]], @"Incorrect operation type/class.");
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:5.0];
    NSDate *dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [queue addOperation:operation];
    while (!operationComplete() && ([loopUntil timeIntervalSinceNow] > 0)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:dt];
        dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    }
    
    STAssertTrue(operationComplete(), @"Asynchronous call never finished.");
}

@end
