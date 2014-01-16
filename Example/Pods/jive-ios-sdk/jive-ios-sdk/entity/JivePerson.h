//
//  JivePerson.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 10/29/12.
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
#import "JiveTypedObject.h"
#import "JiveResponseBlocks.h"

@class Jive;
@protocol JiveRetryingOperation;

extern NSString * const JivePersonType;

extern struct JivePersonAttributes {
    __unsafe_unretained NSString *addresses;
    __unsafe_unretained NSString *displayName;
    __unsafe_unretained NSString *emails;
    __unsafe_unretained NSString *followerCount;
    __unsafe_unretained NSString *followingCount;
    __unsafe_unretained NSString *jiveId;
    __unsafe_unretained NSString *jive;
    __unsafe_unretained NSString *location;
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *phoneNumbers;
    __unsafe_unretained NSString *photos;
    __unsafe_unretained NSString *published;
    __unsafe_unretained NSString *status;
    __unsafe_unretained NSString *tags;
    __unsafe_unretained NSString *thumbnailUrl;
    __unsafe_unretained NSString *updated;
} const JivePersonAttributes;

extern NSString * const JivePersonGuestID;


//! \class JivePerson
//! https://developers.jivesoftware.com/api/v3/rest/PersonEntity.html
@interface JivePerson : JiveTypedObject

//! List of postal JiveAddresses belonging to this person, with standard types home,other,pobox,work and value type of address. JiveAddress[]
//! Creation - optional
@property(nonatomic, strong) NSArray* addresses;

//! Formatted full name of this person, suitable for use in UI presentation. If the person has privacy settings that do not allow you to see his or her name, this will be the Jive username instead.
@property(nonatomic, readonly, strong) NSString* displayName;

//! List of JiveEmail addresses belonging to this person, with standard types home, other, work and value type of string. JiveEmail[]
//! Creation - required
@property(nonatomic, strong) NSArray* emails;

//! Number of people following this object.
@property(nonatomic, readonly, strong) NSNumber *followerCount;

//! Number of people this person is following.
@property(nonatomic, readonly, strong) NSNumber *followingCount;

//! Identifier (unique within an object type and Jive instance) of this object. This field is internal to Jive and should not be confused with contentID or placeID used in URIs.
@property(nonatomic, readonly, strong) NSString* jiveId;

//! Jive extensions to OpenSocial person object.
//! Creation - required
@property(nonatomic, strong) JivePersonJive* jive;

//! Geographic location of this person.
//! Creation - optional
@property(nonatomic, copy) NSString* location;

//! Name components for this person.
//! Creation - required
@property(nonatomic, strong) JiveName* name;

//! JivePhone numbers belonging to this person, with standard types: fax, home, mobile, other, pager, work. JivePhoneNumber[]
//! Creation - optional
@property(nonatomic, strong) NSArray* phoneNumbers;

//! URI(s) of profile images for this person. To manage profile images in REST, use the images resource.
@property(nonatomic, readonly, strong) NSArray* photos;

//! Date and time when this person was originally created.
@property(nonatomic, readonly, strong) NSDate* published;

//! Most recent status update for this person.
//! Creation - optional
@property(nonatomic, copy) NSString* status;

//! Defined tags for this person. NSString[]
//! Creation - optional
@property(nonatomic, strong) NSArray* tags;

//! URL of the thumbnail (avatar) image for this person.
@property(nonatomic, readonly, strong) NSString* thumbnailUrl;

//! Date and time this person was most recently updated.
@property(nonatomic, readonly, strong) NSDate* updated;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getPerson(String,%20String)
- (void) refreshWithOptions:(JiveReturnFieldsRequestOptions *)options
                 onComplete:(JivePersonCompleteBlock)completeBlock
                    onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#deletePerson(String,%20UriInfo)
- (void) deleteOnComplete:(JiveCompletedBlock)completeBlock
                  onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#updatePerson(String,%20PersonEntity)
- (void) updateOnComplete:(JivePersonCompleteBlock)completeBlock
                  onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getAvatar(String)
- (void) avatarOnComplete:(JiveImageCompleteBlock)completeBlock
                  onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getBlog(String,%20String)
- (void) blogWithOptions:(JiveReturnFieldsRequestOptions *)options
              onComplete:(JiveBlogCompleteBlock)completeBlock
                 onError:(JiveErrorBlock)errorBlock;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getManager(String,%20String)
- (void) managerWithOptions:(JiveReturnFieldsRequestOptions *)options
                 onComplete:(JivePersonCompleteBlock)completeBlock
                    onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getColleagues(String,%20int,%20int,%20String)
- (void) colleguesWithOptions:(JivePagedRequestOptions *)options
                   onComplete:(JiveArrayCompleteBlock)completeBlock //! JivePerson[]
                      onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getReports(String,%20int,%20int,%20String)
