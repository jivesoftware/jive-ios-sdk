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
#import "JiveObject_internal.h"

struct JivePropertyTypes const JivePropertyTypes = {
    .boolean = @"boolean",
    .string = @"string",
    .number = @"integer",
};

struct JivePropertyAttributes const JivePropertyAttributes = {
    .availability = @"availability",
    .defaultValue = @"defaultValue",
    .jiveDescription = @"jiveDescription",
    .name = @"name",
    .since = @"since",
    .type = @"type",
    .value = @"value",
};

struct JivePropertyNames const JivePropertyNames = {
    .instanceURL = @"instance.url",
    .statusUpdateMaxCharacters = @"feature.status_update.characters",
    .statusUpdatesEnabled = @"jive.coreapi.enable.statusupdates",
    .realTimeChatEnabled = @"feature.rtc.enabled",
    .imagesEnabled = @"feature.images.enabled",
    .personalStatusUpdatesEnabled = @"feature.status_update.enabled",
    .placeStatusUpdatesEnabled = @"feature.status_update_place.enabled",
    .repostStatusUpdatesEnabled = @"feature.status_update_repost.enabled",
    .mobileBinaryDownloadsDisabled = @"jive.coreapi.disable.binarydownloads.mobileonly",
};

@implementation JiveProperty

@synthesize availability, defaultValue, jiveDescription, name, since, type, value;

#pragma mark - JiveObject

- (BOOL) deserialize:(id)JSON fromInstance:(Jive *)instance {
    if (![JSON objectForKey:JivePropertyAttributes.type]) {
        return false;
    }
    
    // Make sure the type is deserialized first.
    [self deserializeKey:JivePropertyAttributes.type fromJSON:JSON fromInstance:instance];
    
    return [super deserialize:JSON fromInstance:instance];
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:availability forKey:JivePropertyAttributes.availability];
    [dictionary setValue:defaultValue forKey:JivePropertyAttributes.defaultValue];
    [dictionary setValue:jiveDescription forKey:JivePropertyAttributes.jiveDescription];
    [dictionary setValue:name forKey:JivePropertyAttributes.name];
    [dictionary setValue:since forKey:JivePropertyAttributes.since];
    [dictionary setValue:type forKey:JivePropertyAttributes.type];
    [dictionary setValue:value forKey:JivePropertyAttributes.value];
    
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
