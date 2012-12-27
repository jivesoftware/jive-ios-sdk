//
//  JiveEmbedded.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveEmbedded.h"

@implementation JiveEmbedded

@synthesize context, gadget, preferredExperience, previewImage, url;

- (NSDictionary *)toJSONDictionary {
    return [NSDictionary dictionaryWithObject:[url absoluteString] forKey:@"url"];
}

@end
