//
//  JiveCommentsRequestOptions.h
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

#import "JivePagedRequestOptions.h"

//! \class JiveCommentsRequestOptions
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/ContentService.html#getComments(String,%20List<String>,%20boolean,%20boolean,%20boolean,%20int,%20int,%20String,%20String)
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/MessageService.html#getContentReplies(String,%20List<String>,%20boolean,%20boolean,%20int,%20int,%20String,%20String)
@interface JiveCommentsRequestOptions : JivePagedRequestOptions

//! optional URI for a comment to anchor at. Specifying a anchor will try to return the page containing the anchor. If the anchor could not be found then the first page of comments will be returned.
@property (nonatomic, strong) NSURL *anchor;
//! Flag indicating whether to exclude replies (and therefore return direct comments only)
@property (nonatomic) BOOL excludeReplies;
//! Flag indicating that comments should be returned in hierarchical order instead of chronological order
@property (nonatomic) BOOL hierarchical;

@end
