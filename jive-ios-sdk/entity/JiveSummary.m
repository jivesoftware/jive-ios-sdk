//
//  JiveSummary.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveSummary.h"

@implementation JiveSummary

@synthesize html, jiveId, name, type, uri;

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:self.name forKey:@"name"];
    [dictionary setValue:self.jiveId forKey:@"id"];
    [dictionary setValue:self.html forKey:@"html"];
    [dictionary setValue:self.type forKey:@"type"];
    [dictionary setValue:self.uri forKey:@"uri"];
    
    return dictionary;
}

@end