- (void) reportsWithOptions:(JivePagedRequestOptions *)options
                 onComplete:(JiveArrayCompleteBlock)completeBlock //! JivePerson[]
                    onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getFollowers(String,%20int,%20int,%20String)
- (void) followersWithOptions:(JivePagedRequestOptions *)options
                   onComplete:(JiveArrayCompleteBlock)completeBlock //! JivePerson[]
                      onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getFollowing(String,%20int,%20int,%20String)
- (void) followingWithOptions:(JivePagedRequestOptions *)options
                   onComplete:(JiveArrayCompleteBlock)completeBlock //! JivePerson[]
                      onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getFollowingIn(String,%20String)
- (void) followingInWithOptions:(JiveReturnFieldsRequestOptions *)options
                     onComplete:(JiveArrayCompleteBlock)completeBlock //! JiveStream[]
                        onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getStreams(String,%20String)
- (void) streamsWithOptions:(JiveReturnFieldsRequestOptions *)options
                 onComplete:(JiveArrayCompleteBlock)completeBlock //! JiveStream[]
                    onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getActivity(String,%20String,%20String,%20int,%20String)
- (void) activitiesWithOptions:(JiveDateLimitedRequestOptions *)options
                    onComplete:(JiveArrayCompleteBlock)completeBlock //! JiveActivity[]
                       onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getTasks(String,%20String,%20int,%20int,%20String)
- (void) tasksWithOptions:(JiveSortedRequestOptions *)options
               onComplete:(JiveArrayCompleteBlock)completeBlock //! JiveTask[]
                  onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#createFollowing(String,%20String)
- (void) follow:(JivePerson *)target
     onComplete:(JiveCompletedBlock)completeBlock
        onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#deleteFollowing(String,%20String)
- (void) unFollow:(JivePerson *)target
     onComplete:(JiveCompletedBlock)completeBlock
        onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#setFollowingIn(String,%20String,%20String)
- (void) updateFollowingIn:(NSArray *)followingInStreams //! JiveStream[]
               withOptions:(JiveReturnFieldsRequestOptions *)options
                onComplete:(JiveArrayCompleteBlock)completeBlock //! JiveStream[]
                   onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#createTask(String,%20String,%20String)
- (void) createTask:(JiveTask *)task
        withOptions:(JiveReturnFieldsRequestOptions *)options
         onComplete:(JiveTaskCompleteBlock)completeBlock
            onError:(JiveErrorBlock)errorBlock;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getTermsAndConditions(String)
- (void) termsAndConditions:(JiveTermsAndConditionsCompleteBlock)completeBlock
                    onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#acceptTermsAndConditions(String)
- (void) acceptTermsAndConditions:(JiveCompletedBlock)completeBlock
                          onError:(JiveErrorBlock)errorBlock;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getPerson(String,%20String)
- (AFJSONRequestOperation<JiveRetryingOperation> *) refreshOperationWithOptions:(JiveReturnFieldsRequestOptions *)options
                                                                     onComplete:(JivePersonCompleteBlock)completeBlock
                                                                        onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#deletePerson(String,%20UriInfo)
- (AFJSONRequestOperation<JiveRetryingOperation> *) deleteOperationOnComplete:(JiveCompletedBlock)completeBlock
                                                                      onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#updatePerson(String,%20PersonEntity)
- (AFJSONRequestOperation<JiveRetryingOperation> *) updateOperationOnComplete:(JivePersonCompleteBlock)completeBlock
                                                                      onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getAvatar(String)
- (AFImageRequestOperation<JiveRetryingOperation> *) avatarOperationOnComplete:(JiveImageCompleteBlock)completeBlock
                                                                       onError:(JiveErrorBlock)errorBlock;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getBlog(String,%20String)
- (AFJSONRequestOperation<JiveRetryingOperation> *) blogOperationWithOptions:(JiveReturnFieldsRequestOptions *)options
                                                                  onComplete:(JiveBlogCompleteBlock)completeBlock
                                                                     onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getManager(String,%20String)
- (AFJSONRequestOperation<JiveRetryingOperation> *) managerOperationWithOptions:(JiveReturnFieldsRequestOptions *)options
                                                                     onComplete:(JivePersonCompleteBlock)completeBlock
                                                                        onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getColleagues(String,%20int,%20int,%20String)
- (AFJSONRequestOperation<JiveRetryingOperation> *) colleguesOperationWithOptions:(JivePagedRequestOptions *)options
                                                                       onComplete:(JiveArrayCompleteBlock)completeBlock //! JivePerson[]
                                                                          onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getReports(String,%20int,%20int,%20String)
