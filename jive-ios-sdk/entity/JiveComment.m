//
//  JiveComment.m
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

#import "JiveComment.h"

@implementation JiveComment

@synthesize rootType, rootURI;

- (id)init {
    if ((self = [super init])) {
        self.type = @"comment";
    }
    
    return self;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:rootType forKey:@"rootType"];
    [dictionary setValue:rootURI forKey:@"rootURI"];
    
    return dictionary;
}

@end
