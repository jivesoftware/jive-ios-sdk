//
//  JiveResource.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 11/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveResource.h"

@implementation JiveResource

@synthesize availability, description, example, hasBody, jsMethod, name, path, since, unpublished;
@synthesize verb;

- (NSDictionary *)toJSONDictionary {
    return [NSDictionary dictionaryWithObject:name forKey:@"name"];
}

@end
