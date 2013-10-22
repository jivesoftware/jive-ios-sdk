//
//  JiveOutcomeType.m
//  jive-ios-sdk
//
//  Created by Taylor Case on 4/4/13.
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

#import "JiveOutcomeType.h"

struct JiveOutcomeTypeAttributes const JiveOutcomeTypeAttributes = {
	.fields = @"fields",
	.jiveId = @"jiveId",
	.name = @"name",
	.resources = @"resources"
};

@implementation JiveOutcomeType

@synthesize fields, jiveId, name, resources;

#pragma mark - JiveObject

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:jiveId forKey:@"id"];
    
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super persistentJSON];
    
    [dictionary setValue:[fields copy] forKey:JiveOutcomeTypeAttributes.fields];
    [dictionary setValue:name forKey:JiveOutcomeTypeAttributes.name];
    [dictionary setValue:[resources copy] forKey:JiveOutcomeTypeAttributes.resources];
    
    return dictionary;
}

@end
