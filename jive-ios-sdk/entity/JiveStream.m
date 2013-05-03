//
//  JiveStream.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/7/13.
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

#import "JiveStream.h"
#import "JiveTypedObject_internal.h"

struct JiveStreamResourceTags {
    __unsafe_unretained NSString *activity;
};

struct JiveStreamResourceTags const JiveStreamResourceTags = {
    .activity = @"activity"
};

@implementation JiveStream

@synthesize jiveId, name, person, published, receiveEmails, source, updated;

- (NSString *)type {
    return @"stream";
}

- (NSDictionary *) parseDictionaryForProperty:(NSString*)property fromJSON:(id)JSON {
    if ([@"resources" isEqualToString:property]) {
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:[JSON count]];
        
        for (NSString *key in JSON) {
            JiveResourceEntry *entry = [JiveResourceEntry instanceFromJSON:[JSON objectForKey:key]];
            
            [dictionary setValue:entry forKey:key];
        }
        
        return dictionary.count > 0 ? [NSDictionary dictionaryWithDictionary:dictionary] : nil;
    }
    
    return nil;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:name forKey:@"name"];
    [dictionary setValue:receiveEmails forKey:@"receiveEmails"];
    if (source)
        [dictionary setValue:source forKey:@"source"];
    else if (name)
        [dictionary setValue:@"custom" forKey:@"source"];
    
    return dictionary;
}

- (NSURL *)activity {
    return [self resourceForTag:JiveStreamResourceTags.activity].ref;
}

@end
