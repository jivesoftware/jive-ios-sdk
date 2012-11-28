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
    NSAssert([_delegate respondsToSelector:@selector(responseForRequest)],
             @"MockJiveURLResponseDelegate does not repsond to responseForRequest");
    NSAssert([_delegate respondsToSelector:@selector(responseBodyForRequest)],
             @"MockJiveURLResponseDelegate does not repsond to responseBodyForRequest");
    NSAssert([_delegate respondsToSelector:@selector(errorForRequest)],
             @"MockJiveURLResponseDelegate does not repsond to errorForRequest");
    
    NSHTTPURLResponse *response = [_delegate responseForRequest];
    NSData* data = [_delegate responseBodyForRequest];
    NSError* error = [_delegate errorForRequest];
    
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
