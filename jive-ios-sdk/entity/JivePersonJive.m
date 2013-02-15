//
//  Jive.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 10/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePersonJive.h"
#import "JiveProfileEntry.h"

@implementation JivePersonJive

@synthesize enabled, external, externalContributor, federated, level, locale, password, profile, timeZone, username, visible;

- (Class) arrayMappingFor:(NSString*) propertyName {
    return [@"profile" isEqualToString:propertyName] ? [JiveProfileEntry class] : nil;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:self.password forKey:@"password"];
    [dictionary setValue:self.locale forKey:@"locale"];
    [dictionary setValue:self.timeZone forKey:@"timeZone"];
    [dictionary setValue:self.username forKey:@"username"];
    [dictionary setValue:self.enabled forKey:@"enabled"];
    [dictionary setValue:self.external forKey:@"external"];
    [dictionary setValue:self.externalContributor forKey:@"externalContributor"];
    [dictionary setValue:self.federated forKey:@"federated"];
    
    return dictionary;
}

@end
