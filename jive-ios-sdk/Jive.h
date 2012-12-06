//
//  Jive.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 9/28/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import <Foundation/Foundation.h>

// no forward declarations here since this is the framework header.
#import "JiveCredentials.h"
#import "JiveInboxOptions.h"
#import "JiveSearchParams.h"
#import "JivePagedRequestOptions.h"
#import "JiveSearchPeopleRequestOptions.h"
#import "JiveSearchPlacesRequestOptions.h"
#import "JiveSearchContentsRequestOptions.h"
#import "JivePeopleRequestOptions.h"
#import "JivePerson.h"
#import "JiveBlog.h"
#import "JiveGroup.h"
#import "JiveProject.h"
#import "JiveSpace.h"
#import "JiveSummary.h"
#import "JiveAnnouncement.h"
#import "JiveMessage.h"
#import "JiveDocument.h"
#import "JiveFile.h"
#import "JivePoll.h"
#import "JivePost.h"
#import "JiveComment.h"
#import "JiveDirectMessage.h"
#import "JiveFavorite.h"
#import "JiveTask.h"
#import "JiveUpdate.h"
#import "JivePersonJive.h"
#import "JiveName.h"
#import "JiveAddress.h"
#import "JiveEmail.h"
#import "JivePhoneNumber.h"

@protocol JiveAuthorizationDelegate;

@interface Jive : NSObject

- (id) initWithJiveInstance:(NSURL *)jiveInstanceURL authorizationDelegate:(id<JiveAuthorizationDelegate>) delegate;

// API

- (void) people:(JivePeopleRequestOptions *)params onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) person:(NSString *)personID withOptions:(JiveReturnFieldsRequestOptions *)params onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error;
- (void) me:(void(^)(JivePerson *)) complete onError:(void(^)(NSError* error)) error;

- (void) collegues:(NSString*) personId onComplete:(void(^)(id)) complete onError:(void(^)(NSError*)) error;
- (void) followers:(NSString*) personId onComplete:(void(^)(id)) complete onError:(void(^)(NSError*)) error;
- (void) followers:(NSString *)personId withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(id))complete onError:(void (^)(NSError *))error;

- (void) searchPeople:(JiveSearchPeopleRequestOptions *)params onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;
- (void) searchPlaces:(JiveSearchPlacesRequestOptions *)params onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;
- (void) searchContents:(JiveSearchContentsRequestOptions *)params onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;

// Inbox
- (void) inbox:(void(^)(NSArray*)) complete onError:(void(^)(NSError* error)) error;
- (void) inbox: (JiveInboxOptions*) options onComplete:(void(^)(NSArray*)) complete onError:(void(^)(NSError* error)) error;
@end

@protocol JiveAuthorizationDelegate <NSObject>
@required
- (JiveCredentials*) credentialsForJiveInstance:(NSURL*) url;
@optional
//- (void) didReveiveOAuthActivitionResponse:(
@end
