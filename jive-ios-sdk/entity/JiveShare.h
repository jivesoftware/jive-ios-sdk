//
//  JiveShare.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 4/26/13.
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

#import "JiveContent.h"
#import "JivePlace.h"

extern struct JiveShareAttributes {
    __unsafe_unretained NSString *participants;
    __unsafe_unretained NSString *sharedContent;
    __unsafe_unretained NSString *sharedPlace;
    __unsafe_unretained NSString *tags;
    __unsafe_unretained NSString *visibleToExternalContributors;
} const JiveShareAttributes;

//! \class JiveShare
//! https://developers.jivesoftware.com/api/v3/rest/ShareEntity.html
@interface JiveShare : JiveContent

//! The people with which a content object or place has been shared. JivePerson[]
@property (nonatomic, readonly) NSArray *participants;

//! The content object that was shared, if any. If a place was shared, this field will not be present.
@property (nonatomic, readonly) JiveContent *sharedContent;

//! The place containing the content object that was shared, if a content object was shared. If a place was shared, this will be the place.
@property (nonatomic, readonly) JivePlace *sharedPlace;

//! Tags associated with this object. Availability: Will be present only for object types that support tags. NSString[]
@property (nonatomic, copy) NSArray *tags;

//! Flag indicating that this content object is potentially visible to external contributors.
@property (nonatomic, readonly) NSNumber *visibleToExternalContributors;

@end
