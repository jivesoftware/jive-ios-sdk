//
//  Jive.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 9/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "JiveCredentials.h"

@protocol JiveAuthorizationDelegate <NSObject>
@required
- (JiveCredentials*) credentialsForJiveInstance:(NSURL*) url;
@end

@interface Jive : NSObject

- (id) initWithJiveInstance:(NSURL *)jiveInstanceURL authorizationDelegate:(id<JiveAuthorizationDelegate>) delegate;

// API


- (RACAsyncSubject*) me:(void(^)(id JSON)) complete onError:(void(^)(NSError* error)) error;

@end
