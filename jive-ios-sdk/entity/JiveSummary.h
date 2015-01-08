//
//  JiveSummary.h
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

#import "JiveObject.h"

extern struct JiveSummaryAttributes {
    __unsafe_unretained NSString *html;
    __unsafe_unretained NSString *jiveId;
    __unsafe_unretained NSString *name;
    __unsafe_unretained NSString *type;
    __unsafe_unretained NSString *uri;
} const JiveSummaryAttributes;

//! \class JiveSummary
//! https://docs.developers.jivesoftware.com/api/v3/cloud/rest/SummaryEntity.html
@interface JiveSummary : JiveObject

//! The URI of the HTML representation of the summarized object.
@property(nonatomic, readonly, copy) NSString* html;

//! The object ID of the summarized object.
@property(nonatomic, readonly, copy) NSString* jiveId;

//! The name of the summarized object.
@property(nonatomic, readonly, copy) NSString* name;

//! The type of the summarized object.
@property(nonatomic, readonly, copy) NSString* type;

//! The URI of the JSON representation of the summarized object.
@property(nonatomic, readonly, copy) NSString* uri;

@end
