//
//  Jive.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 10/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePersonJive.h"

@implementation JivePersonJive

@synthesize enabled, external, externalContributor, federated, level, locale, password, profile, timeZone, username, visible;

- (id)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:self.password forKey:@"password"];
    [dictionary setValue:self.locale forKey:@"locale"];
    [dictionary setValue:self.timeZone forKey:@"timeZone"];
    [dictionary setValue:self.username forKey:@"username"];
    
    return dictionary;
}

@end
