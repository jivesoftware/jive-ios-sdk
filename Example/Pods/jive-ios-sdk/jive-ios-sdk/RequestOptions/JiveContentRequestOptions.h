//
//  JiveContentRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/3/12.
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

#import "JivePlacesRequestOptions.h"

//! \class JiveContentRequestOptions
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#getContents(List<String>,%20String,%20int,%20int,%20String)
@interface JiveContentRequestOptions : JivePlacesRequestOptions

//! one or more person URIs
@property (nonatomic, strong) NSArray *authors;
//! place URI where the content lives
@property (nonatomic, strong) NSURL *place;

//! Helper method to simplify adding an Author URL to the authors array.
- (void)addAuthor:(NSURL *)url;

@end
