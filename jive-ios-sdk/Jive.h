//
//  Jive.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 9/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@class JiveCredentials;
@class JiveRequestOptions;

@protocol JiveAuthorizationDelegate <NSObject>
@required
- (JiveCredentials*) credentialsForJiveInstance:(NSURL*) url;
@optional
//- (void) didReveiveOAuthActivitionResponse:(
@end

@interface Jive : NSObject

- (id) initWithJiveInstance:(NSURL *)jiveInstanceURL authorizationDelegate:(id<JiveAuthorizationDelegate>) delegate;

// API

- (RACAsyncSubject*) me:(void(^)(id JSON)) complete onError:(void(^)(NSError* error)) error;

- (RACAsyncSubject*) collegues:(NSString*) personId onComplete:(void(^)(id)) complete onError:(void(^)(NSError*)) error;

- (RACAsyncSubject*) search:(NSString*) type queryStr:(NSString*) query onComplete:(void(^)(id)) complete onError:(void(^)(NSError*)) error;

// Inbox
- (RACAsyncSubject*) inbox:(void(^)(NSArray*)) complete onError:(void(^)(NSError* error)) error;
- (RACAsyncSubject*) inbox: (JiveRequestOptions*) options onComplete:(void(^)(NSArray*)) complete onError:(void(^)(NSError* error)) error;
@end
