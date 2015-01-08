//
//  JiveSortedRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/27/12.
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

#import "JivePagedRequestOptions.h"

//! \enum JiveSortOrder
//! Not all sort order values are valid for all calls. Check the call documentation.
enum JiveSortOrder {

//! Use the default sort order.
    JiveSortOrderDefault,  
//! Sort by the date this content object was created, in descending order.
    JiveSortOrderDateCreatedDesc,      
//! Sort by the date this content object was created, in ascending order
    JiveSortOrderDateCreatedAsc,       
//! Sort by the date this content object had the most recent activity, in descending order
    JiveSortOrderLatestActivityDesc,   
//! Sort by the date this content object had the most recent activity, in ascending order
    JiveSortOrderLatestActivityAsc,    
//! Sort by content object subject, in ascending order
    JiveSortOrderTitleAsc,             
//! Sort by first name in ascending order
    JiveSortOrderFirstNameAsc,         
//! Sort by last name in ascending order
    JiveSortOrderLastNameAsc,          
//! Sort by joined date in ascending order
    JiveSortOrderDateJoinedDesc,       
//! Sort by joined date in descending order
    JiveSortOrderDateJoinedAsc,        
//! Sort by status level in descending order
    JiveSortOrderStatusLevelDesc,      
//! Sort by relevance, in descending order.
    JiveSortOrderRelevanceDesc,        
//! Sort by the date this content object was most recently updated, in ascending order.
    JiveSortOrderUpdatedAsc,           
//! Sort by the date this content object was most recently updated, in descending order.
    JiveSortOrderUpdatedDesc,          
//! Sort by last profile update date/time in descending order.
    JiveSortOrderLastProfileUpdateDesc,
//! Sort by last profile update date/time in ascending order.
    JiveSortOrderLastProfileUpdateAsc,
};

//! \class JiveSortedRequestOptions
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/PersonService.html#getTasks(String,%20String,%20int,%20int,%20String,%20boolean)
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/PlaceService.html#getPlaceTasks(String,%20String,%20int,%20int,%20String,%20boolean)
@interface JiveSortedRequestOptions : JivePagedRequestOptions

//! Requested sort order
@property (nonatomic) enum JiveSortOrder sort;

@end
