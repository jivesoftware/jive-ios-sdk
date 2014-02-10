//
//  JiveProperty.h
//  jive-ios-sdk
//
//  Created by Taylor Case on 4/26/13.
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

extern struct JivePropertyTypes {
    __unsafe_unretained NSString *boolean;
    __unsafe_unretained NSString *string;
    __unsafe_unretained NSString *number;
    __unsafe_unretained NSString *integer;
} const JivePropertyTypes;

extern struct JivePropertyAttributes {
    __unsafe_unretained NSString *availability;
    __unsafe_unretained NSString *defaultValue;
    __unsafe_unretained NSString *jiveDescription;
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *since;
    __unsafe_unretained NSString *type;
    __unsafe_unretained NSString *value;
} const JivePropertyAttributes;

extern struct JivePropertyNames {
    __unsafe_unretained NSString *instanceURL;
    __unsafe_unretained NSString *statusUpdatesEnabled;
    __unsafe_unretained NSString *statusUpdateMaxCharacters;
    __unsafe_unretained NSString *blogsEnabled;
    __unsafe_unretained NSString *realTimeChatEnabled;
    __unsafe_unretained NSString *imagesEnabled;
    __unsafe_unretained NSString *personalStatusUpdatesEnabled;
    __unsafe_unretained NSString *placeStatusUpdatesEnabled;
    __unsafe_unretained NSString *repostStatusUpdatesEnabled;
    __unsafe_unretained NSString *mobileBinaryDownloadsDisabled;
    __unsafe_unretained NSString *shareEnabled;
    __unsafe_unretained NSString *maxAttachmentSize;
    __unsafe_unretained NSString *videoModuleEnabled;
} const JivePropertyNames;

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

//! The raw value of this property.
@property (nonatomic, strong, readonly) id value;

//! The value of a boolean property.
- (BOOL)valueAsBOOL;

//! The value of a string property.
- (NSString *)valueAsString;

//! The value of a numeric property.
- (NSNumber *)valueAsNumber;

@end
