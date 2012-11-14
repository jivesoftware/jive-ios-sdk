//
//  JiveMessage.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveContent.h"

@interface JiveMessage : JiveContent

// Flag indicating that this message contains the correct answer to the question posed in this discussion.
@property(nonatomic) bool answer;

// List of attachments to this message (if any).
@property(nonatomic, strong) NSArray* attachments;

// URI of the discussion that this message belongs to.
@property(nonatomic, readonly, copy) NSString* discussion;

// Flag indicating that this message contains a helpful answer to the question posed in this discussion.
@property(nonatomic) bool helpful;

// Tags associated with this object.
@property(nonatomic, readonly, strong) NSArray* tags;

// Flag indicating that this content object is potentially visible to external contributors.
@property(nonatomic) bool visibleToExternalContributors;


@end
