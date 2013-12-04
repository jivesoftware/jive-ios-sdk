//
//  JiveMember.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/31/12.
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

#import "JiveMember.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"
#import "JiveResourceEntry.h"

@implementation JiveMember

@synthesize group, jiveId, person, published, state, updated;

- (NSString *)type {
    return @"member";
}

- (NSDictionary *) parseDictionaryForProperty:(NSString*)property
                                     fromJSON:(id)JSON
                                 fromInstance:(Jive *)instance {
    if ([@"resources" isEqualToString:property]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:[JSON count]];
        
        for (NSString *key in JSON) {
            JiveResourceEntry *entry = [JiveResourceEntry objectFromJSON:[JSON objectForKey:key]
                                                              withInstance:instance];
            
            [dictionary setValue:entry forKey:key];
        }
        
        return dictionary.count > 0 ? [NSDictionary dictionaryWithDictionary:dictionary] : nil;
    }
    
    return nil;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    [dictionary setValue:jiveId forKey:@"id"];
    [dictionary setValue:state forKey:@"state"];
    [dictionary setValue:self.type forKey:@"type"];
    if (person)
        [dictionary setValue:[person toJSONDictionary] forKey:@"person"];
    
    if (group)
        [dictionary setValue:[group toJSONDictionary] forKey:@"group"];
    
    if (published)
        [dictionary setValue:[dateFormatter stringFromDate:published] forKey:@"published"];
    
    if (updated)
        [dictionary setValue:[dateFormatter stringFromDate:updated] forKey:@"updated"];
    
    return dictionary;
}

@end
