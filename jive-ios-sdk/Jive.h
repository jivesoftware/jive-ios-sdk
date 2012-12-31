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
#import "JiveCommentsRequestOptions.h"
#import "JiveResourceEntry.h"
#import "JAPIRequestOperation.h"

@protocol JiveAuthorizationDelegate;

@interface Jive : NSObject

- (id) initWithJiveInstance:(NSURL *)jiveInstanceURL authorizationDelegate:(id<JiveAuthorizationDelegate>) delegate;

// API

// Activities
- (void) activitiesWithOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *activities))completeBlock onError:(void (^)(NSError *error))errorBlock;

- (void) frequentContentWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (void) frequentPeopleWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *persons))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (void) frequentPlacesWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *places))completeBlock onError:(void (^)(NSError *error))errorBlock;

- (void) recentContentWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (void) recentPeopleWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (void) recentPlacesWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(void (^)(NSError *error))errorBlock;

- (JAPIRequestOperation *) activitiesOperationWithOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *activities))completeBlock onError:(void (^)(NSError *error))errorBlock;

- (JAPIRequestOperation *) frequentContentOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (JAPIRequestOperation *) frequentPeopleOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *persons))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (JAPIRequestOperation *) frequentPlacesOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *places))completeBlock onError:(void (^)(NSError *error))errorBlock;

- (JAPIRequestOperation *) recentContentOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (JAPIRequestOperation *) recentPeopleOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (JAPIRequestOperation *) recentPlacesOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(void (^)(NSError *error))errorBlock;

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
- (void) followers:(NSString *)personId onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) followers:(NSString *)personId withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) reports:(NSString *)personId withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) following:(NSString *)personId withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;

- (void) blog:(NSString *)personId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveBlog *))complete onError:(void (^)(NSError *))error;

