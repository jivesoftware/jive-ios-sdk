//
//  JiveOutcome.m
//  jive-ios-sdk
//
//  Created by Taylor Case on 4/4/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveOutcome.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"
#import "JiveResourceEntry.h"
#import "JiveTypedObject_internal.h"

struct JiveOutcomeAttributes const JiveOutcomeAttributes = {
	.creationDate = @"creationDate",
    .jiveId = @"jiveId",
	.outcomeType = @"outcomeType",
	.parent = @"parent",
	.properties = @"properties",
	.updated = @"updated",
	.user = @"user"
};

@implementation JiveOutcome

@synthesize creationDate, jiveId, outcomeType, parent, properties, updated, user;

static NSString * const JiveOutcome_Type = @"outcome";

+ (void)load {
    if (self == [JiveOutcome class])
        [super registerClass:self forType:JiveOutcome_Type];
}

- (NSString *)type {
    return JiveOutcome_Type;
}

#pragma mark - JiveObject

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    
    [dictionary setValue:jiveId forKey:@"id"];
    [dictionary setValue:[outcomeType toJSONDictionary] forKey:JiveOutcomeAttributes.outcomeType];
    [dictionary setValue:[properties copy] forKey:JiveOutcomeAttributes.properties];
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = [super persistentJSON];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    [dictionary setValue:[outcomeType persistentJSON] forKey:JiveOutcomeAttributes.outcomeType];
    [dictionary setValue:parent forKey:JiveOutcomeAttributes.parent];
    [dictionary setValue:[user persistentJSON] forKey:JiveOutcomeAttributes.user];
    
    if (creationDate)
        [dictionary setValue:[dateFormatter stringFromDate:creationDate] forKey:JiveOutcomeAttributes.creationDate];
    
    if (updated)
        [dictionary setValue:[dateFormatter stringFromDate:updated] forKey:JiveOutcomeAttributes.updated];
    
    return dictionary;
}

- (NSURL *)historyRef {
    return [self resourceForTag:@"history"].ref;
}

@end
