//
//  JiveSearchContentsRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/4/12.
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

#import "JiveSearchTypesRequestOptions.h"

//! \class JiveSearchContentsRequestOptions
//! https://developers.jivesoftware.com/api/v3/rest/SearchService.html#searchContents(List<String>,%20boolean,%20String,%20int,%20int,%20String)
@interface JiveSearchContentsRequestOptions : JiveSearchTypesRequestOptions

//! Optional boolean value indicating whether or not to limit search results to only content objects whose subject matches the search keywords.
@property (nonatomic) BOOL subjectOnly;
//! Select content objects last modified after the specified date/time.
@property (nonatomic, strong) NSDate *after;
//! Select content objects last modified before the specified date/time.
@property (nonatomic, strong) NSDate *before;
//! Select content objects authored by the specified person. Only one of authorURL and authorID can be specified.
@property (nonatomic, strong) NSURL *authorURL;
//! Select content objects authored by the specified person. Only one of authorID and authorURL can be specified.
@property (nonatomic, strong) NSString *authorID;
//! Select content objects that are similar to the specified content object.
@property (nonatomic, strong) NSString *moreLikeContentID;
//! Select content objects that are contained in the specified place or places. The parameter value(s) must be full or partial (starting with "/places/") URI for the desired place(s), see the add methods.
@property (nonatomic, strong) NSArray *places;

//! Helper method to add a place id to the places array.
- (void)addPlaceID:(NSString *)place;
//! Helper method to add a place URL to the places array.
- (void)addPlaceURL:(NSURL *)place;

@end
