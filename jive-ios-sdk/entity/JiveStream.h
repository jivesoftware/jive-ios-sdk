//
//  JiveStream.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/7/13.
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

extern struct JiveStreamAttributes {
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *person;
    __unsafe_unretained NSString *published;
    __unsafe_unretained NSString *receiveEmails;
    __unsafe_unretained NSString *resources;
    __unsafe_unretained NSString *type;
    __unsafe_unretained NSString *updated;
} const JiveStreamAttributes;

//! \class JiveStream
//! https://developers.jivesoftware.com/api/v3/rest/StreamEntity.html
@interface JiveStream : JiveTypedObject

//! Unique identifier of this custom stream.
@property(nonatomic, readonly, strong) NSString* jiveId;

//! Name of this custom stream. Will be a zero length string on custom streams with a source other than custom. Must be unique (per user) for streams with source custom.
//! Not included in the REST documentation is the length limit. As of 2013-2-21 the limit is 18 characters.
@property(nonatomic, copy) NSString* name;

//! A Person describing the person that owns this custom stream.
@property(nonatomic, readonly, strong) JivePerson* person;

//! Date and time this custom stream was originally created.
@property(nonatomic, readonly, strong) NSDate* published;

//! Flag indicating whether the owner of this custom stream wants to receive email when new activity arrives.
@property(nonatomic, strong) NSNumber *receiveEmails;

//! Source of this particular stream. Custom streams managed via this API MUST have a stream source of custom. Other values for non-custom streams are:
// all - the standard "Activities" stream
// communications - the standard "Communications" stream
// connections - the standard "Connections" stream
// context - TODO definition
// profile - TODO definition
// watches - TODO definition
@property(nonatomic, readonly, strong) NSString* source;

//! Date and time this custom stream configuration was most recently updated.
@property(nonatomic, readonly, strong) NSDate* updated;

- (NSURL *)activityRef;
- (NSURL *)associationsRef;
- (BOOL)canAddAssociation;
- (BOOL)canDeleteAssociation;
- (NSURL *)htmlRef;

@end
