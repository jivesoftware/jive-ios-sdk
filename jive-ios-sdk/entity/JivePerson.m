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

@implementation JivePerson
@synthesize addresses, displayName, emails, followerCount, followingCount, jiveId, jive, location, name, phoneNumbers, photos, published, resources, status, tags, thumbnailUrl, type, updated;


- (Class) arrayMappingFor:(NSString*) propertyName {
    if (propertyName == @"addresses") {
        return [JiveAddress class];
    }
    
    if (propertyName == @"emails") {
        return [JiveEmail class];
    }
    
    if (propertyName == @"phoneNumbers") {
        return [JivePhoneNumber class];
    }
    
    return nil;
}

- (void) parseDictionary:(NSDictionary *)dictionary forProperty:(NSString*)property FromJSON:(id)JSON {
    
}

- (id)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setValue:self.displayName forKey:@"displayName"];
    [dictionary setValue:self.jiveId forKey:@"id"];
    
    return dictionary;
}

@end
