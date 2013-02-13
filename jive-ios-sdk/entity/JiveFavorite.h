//
//  JiveFavorite.h
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

#import "JiveContent.h"

@interface JiveFavorite : JiveContent

// The favorite object that was saved. When creating a favorite, the fields type and url are required.
@property(nonatomic, strong) NSDictionary* favoriteObject;

// Flag indicating that this favorite is private, and thus not shared.
@property(nonatomic, strong) NSNumber *private;

// Tags associated with this object.
@property(nonatomic, readonly, strong) NSArray* tags;

// Flag indicating that this content object is potentially visible to external contributors.
@property(nonatomic, strong) NSNumber *visibleToExternalContributors;

@end
