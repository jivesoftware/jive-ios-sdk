//
//  JiveContentBody.m
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

#import "JiveContentBody.h"

struct JiveContentBodyAttributes const JiveContentBodyAttributes = {
    .editable = @"editable",
    .text = @"text",
    .type = @"type"
};

@implementation JiveContentBody

@synthesize text, type, editable;

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:text forKey:JiveContentBodyAttributes.text];
    [dictionary setValue:type forKey:JiveContentBodyAttributes.type];
    
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = [super persistentJSON];
    
    [dictionary setValue:editable forKey:JiveContentBodyAttributes.editable];
    
    return dictionary;
}

@end
