//
//  JiveStructuredOutcomeContent.h
//  
//
//  Created by Orson Bushnell on 5/7/14.
//
//    Copyright 2014 Jive Software Inc.
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

#import "JiveContent.h"


extern struct JiveStructuredOutcomeContentAttributes {
    __unsafe_unretained NSString *outcomeCounts;
    __unsafe_unretained NSString *outcomeTypeNames;
    __unsafe_unretained NSString *outcomeTypes;
} const JiveStructuredOutcomeContentAttributes;


@interface JiveStructuredOutcomeContent : JiveContent

//! Map of structured outcome type names that have been assigned to this content object, and a count of how many times they appear. Outcomes assigned to child comments and messages will also be included. Availability: Only available for content object types that support structured outcomes. @{String:Number}
@property(nonatomic, readonly, strong) NSDictionary *outcomeCounts;

//! List of structured outcome type names that have been assigned to this content object. Outcomes assigned to child comments and messages will also be included. Availability: Only available for content object types that support structured outcomes. String[]
@property(nonatomic, strong) NSArray *outcomeTypeNames;

//! A list of valid outcome types that can be set on this piece of content. Creation optional. JiveOutcomeType[]
@property(nonatomic, readonly, strong) NSArray *outcomeTypes;

@end
