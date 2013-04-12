//
//  Jive.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 9/28/12.
//
//    Copyright 2013 Jive Software Inc.
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.
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
#import "JiveDiscussion.h"
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
#import "JiveActivity.h"
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
#import "JiveMinorCommentRequestOptions.h"
#import "JiveInvite.h"
#import "JiveTargetList.h"
#import "JiveWelcomeRequestOptions.h"
#import "JiveAuthorCommentRequestOptions.h"
#import "JiveAssociationTargetList.h"
#import "JiveImage.h"
#import "JiveVideo.h"
#import "JiveOutcome.h"
#import "JiveOutcomeType.h"
#import "JiveOutcomeRequestOptions.h"
#import "JivePlatformVersion.h"
#import "JiveCoreVersion.h"

typedef void (^JiveErrorBlock)(NSError *error);
typedef void (^JiveDateLimitedObjectsCompleteBlock)(NSArray *objects, NSDate *earliestDate, NSDate *latestDate);

@protocol JiveAuthorizationDelegate;

//! \class Jive
@interface Jive : NSObject

//! Use this method, or the operation version, before creating a Jive instance to make sure you can make a Jive instance.
+ (void) getVersionForInstance:(NSURL *)jiveInstanceURL onComplete:(void (^)(JivePlatformVersion *version))completeBlock onError:(JiveErrorBlock)errorBlock;
//! Use this method, or the non-operation version, before creating a Jive instance to make sure you can make a Jive instance.
+ (NSOperation *) getVersionOperationForInstance:(NSURL *)jiveInstanceURL onComplete:(void (^)(JivePlatformVersion *version))completeBlock onError:(JiveErrorBlock)errorBlock;

//! The init method to used when creating a Jive instance for a specific URL and credentials.
- (id) initWithJiveInstance:(NSURL *)jiveInstanceURL authorizationDelegate:(id<JiveAuthorizationDelegate>) delegate;

//! The URL used to init this jive instance.
- (NSURL*) jiveInstanceURL;

#pragma mark - Activities

//! https://developers.jivesoftware.com/api/v3/rest/ActivityService.html#getActivity(String,%20String,%20int,%20String)
- (void) activitiesWithOptions:(JiveDateLimitedRequestOptions *)options onComplete:(JiveDateLimitedObjectsCompleteBlock)completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/ActionService.html#getActions(String,%20String,%20int,%20List<String>,%20String)
- (void) actions:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *activities))complete onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/ActivityService.html#getFrequentContent(int,%20String)
- (void) frequentContentWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/ActivityService.html#getFrequentPeople(int,%20String)
- (void) frequentPeopleWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *persons))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/ActivityService.html#getFrequentPlaces(int,%20String)
- (void) frequentPlacesWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *places))completeBlock onError:(JiveErrorBlock)errorBlock;

//! https://developers.jivesoftware.com/api/v3/rest/ActivityService.html#getRecentContent(int,%20String)
- (void) recentContentWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/ActivityService.html#getRecentPeople(int,%20String)
- (void) recentPeopleWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/ActivityService.html#getRecentPlaces(int,%20String)
- (void) recentPlacesWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(JiveErrorBlock)errorBlock;

//! https://developers.jivesoftware.com/api/v3/rest/ActivityService.html#getActivity(String,%20String,%20int,%20String)
- (NSOperation *) activitiesOperationWithOptions:(JiveDateLimitedRequestOptions *)options onComplete:(JiveDateLimitedObjectsCompleteBlock)completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/ActivityService.html#getActivity(String,%20String,%20int,%20String)
- (NSOperation *) activitiesOperationWithURL:(NSURL *)activitiesURL onComplete:(JiveDateLimitedObjectsCompleteBlock)completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/ActionService.html#getActions(String,%20String,%20int,%20List<String>,%20String)
- (NSOperation *) actionsOperation:(JiveDateLimitedRequestOptions *)options onComplete:(void (^)(NSArray *activities))complete onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/ActivityService.html#getFrequentContent(int,%20String)
- (NSOperation *) frequentContentOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/ActivityService.html#getFrequentPeople(int,%20String)
- (NSOperation *) frequentPeopleOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *persons))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/ActivityService.html#getFrequentPlaces(int,%20String)
- (NSOperation *) frequentPlacesOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *places))completeBlock onError:(JiveErrorBlock)errorBlock;

