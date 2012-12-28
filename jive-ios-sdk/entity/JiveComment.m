//
//  JiveComment.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveComment.h"

@implementation JiveComment

@synthesize rootType, rootURI;

- (id)init {
    if ((self = [super init])) {
        self.type = @"comment";
    }
    
    return self;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:rootType forKey:@"rootType"];
    [dictionary setValue:rootURI forKey:@"rootURI"];
    
    return dictionary;
}

@end
