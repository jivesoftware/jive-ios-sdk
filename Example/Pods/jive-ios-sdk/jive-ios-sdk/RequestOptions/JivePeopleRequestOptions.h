//
//  JivePeopleRequestOptions.h
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

//! \class JivePeopleRequestOptions
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/PersonService.html#getPeople(String,%20String,%20int,%20int,%20String,%20List<String>,%20String,%20String)
@interface JivePeopleRequestOptions : JiveFilterTagsRequestOptions

//! Title to filter by. Can be mixed with other filters.
@property (nonatomic, strong) NSString *title;
//! Department to filter by. Can be mixed with other filters.
@property (nonatomic, strong) NSString *department;
//! Location to filter by. Can be mixed with other filters.
@property (nonatomic, strong) NSString *location;
//! Company to filter by. Can be mixed with other filters.
@property (nonatomic, strong) NSString *company;
//! Office to filter by. Can be mixed with other filters.
@property (nonatomic, strong) NSString *office;
//! Oldest hire date to filter by. Use the setter below. Can be mixed with other filters.
@property (nonatomic, readonly) NSDate *hiredAfter;
@property (nonatomic, readonly) NSDate *hiredBefore;//! Newest hire date to filter by. Use the setter below. Can be mixed with other filters.
//! Person IDs of the individual people to be returned. Can be mixed with other filters.
@property (nonatomic, strong) NSArray *ids;
//! Query string containing search terms (or null for no search criteria). Can be mixed with other filters.
@property (nonatomic, strong) NSString *query;

//! Helper method to simplify adding person ids to the ids array.
- (void)addID:(NSString *)personID;
//! Method to set the hire date range to filter by.
- (void)setHireDateBetween:(NSDate *)after and:(NSDate *)before;

@end
