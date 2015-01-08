//
//  JiveResource.h
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

extern struct JiveResourceAttributes {
    __unsafe_unretained NSString *selfKey;
} const JiveResourceAttributes;

//! \class JiveResource
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/ResourceEntity.html
@interface JiveResource : JiveObject

//! Comments regarding when this resource will be present in an object representation.
@property(atomic, readonly, copy) NSString* availability;

//! Description of this resource.
@property(atomic, readonly, copy) NSString* jiveDescription;

//! A usage example for this resource and verb combination.
@property(atomic, readonly, copy) NSString* example;

//! Flag indicating that this resource expects body content to be passed when it is called.
@property(atomic, readonly) bool hasBody;

//! The name of the JavaScript method to create in the JavaScript API to interact with the specified resource URI using the specified verb. Required only if the normal inference rules result in an undesired method name.
@property(atomic, readonly, copy) NSString* jsMethod;

//! The name of this resource. This name will be the key in the resources field of an object's JSON representation.
@property(atomic, readonly, copy) NSString* name;

//! A URL, provided as an example, to the REST endpoint that serves this resource.
@property(atomic, readonly, copy) NSString* path;

//! Comments about the first version of the API in which this resource became available.
@property(atomic, readonly, copy) NSString* since;

//! Flag indicating that this resource is present for internal use only, and should not be considered to be generally available or documented.
@property(atomic, readonly) bool unpublished;

//! The HTTP verb that will be used to interact with the URI of this resource by the generated JavaScript method.
@property(atomic, readonly, copy) NSString* verb;

@end
