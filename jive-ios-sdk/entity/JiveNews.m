//
//  JiveNews.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/26/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "JiveNews.h"
#import "JiveObject_internal.h"
#import "JiveNewsStream.h"


struct JiveNewsAttributes const JiveNewsAttributes = {
    .newsStreams = @"newsStreams",
    .owner = @"owner",
    .type = @"type",
};


@implementation JiveNews

@synthesize newsStreams, owner, type;

- (NSString *)type {
    return @"news";
}

- (Class) arrayMappingFor:(NSString*) propertyName {
    if ([JiveNewsAttributes.newsStreams isEqualToString:propertyName]) {
        return [JiveNewsStream class];
    }
    
    return [super arrayMappingFor:propertyName];
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super toJSONDictionary];
    
    dictionary[JiveNewsAttributes.type] = self.type;
    
    return dictionary;
}

- (id)persistentJSON {
    NSMutableDictionary *dictionary = [super persistentJSON];
    
    [dictionary setValue:[self.owner persistentJSON] forKey:JiveNewsAttributes.owner];
    [self addArrayElements:self.newsStreams
    toPersistentDictionary:dictionary
                    forTag:JiveNewsAttributes.newsStreams];
    
    return dictionary;
}

@end
