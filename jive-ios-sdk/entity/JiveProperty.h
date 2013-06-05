//
//  JiveProperty.h
//  jive-ios-sdk
//
//  Created by Taylor Case on 4/26/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveObject.h"

//! \class JiveProperty
//! https://developers.jivesoftware.com/api/v3/rest/PropertyEntity.html
@interface JiveProperty : JiveObject

//! Comments regarding when this property will be present.
@property (nonatomic, strong, readonly) NSString *availability;

//! The default value for this property when it is not explicitly set.
@property (nonatomic, strong, readonly) NSString *defaultValue;

//! Description of this property.
@property (nonatomic, strong, readonly) NSString *jiveDescription;

//! Name of this property.
@property (nonatomic, strong, readonly) NSString *name;

//! Comments about the first version of the API in which this property became available.
@property (nonatomic, strong, readonly) NSString *since;

//! The data type for the value of this property.
@property (nonatomic, strong, readonly) NSString *type;

//! The value of this property.
@property (nonatomic, strong, readonly) NSString *value;

@end
