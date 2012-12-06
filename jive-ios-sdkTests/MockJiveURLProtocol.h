//
//  MockJiveURLProtocol.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/3/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MockJiveURLResponseDelegate <NSObject>

@optional
- (NSHTTPURLResponse*) responseForRequest;
- (NSData*) responseBodyForRequest;
- (NSError*) errorForRequest;

- (NSHTTPURLResponse*) responseForRequestWithHTTPMethod:(NSString *)HTTPMethod forURL:(NSURL *)URL;
- (NSData*) responseBodyForRequestWithHTTPMethod:(NSString *)HTTPMethod forURL:(NSURL *)URL;
- (NSError*) errorForRequestWithHTTPMethod:(NSString *)HTTPMethod forURL:(NSURL *)URL;

@end

@interface MockJiveURLProtocol : NSURLProtocol 
+ (void) setMockJiveURLResponseDelegate:(id<MockJiveURLResponseDelegate>) delegate;
@end
