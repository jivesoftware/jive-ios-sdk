//
//  JivePost.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
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
@property(nonatomic) bool restrictComments;

// Tags associated with this object.
@property(nonatomic, readonly, strong) NSArray* tags;

// Flag indicating that this content object is potentially visible to external contributors.
@property(nonatomic) bool visibleToExternalContributors;

@end
