//
//  JiveContentSearchParams.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/12/12.
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

#import "JiveSearchParams.h"

//! \class JiveSearchContentParams
@interface JiveSearchContentParams : JiveSearchParams

// Select content objects last modified after the specified date/time.
@property(nonatomic, strong) NSDate *after;

//Select content objects last modified before the specified date/time.
@property(nonatomic, strong) NSDate *before;

// Select content objects authored by the specified person. The parameter value must be either a full or partial (starting with "/people/") URI for the desired person.
@property(nonatomic, strong) NSString *author;

// Select content objects that are similar to the specified content object.
@property(nonatomic, strong) NSString *morelike;

// Select content objects that are contained in the specified place or places. The parameter value(s) must be full or partial (starting with "/places/") URI for the desired place(s).
@property(nonatomic, strong) NSString *place;

// One or more search terms, separated by commas. This filter is required. You must escape any of the following special characters embedded in the search terms: comma (","), backslash ("\"), left parenthesis ("("), and right parenthesis (")"), by preceding them with a backslash.
@property(nonatomic, strong) NSString *search;

// Optional boolean value indicating whether or not to limit search results to only content objects whose subject matches the search keywords. Defaults to true. Using NSNumber to represent Boolean. Use [NSNumber numberWithBool:YES] or [NSNumber numberWithBool:NO]
@property(nonatomic, strong) NSNumber *subjectonly;

// One or more object types of desired contained places (blog, group, project, space) separated by commas.
@property(nonatomic, strong) NSArray *type;

// Flag indicating that search results should be "collapsed" if they have the same parent. Using NSNumber to represent Boolean. Use [NSNumber numberWithBool:YES] or [NSNumber numberWithBool:NO]
@property(nonatomic, strong) NSNumber *collapse;

// Sort expression used to order results
// relevanceDesc Sort by relevance, in descending order. This is the default sort order.
// updatedAsc Sort by the date this content object was most recently updated, in ascending order.
// updatedDesc Sort by the date this content object was most recently updated, in descending order.
@property(nonatomic, strong) NSString *sort;

// Zero-relative index of the first matching result to return
@property(nonatomic, strong) NSNumber *startindex;

// Maximum number of matches to return
@property(nonatomic, strong) NSNumber *count;

// Fields to include in returned matches
@property(nonatomic, strong) NSArray *fields;


@end
