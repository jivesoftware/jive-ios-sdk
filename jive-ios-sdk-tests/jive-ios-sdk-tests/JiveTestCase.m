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
#import <Jive/JiveHTTPBasicAuthCredentials.h>

NSString * const JiveTestCaseNotAJiveObjectKey = @"JiveTestCaseNotAJiveObject";

static NSTimeInterval JiveTestCaseAsyncTimeout = 30.0;
static NSTimeInterval JIveTestCaseLoopInterval = .1;

@interface JiveTestCaseAuthorizationDelegate : NSObject<JiveAuthorizationDelegate>

- (id)initWithUsername:(NSString *)username
              password:(NSString *)password;

@end

@interface JiveTestCase() {
    JiveTestCaseAuthorizationDelegate *authorizationDelegate1;
    JiveTestCaseAuthorizationDelegate *authorizationDelegate2;
    JiveTestCaseAuthorizationDelegate *authorizationDelegate3;
}
@end

@interface NSURLRequest (ENGSERV_2025_HACK)

+ (void)setAllowsAnyHTTPSCertificate:(BOOL)allowsAnyHTTPSCertificate forHost:(NSString *)host;

@end

@implementation JiveTestCase

+ (void)initialize {

}

#pragma mark - SenTestCase

- (void)setUp {
    [super setUp];
    
    //read the instance info json file
    NSString* contentPath = [[NSBundle bundleForClass:[self class]] pathForResource:@"instance_info" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:contentPath];
    
    NSError *error = nil;
    id jsonObjects = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    
    NSLog(@"Error: %@ %@", [error localizedDescription], [error userInfo]);
    
    
    if (error)
    {
        NSLog(@".... Error reading the file 'instance_info.json'");
        exit(0);
        
    }
    
    server = [jsonObjects valueForKey:@"server"];
    
    userid1 = [jsonObjects valueForKey:@"userid1"];
    pw1 = [jsonObjects valueForKey:@"pw1"];
    userid2 = [jsonObjects valueForKey:@"userid2"];
    pw2 = [jsonObjects valueForKey:@"pw2"];
    userid3 = [jsonObjects valueForKey:@"userid1"];
    pw3 = [jsonObjects valueForKey:@"pw3"];
    
    if (self == [JiveTestCase class]) {
        [NSURLRequest setAllowsAnyHTTPSCertificate:YES
                                           forHost:server];
    }
    
    
    authorizationDelegate1 = [[JiveTestCaseAuthorizationDelegate alloc] initWithUsername:userid1 password:pw1];
    authorizationDelegate2 = [[JiveTestCaseAuthorizationDelegate alloc] initWithUsername:userid2 password:pw2];
    authorizationDelegate3 = [[JiveTestCaseAuthorizationDelegate alloc] initWithUsername:userid3 password:pw3];
    
    jive1 = [[Jive alloc] initWithJiveInstance:[NSURL URLWithString:server]
                         authorizationDelegate:authorizationDelegate1];
    
    jive2 = [[Jive alloc] initWithJiveInstance:[NSURL URLWithString:server]
                         authorizationDelegate:authorizationDelegate2];
    
    jive3 = [[Jive alloc] initWithJiveInstance:[NSURL URLWithString:server]
                         authorizationDelegate:authorizationDelegate3];
    
    jive4 = [[Jive alloc] initWithJiveInstance:[NSURL URLWithString:server]
                         authorizationDelegate:authorizationDelegate1];
    

}

- (void)tearDown {
    jive1 = nil;
    jive2 = nil;
    jive3 = nil;
    jive4 = nil;
    
    [super tearDown];
}

#pragma mark - JiveAuthorizationDelegate

- (id<JiveCredentials>) credentialsForJiveInstance:(NSURL*) url {
    id<JiveCredentials>credentials = [[JiveHTTPBasicAuthCredentials alloc] initWithUsername:userid1
                                                                                   password:pw1];
    return credentials;
}

- (JiveMobileAnalyticsHeader *)mobileAnalyticsHeaderForJiveInstance:(NSURL *)url {
    JiveMobileAnalyticsHeader *mobileAnalyticsHeader = [[JiveMobileAnalyticsHeader alloc] initWithAppID:@"jive-ios-sdkTests"
                                                                                             appVersion:@"SDKTest"
                                                                                         connectionType:@"Unknown"
                                                                                         devicePlatform:@"Test Device"
                                                                                          deviceVersion:@"Test Device"];
    
    return mobileAnalyticsHeader;
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



@interface JiveTestCaseAuthorizationDelegate()

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *password;

@end

@implementation JiveTestCaseAuthorizationDelegate

- (id)initWithUsername:(NSString *)username
              password:(NSString *)password {
    self = [super init];
    if (self) {
        self.username = username;
        self.password = password;
    }
    
    return self;
}

#pragma mark - JiveAuthorizationDelegate

- (id<JiveCredentials>)credentialsForJiveInstance:(NSURL*) url {
    id<JiveCredentials> credentials = [[JiveHTTPBasicAuthCredentials alloc] initWithUsername:self.username
                                                                                    password:self.password];
    return credentials;
}

- (JiveMobileAnalyticsHeader *)mobileAnalyticsHeaderForJiveInstance:(NSURL *)url {
    JiveMobileAnalyticsHeader *mobileAnalyticsHeader = [[JiveMobileAnalyticsHeader alloc] initWithAppID:@"jive-ios-sdkTests"
                                                                                             appVersion:@"SDKTest"
                                                                                         connectionType:@"Unknown"
                                                                                         devicePlatform:@"Test Device"
                                                                                          deviceVersion:@"Test Device"];
    
    return mobileAnalyticsHeader;
}

@end

