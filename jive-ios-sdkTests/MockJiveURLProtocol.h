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

@interface MockJiveURLProtocol : NSURLProtocol 
+ (void) setMockJiveURLResponseDelegate:(id<MockJiveURLResponseDelegate>) delegate;
@end
