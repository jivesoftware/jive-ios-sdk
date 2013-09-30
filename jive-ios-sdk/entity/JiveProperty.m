//
//  JiveProperty.m
//  jive-ios-sdk
//
//  Created by Taylor Case on 4/26/13.
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

#import "JiveProperty.h"

struct JivePropertyTypes {
    __unsafe_unretained NSString *boolean;
    __unsafe_unretained NSString *string;
    __unsafe_unretained NSString *number;
};

struct JivePropertyTypes const JivePropertyTypes = {
    .boolean = @"boolean",
    .string = @"string",
    .number = @"number",
};


@implementation JiveProperty

@synthesize availability, defaultValue, jiveDescription, name, since, type, value;

#pragma mark - JiveObject

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:availability forKey:@"availability"];
    [dictionary setValue:defaultValue forKey:@"defaultValue"];
    [dictionary setValue:jiveDescription forKey:@"description"];
    [dictionary setValue:name forKey:@"name"];
    [dictionary setValue:since forKey:@"since"];
    [dictionary setValue:type forKey:@"type"];
    [dictionary setValue:value forKey:@"value"];
    
    return dictionary;
}

- (void)handlePrimitiveProperty:(NSString *)property fromJSON:(id)newValue {
    if ([self.type isEqualToString:JivePropertyTypes.boolean]) {
        [self setValue:(NSNumber *)newValue forKey:property];
    } else if ([self.type isEqualToString:JivePropertyTypes.string]) {
        [self setValue:(NSString *)newValue forKey:property];
    } else if ([self.type isEqualToString:JivePropertyTypes.number]) {
        [self setValue:(NSNumber *)newValue forKey:property];
    } else {
        NSAssert(false, @"Unknown type (%@) for property (%@)", self.type, property);
    }
}

- (BOOL)valueAsBOOL {
    if (![self.type isEqualToString:JivePropertyTypes.boolean]) {
        NSAssert(false, @"Asking for the wrong property type");
        return NO;
    }
    
    return [(NSNumber *)self.value boolValue];
}

- (NSString *)valueAsString {
    if (![self.type isEqualToString:JivePropertyTypes.string]) {
        return nil;
    }
    
    return (NSString *)self.value;
}

- (NSNumber *)valueAsNumber {
    if (![self.type isEqualToString:JivePropertyTypes.number]) {
        return nil;
    }
    
    return (NSNumber *)self.value;
}

@end
