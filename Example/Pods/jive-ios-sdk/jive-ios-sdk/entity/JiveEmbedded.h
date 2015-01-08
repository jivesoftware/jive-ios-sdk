//
//  JiveEmbedded.h
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
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

#import <Foundation/Foundation.h>
#import "JiveObject.h"

//! \class JiveEmbedded
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/EmbeddedEntity.html
@interface JiveEmbedded : JiveObject

/*! Open ended collection of data that describes, to an OpenSocial gadget, exactly what content to render. For example, a gadget that renders a person's profile information will need to know which profile to display, The set of keys in the context field is undefined, but the field MUST NOT include a key with the value openSocial, which is reserved for use by a container implementation.
 */
@property(nonatomic, readonly, strong) NSDictionary* context;

/*! URI of the OpenSocial gadget definition document that describes the gadget to be embedded. Either gadget or url (but not both) MUST be present.
 */
@property(nonatomic, readonly, strong) NSURL* gadget;

/*! Open ended collection of properties that describe the preferred way that the creator of the embedded experience would like containers to render the content. Think of this as "view" characteristics, while the context element represents "model" characteristics.
 */
@property(nonatomic, readonly, strong) NSDictionary* preferredExperience;

/*! Either an http/https URI of an image that can be used as a preview for the embedded content, or a data: URI containing the bits of the preview image.
 */
@property(nonatomic, readonly, strong) NSString* previewImage;

/*! URL to a web page that allows virtually any web-accessible resource to be used as an embedded experience. Either gadget or url (but not both) MUST be present.
 */
@property(nonatomic, readonly, strong) NSURL* url;

@end
