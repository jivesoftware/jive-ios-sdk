//
//  JiveDocument.h
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

#import "JiveAuthorableContent.h"


extern NSString * const JiveDocumentType;


extern struct JiveDocumentAttributes {
    __unsafe_unretained NSString *approvers;
    __unsafe_unretained NSString *attachments;
    __unsafe_unretained NSString *editingBy;
    __unsafe_unretained NSString *fromQuest;
    __unsafe_unretained NSString *restrictComments;
    __unsafe_unretained NSString *updater;
    
    // Deprecated attribute names. Please use the JiveAuthorableContentAttributes names.
    __unsafe_unretained NSString *authors;
    __unsafe_unretained NSString *authorship;
    
    // Deprecated attribute names. Please use the JiveCategorizedContentAttributes names.
    __unsafe_unretained NSString *categories;
    __unsafe_unretained NSString *users;
    __unsafe_unretained NSString *visibility;
    
    // Deprecated attribute names. Please use the JiveStructuredOutcomeContentAttribute names.
    __unsafe_unretained NSString *outcomeCounts;
    __unsafe_unretained NSString *outcomeTypeNames;
    __unsafe_unretained NSString *outcomeTypes;
    
    // Deprecated attribute names. Please use the JiveContentAttribute names.
    __unsafe_unretained NSString *tags;
    __unsafe_unretained NSString *visibleToExternalContributors;
} const JiveDocumentAttributes;


//! \class JiveDocument
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/DocumentEntity.html
@interface JiveDocument : JiveAuthorableContent

//! List of people who are approvers on the content of this document. Person[]
@property(nonatomic, strong) NSArray* approvers;

//! List of attachments to this message (if any). Attachment[]
@property(nonatomic, strong) NSArray* attachments;

//! The person currently editing this document, meaning that it's locked. If not present, nobody is editing.
@property(nonatomic, readonly) JivePerson *editingBy;

//! Flag indicating that this document was created as part of a quest.
@property(nonatomic, copy) NSString* fromQuest;

//! Flag indicating that old comments will be visible but new comments are not allowed. If not restricted then anyone with appropriate permissions can comment on the content.
@property(nonatomic, strong) NSNumber *restrictComments;

//! The last person that updated this document. If not present, the last person to update this document was the person referenced in the author property.
@property(nonatomic, readonly, strong) JivePerson* updater;

@end
