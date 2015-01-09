//
//  JiveAuthorableContent.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/17/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "JiveCategorizedContent.h"


extern struct JiveAuthorableContentAttributes {
    __unsafe_unretained NSString *authors;
    __unsafe_unretained NSString *authorship;
} const JiveAuthorableContentAttributes;


@interface JiveAuthorableContent : JiveCategorizedContent

//! List of people who are authors on this content. Authors are allowed to edit the content. This value is used only when authorship is limited. Person[]
@property(nonatomic, strong) NSArray *authors;

//! The authorship policy for this content. Some content types have a fixed authorship of author and will ignore this property.
// * open - anyone with appropriate permissions can edit the content. Default when visibility is place.
// * author - only the author can edit the content. Default when visibility is hidden or all.
// * limited - only those users specified by authors can edit the content. If authors was not specified then users will be used instead when visibility is people. Default when visibility is people.
@property(nonatomic, copy) NSString *authorship;

@end
