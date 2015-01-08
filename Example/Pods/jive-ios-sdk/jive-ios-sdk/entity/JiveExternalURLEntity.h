//
//  JiveExternalURLEntity.h
//  jive-ios-sdk
//
//  Created by Chris Gummer on 7/10/13.
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


extern struct JiveExternalURLEntityAttributes {
    __unsafe_unretained NSString *url;
} const JiveExternalURLEntityAttributes;


extern NSString * const JiveExternalURLEntityType;

//! \class JiveExternalURLEntity
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/ExternalURLEntity.html
@interface JiveExternalURLEntity : JiveContent

//! The external URL that was bookmarked. Required when creating a JiveFavorite.
@property (nonatomic, strong) NSURL *url;

@end
