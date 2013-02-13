//
//  JiveAsyncTestCase.m
//  jive-ios-sdk
//
//  Created by Heath Borders on 12/6/12.
//
//    Copyright 2013 Jive Software Inc.
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.
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
