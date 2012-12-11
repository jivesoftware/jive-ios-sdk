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
#import "JiveResource.h"
#import "JiveTrendingContentRequestOptions.h"
#import "JiveDateLimitedRequestOptions.h"
#import "JiveActivityObject.h"
#import "JiveInboxEntry.h"
#import "JiveContentRequestOptions.h"
#import "JiveContent.h"


@protocol JiveAuthorizationDelegate;

@interface Jive : NSObject

- (id) initWithJiveInstance:(NSURL *)jiveInstanceURL authorizationDelegate:(id<JiveAuthorizationDelegate>) delegate;

// API

// People
- (void) people:(JivePeopleRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) recommendedPeople:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) trending:(JiveTrendingPeopleRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;

- (void) person:(NSString *)personId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error;
- (void) me:(void(^)(JivePerson *)) complete onError:(void(^)(NSError* error)) error;
- (void) personByEmail:(NSString *)email withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error;
- (void) personByUserName:(NSString *)userName withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error;
- (void) manager:(NSString *)personId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error;
- (void) person:(NSString *)personId reports:(NSString *)reportsPersonId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error;

- (void) activities:(NSString*) personId withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void(^)(NSArray *)) complete onError:(void(^)(NSError*)) error;
- (void) collegues:(NSString*) personId withOptions:(JivePagedRequestOptions *)options onComplete:(void(^)(NSArray *)) complete onError:(void(^)(NSError*)) error;
- (void) followers:(NSString*) personId onComplete:(void(^)(NSArray *)) complete onError:(void(^)(NSError*)) error;
- (void) followers:(NSString *)personId withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) reports:(NSString *)personId withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) following:(NSString *)personId withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;

- (void) searchPeople:(JiveSearchPeopleRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;
- (void) searchPlaces:(JiveSearchPlacesRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;
- (void) searchContents:(JiveSearchContentsRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;

- (void) blog:(NSString *)personId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error;

// Inbox
- (void) inbox:(void(^)(NSArray*)) complete onError:(void(^)(NSError* error)) error;
- (void) inbox:(JiveInboxOptions*) options onComplete:(void(^)(NSArray*)) complete onError:(void(^)(NSError* error)) error;
- (void) markInboxEntries:(NSArray *)inboxEntries asRead:(BOOL)read onComplete:(void(^)(void))completeBlock onError:(void(^)(NSError *))errorBlock;

// Environment
- (void) filterableFields:(void(^)(NSArray *))complete onError:(void(^)(NSError* error))error;
- (void) supportedFields:(void(^)(NSArray *))complete onError:(void(^)(NSError* error))error;
- (void) resources:(void(^)(NSArray *))complete onError:(void(^)(NSError* error))error;

// Places

// Contents
- (void) contents:(JiveContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) popularContents:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) recommendedContents:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) trendingContents:(JiveTrendingContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;

@end

@protocol JiveAuthorizationDelegate <NSObject>
@required
- (JiveCredentials*) credentialsForJiveInstance:(NSURL*) url;
@optional
//- (void) didReveiveOAuthActivitionResponse:(
@end
