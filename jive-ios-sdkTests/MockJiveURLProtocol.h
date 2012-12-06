//
//  MockJiveURLProtocol.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/3/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
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
