//
//  JiveMediaLink.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveMediaLink.h"

@implementation JiveMediaLink

@synthesize duration, height, width, url;

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:duration forKey:@"duration"];
    [dictionary setValue:height forKey:@"height"];
    [dictionary setValue:width forKey:@"width"];
    [dictionary setValue:[url absoluteString] forKey:@"url"];
    
    return dictionary;
}

@end
