//
//  jive_ios_sdk_tests.m
//  jive-ios-sdk-tests
//
//  Created by Heath Borders on 1/17/13.
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

#import "JiveTestCase.h"

NSString * const JiveTestCaseNotAJiveObjectKey = @"JiveTestCaseNotAJiveObject";

static NSTimeInterval JiveTestCaseAsyncTimeout = 30.0;
static NSTimeInterval JIveTestCaseLoopInterval = .1;

@interface JiveTestCase() <JiveAuthorizationDelegate>

@end

@implementation JiveTestCase

#pragma mark - SenTestCase

- (void)setUp {
    [super setUp];
    
    jive = [[Jive alloc] initWithJiveInstance:[NSURL URLWithString:@"http://tiedhouse-yeti1.eng.jiveland.com"]
                        authorizationDelegate:self];
}

- (void)tearDown {
    jive = nil;
    
    [super tearDown];
}

#pragma mark - JiveAuthorizationDelegate

- (JiveCredentials *) credentialsForJiveInstance:(NSURL*) url {
    JiveCredentials *credentials = [[JiveCredentials alloc] initWithUserName:@"iOS-SDK-TestUser1"
                                                                    password:@"test123"];
    return credentials;
}

#pragma mark - public API

- (void)waitForTimeout:(JiveTestCaseAsyncBlock)asynchBlock {
    __block BOOL finished = NO;
    JiveTestCaseAsyncFinishBlock finishBlock = ^{
        finished = YES;
    };
    
    asynchBlock(finishBlock);
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:JiveTestCaseAsyncTimeout];
    NSDate *dt = [NSDate dateWithTimeIntervalSinceNow:JIveTestCaseLoopInterval];
    
    while (!finished && ([loopUntil timeIntervalSinceNow] > 0)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:dt];
        dt = [NSDate dateWithTimeIntervalSinceNow:JIveTestCaseLoopInterval];
    }
    
    STAssertTrue(finished, @"Asynchronous call never finished.");
}

- (void)unexpectedErrorInWaitForTimeOut:(NSError *)error
                            finishBlock:(JiveTestCaseAsyncFinishBlock)finishBlock {
    STFail(@"Unexpected error: %@ %@", [error localizedDescription], [error userInfo]);
    finishBlock();
}

- (void)runOperation:(NSOperation *)operation {
    STAssertNotNil(operation, @"Invalid operation");
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:JiveTestCaseAsyncTimeout];
    NSDate *dt = [NSDate dateWithTimeIntervalSinceNow:JIveTestCaseLoopInterval];
    NSOperationQueue *queue = [NSOperationQueue new];
    
    [queue addOperation:operation];
    while (![operation isFinished] && ([loopUntil timeIntervalSinceNow] > 0)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:dt];
        dt = [NSDate dateWithTimeIntervalSinceNow:JIveTestCaseLoopInterval];
    }
    
    STAssertTrue([operation isFinished], @"Asynchronous call never finished.");
}

@end

@implementation NSArray (JiveTestCase)

- (NSArray *) arrayOfJiveObjectJSONDictionaries {
    NSMutableArray *jiveObjectJSONDictionaries = [NSMutableArray arrayWithCapacity:[self count]];
    for (id maybeJiveObject in self) {
        if ([maybeJiveObject isKindOfClass:[JiveObject class]]) {
            JiveObject *jiveObject = (JiveObject *)maybeJiveObject;
            NSDictionary *jiveObjectJSONDictionary = [jiveObject toJSONDictionary];
            [jiveObjectJSONDictionaries addObject:jiveObjectJSONDictionary];
        } else {
            NSString *description = [maybeJiveObject description];
            if (description) {
                [jiveObjectJSONDictionaries addObject:(@{
                                                       JiveTestCaseNotAJiveObjectKey : description,
                                                       })];
            } else {
                [jiveObjectJSONDictionaries addObject:(@{
                                                       JiveTestCaseNotAJiveObjectKey : [NSNull null],
                                                       })];
            }
        }
    }
    
    return jiveObjectJSONDictionaries;
}

@end
