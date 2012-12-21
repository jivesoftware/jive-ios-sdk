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

- (void)handlePrimitiveProperty:(NSString *)property fromJSON:(id)value {
    if ([property isEqualToString:@"enabled"])
        enabled = CFBooleanGetValue((__bridge CFBooleanRef)(value));
    else if ([property isEqualToString:@"external"])
        external = CFBooleanGetValue((__bridge CFBooleanRef)(value));
    else if ([property isEqualToString:@"externalContributor"])
        externalContributor = CFBooleanGetValue((__bridge CFBooleanRef)(value));
    else if ([property isEqualToString:@"federated"])
        federated = CFBooleanGetValue((__bridge CFBooleanRef)(value));
    else if ([property isEqualToString:@"visible"])
        visible = CFBooleanGetValue((__bridge CFBooleanRef)(value));
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:self.password forKey:@"password"];
    [dictionary setValue:self.locale forKey:@"locale"];
    [dictionary setValue:self.timeZone forKey:@"timeZone"];
    [dictionary setValue:self.username forKey:@"username"];
    
    if (enabled)
        [dictionary setValue:(__bridge id)kCFBooleanTrue forKey:@"enabled"];
    
    if (external)
        [dictionary setValue:(__bridge id)kCFBooleanTrue forKey:@"external"];
    
    if (externalContributor)
        [dictionary setValue:(__bridge id)kCFBooleanTrue forKey:@"externalContributor"];
    
    if (federated)
        [dictionary setValue:(__bridge id)kCFBooleanTrue forKey:@"federated"];
    
    if (visible)
        [dictionary setValue:(__bridge id)kCFBooleanTrue forKey:@"visible"];
    
    return dictionary;
}

@end
