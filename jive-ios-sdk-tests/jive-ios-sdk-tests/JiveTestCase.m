//
//  jive_ios_sdk_tests.m
//  jive-ios-sdk-tests
//
//  Created by Heath Borders on 1/17/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
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
