//
//  JiveInvite.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/11/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveObject.h"
#import "JivePerson.h"
#import "JivePlace.h"

enum JiveInviteState {
    JiveInviteDeleted = 1,  // Marked for deletion but not yet removed by a background task.
    JiveInviteFulfilled,    // Conditions for fulfillment of this invitation have been met, but further action on the part of the invitee is required.
    JiveInviteProcessing,   // Initial state of an invitation after a user has been invited. State will automatically change to sent after it has been emailed.
    JiveInviteRevoked,      // This invitation has been revoked and may no longer be accepted.
    JiveInviteSent          // This invitation has been sent (via email), but not yet accepted.
    };

@interface JiveInvite : JiveObject

// The (HTML) body content of this invitation.
@property (nonatomic, readonly, strong) NSString *body;

// The email address of the invitee, if not a Jive person. Otherwise, the invitee field will be populated.
@property (nonatomic, readonly, strong) NSString *email;

// Identifier (unique within an object type and Jive instance) of this object. This field is internal to Jive and should not be confused with contentID or placeID used in URIs.
@property (nonatomic, readonly, strong) NSString *jiveId;

// The person that was invited, if the invitee is a Jive person. If not, the email field should be populated.
@property (nonatomic, readonly, strong) JivePerson *invitee;

// The person that issued this invitation.
@property (nonatomic, readonly, strong) JivePerson *inviter;

// The place to which the invitee was invited.
@property (nonatomic, readonly, strong) JivePlace *place;

// The date and time at which this invite was created.
@property (nonatomic, readonly, strong) NSDate* published;

// Resource links (and related permissions for the requesting person) relevant to this object.
@property (nonatomic, readonly, strong) NSDictionary* resources;

// The date and time at which this invitation was revoked (if any).
@property (nonatomic, readonly, strong) NSDate *revokeDate;

// The person that revoked this invitation (if any).
@property (nonatomic, readonly, strong) JivePerson *revoker;

// The date and time at which this invitation was sent.
@property (nonatomic, readonly, strong) NSDate *sentDate;

// The current state of this invitation. Valid values are:
@property (nonatomic, readonly) enum JiveInviteState state;

// The object type of this object ("invite")
@property (nonatomic, readonly) NSString *type;

// The date and time at which this invite was last updated.
@property (nonatomic, readonly, strong) NSDate* updated;

@end
