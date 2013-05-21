//
//  JiveOutcomeType.h
//  jive-ios-sdk
//
//  Created by Taylor Case on 4/4/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveObject.h"

extern struct JiveOutcomeTypeAttributes {
    __unsafe_unretained NSString *fields;
    __unsafe_unretained NSString *jiveId;
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *resources;
} const JiveOutcomeTypeAttributes;

//! \class JvieOutcomeType
//! https://developers.jivesoftware.com/api/v3/rest/OutcomeTypeEntity.html
@interface JiveOutcomeType : JiveObject

//! Metadata about the fields that may be present in the JSON representation of this object type.
@property (nonatomic, readonly, strong) NSArray *fields;

//! The unique identifier of this outcome type.
@property (nonatomic, readonly, strong) NSString *jiveId;

//! The name of this outcome type.
@property (nonatomic, readonly, strong) NSString *name;

//! Resource links (and related permissions for the requesting person) relevant to this object.
@property (nonatomic, readonly, strong) NSDictionary *resources;

@end
