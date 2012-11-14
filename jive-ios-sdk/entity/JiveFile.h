//
//  JiveFile.h
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveContent.h"

@interface JiveFile : JiveContent

// List of people who are authors on this content. Authors are allowed to edit the content. This value is used only when authorship is limited.
@property(nonatomic, strong) NSArray* authors;

// The authorship policy for this content.
// * open - anyone with appropriate permissions can edit the content. Default when visibility is place.
// * author - only the author can edit the content. Default when visibility is hidden or all.
// * limited - only those users specified by authors can edit the content. If authors was not specified then users will be used instead when visibility is people. Default when visibility is people.
@property(nonatomic, copy) NSString* authorship;

// URL to retrieve the binary content of this file.
@property(nonatomic, readonly, copy) NSString* binaryURL;

// Categories associated with this object. Places define the list of possible categories. Strings
@property(nonatomic, strong) NSArray* categories;


// Tags associated with this object.
@property(nonatomic, readonly, strong) NSArray* tags;

// The list of users that can see the content. On create or update, provide a list of Person URIs or Person entities. On get, returns a list of Person entities. This value is used only when visibility is people. People[]
@property(nonatomic, readonly, strong) NSArray* users;

// The visibility policy for this discussion. Valid values are:
// * all - anyone with appropriate permissions can see the content. Default when visibility, parent and users were not specified.
// * hidden - only the author can see the content.
// * people - only those users specified by users can see the content. Default when visibility and parent were not specified but users was specified.
// * place - place permissions specify which users can see the content. Default when visibility was not specified but parent was specified.
@property(nonatomic, copy) NSString* visibility;

// Flag indicating that this content object is potentially visible to external contributors.
@property(nonatomic) bool visibleToExternalContributors;

@end
