//
//  JivePropertyTests.m
//  jive-ios-sdk
//
//  Created by Taylor Case on 4/26/13.
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

#import "JivePropertyTests.h"
#import "JiveProperty.h"

@implementation JivePropertyTests

@synthesize property;

- (void)setUp {
    self.property = [JiveProperty new];
}

- (void)tearDown {
    self.property = nil;
}

- (void)testToJSON {
    NSString *availability = @"availability1";
    NSString *defaultValue = @"defaultValue1";
    NSString *description = @"description1";
    NSString *name = @"name1";
    NSString *since = @"since1";
    NSString *type = @"string";
    NSString *value = @"value1";
    
    [property setValue:availability forKey:JivePropertyAttributes.availability];
    [property setValue:defaultValue forKey:JivePropertyAttributes.defaultValue];
    [property setValue:description forKey:JivePropertyAttributes.jiveDescription];
    [property setValue:name forKey:JivePropertyAttributes.name];
    [property setValue:since forKey:JivePropertyAttributes.since];
    [property setValue:type forKey:JivePropertyAttributes.type];
    [property setValue:value forKey:JivePropertyAttributes.value];
    
    NSDictionary *JSON = [property toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:JivePropertyAttributes.availability], availability, @"availability wrong in JSON");
    STAssertEqualObjects([JSON objectForKey:JivePropertyAttributes.defaultValue], defaultValue, @"defaultValue wrong in JSON");
    STAssertEqualObjects([JSON objectForKey:JivePropertyAttributes.jiveDescription], description, @"description wrong in outcome JSON");
    STAssertEqualObjects([JSON objectForKey:JivePropertyAttributes.name], name, @"name wrong in outcome JSON");
    STAssertEqualObjects([JSON objectForKey:JivePropertyAttributes.since], since, @"since wrong in outcome JSON");
    STAssertEqualObjects([JSON objectForKey:JivePropertyAttributes.type], type, @"type wrong in outcome JSON");
    STAssertEqualObjects([JSON objectForKey:JivePropertyAttributes.value], value, @"value wrong in JSON");
}

- (void)testToJSON_alternate {
    NSString *availability = @"availability2";
    NSString *defaultValue = @"defaultValue2";
    NSString *description = @"description2";
    NSString *name = @"name2";
    NSString *since = @"since2";
    NSString *type = @"bool";
    NSNumber *value = [NSNumber numberWithBool:YES];
    
    [property setValue:availability forKey:JivePropertyAttributes.availability];
    [property setValue:defaultValue forKey:JivePropertyAttributes.defaultValue];
    [property setValue:description forKey:JivePropertyAttributes.jiveDescription];
    [property setValue:name forKey:JivePropertyAttributes.name];
    [property setValue:since forKey:JivePropertyAttributes.since];
    [property setValue:type forKey:JivePropertyAttributes.type];
    [property setValue:value forKey:JivePropertyAttributes.value];
    
    NSDictionary *JSON = [property toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:JivePropertyAttributes.availability], availability, @"availability wrong in JSON");
    STAssertEqualObjects([JSON objectForKey:JivePropertyAttributes.defaultValue], defaultValue, @"defaultValue wrong in JSON");
    STAssertEqualObjects([JSON objectForKey:JivePropertyAttributes.jiveDescription], description, @"description wrong in outcome JSON");
    STAssertEqualObjects([JSON objectForKey:JivePropertyAttributes.name], name, @"name wrong in outcome JSON");
    STAssertEqualObjects([JSON objectForKey:JivePropertyAttributes.since], since, @"since wrong in outcome JSON");
    STAssertEqualObjects([JSON objectForKey:JivePropertyAttributes.type], type, @"type wrong in outcome JSON");
    STAssertEqualObjects([JSON objectForKey:JivePropertyAttributes.value], value, @"value wrong in JSON");
}

@end
