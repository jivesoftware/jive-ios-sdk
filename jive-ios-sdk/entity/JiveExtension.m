//
//  JiveExtension.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveExtension.h"
#import "JiveActivityObject.h"

@implementation JiveExtension

@synthesize collection, collectionUpdated, display, parent, read, state, update;

- (NSDictionary *)toJSONDictionary {
    return [NSDictionary dictionaryWithObject:state forKey:@"state"];
}

@end
