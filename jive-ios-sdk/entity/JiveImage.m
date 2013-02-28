//
//  JiveImage.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 2/27/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveImage.h"

@implementation JiveImage

@synthesize type, jiveId, size, contentType, ref;

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];    
    [dictionary setValue:self.type forKey:@"type"];
    [dictionary setValue:self.size forKey:@"size"];
    [dictionary setValue:self.contentType forKey:@"contentType"];
    [dictionary setValue:[self.ref absoluteString] forKey:@"ref"];
    [dictionary setValue:self.jiveId forKey:@"id"];
    return dictionary;
}
@end
