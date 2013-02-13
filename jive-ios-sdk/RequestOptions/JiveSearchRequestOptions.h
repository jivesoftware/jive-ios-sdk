//
//  JiveSearchRequestOptions.h
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/4/12.
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

#import "JiveSortedRequestOptions.h"

@interface JiveSearchRequestOptions : JiveSortedRequestOptions

@property (nonatomic, strong) NSArray *search; // One or more search terms. You must escape any of the following special characters embedded in the search terms: comma (","), backslash ("\"), left parenthesis ("("), and right parenthesis (")") by preceding them with a backslash. Wildcards can be used, e.g. to search by substring use "*someSubstring*".

- (void)addSearchTerm:(NSString *)term; // Will escape ,\() for you.

@end
