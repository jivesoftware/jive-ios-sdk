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

- (void)testValueAsBool {
    [property setValue:JivePropertyTypes.boolean forKey:JivePropertyAttributes.type];
    [property setValue:@0 forKey:JivePropertyAttributes.value];
    STAssertFalse(property.valueAsBOOL, @"Value not reported as NO");

    [property setValue:@1 forKey:JivePropertyAttributes.value];
    STAssertTrue(property.valueAsBOOL, @"Value not reported as YES");

    [property setValue:JivePropertyTypes.string forKey:JivePropertyAttributes.type];
    [property setValue:@"dummy" forKey:JivePropertyAttributes.value];
    STAssertFalse(property.valueAsBOOL, @"Value not reported as NO");
}

- (void)testValueAsString {
    NSString *firstTestValue = @"first";
    NSString *secondTestValue = @"second";
    
    [property setValue:JivePropertyTypes.string forKey:JivePropertyAttributes.type];
    [property setValue:firstTestValue forKey:JivePropertyAttributes.value];
    STAssertEqualObjects(property.valueAsString, firstTestValue, @"Wrong string returned");
    
    [property setValue:secondTestValue forKey:JivePropertyAttributes.value];
    STAssertEqualObjects(property.valueAsString, secondTestValue, @"Wrong string returned");
    
    [property setValue:JivePropertyTypes.boolean forKey:JivePropertyAttributes.type];
    [property setValue:@0 forKey:JivePropertyAttributes.value];
    STAssertNil(property.valueAsString, @"A string was returned.");
}

- (void)testValueAsNumber {
    NSNumber *firstTestValue = @4;
    NSNumber *secondTestValue = @123456.789;
    
    [property setValue:JivePropertyTypes.number forKey:JivePropertyAttributes.type];
    [property setValue:firstTestValue forKey:JivePropertyAttributes.value];
    STAssertEqualObjects(property.valueAsNumber, firstTestValue, @"Wrong number returned");
    
    [property setValue:secondTestValue forKey:JivePropertyAttributes.value];
    STAssertEqualObjects(property.valueAsNumber, secondTestValue, @"Wrong number returned");
    
    [property setValue:JivePropertyTypes.string forKey:JivePropertyAttributes.type];
    [property setValue:@"dummy" forKey:JivePropertyAttributes.value];
    STAssertNil(property.valueAsNumber, @"A number was returned.");
}

- (void)testDeserialize_validJSON {
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
    JiveProperty *newProperty = [JiveProperty instanceFromJSON:JSON];
    
    STAssertEqualObjects(newProperty.availability, availability, @"Wrong availability");
    STAssertEqualObjects(newProperty.defaultValue, defaultValue, @"Wrong defaultValue");
    STAssertEqualObjects(newProperty.jiveDescription, description, @"Wrong description");
    STAssertEqualObjects(newProperty.name, name, @"Wrong name");
    STAssertEqualObjects(newProperty.since, since, @"Wrong since");
    STAssertEqualObjects(newProperty.type, type, @"Wrong type");
    STAssertEqualObjects(newProperty.value, value, @"Wrong value");
}

- (void)testDeserialize_validJSON_typeFirst {
    NSString *type = @"string";
    NSString *value = @"value1";
    NSDictionary *JSON = @{JivePropertyAttributes.type: type,
                           JivePropertyAttributes.value: value};
    JiveProperty *newProperty = [JiveProperty instanceFromJSON:JSON];
    
    STAssertEqualObjects(newProperty.type, type, @"Wrong type");
    STAssertEqualObjects(newProperty.value, value, @"Wrong value");
}

- (void)testDeserialize_validJSON_typeLast {
    NSString *type = @"string";
    NSString *value = @"value1";
    NSDictionary *JSON = @{JivePropertyAttributes.value: value,
                           JivePropertyAttributes.type: type};
    JiveProperty *newProperty = [JiveProperty instanceFromJSON:JSON];
    
    STAssertEqualObjects(newProperty.type, type, @"Wrong type");
    STAssertEqualObjects(newProperty.value, value, @"Wrong value");
}

- (void)testDeserialize_validJSON_missingType {
    NSString *name = @"string";
    NSString *value = @"value1";
    NSDictionary *JSON = @{JivePropertyAttributes.value: value,
                           JivePropertyAttributes.name: name};
    JiveProperty *newProperty = [JiveProperty instanceFromJSON:JSON];
    
    STAssertNil(newProperty, @"Property created without a valid type");
}

@end
