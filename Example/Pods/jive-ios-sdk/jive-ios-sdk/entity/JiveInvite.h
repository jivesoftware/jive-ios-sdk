//
//  JiveInvite.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/11/13.
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

#import "JiveTypedObject.h"
#import "JivePerson.h"
#import "JivePlace.h"

//! \enum JiveInviteState
enum JiveInviteState {
//! Marked for deletion but not yet removed by a background task.
    JiveInviteDeleted = 1, 
//! Conditions for fulfillment of this invitation have been met, but further action on the part of the invitee is required.
    JiveInviteFulfilled,   
//! Initial state of an invitation after a user has been invited. State will automatically change to sent after it has been emailed.
    JiveInviteProcessing,  
//! This invitation has been revoked and may no longer be accepted.
    JiveInviteRevoked,     
//! This invitation has been sent (via email), but not yet accepted.
    JiveInviteSent         
    };

//! \class JiveInvite
//! https://developers.jivesoftware.com/api/v3/rest/InviteEntity.html
@interface JiveInvite : JiveTypedObject

//! The (HTML) body content of this invitation.
@property (nonatomic, readonly, strong) NSString *body;

//! The email address of the invitee, if not a Jive person. Otherwise, the invitee field will be populated.
@property (nonatomic, readonly, strong) NSString *email;

//! Identifier (unique within an object type and Jive instance) of this object. This field is internal to Jive and should not be confused with contentID or placeID used in URIs.
@property (nonatomic, readonly, strong) NSString *jiveId;

//! The person that was invited, if the invitee is a Jive person. If not, the email field should be populated.
@property (nonatomic, readonly, strong) JivePerson *invitee;

//! The person that issued this invitation.
@property (nonatomic, readonly, strong) JivePerson *inviter;

//! The place to which the invitee was invited.
@property (nonatomic, readonly, strong) JivePlace *place;

//! The date and time at which this invite was created.
@property (nonatomic, readonly, strong) NSDate* published;

//! The date and time at which this invitation was revoked (if any).
@property (nonatomic, readonly, strong) NSDate *revokeDate;

//! The person that revoked this invitation (if any).
@property (nonatomic, readonly, strong) JivePerson *revoker;

//! The date and time at which this invitation was sent.
@property (nonatomic, readonly, strong) NSDate *sentDate;

//! The current state of this invitation.
@property (nonatomic, readonly) enum JiveInviteState state;

//! The date and time at which this invite was last updated.
@property (nonatomic, readonly, strong) NSDate* updated;

@end
