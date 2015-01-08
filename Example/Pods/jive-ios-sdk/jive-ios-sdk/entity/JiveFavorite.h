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
#import "JiveExternalURLEntity.h"


extern struct JiveFavoriteAttributes {
    __unsafe_unretained NSString *favoriteObject;
    __unsafe_unretained NSString *private;
} const JiveFavoriteAttributes;

extern NSString * const JiveFavoriteType;

//! \class JiveFavorite
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/FavoriteEntity.html
@interface JiveFavorite : JiveContent

//! The favorite object that was saved. When creating a favorite for a JiveExternalURLEntity, the url is required.
@property(nonatomic, strong) JiveContent *favoriteObject;

//! Flag indicating that this favorite is private, and thus not shared.
@property(nonatomic, strong) NSNumber *private;
- (BOOL)isPrivate;

//! The notes for the favorite
@property(nonatomic, strong) NSString *notes;

//! A helper method to initialize a new JiveFavorite object for a target JiveContent object.
//! The object returned contains the minimum necessary to create a public bookmark of the target content.
//! Use the standard content creation methods to create the favorite on the server.
//! Notes are optional.
+ (id)createFavoriteForContent:(JiveContent *)targetContent
                          name:(NSString *)name
                         notes:(NSString *)notes;

@end
