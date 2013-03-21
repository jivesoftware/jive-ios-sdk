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
    
    [dictionary setValue:self.visibleToExternalContributors forKey:@"visibleToExternalContributors"];
    if (self.tags)
        [dictionary setValue:self.tags forKey:@"tags"];
    
    return dictionary;
}

@end
