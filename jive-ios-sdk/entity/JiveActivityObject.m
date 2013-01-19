//
//  JiveActivityObject.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveActivityObject.h"
#import "JiveMediaLink.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"

@implementation JiveActivityObject

@synthesize author, content, displayName, jiveId, image, objectType, published, summary, updated, url;

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    [dictionary setValue:content forKey:@"content"];
    [dictionary setValue:jiveId forKey:@"id"];
    [dictionary setValue:displayName forKey:@"displayName"];
    [dictionary setValue:[url absoluteString] forKey:@"url"];
    [dictionary setValue:objectType forKey:@"objectType"];
    [dictionary setValue:summary forKey:@"summary"];
    if (published)
        [dictionary setValue:[dateFormatter stringFromDate:published] forKey:@"published"];
    
    if (updated)
        [dictionary setValue:[dateFormatter stringFromDate:updated] forKey:@"updated"];
    
    if (author)
        [dictionary setValue:[author toJSONDictionary] forKey:@"author"];
    
    if (image)
        [dictionary setValue:[image toJSONDictionary] forKey:@"image"];
    
    return dictionary;
}

@end
