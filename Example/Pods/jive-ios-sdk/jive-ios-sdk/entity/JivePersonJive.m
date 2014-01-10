//
//  Jive.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 10/29/12.
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

#import "JivePersonJive.h"
#import "JiveProfileEntry.h"
#import "JiveLevel.h"
#import "JiveObject_internal.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"

struct JivePersonJiveAttributes const JivePersonJiveAttributes = {
    .enabled = @"enabled",
    .external = @"external",
    .externalContributor = @"externalContributor",
    .federated = @"federated",
    .lastProfileUpdate = @"lastProfileUpdate",
    .level = @"level",
    .locale = @"locale",
    .password = @"password",
    .sendable = @"sendable",
    .profile = @"profile",
    .termsAndConditionsRequired = @"termsAndConditionsRequired",
    .timeZone = @"timeZone",
    .username = @"username",
    .viewContent = @"viewContent",
    .visible = @"visible",
};

@implementation JivePersonJive

@synthesize enabled, external, externalContributor, federated, level, locale, password, profile;
@synthesize timeZone, username, visible, lastProfileUpdate, sendable, viewContent;
@synthesize termsAndConditionsRequired;

- (Class) arrayMappingFor:(NSString*) propertyName {
    return [JivePersonJiveAttributes.profile isEqualToString:propertyName] ? [JiveProfileEntry class] : nil;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:self.password forKey:JivePersonJiveAttributes.password];
    [dictionary setValue:self.locale forKey:JivePersonJiveAttributes.locale];
    [dictionary setValue:self.timeZone forKey:JivePersonJiveAttributes.timeZone];
    [dictionary setValue:self.username forKey:JivePersonJiveAttributes.username];
    [dictionary setValue:self.enabled forKey:JivePersonJiveAttributes.enabled];
    [dictionary setValue:self.external forKey:JivePersonJiveAttributes.external];
    [dictionary setValue:self.externalContributor forKey:JivePersonJiveAttributes.externalContributor];
    [dictionary setValue:self.federated forKey:JivePersonJiveAttributes.federated];
    
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = [super persistentJSON];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    [dictionary setValue:self.sendable forKey:JivePersonJiveAttributes.sendable];
    [dictionary setValue:self.viewContent forKey:JivePersonJiveAttributes.viewContent];
    [dictionary setValue:self.visible forKey:JivePersonJiveAttributes.visible];
    [dictionary setValue:self.termsAndConditionsRequired
                  forKey:JivePersonJiveAttributes.termsAndConditionsRequired];
    [dictionary setValue:self.level.persistentJSON forKey:JivePersonJiveAttributes.level];
    [self addArrayElements:self.profile
    toPersistentDictionary:dictionary
                    forTag:JivePersonJiveAttributes.profile];
    if (self.lastProfileUpdate) {
        [dictionary setValue:[dateFormatter stringFromDate:self.lastProfileUpdate]
                      forKey:JivePersonJiveAttributes.lastProfileUpdate];
    }
    
    return dictionary;
}

@end
