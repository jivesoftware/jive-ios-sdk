//
//  JivePerson.m
//  jive-ios-sdk
//
//  Created by Jacob Wright on 10/29/12.
//
//    Copyright 2013 Jive Software Inc.
//    Licensed under the Apache License, Version 2.0 (the "License");
//    you may not use this file except in compliance with the License.
//    You may obtain a copy of the License at
//    http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in writing, software
//    distributed under the License is distributed on an "AS IS" BASIS,
//    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//    See the License for the specific language governing permissions and
//    limitations under the License.
//

#import "JivePerson.h"
#import "JivePersonJive.h"
#import "JiveName.h"
#import "JiveAddress.h"
#import "JiveEmail.h"
#import "JivePhoneNumber.h"
#import "JiveTypedObject_internal.h"

@implementation JivePerson
@synthesize addresses, displayName, emails, followerCount, followingCount, jiveId, jive, location, name, phoneNumbers, photos, published, status, tags, thumbnailUrl, updated;

static NSString *personType = @"person";

+ (void)initialize {
    [super initialize];
    [super registerClass:self forType:personType];
}

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
