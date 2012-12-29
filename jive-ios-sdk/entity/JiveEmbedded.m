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

- (NSDictionary *) parseDictionaryForProperty:(NSString*)property fromJSON:(id)JSON {
    return JSON;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:context forKey:@"context"];
    [dictionary setValue:preferredExperience forKey:@"preferredExperience"];
    [dictionary setValue:[gadget absoluteString] forKey:@"gadget"];
    [dictionary setValue:previewImage forKey:@"previewImage"];
    [dictionary setValue:[url absoluteString] forKey:@"url"];
    
    return dictionary;
}

@end
