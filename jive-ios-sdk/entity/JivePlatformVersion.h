//
//  JiveVersion.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 4/10/13.
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

#import "JiveObject.h"

extern struct JivePlatformVersionAttributes {
    __unsafe_unretained NSString *major;
    __unsafe_unretained NSString *minor;
    __unsafe_unretained NSString *maintenance;
    __unsafe_unretained NSString *build;
    __unsafe_unretained NSString *releaseID;
    __unsafe_unretained NSString *coreURI;
    __unsafe_unretained NSString *ssoEnabled;
    __unsafe_unretained NSString *sdk;
    __unsafe_unretained NSString *instanceURL;
} const JivePlatformVersionAttributes;

//! \class JivePlatformVersion
//! Version data for a Jive instance
@interface JivePlatformVersion : JiveObject

//! Major release version
@property (nonatomic, readonly) NSNumber *major;

//! Minor release version
@property (nonatomic, readonly) NSNumber *minor;

//! Maintenance release version
@property (nonatomic, readonly) NSNumber *maintenance;

//! Build version
@property (nonatomic, readonly) NSNumber *build;

//! Release identifier.
@property (nonatomic, readonly) NSString *releaseID;

//! Available REST api versions. JiveCoreVersion[]
@property (nonatomic, readonly) NSArray *coreURI;

//! SSO types available for authorization. Simple authorization is not available if this is populated. NSString[]
@property (nonatomic, readonly) NSArray *ssoEnabled;

//! Jive iOS SDK version number
@property (nonatomic, readonly) NSString *sdk;

//! The URL known to the server
@property (nonatomic, readonly) NSURL *instanceURL;

- (BOOL)supportsDraftPostCreation;
- (BOOL)supportsDraftPostContentFilter;
- (BOOL)supportsExplicitSSO;
- (BOOL)supportsFollowing;
- (BOOL)supportsStatusUpdateInPlace;
- (BOOL)supportsBookmarkInboxEntries;
- (BOOL)supportsCorrectAndHelpfulReplies;
- (BOOL)supportsStructuredOutcomes;
- (BOOL)supportsExplicitCorrectAnswerAPI;
- (BOOL)supportsDiscussionLikesInActivityObjects;
- (BOOL)supportsInboxTypeFiltering;
- (BOOL)supportsCommentAndReplyPermissions;
- (BOOL)supportedIPhoneVersion;
- (BOOL)supportsOAuth;
- (BOOL)supportsOAuthSessionGrant;
- (BOOL)supportsFeatureModuleVideoProperty;
- (BOOL)supportsContentEditingAPI;
- (BOOL)supportsLikeCountInStreams;

@end
