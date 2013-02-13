//
//  JiveDefinedSizeRequestOptions.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/28/12.
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

#import "JiveDefinedSizeRequestOptions.h"

@implementation JiveDefinedSizeRequestOptions

- (NSString *)toQueryString {
    
    int size = self.size;
    static NSString *queryStrings[] = { nil, @"size=medium", @"size=small" };

    if (size < 0 || size > JiveImageSizeOptionSmallImage)
        size = 0;

    return queryStrings[size];
}

@end
