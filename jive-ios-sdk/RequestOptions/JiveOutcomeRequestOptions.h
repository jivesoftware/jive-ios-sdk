//
//  JiveOutcomeRequestOptions.h
//  jive-ios-sdk
//
//  Created by Taylor Case on 4/5/13.
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

#import "JivePagedRequestOptions.h"

@interface JiveOutcomeRequestOptions : JivePagedRequestOptions

//! Flag to indicate if child outcomes should be returned as well
@property (nonatomic) BOOL includeChildrenOutcomes;


@end
