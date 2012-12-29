//
//  JiveTask.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveTask.h"
#import "NSThread+JiveISO8601DateFormatter.h"

@implementation JiveTask

@synthesize completed, dueDate, parentTask, subTasks, tags, visibleToExternalContributors;

- (id)init {
    if ((self = [super init])) {
        self.type = @"task";
    }
    
    return self;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    NSDateFormatter *dateFormatter = [NSThread currentThread].jive_ISO8601DateFormatter;
    
    [dictionary setValue:parentTask forKey:@"parentTask"];
    [dictionary setValue:completed forKey:@"completed"];
    [dictionary setValue:visibleToExternalContributors forKey:@"visibleToExternalContributors"];
    if (tags)
        [dictionary setValue:tags forKey:@"tags"];
    
    if (subTasks)
        [dictionary setValue:subTasks forKey:@"subTasks"];
    
    if (dueDate)
        [dictionary setValue:[dateFormatter stringFromDate:dueDate] forKey:@"dueDate"];
    
    return dictionary;
}

@end
