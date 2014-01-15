//
//  JiveContentBody.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
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

extern struct JiveContentBodyAttributes {
    __unsafe_unretained NSString *text;
    __unsafe_unretained NSString *type;
    __unsafe_unretained NSString *editable;
} const JiveContentBodyAttributes;

//! \class JiveContentBody
//! https://developers.jivesoftware.com/api/v3/rest/ContentBodyEntity.html
@interface JiveContentBody : JiveObject

//! The (typically HTML) text of the content object's body.
@property(nonatomic, copy) NSString* text;

//! The MIME type of this content object's body (typically text/html).
@property(nonatomic, copy) NSString* type;

//! Flag indicating if content text is editable.
@property(nonatomic, readonly) NSNumber *editable;
//! Convenience method to get the value of the editable property.
@property(nonatomic, readonly) BOOL editableValue;

@end
