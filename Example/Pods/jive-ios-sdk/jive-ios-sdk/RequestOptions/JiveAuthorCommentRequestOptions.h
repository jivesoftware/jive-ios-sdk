//
//  JiveAuthorCommentRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/30/12.
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

#import "JiveReturnFieldsRequestOptions.h"

//! \class JiveAuthorCommentRequestOptions
//! https://developers.jivesoftware.com/api/v3/rest/ContentService.html#createComment(String,%20String,%20boolean,%20String)
@interface JiveAuthorCommentRequestOptions : JiveReturnFieldsRequestOptions

//! Flag indicating if new comment is an author comment or a regular comment (only valid for documents). By default a regular comment will be created.
@property (nonatomic) BOOL author;

@end
