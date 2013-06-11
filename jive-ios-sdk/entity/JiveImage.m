//
//  JiveImage.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 2/27/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveImage.h"
#import "JiveTypedObject_internal.h"

@implementation JiveImage

@synthesize jiveId, size, contentType, ref;

static NSString * const JiveImageType = @"image";

+ (void)load {
    if (self == [JiveImage class])
        [super registerClass:self forType:JiveImageType];
}

- (NSString *)type {
    return JiveImageType;
}

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
