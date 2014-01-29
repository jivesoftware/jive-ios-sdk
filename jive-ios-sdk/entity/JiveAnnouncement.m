//
//  JiveAnnouncement.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/13/12.
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

#import "JiveAnnouncement.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"
#import "JiveTypedObject_internal.h"

@implementation JiveAnnouncement

@synthesize endDate, image, publishDate, sortKey, subjectURI, subjectURITargetType;
@synthesize visibleToExternalContributors;

NSString * const JiveAnnouncementType = @"announcement";

+ (void)load {
    if (self == [JiveAnnouncement class])
        [super registerClass:self forType:JiveAnnouncementType];
}

- (NSString *)type {
    return JiveAnnouncementType;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    [dictionary setValue:sortKey forKey:@"sortKey"];
    [dictionary setValue:subjectURI forKey:@"subjectURI"];
    [dictionary setValue:subjectURITargetType forKey:@"subjectURITargetType"];
    [dictionary setValue:visibleToExternalContributors forKey:@"visibleToExternalContributors"];
    [dictionary setValue:[image absoluteString] forKey:@"image"];
    
    if (endDate)
        [dictionary setValue:[dateFormatter stringFromDate:endDate] forKey:@"endDate"];
    
    if (publishDate)
        [dictionary setValue:[dateFormatter stringFromDate:publishDate] forKey:@"publishDate"];
    
    return dictionary;
}

@end