//! https://developers.jivesoftware.com/api/v3/rest/ActivityService.html#getRecentContent(int,%20String)
- (NSOperation *) recentContentOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/ActivityService.html#getRecentPeople(int,%20String)
- (NSOperation *) recentPeopleOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/ActivityService.html#getRecentPlaces(int,%20String)
- (NSOperation *) recentPlacesOperationWithOptions:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *contents))completeBlock onError:(JiveErrorBlock)errorBlock;

#pragma mark - Announcements

//! https://developers.jivesoftware.com/api/v3/rest/AnnouncementService.html#getSystemAnnouncements(int,%20int,%20boolean,%20String)
- (void) announcementsWithOptions:(JiveAnnouncementRequestOptions *)options onComplete:(void (^)(NSArray *announcements))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/AnnouncementService.html#getAnnouncement(String,%20String)
- (void) announcementWithAnnouncement:(JiveAnnouncement *)announcement options:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveAnnouncement *announcement))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/AnnouncementService.html#deleteAnnouncement(String)
- (void) deleteAnnouncement:(JiveAnnouncement *)announcement onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/AnnouncementService.html#markRead(String)
- (void) markAnnouncement:(JiveAnnouncement *)announcement asRead:(BOOL)read onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock;

//! https://developers.jivesoftware.com/api/v3/rest/AnnouncementService.html#getSystemAnnouncements(int,%20int,%20boolean,%20String)
- (NSOperation *) announcementsOperationWithOptions:(JiveAnnouncementRequestOptions *)options onComplete:(void (^)(NSArray *announcements))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/AnnouncementService.html#getAnnouncement(String,%20String)
- (NSOperation *) announcementOperationWithAnnouncement:(JiveAnnouncement *)announcement options:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveAnnouncement *announcement))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/AnnouncementService.html#deleteAnnouncement(String)
- (NSOperation *) deleteAnnouncementOperationWithAnnouncement:(JiveAnnouncement *)announcement onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/AnnouncementService.html#markRead(String)
- (NSOperation *) markAnnouncementOperationWithAnnouncement:(JiveAnnouncement *)announcement asRead:(BOOL)read onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock;

#pragma mark - People

- (void)personFromURL:(NSURL *)personURL onComplete:(void (^)(JivePerson *person))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getPeople(String,%20String,%20int,%20int,%20String,%20List<String>,%20String)
- (void) people:(JivePeopleRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getRecommendedPeople(int,%20String)
- (void) recommendedPeople:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getTrendingPeople(List<String>,%20int,%20String)
- (void) trending:(JiveTrendingPeopleRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#createPerson(PersonEntity,%20Boolean,%20String)
- (void) createPerson:(JivePerson *)person withOptions:(JiveWelcomeRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#createTask(String,%20String,%20String)
- (void) createTask:(JiveTask *)task forPerson:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveTask *))complete onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getPerson(String,%20String)
- (void) person:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error;
//! Retrive the JivePerson object for the current user.
- (void) me:(void(^)(JivePerson *)) complete onError:(JiveErrorBlock) error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getPersonByEmail(String,%20String)
- (void) personByEmail:(NSString *)email withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getPersonByUsername(String,%20String)
- (void) personByUserName:(NSString *)userName withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getManager(String,%20String)
- (void) manager:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getReport(String,%20String,%20String)
- (void) person:(NSString *)personId reports:(NSString *)reportsPersonId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#deletePerson(String,%20UriInfo)
- (void) deletePerson:(JivePerson *)person onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getAvatar(String)
- (void) avatarForPerson:(JivePerson *)person onComplete:(void (^)(UIImage *avatarImage))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#updatePerson(String,%20PersonEntity)
- (void) updatePerson:(JivePerson *)person onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#createFollowing(String,%20String)
- (void) person:(JivePerson *)person follow:(JivePerson *)target onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getActivity(String,%20String,%20String,%20int,%20String)
- (void) activities:(JivePerson *)person withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getColleagues(String,%20int,%20int,%20String)
- (void) collegues:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error;
- (void) followers:(JivePerson *)person onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getFollowers(String,%20int,%20int,%20String)
- (void) followers:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getReports(String,%20int,%20int,%20String)
- (void) reports:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getFollowing(String,%20int,%20int,%20String)
- (void) following:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getFollowingIn(String,%20String)
- (void) followingIn:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getStreams(String,%20String)
- (void) streams:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getTasks(String,%20String,%20int,%20int,%20String)
- (void) tasks:(JivePerson *)person withOptions:(JiveSortedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getBlog(String,%20String)
- (void) blog:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveBlog *))complete onError:(JiveErrorBlock)errorBlock;

