//
//  JiveVia.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 5/13/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "JiveVia.h"


struct JiveViaAttributes const JiveViaAttributes = {
    .displayName = @"displayName",
    .url = @"url",
};


@implementation JiveVia

@synthesize displayName, url;

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    [dictionary setValue:displayName forKeyPath:JiveViaAttributes.displayName];
    [dictionary setValue:[url absoluteString] forKeyPath:JiveViaAttributes.url];
    
    return dictionary;
}

@end
