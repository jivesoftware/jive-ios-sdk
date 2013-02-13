//
//  MockJiveURLProtocol.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/3/12.
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

#import <Foundation/Foundation.h>

@protocol MockJiveURLResponseDelegate <NSObject>

- (NSHTTPURLResponse*) responseForRequest;
- (NSData*) responseBodyForRequest;
- (NSError*) errorForRequest;

@end

@protocol MockJiveURLResponseDelegate2 <NSObject>


- (NSHTTPURLResponse*) responseForRequestWithHTTPMethod:(NSString *)HTTPMethod forURL:(NSURL *)URL;
- (NSData*) responseBodyForRequestWithHTTPMethod:(NSString *)HTTPMethod forURL:(NSURL *)URL;
- (NSError*) errorForRequestWithHTTPMethod:(NSString *)HTTPMethod forURL:(NSURL *)URL;

@end

@interface MockJiveURLProtocol : NSURLProtocol
+ (void) setMockJiveURLResponseDelegate:(id<MockJiveURLResponseDelegate>) delegate;
+ (void) setMockJiveURLResponseDelegate2:(id<MockJiveURLResponseDelegate2>) delegate2;
@end
