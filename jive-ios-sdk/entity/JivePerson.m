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
#import "NSThread+JiveISO8601DateFormatter.h"

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

- (void)addArrayElements:(NSArray *)array toJSONDictionary:(NSMutableDictionary *)dictionary forTag:(NSString *)tag {
    if (array.count > 0) {
        NSMutableArray *JSONArray = [NSMutableArray arrayWithCapacity:array.count];
        
        for (JiveObject *object in array)
            [JSONArray addObject:object.toJSONDictionary];
        
        [dictionary setValue:[NSArray arrayWithArray:JSONArray] forKey:tag];
    }
}

- (id)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSDateFormatter *dateFormatter = [NSThread currentThread].jive_ISO8601DateFormatter;
    
    [dictionary setValue:self.displayName forKey:@"displayName"];
    [dictionary setValue:self.jiveId forKey:@"id"];
    [dictionary setValue:self.location forKey:@"location"];
    [dictionary setValue:self.status forKey:@"status"];
    [dictionary setValue:self.thumbnailUrl forKey:@"thumbnailUrl"];
    [dictionary setValue:self.type forKey:@"type"];
    [dictionary setValue:self.followerCount forKey:@"followerCount"];
    [dictionary setValue:self.followingCount forKey:@"followingCount"];
    [self addArrayElements:addresses toJSONDictionary:dictionary forTag:@"addresses"];
    [self addArrayElements:emails toJSONDictionary:dictionary forTag:@"emails"];
    [self addArrayElements:phoneNumbers toJSONDictionary:dictionary forTag:@"phoneNumbers"];
    if (published)
        [dictionary setValue:[dateFormatter stringFromDate:published] forKey:@"published"];
    
    if (updated)
        [dictionary setValue:[dateFormatter stringFromDate:updated] forKey:@"updated"];
    
    if (name)
        [dictionary setValue:[name toJSONDictionary] forKey:@"name"];
    
    if (jive)
        [dictionary setValue:[jive toJSONDictionary] forKey:@"jive"];
    
    if (tags)
        [dictionary setValue:[tags copy] forKey:@"tags"];
    
    if (photos)
        [dictionary setValue:[photos copy] forKey:@"photos"];
    
    return dictionary;
}

@end
