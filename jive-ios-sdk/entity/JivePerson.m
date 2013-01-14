//
//  JivePerson.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 10/29/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePerson.h"
#import "JivePersonJive.h"
#import "JiveName.h"
#import "JiveAddress.h"
#import "JiveEmail.h"
#import "JivePhoneNumber.h"
#import "JiveResourceEntry.h"

@implementation JivePerson
@synthesize addresses, displayName, emails, followerCount, followingCount, jiveId, jive, location, name, phoneNumbers, photos, published, resources, status, tags, thumbnailUrl, updated;

- (NSString *)type {
    return @"person";
}

- (Class) arrayMappingFor:(NSString*) propertyName {
    static NSDictionary *propertyClasses = nil;
    
    if (!propertyClasses)
        propertyClasses = [NSDictionary dictionaryWithObjectsAndKeys:
                           [JiveAddress class], @"addresses",
                           [JiveEmail class], @"emails",
                           [JivePhoneNumber class], @"phoneNumbers",
                           nil];
    
    return [propertyClasses objectForKey:propertyName];
}

- (NSDictionary *) parseDictionaryForProperty:(NSString*)property fromJSON:(id)JSON {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:[JSON count]];
    
    for (NSString *key in JSON) {
        JiveResourceEntry *entry = [JiveResourceEntry instanceFromJSON:[JSON objectForKey:key]];
        
        [dictionary setValue:entry forKey:key];
    }
    
    return dictionary.count > 0 ? [NSDictionary dictionaryWithDictionary:dictionary] : nil;
}

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:self.type forKey:@"type"];
    [dictionary setValue:self.jiveId forKey:@"id"];
    [dictionary setValue:self.location forKey:@"location"];
    [dictionary setValue:self.status forKey:@"status"];
    [self addArrayElements:addresses toJSONDictionary:dictionary forTag:@"addresses"];
    [self addArrayElements:emails toJSONDictionary:dictionary forTag:@"emails"];
    [self addArrayElements:phoneNumbers toJSONDictionary:dictionary forTag:@"phoneNumbers"];
    if (jive)
        [dictionary setValue:[jive toJSONDictionary] forKey:@"jive"];
    
    if (name)
        [dictionary setValue:[name toJSONDictionary] forKey:@"name"];
    
    if (tags)
        [dictionary setValue:[tags copy] forKey:@"tags"];
    
    return dictionary;
}

@end