- (NSOperation *)personOperationWithURL:(NSURL *)personURL onComplete:(void (^)(JivePerson *person))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getPeople(String,%20String,%20int,%20int,%20String,%20List<String>,%20String)
- (NSOperation *) peopleOperation:(JivePeopleRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getRecommendedPeople(int,%20String)
- (NSOperation *) recommendedPeopleOperation:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getTrendingPeople(List<String>,%20int,%20String)
- (NSOperation *) trendingOperation:(JiveTrendingPeopleRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#createPerson(PersonEntity,%20Boolean,%20String)
- (NSOperation *) createPersonOperation:(JivePerson *)person withOptions:(JiveWelcomeRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#createTask(String,%20String,%20String)
- (NSOperation *) createTaskOperation:(JiveTask *)task forPerson:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveTask *))complete onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getPerson(String,%20String)
- (NSOperation *) personOperation:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error;
//! Create an NSOperation to retrieve the JivePerson object for the current user.
- (NSOperation *) meOperation:(void(^)(JivePerson *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getPersonByEmail(String,%20String)
- (NSOperation *) personByEmailOperation:(NSString *)email withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getPersonByUsername(String,%20String)
- (NSOperation *) personByUserNameOperation:(NSString *)userName withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getManager(String,%20String)
- (NSOperation *) managerOperation:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getReport(String,%20String,%20String)
- (NSOperation *) person:(NSString *)personId reportsOperation:(NSString *)reportsPersonId withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#deletePerson(String,%20UriInfo)
- (NSOperation *) deletePersonOperation:(JivePerson *)person onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getAvatar(String)
- (NSOperation *) avatarForPersonOperation:(JivePerson *)person onComplete:(void (^)(UIImage *avatarImage))complete onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#updatePerson(String,%20PersonEntity)
- (NSOperation *) updatePersonOperation:(JivePerson *)person onComplete:(void (^)(JivePerson *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#createFollowing(String,%20String)
- (NSOperation *) personOperation:(JivePerson *)person follow:(JivePerson *)target onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getActivity(String,%20String,%20String,%20int,%20String)
- (NSOperation *) activitiesOperation:(JivePerson *)person withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getColleagues(String,%20int,%20int,%20String)
- (NSOperation *) colleguesOperation:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error;
- (NSOperation *) followersOperation:(JivePerson *)person onComplete:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getFollowers(String,%20int,%20int,%20String)
- (NSOperation *) followersOperation:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getReports(String,%20int,%20int,%20String)
- (NSOperation *) reportsOperation:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getFollowing(String,%20int,%20int,%20String)
- (NSOperation *) followingOperation:(JivePerson *)person withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getFollowingIn(String,%20String)
- (NSOperation *) followingInOperation:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getStreams(String,%20String)
- (NSOperation *) streamsOperation:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getTasks(String,%20String,%20int,%20int,%20String)
- (NSOperation *) tasksOperation:(JivePerson *)person withOptions:(JiveSortedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getBlog(String,%20String)
- (NSOperation *) blogOperation:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveBlog *))complete onError:(JiveErrorBlock)error;


#pragma mark - search

//! https://developers.jivesoftware.com/api/v3/rest/SearchService.html#searchPeople(List<String>,%20String,%20int,%20int,%20String)
- (void) searchPeople:(JiveSearchPeopleRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/SearchService.html#searchPlaces(List<String>,%20boolean,%20String,%20int,%20int,%20String)
- (void) searchPlaces:(JiveSearchPlacesRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/SearchService.html#searchContents(List<String>,%20boolean,%20String,%20int,%20int,%20String)
- (void) searchContents:(JiveSearchContentsRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/SearchService.html#searchPeople(List<String>,%20String,%20int,%20int,%20String)
- (NSOperation*) searchPeopleRequestOperation:(JiveSearchPeopleRequestOptions *)options onComplete:(void (^) (NSArray *people))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/SearchService.html#searchPlaces(List<String>,%20boolean,%20String,%20int,%20int,%20String)
- (NSOperation*) searchPlacesRequestOperation:(JiveSearchPlacesRequestOptions *)options onComplete:(void (^)(NSArray *places))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/SearchService.html#searchContents(List<String>,%20boolean,%20String,%20int,%20int,%20String)
- (NSOperation*) searchContentsRequestOperation:(JiveSearchContentsRequestOptions *)options onComplete:(void (^)(NSArray *contents))complete onError:(JiveErrorBlock)error;

#pragma mark - Inbox

//! https://developers.jivesoftware.com/api/v3/rest/InboxService.html#getActivity(String,%20String,%20int,%20List<String>,%20String)
- (void) inbox:(JiveInboxOptions*) options onComplete:(JiveDateLimitedObjectsCompleteBlock)completeBlock onError:(JiveErrorBlock)errorBlock;
- (void) markInboxEntries:(NSArray *)inboxEntries asRead:(BOOL)read onComplete:(void(^)(void))completeBlock onError:(JiveErrorBlock)errorBlock;
- (void) markInboxEntryUpdates:(NSArray *)inboxEntryUpdates asRead:(BOOL)read onComplete:(void(^)(void))completeBlock onError:(JiveErrorBlock)errorBlock;

- (NSOperation *)inboxOperation:(JiveInboxOptions *)options onComplete:(JiveDateLimitedObjectsCompleteBlock)completeBlock onError:(JiveErrorBlock)errorBlock;

#pragma mark - Environment

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getFilterableFields()
- (void) filterableFields:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getSupportedFields()
- (void) supportedFields:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getResources()
- (void) resources:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getFilterableFields()
- (NSOperation *) filterableFieldsOperation:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getSupportedFields()
- (NSOperation *) supportedFieldsOperation:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getResources()
- (NSOperation *) resourcesOperation:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error;

#pragma mark - Places

//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#getPlaces(List<String>,%20String,%20int,%20int,%20String)
- (void) places:(JivePlacesRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#getRecommendedPlaces(int,%20String)
- (void) recommendedPlaces:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#getTrendingPlaces(int,%20String)
- (void) trendingPlaces:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#getPlacePlaces(String,%20int,%20int,%20String,%20List<String>,%20String)
- (void) placePlaces:(JivePlace *)place withOptions:(JivePlacePlacesRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#createPlace(String,%20String)
- (void) createPlace:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#createPlaceTask(String,%20String,%20String)
- (void) createTask:(JiveTask *)task forPlace:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveTask *))complete onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#getPlace(String,%20String)
- (void)placeFromURL:(NSURL *)placeURL withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *place))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#getPlace(String,%20String)
- (NSOperation *)placeOperationWithURL:(NSURL *)placeURL withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *person))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#getPlace(String,%20String)
- (void) place:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#getActivity(String,%20String,%20String,%20int,%20String)
- (void) placeActivities:(JivePlace *)place withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#getPlaceFollowingIn(String,%20String)
- (void) placeFollowingIn:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#updatePlace(String,%20String,%20String)
- (void) updatePlace:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/InviteService.html#getInvites(String,%20int,%20int,%20String,%20String,%20String)
- (void) invites:(JivePlace *)place withOptions:(JivePagedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#deletePlace(String)
- (void) deletePlace:(JivePlace *)place onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#deletePlaceAvatar(String)
- (void) deleteAvatarForPlace:(JivePlace *)place onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#getPlaceAnnouncements(String,%20int,%20int,%20boolean,%20String)
- (void) announcementsForPlace:(JivePlace *)place options:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *announcements))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#getPlaceAvatar(String,%20String)
- (void) avatarForPlace:(JivePlace *)place options:(JiveDefinedSizeRequestOptions *)options onComplete:(void (^)(UIImage *avatarImage))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#getPlaceTasks(String,%20String,%20int,%20int,%20String)
- (void) tasksForPlace:(JivePlace *)place options:(JiveSortedRequestOptions *)options onComplete:(void (^)(NSArray *tasks))completeBlock onError:(JiveErrorBlock)errorBlock;

//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#getPlaces(List<String>,%20String,%20int,%20int,%20String)
- (NSOperation *) placesOperation:(JivePlacesRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#getRecommendedPlaces(int,%20String)
- (NSOperation *) recommendedPlacesOperation:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#getTrendingPlaces(int,%20String)
- (NSOperation *) trendingPlacesOperation:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#getPlacePlaces(String,%20int,%20int,%20String,%20List<String>,%20String)
- (NSOperation *) placePlacesOperation:(JivePlace *)place withOptions:(JivePlacePlacesRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#createPlace(String,%20String)
- (NSOperation *) createPlaceOperation:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#createPlaceTask(String,%20String,%20String)
- (NSOperation *) createTaskOperation:(JiveTask *)task forPlace:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveTask *))complete onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#getPlace(String,%20String)
- (NSOperation *) placeOperation:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#getActivity(String,%20String,%20String,%20int,%20String)
- (NSOperation *) placeActivitiesOperation:(JivePlace *)place withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#getPlaceFollowingIn(String,%20String)
- (NSOperation *) placeFollowingInOperation:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#updatePlace(String,%20String,%20String)
- (NSOperation *) updatePlaceOperation:(JivePlace *)place withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JivePlace *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/InviteService.html#getInvites(String,%20int,%20int,%20String,%20String,%20String)
- (NSOperation *) invitesOperation:(JivePlace *)place withOptions:(JivePagedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#deletePlace(String)
- (NSOperation *) deletePlaceOperationWithPlace:(JivePlace *)place onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#deletePlaceAvatar(String)
- (NSOperation *) deleteAvatarOperationForPlace:(JivePlace *)place onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#getPlaceAnnouncements(String,%20int,%20int,%20boolean,%20String)
- (NSOperation *) announcementsOperationForPlace:(JivePlace *)place options:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *announcements))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#getPlaceAvatar(String,%20String)
- (NSOperation *) avatarOperationForPlace:(JivePlace *)place options:(JiveDefinedSizeRequestOptions *)options onComplete:(void (^)(UIImage *avatarImage))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#getPlaceTasks(String,%20String,%20int,%20int,%20String)
- (NSOperation *) tasksOperationForPlace:(JivePlace *)place options:(JiveSortedRequestOptions *)options onComplete:(void (^)(NSArray *tasks))completeBlock onError:(JiveErrorBlock)errorBlock;

#pragma mark - Contents

- (void) contentFromURL:(NSURL *)contentURL onComplete:(void (^)(JiveContent *content))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#getContents(List<String>,%20String,%20int,%20int,%20String)
- (void) contents:(JiveContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#getPopularContent(String)
- (void) popularContents:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#getRecommendedContent(int,%20String)
- (void) recommendedContents:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#getTrendingContent(List<String>,%20int,%20String)
- (void) trendingContents:(JiveTrendingContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#createContent(String,%20String)
- (void) createContent:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/DirectMessageService.html#createDirectMessage(String,%20String)
- (void) createDirectMessage:(JiveContent *)content withTargets:(JiveTargetList *)targets andOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#createComment(String,%20String,%20boolean,%20String)
- (void) createComment:(JiveComment *)comment withOptions:(JiveAuthorCommentRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/MessageService.html#createMessage(String,%20String)
- (void) createMessage:(JiveMessage *)message withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#getContent(String,%20String)
- (void) content:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#getComments(String,%20boolean,%20boolean,%20boolean,%20int,%20int,%20String,%20String)
- (void) commentsForContent:(JiveContent *)content withOptions:(JiveCommentsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/MessageService.html#getContentReplies(String,%20boolean,%20boolean,%20int,%20int,%20String,%20String)
- (void) messagesForContent:(JiveContent *)content withOptions:(JiveCommentsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#getContentLikes(String,%20int,%20int,%20String)
- (void) contentLikedBy:(JiveContent *)content withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#getContentFollowingIn(String,%20String)
- (void) contentFollowingIn:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#markRead(String)
- (void) content:(JiveContent *)content markAsRead:(BOOL)read onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#createContentLike(String)
- (void) content:(JiveContent *)content likes:(BOOL)read onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#deleteContent(String)
- (void) deleteContent:(JiveContent *)content onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#updateContent(String,%20String,%20boolean,%20String)
- (void) updateContent:(JiveContent *)content withOptions:(JiveMinorCommentRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/ActivityObjectEntity.html
- (void) activityObject:(JiveActivityObject *) activityObject contentWithCompleteBlock:(void(^)(JiveContent *content))completeBlock errorBlock:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/CommentEntity.html
- (void) comment:(JiveComment *) comment rootContentWithCompleteBlock:(void(^)(JiveContent *rootContent))completeBlock errorBlock:(void(^)(NSError *error))errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/MessageEntity.html
- (void) message:(JiveMessage *) message discussionWithCompleteBlock:(void(^)(JiveDiscussion *discussion))completeBlock errorBlock:(void(^)(NSError *error))errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/MessageService.html#createContentMessage(String,%20String,%20String)
- (void) createReplyMessage:(JiveMessage *)replyMessage forDiscussion:(JiveDiscussion *)discussion withOptions:(JiveReturnFieldsRequestOptions *)options completeBlock:(void (^)(JiveMessage *message))completeBlock errorBlock:(void (^)(NSError *error))errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/MessageService.html#createContentMessage(String,%20String,%20String)
- (NSOperation *) operationToCreateReplyMessage:(JiveMessage *)replyMessage forDiscussion:(JiveDiscussion *)discussion withOptions:(JiveReturnFieldsRequestOptions *)options completeBlock:(void (^)(JiveMessage *message))completeBlock errorBlock:(void (^)(NSError *error))errorBlock;

//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#getContents(List<String>, String, int, int, String)
- (NSOperation *) contentsOperationWithURL:(NSURL *)contentsURL onComplete:(void (^)(NSArray *contents))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#getContents(List<String>,%20String,%20int,%20int,%20String)
- (NSOperation *) contentsOperation:(JiveContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#getPopularContent(String)
- (NSOperation *) popularContentsOperation:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#getRecommendedContent(int,%20String)
- (NSOperation *) recommendedContentsOperation:(JiveCountRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#getTrendingContent(List<String>,%20int,%20String)
- (NSOperation *) trendingContentsOperation:(JiveTrendingContentRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#createContent(String,%20String)
- (NSOperation *) createContentOperation:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/DirectMessageService.html#createDirectMessage(String,%20String)
- (NSOperation *) createDirectMessageOperation:(JiveContent *)content withTargets:(JiveTargetList *)targets andOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#createComment(String,%20String,%20boolean,%20String)
- (NSOperation *) createCommentOperation:(JiveComment *)comment withOptions:(JiveAuthorCommentRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/MessageService.html#createMessage(String,%20String)
- (NSOperation *) createMessageOperation:(JiveMessage *)message withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#getContent(String,%20String)
- (NSOperation *) contentOperation:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#getComments(String,%20boolean,%20boolean,%20boolean,%20int,%20int,%20String,%20String)
- (NSOperation *) commentsOperationForContent:(JiveContent *)content withOptions:(JiveCommentsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/MessageService.html#getContentReplies(String,%20boolean,%20boolean,%20int,%20int,%20String,%20String)
- (NSOperation *) messagesOperationForContent:(JiveContent *)content withOptions:(JiveCommentsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#getContentLikes(String,%20int,%20int,%20String)
- (NSOperation *) contentLikedByOperation:(JiveContent *)content withOptions:(JivePagedRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#getContentFollowingIn(String,%20String)
- (NSOperation *) contentFollowingInOperation:(JiveContent *)content withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#markRead(String)
- (NSOperation *) contentOperation:(JiveContent *)content markAsRead:(BOOL)read onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#createContentLike(String)
- (NSOperation *) contentOperation:(JiveContent *)content likes:(BOOL)read onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#deleteContent(String)
- (NSOperation *) deleteContentOperation:(JiveContent *)content onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#updateContent(String,%20String,%20boolean,%20String)
- (NSOperation *) updateContentOperation:(JiveContent *)content withOptions:(JiveMinorCommentRequestOptions *)options onComplete:(void (^)(JiveContent *))complete onError:(JiveErrorBlock)error;

#pragma mark - Members

//! https://developers.jivesoftware.com/api/v3/rest/MemberService.html#deleteMember(String)
- (void) deleteMember:(JiveMember *)member onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/MemberService.html#getMember(String,%20String)
- (void) memberWithMember:(JiveMember *)member options:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveMember *member))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/MemberService.html#getMembersByGroup(String,%20List<String>,%20int,%20int,%20String)
- (void) membersForGroup:(JiveGroup *)group options:(JiveStateRequestOptions *)options onComplete:(void (^)(NSArray *members))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/MemberService.html#getMembersByPerson(String,%20List<String>,%20int,%20int,%20String)
- (void) membersForPerson:(JivePerson *)person options:(JiveStateRequestOptions *)options onComplete:(void (^)(NSArray *members))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/MemberService.html#updateMember(String,%20String,%20String)
- (void) updateMember:(JiveMember *)member withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveMember *member))complete onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/MemberService.html#deleteMember(String)
- (NSOperation *) deleteMemberOperationWithMember:(JiveMember *)member onComplete:(void (^)(void))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/MemberService.html#getMember(String,%20String)
- (NSOperation *) memberOperationWithMember:(JiveMember *)member options:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveMember *member))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/MemberService.html#getMembersByGroup(String,%20List<String>,%20int,%20int,%20String)
- (NSOperation *) membersOperationForGroup:(JiveGroup *)group options:(JiveStateRequestOptions *)options onComplete:(void (^)(NSArray *members))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/MemberService.html#getMembersByPerson(String,%20List<String>,%20int,%20int,%20String)
- (NSOperation *) membersOperationForPerson:(JivePerson *)person options:(JiveStateRequestOptions *)options onComplete:(void (^)(NSArray *members))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/MemberService.html#updateMember(String,%20String,%20String)
- (NSOperation *) updateMemberOperation:(JiveMember *)member withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveMember *member))complete onError:(JiveErrorBlock)error;

#pragma mark - Streams

//! https://developers.jivesoftware.com/api/v3/rest/StreamService.html#deleteStream(String)
- (void) deleteStream:(JiveStream *)stream onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/StreamService.html#getConnectionsActivity(String,%20String,%20int,%20String)
- (void) streamConnectionsActivities:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/StreamService.html#getStream(String,%20String)
- (void) stream:(JiveStream *)stream withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveStream *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/StreamService.html#getActivity(String,%20String,%20String,%20int,%20String)
- (void) streamActivities:(JiveStream *)stream withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/StreamService.html#getAssociations(String,%20int,%20int,%20String,%20List<String>)
- (void) streamAssociations:(JiveStream *)stream withOptions:(JiveAssociationsRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/StreamService.html#updateStream(String,%20StreamEntity,%20String)
- (void) updateStream:(JiveStream *)stream withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveStream *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#createStream(String,%20String,%20StreamEntity)
- (void) createStream:(JiveStream *)stream forPerson:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveStream *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/StreamService.html#removeAssociation(String,%20String,%20String)
- (void) deleteAssociation:(JiveTypedObject *)association fromStream:(JiveStream *)stream onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/StreamService.html#addAssociations(String,%20List<String>)
- (void) createAssociations:(JiveAssociationTargetList *)targets forStream:(JiveStream *)stream onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/StreamService.html#deleteStream(String)
- (NSOperation *) deleteStreamOperation:(JiveStream *)stream onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/StreamService.html#getConnectionsActivity(String,%20String,%20int,%20String)
- (NSOperation *) streamConnectionsActivitiesOperation:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/StreamService.html#getStream(String,%20String)
- (NSOperation *) streamOperation:(JiveStream *)stream withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveStream *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/StreamService.html#getActivity(String,%20String,%20String,%20int,%20String)
- (NSOperation *) streamActivitiesOperation:(JiveStream *)stream withOptions:(JiveDateLimitedRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/StreamService.html#getAssociations(String,%20int,%20int,%20String,%20List<String>)
- (NSOperation *) streamAssociationsOperation:(JiveStream *)stream withOptions:(JiveAssociationsRequestOptions *)options onComplete:(void(^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/StreamService.html#updateStream(String,%20StreamEntity,%20String)
- (NSOperation *) updateStreamOperation:(JiveStream *)stream withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveStream *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#createStream(String,%20String,%20StreamEntity)
- (NSOperation *) createStreamOperation:(JiveStream *)stream forPerson:(JivePerson *)person withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveStream *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/StreamService.html#removeAssociation(String,%20String,%20String)
- (NSOperation *) deleteAssociationOperation:(JiveTypedObject *)association fromStream:(JiveStream *)stream onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/StreamService.html#addAssociations(String,%20List<String>)
- (NSOperation *) createAssociationsOperation:(JiveAssociationTargetList *)targets forStream:(JiveStream *)stream onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error;

#pragma mark - Invites

//! https://developers.jivesoftware.com/api/v3/rest/InviteService.html#getInvite(String,%20String)
- (void) invite:(JiveInvite *)invite withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveInvite *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/InviteService.html#deleteInvite(String)
- (void) deleteInvite:(JiveInvite *)invite onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/InviteService.html#updateInvite(String,%20String,%20String)
- (void) updateInvite:(JiveInvite *)invite withState:(enum JiveInviteState)state andOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveInvite *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/InviteService.html#createInvites(String,%20String,%20String)
- (void) createInviteTo:(JivePlace *)place withMessage:(NSString *)message targets:(JiveTargetList *)targets andOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/InviteService.html#getInvite(String,%20String)
- (NSOperation *) inviteOperation:(JiveInvite *)invite withOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveInvite *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/InviteService.html#deleteInvite(String)
- (NSOperation *) deleteInviteOperation:(JiveInvite *)invite onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/InviteService.html#updateInvite(String,%20String,%20String)
- (NSOperation *) updateInviteOperation:(JiveInvite *)invite withState:(enum JiveInviteState)state andOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(JiveInvite *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/InviteService.html#createInvites(String,%20String,%20String)
- (NSOperation *) createInviteToOperation:(JivePlace *)place withMessage:(NSString *)message targets:(JiveTargetList *)targets andOptions:(JiveReturnFieldsRequestOptions *)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;

#pragma mark - Images

//! https://developers.jivesoftware.com/api/v3/rest/ImageService.html#getContentImages(String,%20String)
- (void)imagesFromURL:(NSURL *)imagesURL onComplete:(void (^)(NSArray *images))completeBlock onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/ImageService.html#uploadImage(MultipartBody)
- (void) uploadImage:(UIImage*) image onComplete:(void (^)(JiveImage*))complete onError:(JiveErrorBlock) errorBlock;

//! https://developers.jivesoftware.com/api/v3/rest/ImageService.html#getContentImages(String,%20String)
- (NSOperation *)imagesOperationFromURL:(NSURL *)imagesURL onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/ImageService.html#uploadImage(MultipartBody)
- (NSOperation*) uploadImageOperation:(UIImage*) image onComplete:(void (^)(JiveImage*))complete onError:(JiveErrorBlock) errorBlock;

#pragma mark - Outcomes
//! No official documnetation yet.
- (NSOperation *) outcomesListOperation:(JiveContent *)content withOptions:(NSObject<JiveRequestOptions>*)options onComplete:(void (^)(NSArray *))complete onError:(JiveErrorBlock)error;
//! No official documnetation yet.
- (NSOperation *) outcomesOperation:(JiveContent *)content withOptions:(JiveOutcomeRequestOptions *)options onComplete:(void (^)(NSArray *outcomes))complete onError:(JiveErrorBlock) error;
//! No official documnetation yet.
- (void) outcomes:(JiveContent *)content withOptions:(JiveOutcomeRequestOptions *)options onComplete:(void (^)(NSArray *outcomes))complete onError:(JiveErrorBlock) error;
//! No official documnetation yet.
- (NSOperation *) deleteOutcomeOperation:(JiveOutcome *)outcome onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error;
- (void) deleteOutcome:(JiveOutcome *)outcome onComplete:(void (^)(void))complete onError:(JiveErrorBlock)error;
//! No official documnetation yet.
- (NSOperation *) createOutcomeOperation:(JiveOutcome *)outcome forContent:(JiveContent *)content onComplete:(void (^)(JiveOutcome *))complete onError:(JiveErrorBlock)error;
//! No official documentation yet.
- (void) createOutcome:(JiveOutcome *)outcome forContent:(JiveContent *)content onComplete:(void (^)(JiveOutcome *))complete onError:(JiveErrorBlock)error;


@end

//! \class JiveAuthorizationDelegate
@protocol JiveAuthorizationDelegate <NSObject>
@required
//! Method to retrive the JiveCredentials for the specified URL.
- (JiveCredentials*) credentialsForJiveInstance:(NSURL*) url;
@optional
//- (void) didReveiveOAuthActivitionResponse:(
@end
