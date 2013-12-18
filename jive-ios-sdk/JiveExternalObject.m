//
//  JiveExternalObject.m
//  Pods
//
//  Created by Janeen Neri on 12/18/13.
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

#import "JiveExternalObject.h"
#import "JiveTypedObject_internal.h"

NSString * const JiveExternalType = @"extStreamActivity";

@implementation JiveExternalObject

@synthesize onBehalfOf, productIcon, productName;

+ (void)load {
    if (self == [JiveExternalObject class])
        [super registerClass:self forType:JiveExternalType];
}

- (NSString *)type {
    return JiveExternalType;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    if (onBehalfOf)
        [dictionary setValue:[onBehalfOf toJSONDictionary] forKey:@"onBehalfOf"];
    
    [dictionary setValue:productIcon forKey:@"productIcon"];
    [dictionary setValue:productName forKey:@"productName"];

    return dictionary;
}

@end
