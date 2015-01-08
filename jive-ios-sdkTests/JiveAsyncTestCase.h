//
//  JiveAsyncTestCase.h
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

#import <SenTestingKit/SenTestingKit.h>
#import <OHHTTPStubs/OHHTTPStubs.h>

@interface JiveAsyncTestCase : SenTestCase

- (void)waitForTimeout:(void (^)(dispatch_block_t finishedBlock))asynchBlock file:(const char *)file line:(int)line;
- (void)delay;

@end

#define waitForTimeout(block) [self waitForTimeout:block file:__FILE__ line:__LINE__]

@interface OHHTTPStubsResponse (JiveAsyncTestCase)

+ (instancetype)responseWithJSON:(id)JSON;
+ (instancetype)responseWithJSON:(id)JSON
                       responder:(OHHTTPStubsResponder)responder;
+ (instancetype)responseWithJSONFile:(NSString *)fileName;
+ (instancetype)responseWithJSONFile:(NSString *)fileName
                           responder:(OHHTTPStubsResponder)responder;
+ (instancetype)responseWithHTML:(NSString *)HTML;
+ (instancetype)responseWithHTML:(NSString *)HTML
                       responder:(OHHTTPStubsResponder)responder;
+ (instancetype)responseThatRedirectsToLocation:(NSURL *)locationURL;
+ (instancetype)responseThatRedirectsToLocation:(NSURL *)locationURL
                                      responder:(OHHTTPStubsResponder)responder;
+ (instancetype)responseWithError:(NSError *)error
                        responder:(OHHTTPStubsResponder)responder;

@end
