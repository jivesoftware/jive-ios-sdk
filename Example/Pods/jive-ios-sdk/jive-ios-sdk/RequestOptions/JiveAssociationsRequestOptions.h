//
//  JiveAssociationsRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/7/13.
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

//! \class JiveAssociationsRequestOptions
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/StreamService.html#getAssociations(String,%20int,%20int,%20String,%20List<String>)
@interface JiveAssociationsRequestOptions : JivePagedRequestOptions

//! Filter by object type(s) (document, group, etc.)
@property (nonatomic, strong) NSArray *types;

//! Helper method to simplify adding an object type to filter by.
- (void)addType:(NSString *)newType;

// Internal method referenced by derived classes.
- (NSMutableArray *)buildFilter;

@end