- (AFJSONRequestOperation<JiveRetryingOperation> *) reportsOperationWithOptions:(JivePagedRequestOptions *)options
                                                                     onComplete:(JiveArrayCompleteBlock)completeBlock //! JivePerson[]
                                                                        onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getFollowers(String,%20int,%20int,%20String)
- (AFJSONRequestOperation<JiveRetryingOperation> *) followersOperationWithOptions:(JivePagedRequestOptions *)options
                                                                       onComplete:(JiveArrayCompleteBlock)completeBlock //! JivePerson[]
                                                                          onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getFollowing(String,%20int,%20int,%20String)
- (AFJSONRequestOperation<JiveRetryingOperation> *) followingOperationWithOptions:(JivePagedRequestOptions *)options
                                                                       onComplete:(JiveArrayCompleteBlock)completeBlock //! JivePerson[]
                                                                          onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getFollowingIn(String,%20String)
- (AFJSONRequestOperation<JiveRetryingOperation> *) followingInOperationWithOptions:(JiveReturnFieldsRequestOptions *)options
                                                                         onComplete:(JiveArrayCompleteBlock)completeBlock //! JiveStream[]
                                                                            onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getStreams(String,%20String)
- (AFJSONRequestOperation<JiveRetryingOperation> *) streamsOperationWithOptions:(JiveReturnFieldsRequestOptions *)options
                                                                     onComplete:(JiveArrayCompleteBlock)completeBlock //! JiveStream[]
                                                                        onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getActivity(String,%20String,%20String,%20int,%20String)
- (AFJSONRequestOperation<JiveRetryingOperation> *) activitiesOperationWithOptions:(JiveDateLimitedRequestOptions *)options
                                                                        onComplete:(JiveArrayCompleteBlock)completeBlock //! JiveActivity[]
                                                                           onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getTasks(String,%20String,%20int,%20int,%20String)
- (AFJSONRequestOperation<JiveRetryingOperation> *) tasksOperationWithOptions:(JiveSortedRequestOptions *)options
                                                                   onComplete:(JiveArrayCompleteBlock)completeBlock //! JiveTask[]
                                                                      onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#createFollowing(String,%20String)
- (AFJSONRequestOperation<JiveRetryingOperation> *) followOperation:(JivePerson *)target
                                                         onComplete:(JiveCompletedBlock)completeBlock
                                                            onError:(JiveErrorBlock)error;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#setFollowingIn(String,%20String,%20String)
- (AFJSONRequestOperation<JiveRetryingOperation> *)updateFollowingInOperation:(NSArray *)followingInStreams //! JiveStream[]
                                                                  withOptions:(JiveReturnFieldsRequestOptions *)options
                                                                   onComplete:(JiveArrayCompleteBlock)completeBlock //! JiveStream[]
                                                                      onError:(JiveErrorBlock)error;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#deleteFollowing(String,%20String)
- (AFJSONRequestOperation<JiveRetryingOperation> *) unFollowOperation:(JivePerson *)target
                                                           onComplete:(JiveCompletedBlock)completeBlock
                                                              onError:(JiveErrorBlock)errorBlock;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#createTask(String,%20String,%20String)
- (AFJSONRequestOperation<JiveRetryingOperation> *) createTaskOperation:(JiveTask *)task
                                                            withOptions:(JiveReturnFieldsRequestOptions *)options
                                                             onComplete:(JiveTaskCompleteBlock)completeBlock
                                                                onError:(JiveErrorBlock)errorBlock;

//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#getTermsAndConditions(String)
- (AFJSONRequestOperation<JiveRetryingOperation> *) termsAndConditionsOperation:(JiveTermsAndConditionsCompleteBlock)completeBlock
                                                                        onError:(JiveErrorBlock)errorBlock;
//! https://developers.jivesoftware.com/api/v3/rest/PersonService.html#acceptTermsAndConditions(String)
- (AFJSONRequestOperation<JiveRetryingOperation> *) acceptTermsAndConditionsOperation:(JiveCompletedBlock)completeBlock
                                                                              onError:(JiveErrorBlock)errorBlock;

- (NSURL *)avatarRef;
- (NSURL *)activityRef;
- (NSURL *)blogRef;
- (NSURL *)colleaguesRef;
- (NSURL *)extPropsRef;
- (BOOL)canAddExtProps;
- (BOOL)canDeleteExtProps;
- (NSURL *)followersRef;
- (NSURL *)followingRef;
- (NSURL *)followingInRef;
- (NSURL *)htmlRef;
- (NSURL *)imagesRef;
- (NSURL *)managerRef;
- (NSURL *)membersRef;
- (NSURL *)reportsRef;
- (NSURL *)streamsRef;
- (BOOL)canCreateNewStream;
- (NSURL *)tasksRef;
- (BOOL)canCreateNewTask;

- (BOOL)isGuest;

@property (strong, nonatomic) Jive *jiveInstance;

@end
