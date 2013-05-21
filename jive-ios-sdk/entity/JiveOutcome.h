//
//  JiveOutcome.h
//  jive-ios-sdk
//
//  Created by Taylor Case on 4/4/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveTypedObject.h"
#import "JivePerson.h"
#import "JiveOutcomeType.h"

extern struct JiveOutcomeAttributes {
    __unsafe_unretained NSString *creationDate;
    __unsafe_unretained NSString *jiveId;
    __unsafe_unretained NSString *outcomeType;
    __unsafe_unretained NSString *parent;
    __unsafe_unretained NSString *properties;
    __unsafe_unretained NSString *updated;
    __unsafe_unretained NSString *user;
} const JiveOutcomeAttributes;

//! \class JiveOutcome
//! https://developers.jivesoftware.com/api/v3/rest/OutcomeEntity.html
@interface JiveOutcome : JiveTypedObject

//! The creation date of the outcome.
@property (nonatomic, readonly, strong) NSDate *creationDate;

//! Identifier (unique within an object type and Jive instance) of this object. This field is internal to Jive and should not be confused with contentID or placeID used in URIs.
@property (nonatomic, readonly, strong) NSString *jiveId;

//! Flag indicating whether objects of this type can be associated to (followed in) an activity stream. Present on Jive core object types only.
@property (nonatomic, strong) JiveOutcomeType *outcomeType;

//! The owner of outcome which is the content object the outcome was made on
@property (nonatomic, readonly, strong) NSString *parent;

//! The properties of the outcome
@property (nonatomic, strong) NSArray *properties;

//! The modification date of the outcome.
@property (nonatomic, readonly, strong) NSDate *updated;

//! The user assigned to the outcome.
@property (nonatomic, readonly, strong) JivePerson *user;

- (NSURL *)historyRef;

@end
