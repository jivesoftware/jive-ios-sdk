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
#import "JiveAnnouncementRequestOptions.h"
#import "JiveDefinedSizeRequestOptions.h"
#import "JiveStateRequestOptions.h"
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
#import "JiveMember.h"
#import "JiveStream.h"
#import "JiveAssociationsRequestOptions.h"
#import "JiveSearchContentParams.h"
#import "JiveContent.h"
#import "JivePerson.h"
#import "JivePlace.h"
#import "JiveExtension.h"

@protocol JiveAuthorizationDelegate;

@interface Jive : NSObject

- (id) initWithJiveInstance:(NSURL *)jiveInstanceURL authorizationDelegate:(id<JiveAuthorizationDelegate>) delegate;

#pragma mark - Activities

- (void) activitiesWithOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *activities))completeBlock onError:(void (^)(NSError *error))errorBlock;

- (void) frequentContentWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (void) frequentPeopleWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *persons))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (void) frequentPlacesWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *places))completeBlock onError:(void (^)(NSError *error))errorBlock;

- (void) recentContentWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (void) recentPeopleWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (void) recentPlacesWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(void (^)(NSError *error))errorBlock;

- (NSOperation *) activitiesOperationWithOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *activities))completeBlock onError:(void (^)(NSError *error))errorBlock;

- (NSOperation *) frequentContentOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (NSOperation *) frequentPeopleOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *persons))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (NSOperation *) frequentPlacesOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *places))completeBlock onError:(void (^)(NSError *error))errorBlock;

- (NSOperation *) recentContentOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (NSOperation *) recentPeopleOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (NSOperation *) recentPlacesOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(void (^)(NSError *error))errorBlock;

#pragma mark - Announcements

- (void) announcementsWithOptions:(JiveAnnouncementRequestOptions *)options onComplete:(void (^)(NSArray *announcements))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (void) announcementWithAnnouncement:(JiveAnnouncement *)announcement options:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveAnnouncement *announcement))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (void) deleteAnnouncement:(JiveAnnouncement *)announcement onComplete:(void (^)(void))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (void) markAnnouncement:(JiveAnnouncement *)announcement asRead:(BOOL)read onComplete:(void (^)(void))completeBlock onError:(void (^)(NSError *error))errorBlock;

- (NSOperation *) announcementsOperationWithOptions:(JiveAnnouncementRequestOptions *)options onComplete:(void (^)(NSArray *announcements))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (NSOperation *) announcementOperationWithAnnouncement:(JiveAnnouncement *)announcement options:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveAnnouncement *announcement))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (NSOperation *) deleteAnnouncementOperationWithAnnouncement:(JiveAnnouncement *)announcement onComplete:(void (^)(void))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (NSOperation *) markAnnouncementOperationWithAnnouncement:(JiveAnnouncement *)announcement asRead:(BOOL)read onComplete:(void (^)(void))completeBlock onError:(void (^)(NSError *error))errorBlock;

#pragma mark - People

- (void) people:(JivePeopleRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) recommendedPeople:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) trending:(JiveTrendingPeopleRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;

- (void) person:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error;
- (void) me:(void(^)(JivePerson *)) complete onError:(void(^)(NSError* error)) error;
- (void) personByEmail:(NSString *)email withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error;
- (void) personByUserName:(NSString *)userName withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error;
- (void) manager:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error;
- (void) person:(NSString *)personId reports:(NSString *)reportsPersonId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error;
- (void) deletePerson:(JivePerson *)person onComplete:(void (^)(void))complete onError:(void (^)(NSError *))error;
- (void) avatarForPerson:(JivePerson *)person onComplete:(void (^)(UIImage *avatarImage))complete onError:(void (^)(NSError *error))error;

- (void) activities:(JivePerson *)person withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;
- (void) collegues:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;
- (void) followers:(JivePerson *)person onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) followers:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) reports:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) following:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) followingIn:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) streams:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) tasks:(JivePerson *)person withOptions:(JiveSortedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;

- (void) blog:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveBlog *))complete onError:(void (^)(NSError *))error;

