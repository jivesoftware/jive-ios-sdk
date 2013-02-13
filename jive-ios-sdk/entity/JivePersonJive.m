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

@implementation JivePersonJive

@synthesize enabled, external, externalContributor, federated, level, locale, password, profile, timeZone, username, visible;

- (Class) arrayMappingFor:(NSString*) propertyName {
    return [@"profile" isEqualToString:propertyName] ? [JiveProfileEntry class] : nil;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:self.password forKey:@"password"];
    [dictionary setValue:self.locale forKey:@"locale"];
    [dictionary setValue:self.timeZone forKey:@"timeZone"];
    [dictionary setValue:self.username forKey:@"username"];
    [dictionary setValue:self.enabled forKey:@"enabled"];
    [dictionary setValue:self.external forKey:@"external"];
    [dictionary setValue:self.externalContributor forKey:@"externalContributor"];
    [dictionary setValue:self.federated forKey:@"federated"];
    
    return dictionary;
}

@end
