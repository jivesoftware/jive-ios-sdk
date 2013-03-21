//
//  JiveVideo.m
//  jive-ios-sdk
//
//  Created by Chris Gummer on 3/20/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveVideo.h"
#import "JiveTypedObject_internal.h"

@implementation JiveVideo

@synthesize tags, visibleToExternalContributors;

static NSString * const JiveVideoType = @"video";

+ (void)initialize {
    if (self == [JiveVideo class])
        [super registerClass:self forType:JiveVideoType];
}

- (NSString *)type {
    return JiveVideoType;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:visibleToExternalContributors forKey:@"visibleToExternalContributors"];
    if (tags)
        [dictionary setValue:tags forKey:@"tags"];
    
    return dictionary;
}

@end
