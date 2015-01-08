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
    __unsafe_unretained NSString *count;
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *person;
    __unsafe_unretained NSString *published;
    __unsafe_unretained NSString *receiveEmails;
    __unsafe_unretained NSString *source;
    __unsafe_unretained NSString *updated;
    __unsafe_unretained NSString *updatesNew;
    __unsafe_unretained NSString *updatesPrevious;
} const JiveStreamAttributes;

extern struct JiveStreamSourceValues {
    __unsafe_unretained NSString *all;
    __unsafe_unretained NSString *communications;
    __unsafe_unretained NSString *connections;
    __unsafe_unretained NSString *context;
    __unsafe_unretained NSString *profile;
    __unsafe_unretained NSString *watches;
    __unsafe_unretained NSString *custom;
} const JiveStreamSourceValues;

//! \class JiveStream
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/StreamEntity.html
@interface JiveStream : JiveTypedObject

//! The number of activities in this stream that have been added since the last time activities were retrieved with the updateLastRead flag set to true. Availability: Only available when retrieving one of your own streams
@property (nonatomic, readonly, strong) NSNumber *count;

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
// watches - Legacy stream type created when a pre-Jive 6 instance is upgraded to Jive 6+.
@property(nonatomic, readonly, strong) NSString* source;

//! Date and time this custom stream configuration was most recently updated.
@property(nonatomic, readonly, strong) NSDate* updated;

//! Date and time denoting the last time that activities in this stream were read (with the updateLastRead parameter set to true). Activities with a published date/time later than this are considered "new updates". Availability: Only available when retrieving your own streams
@property(nonatomic, readonly, strong) NSDate *updatesNew;

//! Date and time denoting the previous value of the updatesNew field, reset when activities are read with the updateLastRead parameter set to true. Availability: Only available when retrieving your own streams
@property(nonatomic, readonly, strong) NSDate *updatesPrevious;

- (NSURL *)activityRef;
- (NSURL *)associationsRef;
- (BOOL)canAddAssociation;
- (BOOL)canDeleteAssociation;
- (NSURL *)htmlRef;

@end
