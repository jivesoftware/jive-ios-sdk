//
//  JivePlacePlacesRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/29/12.
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

#import "JiveFilterTagsRequestOptions.h"

//! \class JivePlacePlacesRequestOptions
//! https://developers.jivesoftware.com/api/v3/rest/PlaceService.html#getPlacePlaces(String,%20int,%20int,%20String,%20List<String>,%20String)
@interface JivePlacePlacesRequestOptions : JiveFilterTagsRequestOptions

//! Select entries of the specified type. One or more types can be specified.
@property (nonatomic, strong) NSArray *types;
//! One or more search terms, separated by commas. You must escape any of the following special characters embedded in the search terms: comma (","), backslash ("\"), left parenthesis ("("), and right parenthesis (")") by preceding them with a backslash. Wildcards can be used, e.g. to search by substring use "*someSubstring*".
@property (nonatomic, strong) NSArray *search;

//! Helper method for adding a type to the types array.
- (void)addType:(NSString *)type;
//! Will escape ,\() for you. Helper method for adding a search term to the search terms array.
- (void)addSearchTerm:(NSString *)term;

@end
