//
//  JiveOutcome.m
//  jive-ios-sdk
//
//  Created by Taylor Case on 4/4/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveOutcome.h"
#import "JiveOutcomeType.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"

@implementation JiveOutcome

@synthesize creationDate, jiveId, outcomeType, parent, properties, resources, updated, user;

#pragma mark - JiveObject

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    if (creationDate)
        [dictionary setValue:[dateFormatter stringFromDate:creationDate] forKey:@"creationDate"];
    [dictionary setValue:self.jiveId forKey:@"id"];
    [dictionary setValue:[self.outcomeType toJSONDictionary] forKey:@"outcomeType"];
    [dictionary setValue:self.parent forKey:@"parent"];
    [dictionary setValue:[self.properties copy] forKey:@"properties"];
    [dictionary setValue:[self.resources copy] forKey:@"resources"];
    if (updated)
        [dictionary setValue:[dateFormatter stringFromDate:updated] forKey:@"updated"];
    [dictionary setValue:[self.user toJSONDictionary] forKey:@"user"];
    
    return dictionary;
}

@end
