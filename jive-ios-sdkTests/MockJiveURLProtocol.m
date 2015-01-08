//
//  MockJiveURLProtocol.m
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

#import "MockJiveURLProtocol.h"

static id<MockJiveURLResponseDelegate> _delegate;
static id<MockJiveURLResponseDelegate2> _delegate2;

@implementation MockJiveURLProtocol

+ (void) setMockJiveURLResponseDelegate:(id<MockJiveURLResponseDelegate>) delegate {
    _delegate = delegate;
}

+ (void) setMockJiveURLResponseDelegate2:(id<MockJiveURLResponseDelegate2>) delegate2 {
    _delegate2 = delegate2;
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    return YES;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    return request;
}


- (NSCachedURLResponse*) cachedResponse {
    return nil;
}

- (void) startLoading {
	id<NSURLProtocolClient> client = [self client];
    
    NSAssert(_delegate || _delegate2, @"MockJiveURLResponseDelegate and MockJiveURLResponseDelegate2 cannot be nil!");
    
    
    NSHTTPURLResponse *response;
    NSData* data;
    NSError* error;
    if (_delegate) {
        NSAssert([_delegate respondsToSelector:@selector(responseForRequest)],
                 @"MockJiveURLResponseDelegate does not repsond to responseForRequest");
        NSAssert([_delegate respondsToSelector:@selector(responseBodyForRequest)],
                 @"MockJiveURLResponseDelegate does not repsond to responseBodyForRequest");
        NSAssert([_delegate respondsToSelector:@selector(errorForRequest)],
                 @"MockJiveURLResponseDelegate does not repsond to errorForRequest");
        
        response = [_delegate responseForRequest];
        data = [_delegate responseBodyForRequest];
        error = [_delegate errorForRequest];
    } else if (_delegate2) {
        NSAssert([_delegate2 respondsToSelector:@selector(responseBodyForRequestWithHTTPMethod:forURL:)],
                 @"MockJiveURLResponseDelegate does not repsond to responseBodyForRequestWithHTTPMethod:forURL:");
        NSAssert([_delegate2 respondsToSelector:@selector(errorForRequestWithHTTPMethod:forURL:)],
                 @"MockJiveURLResponseDelegate does not repsond to errorForRequestWithHTTPMethod:forURL:");
        
        NSURLRequest *request = [self request];
        NSString *HTTPMethod = [request HTTPMethod];
        NSURL *URL = [request URL];
        response = [_delegate2 responseForRequestWithHTTPMethod:HTTPMethod
                                                         forURL:URL];
        data = [_delegate2 responseBodyForRequestWithHTTPMethod:HTTPMethod
                                                         forURL:URL];
        error = [_delegate2 errorForRequestWithHTTPMethod:HTTPMethod
                                                   forURL:URL];
    }
    
    NSAssert(nil != response || nil != error, @"responseForRequest and errorForRequest cannot both return nil! Be sure to mock MockJiveURLResponseDelegate in your unit tests appropriately");
    
    if(error) {
        [client URLProtocol:self didFailWithError:error];
        return;
    }
    
    [client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    [client URLProtocol:self didLoadData:data];
    [client URLProtocolDidFinishLoading:self];
}

- (void) stopLoading {
    // NOOP
}

@end