- (NSOperation *) peopleOperation:(JivePeopleRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (NSOperation *) recommendedPeopleOperation:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (NSOperation *) trendingOperation:(JiveTrendingPeopleRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;

- (NSOperation *) personOperation:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error;
- (NSOperation *) meOperation:(void(^)(JivePerson *))complete onError:(void(^)(NSError* error))error;
- (NSOperation *) personByEmailOperation:(NSString *)email withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error;
- (NSOperation *) personByUserNameOperation:(NSString *)userName withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error;
- (NSOperation *) managerOperation:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error;
- (NSOperation *) person:(NSString *)personId reportsOperation:(NSString *)reportsPersonId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(void (^)(NSError *))error;
- (NSOperation *) deletePersonOperation:(JivePerson *)person onComplete:(void (^)(void))complete onError:(void (^)(NSError *))error;
- (NSOperation *) avatarForPersonOperation:(JivePerson *)person onComplete:(void (^)(UIImage *avatarImage))complete onError:(void (^)(NSError *error))error;

- (NSOperation *) activitiesOperation:(JivePerson *)person withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;
- (NSOperation *) colleguesOperation:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;
- (NSOperation *) followersOperation:(JivePerson *)person onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;
- (NSOperation *) followersOperation:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;
- (NSOperation *) reportsOperation:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (NSOperation *) followingOperation:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (NSOperation *) followingInOperation:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (NSOperation *) streamsOperation:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (NSOperation *) tasksOperation:(JivePerson *)person withOptions:(JiveSortedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;

- (NSOperation *) blogOperation:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveBlog *))complete onError:(void (^)(NSError *))error;


#pragma mark - search

- (void) searchPeople:(JiveSearchPeopleRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;
- (void) searchPlaces:(JiveSearchPlacesRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;
- (void) searchContents:(JiveSearchContentsRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;

- (NSOperation*) searchPeopleRequestOperation:(JiveSearchPeopleRequestOptions *)options onComplete:(void (^) (NSArray *people))complete onError:(void (^)(NSError *))error;
- (NSOperation*) searchPlacesRequestOperation:(JiveSearchPlacesRequestOptions *)options onComplete:(void (^)(NSArray *places))complete onError:(void (^)(NSError *))error;
- (NSOperation*) searchContentsRequestOperation:(JiveSearchContentsRequestOptions *)options onComplete:(void (^)(NSArray *contents))complete onError:(void (^)(NSError *))error;

#pragma mark - Inbox

- (void) inbox:(void(^)(NSArray*)) complete onError:(void(^)(NSError* error)) error;
- (void) inbox:(JiveInboxOptions*) options onComplete:(void(^)(NSArray*)) complete onError:(void(^)(NSError* error)) error;
- (void) markInboxEntries:(NSArray *)inboxEntries asRead:(BOOL)read onComplete:(void(^)(void))completeBlock onError:(void(^)(NSError *))errorBlock;
- (void) markInboxEntryUpdates:(NSArray *)inboxEntryUpdates asRead:(BOOL)read onComplete:(void(^)(void))completeBlock onError:(void(^)(NSError *))errorBlock;

#pragma mark - Environment

- (void) filterableFields:(void(^)(NSArray *))complete onError:(void(^)(NSError* error))error;
- (void) supportedFields:(void(^)(NSArray *))complete onError:(void(^)(NSError* error))error;
- (void) resources:(void(^)(NSArray *))complete onError:(void(^)(NSError* error))error;

- (NSOperation *) filterableFieldsOperation:(void(^)(NSArray *))complete onError:(void(^)(NSError* error))error;
- (NSOperation *) supportedFieldsOperation:(void(^)(NSArray *))complete onError:(void(^)(NSError* error))error;
- (NSOperation *) resourcesOperation:(void(^)(NSArray *))complete onError:(void(^)(NSError* error))error;

#pragma mark - Places

- (void) places:(JivePlacesRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) recommendedPlaces:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) trendingPlaces:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) placePlaces:(JivePlace *)place withOptions:(JivePlacePlacesRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;

- (void) place:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *))complete onError:(void (^)(NSError *))error;
- (void) placeActivities:(JivePlace *)place withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;
- (void) placeFollowingIn:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;

- (void) deletePlace:(JivePlace *)place onComplete:(void (^)(void))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (void) deleteAvatarForPlace:(JivePlace *)place onComplete:(void (^)(void))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (void) announcementsForPlace:(JivePlace *)place options:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *announcements))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (void) avatarForPlace:(JivePlace *)place options:(JiveDefinedSizeRequestOptions *)options onComplete:(void (^)(UIImage *avatarImage))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (void) tasksForPlace:(JivePlace *)place options:(JiveSortedRequestOptions *)options onComplete:(void (^)(NSArray *tasks))completeBlock onError:(void (^)(NSError *error))errorBlock;

- (NSOperation *) placesOperation:(JivePlacesRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (NSOperation *) recommendedPlacesOperation:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (NSOperation *) trendingPlacesOperation:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (NSOperation *) placePlacesOperation:(JivePlace *)place withOptions:(JivePlacePlacesRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;

- (NSOperation *) placeOperation:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *))complete onError:(void (^)(NSError *))error;
- (NSOperation *) placeActivitiesOperation:(JivePlace *)place withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;
- (NSOperation *) placeFollowingInOperation:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;

- (NSOperation *) deletePlaceOperationWithPlace:(JivePlace *)place onComplete:(void (^)(void))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (NSOperation *) deleteAvatarOperationForPlace:(JivePlace *)place onComplete:(void (^)(void))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (NSOperation *) announcementsOperationForPlace:(JivePlace *)place options:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *announcements))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (NSOperation *) avatarOperationForPlace:(JivePlace *)place options:(JiveDefinedSizeRequestOptions *)options onComplete:(void (^)(UIImage *avatarImage))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (NSOperation *) tasksOperationForPlace:(JivePlace *)place options:(JiveSortedRequestOptions *)options onComplete:(void (^)(NSArray *tasks))completeBlock onError:(void (^)(NSError *error))errorBlock;

