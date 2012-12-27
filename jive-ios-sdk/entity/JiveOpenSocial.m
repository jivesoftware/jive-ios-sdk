//
//  JiveOpenSocial.m
//  jive-ios-sdk
//
//  Created by Rob Derstadt on 10/24/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveOpenSocial.h"
#import "JiveEmbedded.h"
#import "JiveActionLink.h"

@implementation JiveOpenSocial

@synthesize actionLinks, deliverTo, embed;

- (Class) arrayMappingFor:(NSString*) propertyName {
    if (propertyName == @"actionLinks") {
        return [JiveActionLink class];
    }
    
    return nil;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    if (embed)
        [dictionary setValue:[embed toJSONDictionary] forKey:@"embed"];
    
    if (deliverTo)
        [dictionary setValue:[deliverTo copy] forKey:@"deliverTo"];
    
    if (actionLinks.count > 0) {
        NSMutableArray *JSONArray = [NSMutableArray arrayWithCapacity:actionLinks.count];
        
        for (JiveObject *object in actionLinks)
            [JSONArray addObject:object.toJSONDictionary];
        
        [dictionary setValue:[NSArray arrayWithArray:JSONArray] forKey:@"actionLinks"];
    }
    
    return dictionary;
}

@end
