//
//  Jive.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 9/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JiveCredentials;
@class JiveRequestOptions;
@class JiveSearchParams;

@protocol JiveAuthorizationDelegate <NSObject>
@required
- (JiveCredentials*) credentialsForJiveInstance:(NSURL*) url;
@optional
//- (void) didReveiveOAuthActivitionResponse:(
@end

@interface Jive : NSObject

- (id) initWithJiveInstance:(NSURL *)jiveInstanceURL authorizationDelegate:(id<JiveAuthorizationDelegate>) delegate;

// API

- (void) me:(void(^)(id JSON)) complete onError:(void(^)(NSError* error)) error;

- (void) collegues:(NSString*) personId onComplete:(void(^)(id)) complete onError:(void(^)(NSError*)) error;
- (void) followers:(NSString*) personId onComplete:(void(^)(id)) complete onError:(void(^)(NSError*)) error;

- (void) search:(JiveSearchParams *)params onComplete:(void(^)(id)) complete onError:(void(^)(NSError*)) error;

// Inbox
- (void) inbox:(void(^)(NSArray*)) complete onError:(void(^)(NSError* error)) error;
- (void) inbox: (JiveRequestOptions*) options onComplete:(void(^)(NSArray*)) complete onError:(void(^)(NSError* error)) error;
@end
