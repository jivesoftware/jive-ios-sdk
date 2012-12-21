//
//  JivePoll.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveContent.h"

@interface JivePoll : JiveContent

// Categories associated with this object. Places define the list of possible categories. String[]
@property(nonatomic, strong) NSArray* categories;

// The options available to be voted on for this poll. String[]
@property(nonatomic, strong) NSArray* options;

// Tags associated with this object.
@property(nonatomic, readonly, strong) NSArray* tags;

// The visibility policy for this discussion. Valid values are:
// * all - anyone with appropriate permissions can see the content. Default when visibility, parent and users were not specified.
// * hidden - only the author can see the content.
// * people - only those users specified by users can see the content. Default when visibility and parent were not specified but users was specified.
// * place - place permissions specify which users can see the content. Default when visibility was not specified but parent was specified.
@property(nonatomic, copy) NSString* visibility;

// Flag indicating that this content object is potentially visible to external contributors.
@property(nonatomic) bool visibleToExternalContributors;

// The current number of votes on this poll.
@property(nonatomic, readonly) NSNumber *voteCount;

// The options voted by the user making the request. String[]
@property(nonatomic, readonly, strong) NSArray* votes;

@end
