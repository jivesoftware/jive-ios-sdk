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
#import "JiveAttachment.h"

struct JiveExternalObjectAttributes const JiveExternalObjectAttributes = {
    .attachments = @"attachments",
	.object = @"object",
    .productIcon = @"productIcon",
    .productName = @"productName",
    .onBehalfOf = @"onBehalfOf",
};

NSString * const JiveExternalType = @"extStreamActivity";

@implementation JiveExternalObject

@synthesize attachments, object, onBehalfOf, productIcon, productName;

+ (void)load {
    if (self == [JiveExternalObject class])
        [super registerClass:self forType:JiveExternalType];
}

- (NSString *)type {
    return JiveExternalType;
}

- (Class) arrayMappingFor:(NSString*) propertyName {
    if ([propertyName isEqualToString:JiveExternalObjectAttributes.attachments]) {
        return [JiveAttachment class];
    }
    return nil;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super persistentJSON];
    
    [self addArrayElements:attachments toJSONDictionary:dictionary forTag:JiveExternalObjectAttributes.attachments];
    [dictionary setValue:[object persistentJSON] forKey:JiveExternalObjectAttributes.object];
    [dictionary setValue:[onBehalfOf persistentJSON] forKey:JiveExternalObjectAttributes.onBehalfOf];
    [dictionary setValue:[productIcon absoluteString] forKey:JiveExternalObjectAttributes.productIcon];
    [dictionary setValue:productName forKey:JiveExternalObjectAttributes.productName];

    return dictionary;
}

@end
