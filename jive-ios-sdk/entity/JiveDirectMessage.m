//
//  JiveDirectMessage.m
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

#import "JiveDirectMessage.h"
#import "JiveTypedObject_internal.h"

struct JiveDirectMessageAttributes const JiveDirectMessageAttributes = {
	.participants = @"participants",
	.typeActual = @"typeActual",
    
	.tags = @"tags",
    .visibleToExternalContributors = @"visibleToExternalContributors"
};

@implementation JiveDirectMessage

@synthesize participants, typeActual;

NSString * const JiveDirectMessageType = @"dm";

+ (void)load {
    if (self == [JiveDirectMessage class])
        [super registerClass:self forType:JiveDirectMessageType];
}

- (NSString *)type {
    return JiveDirectMessageType;
}

- (Class) arrayMappingFor:(NSString*) propertyName {
    if ([JiveDirectMessageAttributes.participants isEqualToString:propertyName]) {
        return [JivePerson class];
    }
    
    return [super arrayMappingFor:propertyName];
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = [super persistentJSON];
    
    [dictionary setValue:typeActual forKey:JiveDirectMessageAttributes.typeActual];
    [self addArrayElements:participants
    toPersistentDictionary:dictionary
                    forTag:JiveDirectMessageAttributes.participants];
    
    return dictionary;
}

@end
