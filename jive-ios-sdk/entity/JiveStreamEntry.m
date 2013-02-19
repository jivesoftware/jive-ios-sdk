//
//  JiveStream.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/2/13.
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

#import "JiveStreamEntry.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"
#import "JiveResourceEntry.h"

@implementation JiveStreamEntry

@synthesize author, content, followerCount, highlightBody, highlightSubject, highlightTags, jiveId;
@synthesize likeCount, parent, parentContent, parentPlace, published, replyCount, resources, status;
@synthesize subject, tags, type, updated, verb, viewCount, visibleToExternalContributors;

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
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    [dictionary setValue:followerCount forKey:@"followerCount"];
    [dictionary setValue:highlightBody forKey:@"highlightBody"];
    [dictionary setValue:highlightSubject forKey:@"highlightSubject"];
    [dictionary setValue:highlightTags forKey:@"highlightTags"];
    [dictionary setValue:jiveId forKey:@"id"];
    [dictionary setValue:likeCount forKey:@"likeCount"];
    [dictionary setValue:parent forKey:@"parent"];
    [dictionary setValue:replyCount forKey:@"replyCount"];
    [dictionary setValue:status forKey:@"status"];
    [dictionary setValue:subject forKey:@"subject"];
    [dictionary setValue:type forKey:@"type"];
    [dictionary setValue:verb forKey:@"verb"];
    [dictionary setValue:viewCount forKey:@"viewCount"];
    [dictionary setValue:visibleToExternalContributors forKey:@"visibleToExternalContributors"];
    if (tags)
        [dictionary setValue:tags forKey:@"tags"];
    
    if (author)
        [dictionary setValue:[author toJSONDictionary] forKey:@"author"];
    
    if (content)
        [dictionary setValue:[content toJSONDictionary] forKey:@"content"];
    
    if (parentContent)
        [dictionary setValue:[parentContent toJSONDictionary] forKey:@"parentContent"];
    
    if (parentPlace)
        [dictionary setValue:[parentPlace toJSONDictionary] forKey:@"parentPlace"];
    
    if (published)
        [dictionary setValue:[dateFormatter stringFromDate:published] forKey:@"published"];
    
    if (updated)
        [dictionary setValue:[dateFormatter stringFromDate:updated] forKey:@"updated"];
    
    return dictionary;
}

@end