// People Operations
- (JAPIRequestOperation *) peopleOperation:(JivePeopleRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (JAPIRequestOperation *) recommendedPeopleOperation:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (JAPIRequestOperation *) trendingOperation:(JiveTrendingPeopleRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;

- (JAPIRequestOperation *) personOperation:(NSString *)personId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error;
- (JAPIRequestOperation *) meOperation:(void(^)(JivePerson *))complete onError:(void(^)(NSError* error))error;
- (JAPIRequestOperation *) personByEmailOperation:(NSString *)email withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error;
- (JAPIRequestOperation *) personByUserNameOperation:(NSString *)userName withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error;
- (JAPIRequestOperation *) managerOperation:(NSString *)personId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error;
- (JAPIRequestOperation *) person:(NSString *)personId reportsOperation:(NSString *)reportsPersonId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error;

- (JAPIRequestOperation *) activitiesOperation:(NSString*) personId withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void(^)(NSArray *)) complete onError:(void(^)(NSError*)) error;
- (JAPIRequestOperation *) colleguesOperation:(NSString*)personId withOptions:(JivePagedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;
- (JAPIRequestOperation *) followersOperation:(NSString*)personId onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;
- (JAPIRequestOperation *) followersOperation:(NSString*)personId withOptions:(JivePagedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;
- (JAPIRequestOperation *) reportsOperation:(NSString *)personId withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (JAPIRequestOperation *) followingOperation:(NSString *)personId withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;

- (JAPIRequestOperation *) blogOperation:(NSString *)personId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveBlog *))complete onError:(void (^)(NSError *))error;

// Search
- (void) searchPeople:(JiveSearchPeopleRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;
- (void) searchPlaces:(JiveSearchPlacesRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;
- (void) searchContents:(JiveSearchContentsRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;

// Search Operations
- (JAPIRequestOperation*) searchPeopleRequestOperation:(JiveSearchPeopleRequestOptions *)options onComplete:(void (^) (NSArray *people))complete onError:(void (^)(NSError *))error;
- (JAPIRequestOperation*) searchPlacesRequestOperation:(JiveSearchPlacesRequestOptions *)options onComplete:(void (^)(NSArray *places))complete onError:(void (^)(NSError *))error;
- (JAPIRequestOperation*) searchContentsRequestOperation:(JiveSearchContentsRequestOptions *)options onComplete:(void (^)(NSArray *contents))complete onError:(void (^)(NSError *))error;

// Inbox
- (void) inbox:(void(^)(NSArray*)) complete onError:(void(^)(NSError* error)) error;
- (void) inbox:(JiveInboxOptions*) options onComplete:(void(^)(NSArray*)) complete onError:(void(^)(NSError* error)) error;
- (void) markInboxEntries:(NSArray *)inboxEntries asRead:(BOOL)read onComplete:(void(^)(void))completeBlock onError:(void(^)(NSError *))errorBlock;
- (void) markInboxEntryUpdates:(NSArray *)inboxEntryUpdates asRead:(BOOL)read onComplete:(void(^)(void))completeBlock onError:(void(^)(NSError *))errorBlock;

// Environment
- (void) filterableFields:(void(^)(NSArray *))complete onError:(void(^)(NSError* error))error;
- (void) supportedFields:(void(^)(NSArray *))complete onError:(void(^)(NSError* error))error;
- (void) resources:(void(^)(NSArray *))complete onError:(void(^)(NSError* error))error;

// Environment Operations
- (JAPIRequestOperation *) filterableFieldsOperation:(void(^)(NSArray *))complete onError:(void(^)(NSError* error))error;
- (JAPIRequestOperation *) supportedFieldsOperation:(void(^)(NSArray *))complete onError:(void(^)(NSError* error))error;
- (JAPIRequestOperation *) resourcesOperation:(void(^)(NSArray *))complete onError:(void(^)(NSError* error))error;

// Places
- (void) places:(JivePlacesRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) recommendedPlaces:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) trendingPlaces:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) placePlaces:(NSString *)placeId withOptions:(JivePlacePlacesRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;

- (void) place:(NSString *)placeId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *))complete onError:(void (^)(NSError *))error;
- (void) placeActivities:(NSString*)placeId withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;

// Places Operations
- (JAPIRequestOperation *) placesOperation:(JivePlacesRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (JAPIRequestOperation *) recommendedPlacesOperation:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (JAPIRequestOperation *) trendingPlacesOperation:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (JAPIRequestOperation *) placePlacesOperation:(NSString *)placeId withOptions:(JivePlacePlacesRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;

- (JAPIRequestOperation *) placeOperation:(NSString *)placeId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *))complete onError:(void (^)(NSError *))error;
- (JAPIRequestOperation *) placeActivitiesOperation:(NSString*)placeId withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;

// Contents
- (void) contentFromURL:(NSURL *)contentURL onComplete:(void (^)(JiveContent *content))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (void) contents:(JiveContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) popularContents:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) recommendedContents:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) trendingContents:(JiveTrendingContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;

- (void) content:(NSString *)contentId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(void (^)(NSError *))error;
- (void) commentsForContent:(NSString *)contentId withOptions:(JiveCommentsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) contentLikedBy:(NSString *)contentId withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;

- (void) activityObject:(JiveActivityObject *) activityObject contentWithCompleteBlock:(void(^)(JiveContent *content))completeBlock errorBlock:(void(^)(NSError *error))errorBlock;
- (void) comment:(JiveComment *) comment rootContentWithCompleteBlock:(void(^)(JiveContent *rootContent))completeBlock errorBlock:(void(^)(NSError *error))errorBlock;

// Contents
- (JAPIRequestOperation *) contentsOperation:(JiveContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (JAPIRequestOperation *) popularContentsOperation:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (JAPIRequestOperation *) recommendedContentsOperation:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (JAPIRequestOperation *) trendingContentsOperation:(JiveTrendingContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;

- (JAPIRequestOperation *) contentOperation:(NSString *)contentId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(void (^)(NSError *))error;
- (JAPIRequestOperation *) commentsForContentOperation:(NSString *)contentId withOptions:(JiveCommentsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (JAPIRequestOperation *) contentLikedByOperation:(NSString *)contentId withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;

@end

@protocol JiveAuthorizationDelegate <NSObject>
@required
- (JiveCredentials*) credentialsForJiveInstance:(NSURL*) url;
@optional
//- (void) didReveiveOAuthActivitionResponse:(
@end
