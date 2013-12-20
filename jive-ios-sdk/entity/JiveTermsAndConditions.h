//
//  JiveTermsAndConditions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/20/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveObject.h"

extern struct JiveTermsAndConditionsAttributes {
    __unsafe_unretained NSString *acceptanceRequired;
    __unsafe_unretained NSString *text;
    __unsafe_unretained NSString *url;
} const JiveTermsAndConditionsAttributes;

@class JiveLevel;

//! \class JiveTermsAndConditions
//! This class contains either the text or a url pointing to the text of the Jive instance Terms and Conditions which the user must agree to before further calls to the instance can be allowed.
@interface JiveTermsAndConditions : JiveObject

//! Flag indicating that the T&Cs must be accepted.
@property(nonatomic, readonly) NSNumber *acceptanceRequired;

//! The text of the T&Cs in HTML format.
@property(nonatomic, readonly) NSString *text;

//! The URL of the T&Cs.
@property(nonatomic, readonly) NSURL *url;

@end
