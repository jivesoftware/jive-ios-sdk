//
//  JiveProject.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/15/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveProject.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"

@implementation JiveProject

@synthesize creator, dueDate, projectStatus, startDate, tags;

- (id)init {
    if ((self = [super init])) {
        self.type = @"project";
    }
    
    return self;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    [dictionary setValue:projectStatus forKey:@"projectStatus"];
    if (tags)
        [dictionary setValue:tags forKey:@"tags"];
    
    if (creator)
        [dictionary setValue:[creator toJSONDictionary] forKey:@"creator"];
    
    if (dueDate)
        [dictionary setValue:[dateFormatter stringFromDate:dueDate] forKey:@"dueDate"];
    
    if (startDate)
        [dictionary setValue:[dateFormatter stringFromDate:startDate] forKey:@"startDate"];
    
    return dictionary;
}

@end
