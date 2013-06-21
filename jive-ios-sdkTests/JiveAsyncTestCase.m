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

static NSTimeInterval const JiveAsyncTestCaseTimeout = 5000;
static NSTimeInterval const JiveAsyncTestCaseDelayInterval = 1;

@implementation JiveAsyncTestCase

- (void)setUp {
    [super setUp];
    
    [OHHTTPStubs removeAllRequestHandlers];
}

- (void)tearDown {
    [OHHTTPStubs removeAllRequestHandlers];
    
    [super tearDown];
}

- (void)waitForTimeout:(void (^)(dispatch_block_t finishedBlock))asynchBlock {
    __block BOOL finished = NO;
    void (^finishedBlock)(void) = [^{
        finished = YES;
    } copy];
    
    asynchBlock(finishedBlock);
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:JiveAsyncTestCaseTimeout];
    NSDate *dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    
    while (!finished && ([loopUntil timeIntervalSinceNow] > 0)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:dt];
        dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    }
    
    STAssertTrue(finished, @"Asynchronous call never finished.");
}

- (void)delay {
    NSDate *loopUntilDate = [NSDate dateWithTimeIntervalSinceNow:JiveAsyncTestCaseDelayInterval];
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                             beforeDate:loopUntilDate];
}

@end

@implementation OHHTTPStubsResponse (JiveAsyncTestCase)


+ (instancetype)responseWithJSON:(id)JSON {
    return [self responseWithJSON:JSON
                        responder:NULL];
}

+ (instancetype)responseWithJSON:(id)JSON
                       responder:(OHHTTPStubsResponder)responder {
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:JSON
                                                       options:NSJSONWritingPrettyPrinted error:NULL];
    OHHTTPStubsResponse *response = [self responseWithData:JSONData
                                                statusCode:200
                                              responseTime:0
                                                   headers:(@{
                                                            @"Content-Type" : @"application/json",
                                                            })];
    response.responder = responder;
    return response;
}

+ (instancetype)responseWithJSONFile:(NSString *)fileName {
    return [self responseWithJSONFile:fileName
                            responder:NULL];
}

+ (instancetype)responseWithJSONFile:(NSString *)fileName
                           responder:(OHHTTPStubsResponder)responder {
    OHHTTPStubsResponse *response = [self responseWithFile:fileName
                                               contentType:@"application/json"
                                              responseTime:0];
    response.responder = responder;
    return response;
}

+ (instancetype)responseWithHTML:(NSString *)HTML {
    return [self responseWithHTML:HTML
                        responder:NULL];
}

+ (instancetype)responseWithHTML:(NSString *)HTML
                       responder:(OHHTTPStubsResponder)responder {
    OHHTTPStubsResponse *response = [self responseWithData:[HTML dataUsingEncoding:NSUTF8StringEncoding]
                                                statusCode:200
                                              responseTime:0
                                                   headers:(@{
                                                            @"Content-Type" : @"text/html",
                                                            })];
    response.responder = responder;
    return response;
    
}

+ (instancetype)responseThatRedirectsToLocation:(NSURL *)locationURL {
    return [self responseThatRedirectsToLocation:locationURL
                                       responder:NULL];
}

+ (instancetype)responseThatRedirectsToLocation:(NSURL *)locationURL
                                      responder:(OHHTTPStubsResponder)responder {
    OHHTTPStubsResponse *response = [self responseWithData:[@"<html></html>" dataUsingEncoding:NSUTF8StringEncoding]
                                                statusCode:300
                                              responseTime:0
                                                   headers:(@{
                                                            @"Content-Type" : @"text/html",
                                                            @"Location" : [locationURL absoluteString],
                                                            })];
    response.responder = responder;
    return response;
}

+ (instancetype)responseWithError:(NSError *)error
                        responder:(OHHTTPStubsResponder)responder {
    OHHTTPStubsResponse *response = [self responseWithError:error];
    response.responder = responder;
    return response;
}

@end
