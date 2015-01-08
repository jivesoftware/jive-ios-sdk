//
//  JiveFile.h
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


extern struct JiveFileAttributes {
    __unsafe_unretained NSString *binaryURL;
    __unsafe_unretained NSString *contentType;
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *restrictComments;
    __unsafe_unretained NSString *size;
    
    // Deprecated attribute names. Please use the JiveAuthorableContentAttributes names.
    __unsafe_unretained NSString *authors;
    __unsafe_unretained NSString *authorship;
    
    // Deprecated attribute names. Please use the JiveCategorizedContentAttributes names.
    __unsafe_unretained NSString *categories;
    __unsafe_unretained NSString *users;
    __unsafe_unretained NSString *visibility;
    
    // Deprecated attribute names. Please use the JiveContentAttribute names.
    __unsafe_unretained NSString *tags;
    __unsafe_unretained NSString *visibleToExternalContributors;
} const JiveFileAttributes;


extern NSString * const JiveFileType;


//! \class JiveFile
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/FileEntity.html
@interface JiveFile : JiveAuthorableContent

//! URL to retrieve the binary content of this file.
@property(nonatomic, readonly, copy) NSURL* binaryURL;

//! The MIME type of this file.
@property (nonatomic, readonly, copy) NSString *contentType;

//! The filename of this file.
@property(nonatomic, readonly, copy) NSString *name;

//! Flag indicating that old comments will be visible but new comments are not allowed. If not restricted then anyone with appropriate permissions can comment on the content.
@property(nonatomic, strong) NSNumber *restrictComments;
- (BOOL)commentsNotAllowed;

//! The size (in bytes) of this file.
@property(nonatomic, readonly, strong) NSNumber *size;

@end
