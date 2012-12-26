//
//  JiveActivityObject.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveActivityObject.h"
#import "JiveMediaLink.h"

@implementation JiveActivityObject

@synthesize author, content, displayName, jiveId, image, objectType, published, summary, updated, url;

- (NSDictionary *)toJSONDictionary {
    return [NSDictionary dictionaryWithObject:jiveId forKey:@"id"];
}

@end
