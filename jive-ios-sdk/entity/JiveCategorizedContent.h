//
//  JiveCategorizedContent.h
//  
//
//  Created by Orson Bushnell on 11/19/14.
//
//

#import "JiveStructuredOutcomeContent.h"


extern struct JiveCategorizedContentAttributes {
    __unsafe_unretained NSString *categories;
    __unsafe_unretained NSString *extendedAuthors;
    __unsafe_unretained NSString *users;
    __unsafe_unretained NSString *visibility;
} const JiveCategorizedContentAttributes;


@interface JiveCategorizedContent : JiveStructuredOutcomeContent

//! Categories associated with this object. Places define the list of possible categories. String[]
@property(nonatomic, strong) NSArray* categories;

//! List of people who have been granted authorship on this content, who would normally not have access to it. Extended authors are allowed to edit the content. This value is used only when authorship is limited. Person[]
@property(nonatomic, strong) NSArray* extendedAuthors;

//! The list of users that can see the content. On create or update, provide a list of Person URIs or Person entities. On get, returns a list of Person entities. This value is used only when visibility is people. String[] or Person[]
@property(nonatomic, strong) NSArray* users;

//! The visibility policy for this discussion. Valid values are:
// * all - anyone with appropriate permissions can see the content. Default when visibility, parent and users were not specified.
// * hidden - only the author can see the content.
// * people - only those users specified by users can see the content. Default when visibility and parent were not specified but users was specified.
// * place - place permissions specify which users can see the content. Default when visibility was not specified but parent was specified.
@property(nonatomic, copy) NSString* visibility;

@end
