//
//  JiveDiscusson.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveContent.h"

@interface JiveDiscussion : JiveContent

// Categories associated with this object. Places define the list of possible categories. Strings
@property(nonatomic, strong) NSArray* categories;

// Flag indicating that this discussion is a question.
@property(nonatomic, strong) NSNumber *question;

// Tags associated with this object. String[]
@property(nonatomic, readonly, strong) NSArray* tags;

// The list of users that can see the content. On create or update, provide a list of Person URIs or Person entities. On get, returns a list of Person entities. This value is used only when visibility is people. String[] or Person[]
@property(nonatomic, readonly, strong) NSArray* users;

// The visibility policy for this discussion. Valid values are:
// * all - anyone with appropriate permissions can see the content. Default when visibility, parent and users were not specified.
// * people - only those users specified by users can see the content. Default when visibility and parent were not specified but users was specified.
// * place - place permissions specify which users can see the content. Default when visibility was not specified but parent was specified.
@property(nonatomic, copy) NSString* visibility;

// Flag indicating that this content object is potentially visible to external contributors.
@property(nonatomic, strong) NSNumber *visibleToExternalContributors;


@end
