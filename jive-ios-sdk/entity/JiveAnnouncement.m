//
//  JiveAnnouncement.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/13/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveAnnouncement.h"
#import "NSThread+JiveISO8601DateFormatter.h"

@implementation JiveAnnouncement

@synthesize endDate, image, publishDate, sortKey, subjectURI, subjectURITargetType;
@synthesize visibleToExternalContributors;

- (id)init {
    if ((self = [super init])) {
        self.type = @"announcement";
    }
    
    return self;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    NSDateFormatter *dateFormatter = [NSThread currentThread].jive_ISO8601DateFormatter;
    
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
