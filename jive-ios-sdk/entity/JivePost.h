//
//  JivePost.h
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

@interface JivePost : JiveContent

// List of attachments to this message (if any).
@property(nonatomic, strong) NSArray* attachments;

// Categories associated with this object. Places define the list of possible categories. String[]
@property(nonatomic, strong) NSArray* categories;

// Permanent URI for the HTML version of this post.
@property(nonatomic, readonly, copy) NSString* permalink;

// Date and time at which this post should be made visible.
@property(nonatomic, strong) NSDate* publishDate;

// Flag indicating that old comments will be visible but new comments are not allowed. If not restricted then anyone with appropriate permissions can comment on the content.
@property(nonatomic, strong) NSNumber *restrictComments;

// Tags associated with this object.
@property(nonatomic, readonly, strong) NSArray* tags;

// Flag indicating that this content object is potentially visible to external contributors.
@property(nonatomic, strong) NSNumber *visibleToExternalContributors;

@end
