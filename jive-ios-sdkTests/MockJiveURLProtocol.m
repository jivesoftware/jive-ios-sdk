//
//  MockJiveURLProtocol.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/3/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "MockJiveURLProtocol.h"

static id<MockJiveURLResponseDelegate> _delegate;

@implementation MockJiveURLProtocol

+ (void) setMockJiveURLResponseDelegate:(id<MockJiveURLResponseDelegate>) delegate {
    _delegate = delegate;
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
    
    NSAssert(_delegate, @"MockJiveURLResponseDelegate cannot be nil!");
    
    
    NSHTTPURLResponse *response;
    NSData* data;
    NSError* error;
    if ([_delegate respondsToSelector:@selector(responseForRequestWithHTTPMethod:forURL:)]) {
        NSAssert([_delegate respondsToSelector:@selector(responseBodyForRequestWithHTTPMethod:forURL:)],
                 @"MockJiveURLResponseDelegate does not repsond to responseBodyForRequest");
        NSAssert([_delegate respondsToSelector:@selector(errorForRequestWithHTTPMethod:forURL:)],
                 @"MockJiveURLResponseDelegate does not repsond to errorForRequest");
        
        NSURLRequest *request = [self request];
        NSString *HTTPMethod = [request HTTPMethod];
        NSURL *URL = [request URL];
        response = [_delegate responseForRequestWithHTTPMethod:HTTPMethod
                                                        forURL:URL];
        data = [_delegate responseBodyForRequestWithHTTPMethod:HTTPMethod
                                                        forURL:URL];
        error = [_delegate errorForRequestWithHTTPMethod:HTTPMethod
                                                  forURL:URL];
    } else {
        NSAssert([_delegate respondsToSelector:@selector(responseForRequest)],
                 @"MockJiveURLResponseDelegate does not repsond to responseForRequest");
        NSAssert([_delegate respondsToSelector:@selector(responseBodyForRequest)],
                 @"MockJiveURLResponseDelegate does not repsond to responseBodyForRequest");
        NSAssert([_delegate respondsToSelector:@selector(errorForRequest)],
                 @"MockJiveURLResponseDelegate does not repsond to errorForRequest");
        
        response = [_delegate responseForRequest];
        data = [_delegate responseBodyForRequest];
        error = [_delegate errorForRequest];
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
