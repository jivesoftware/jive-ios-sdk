//
//  JiveAttachment.m
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

#import "JiveAttachment.h"
#import "JiveResourceEntry.h"

@implementation JiveAttachment

@synthesize contentType, doUpload, jiveId, name, resources, size, url;

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
        
        if (dictionary.count > 0)
            return [NSDictionary dictionaryWithDictionary:dictionary];
    }
    
    return nil;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:contentType forKey:@"contentType"];
    [dictionary setValue:doUpload forKey:@"doUpload"];
    [dictionary setValue:jiveId forKey:@"id"];
    [dictionary setValue:name forKey:@"name"];
    [dictionary setValue:size forKey:@"size"];
    [dictionary setValue:[url absoluteString] forKey:@"url"];
    
    return dictionary;
}
@end