#pragma mark - Contents

- (void) contentFromURL:(NSURL *)contentURL onComplete:(void (^)(JiveContent *content))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (void) contents:(JiveContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) popularContents:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) recommendedContents:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) trendingContents:(JiveTrendingContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;

- (void) content:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(void (^)(NSError *))error;
- (void) commentsForContent:(JiveContent *)content withOptions:(JiveCommentsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) contentLikedBy:(JiveContent *)content withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) contentFollowingIn:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) content:(JiveContent *)content markAsRead:(BOOL)read onComplete:(void (^)(void))complete onError:(void (^)(NSError *error))error;
- (void) content:(JiveContent *)content likes:(BOOL)read onComplete:(void (^)(void))complete onError:(void (^)(NSError *error))error;

- (void) activityObject:(JiveActivityObject *) activityObject contentWithCompleteBlock:(void(^)(JiveContent *content))completeBlock errorBlock:(void(^)(NSError *error))errorBlock;
- (void) comment:(JiveComment *) comment rootContentWithCompleteBlock:(void(^)(JiveContent *rootContent))completeBlock errorBlock:(void(^)(NSError *error))errorBlock;

- (NSOperation *) contentsOperation:(JiveContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (NSOperation *) popularContentsOperation:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (NSOperation *) recommendedContentsOperation:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (NSOperation *) trendingContentsOperation:(JiveTrendingContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;

- (NSOperation *) contentOperation:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(void (^)(NSError *))error;
- (NSOperation *) commentsOperationForContent:(JiveContent *)content withOptions:(JiveCommentsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (NSOperation *) contentLikedByOperation:(JiveContent *)content withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (NSOperation *) contentFollowingInOperation:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (NSOperation *) contentOperation:(JiveContent *)content markAsRead:(BOOL)read onComplete:(void (^)(void))complete onError:(void (^)(NSError *error))error;
- (NSOperation *) contentOperation:(JiveContent *)content likes:(BOOL)read onComplete:(void (^)(void))complete onError:(void (^)(NSError *error))error;

#pragma mark - Members

- (void) deleteMember:(JiveMember *)member onComplete:(void (^)(void))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (void) memberWithMember:(JiveMember *)member options:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveMember *member))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (void) membersForGroup:(JiveGroup *)group options:(JiveStateRequestOptions *)options onComplete:(void (^)(NSArray *members))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (void) membersForPerson:(JivePerson *)person options:(JiveStateRequestOptions *)options onComplete:(void (^)(NSArray *members))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (void) updateMember:(JiveMember *)member withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveMember *member))complete onError:(void (^)(NSError *error))error;

- (NSOperation *) deleteMemberOperationWithMember:(JiveMember *)member onComplete:(void (^)(void))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (NSOperation *) memberOperationWithMember:(JiveMember *)member options:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveMember *member))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (NSOperation *) membersOperationForGroup:(JiveGroup *)group options:(JiveStateRequestOptions *)options onComplete:(void (^)(NSArray *members))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (NSOperation *) membersOperationForPerson:(JivePerson *)person options:(JiveStateRequestOptions *)options onComplete:(void (^)(NSArray *members))completeBlock onError:(void (^)(NSError *error))errorBlock;
- (NSOperation *) updateMemberOperation:(JiveMember *)member withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveMember *member))complete onError:(void (^)(NSError *error))error;

#pragma mark - Streams

- (void) deleteStream:(JiveStream *)stream onComplete:(void (^)(void))complete onError:(void (^)(NSError *error))error;
- (void) streamConnectionsActivities:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (void) stream:(JiveStream *)stream withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveStream *))complete onError:(void (^)(NSError *))error;
- (void) streamActivities:(JiveStream *)stream withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;
- (void) streamAssociations:(JiveStream *)stream withOptions:(JiveAssociationsRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;
- (void) updateStream:(JiveStream *)stream withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveStream *))complete onError:(void (^)(NSError *))error;

- (NSOperation *) deleteStreamOperation:(JiveStream *)stream onComplete:(void (^)(void))complete onError:(void (^)(NSError *error))error;
- (NSOperation *) streamConnectionsActivitiesOperation:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(void (^)(NSError *))error;
- (NSOperation *) streamOperation:(JiveStream *)stream withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveStream *))complete onError:(void (^)(NSError *))error;
- (NSOperation *) streamActivitiesOperation:(JiveStream *)stream withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;
- (NSOperation *) streamAssociationsOperation:(JiveStream *)stream withOptions:(JiveAssociationsRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(void(^)(NSError*))error;
- (NSOperation *) updateStreamOperation:(JiveStream *)stream withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveStream *))complete onError:(void (^)(NSError *))error;

@end

@protocol JiveAuthorizationDelegate <NSObject>
@required
- (JiveCredentials*) credentialsForJiveInstance:(NSURL*) url;
@optional
//- (void) didReveiveOAuthActivitionResponse:(
@end
