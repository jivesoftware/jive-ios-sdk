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
#import "JiveObject_internal.h"

@implementation JivePropertyTests

- (void)setUp {
    [super setUp];
    self.object = [JiveProperty new];
}

- (JiveProperty *)property {
    return (JiveProperty *)self.object;
}

- (void)testToJSON {
    NSString *availability = @"availability1";
    NSString *defaultValue = @"defaultValue1";
    NSString *description = @"description1";
    NSString *name = @"name1";
    NSString *since = @"since1";
    NSString *type = @"string";
    NSString *value = @"value1";
    
    [self.property setValue:availability forKey:JivePropertyAttributes.availability];
    [self.property setValue:defaultValue forKey:JivePropertyAttributes.defaultValue];
    [self.property setValue:description forKey:JivePropertyAttributes.jiveDescription];
    [self.property setValue:name forKey:JivePropertyAttributes.name];
    [self.property setValue:since forKey:JivePropertyAttributes.since];
    [self.property setValue:type forKey:JivePropertyAttributes.type];
    [self.property setValue:value forKey:JivePropertyAttributes.value];
    
    NSDictionary *JSON = [self.property toJSONDictionary];
    
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
    
    [self.property setValue:availability forKey:JivePropertyAttributes.availability];
    [self.property setValue:defaultValue forKey:JivePropertyAttributes.defaultValue];
    [self.property setValue:description forKey:JivePropertyAttributes.jiveDescription];
    [self.property setValue:name forKey:JivePropertyAttributes.name];
    [self.property setValue:since forKey:JivePropertyAttributes.since];
    [self.property setValue:type forKey:JivePropertyAttributes.type];
    [self.property setValue:value forKey:JivePropertyAttributes.value];
    
    NSDictionary *JSON = [self.property toJSONDictionary];
    
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
    [self.property setValue:JivePropertyTypes.boolean forKey:JivePropertyAttributes.type];
    [self.property setValue:@0 forKey:JivePropertyAttributes.value];
    STAssertFalse(self.property.valueAsBOOL, @"Value not reported as NO");

    [self.property setValue:@1 forKey:JivePropertyAttributes.value];
    STAssertTrue(self.property.valueAsBOOL, @"Value not reported as YES");

    [self.property setValue:JivePropertyTypes.string forKey:JivePropertyAttributes.type];
    [self.property setValue:@"dummy" forKey:JivePropertyAttributes.value];
    STAssertFalse(self.property.valueAsBOOL, @"Value not reported as NO");
}

- (void)testValueAsString {
    NSString *firstTestValue = @"first";
    NSString *secondTestValue = @"second";
    
    [self.property setValue:JivePropertyTypes.string forKey:JivePropertyAttributes.type];
    [self.property setValue:firstTestValue forKey:JivePropertyAttributes.value];
    STAssertEqualObjects(self.property.valueAsString, firstTestValue, @"Wrong string returned");
    
    [self.property setValue:secondTestValue forKey:JivePropertyAttributes.value];
    STAssertEqualObjects(self.property.valueAsString, secondTestValue, @"Wrong string returned");
    
    [self.property setValue:JivePropertyTypes.boolean forKey:JivePropertyAttributes.type];
    [self.property setValue:@0 forKey:JivePropertyAttributes.value];
    STAssertNil(self.property.valueAsString, @"A string was returned.");
}

- (void)testValueAsNumber {
    NSNumber *firstTestValue = @4;
    NSNumber *secondTestValue = @123456.789;
    
    [self.property setValue:JivePropertyTypes.number forKey:JivePropertyAttributes.type];
    [self.property setValue:firstTestValue forKey:JivePropertyAttributes.value];
    STAssertEqualObjects(self.property.valueAsNumber, firstTestValue, @"Wrong number returned");
    
    [self.property setValue:secondTestValue forKey:JivePropertyAttributes.value];
    STAssertEqualObjects(self.property.valueAsNumber, secondTestValue, @"Wrong number returned");
    
    [self.property setValue:JivePropertyTypes.string forKey:JivePropertyAttributes.type];
    [self.property setValue:@"dummy" forKey:JivePropertyAttributes.value];
    STAssertNil(self.property.valueAsNumber, @"A number was returned.");
}

- (id) JSONFromTestFile:(NSString*) filename {
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:[filename stringByDeletingPathExtension] ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSError* error;
    id json  = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    STAssertNil(error, @"Unable to deserialize JSON text data from file '%@'.json", filename);
    return json;
}

- (void)testValueAsNumber_realData {
    id numericPropertyJSON = [self JSONFromTestFile:@"feature.status_update.characters.json"];
    
    [self.property deserialize:numericPropertyJSON fromInstance:self.instance];
    STAssertEqualObjects(self.property.type, JivePropertyTypes.number, @"Wrong property type");
    STAssertEqualObjects(self.property.valueAsNumber, numericPropertyJSON[JivePropertyAttributes.value],
                         @"Wrong value");
    STAssertEqualObjects(self.property.name, numericPropertyJSON[JivePropertyAttributes.name],
                         @"Wrong name");
    STAssertEqualObjects(self.property.jiveDescription, numericPropertyJSON[@"description"],
                         @"Wrong description");
    STAssertNil(self.property.availability, @"There should be no availability");
    STAssertNil(self.property.defaultValue, @"There should be no default value");
    STAssertNil(self.property.since, @"There should be no since");
}

- (void)testDeserialize_invalidJSON {
    NSString *type = @"string";
    NSDictionary *JSON = @{@"dummy key":@"bad value", @"type":type};
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with wrong JSON including type field");
    STAssertTrue(self.object.extraFieldsDetected, @"No extra fields reported with wrong JSON");
    STAssertEqualObjects(self.property.type, type, @"Wrong type");
    STAssertNil(self.property.value, @"There should be no value");
    STAssertNil(self.property.name, @"There should be no name");
    STAssertNil(self.property.jiveDescription, @"There should be no description");
    STAssertNil(self.property.availability, @"There should be no availability");
    STAssertNil(self.property.defaultValue, @"There should be no default value");
    STAssertNil(self.property.since, @"There should be no since");
}

- (void)testDeserialize_validJSON {
    NSString *availability = @"availability1";
    NSString *defaultValue = @"defaultValue1";
    NSString *description = @"description1";
    NSString *name = @"name1";
    NSString *since = @"since1";
    NSString *type = @"string";
    NSString *value = @"value1";
    
    [self.property setValue:availability forKey:JivePropertyAttributes.availability];
    [self.property setValue:defaultValue forKey:JivePropertyAttributes.defaultValue];
    [self.property setValue:description forKey:JivePropertyAttributes.jiveDescription];
    [self.property setValue:name forKey:JivePropertyAttributes.name];
    [self.property setValue:since forKey:JivePropertyAttributes.since];
    [self.property setValue:type forKey:JivePropertyAttributes.type];
    [self.property setValue:value forKey:JivePropertyAttributes.value];
    
    NSDictionary *JSON = [self.property toJSONDictionary];
    JiveProperty *newProperty = [JiveProperty objectFromJSON:JSON withInstance:self.instance];
    
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
    JiveProperty *newProperty = [JiveProperty objectFromJSON:JSON withInstance:self.instance];
    
    STAssertEqualObjects(newProperty.type, type, @"Wrong type");
    STAssertEqualObjects(newProperty.value, value, @"Wrong value");
}

- (void)testDeserialize_validJSON_typeLast {
    NSString *type = @"string";
    NSString *value = @"value1";
    NSDictionary *JSON = @{JivePropertyAttributes.value: value,
                           JivePropertyAttributes.type: type};
    JiveProperty *newProperty = [JiveProperty objectFromJSON:JSON withInstance:self.instance];
    
    STAssertEqualObjects(newProperty.type, type, @"Wrong type");
    STAssertEqualObjects(newProperty.value, value, @"Wrong value");
}

- (void)testDeserialize_validJSON_missingType {
    NSString *name = @"string";
    NSString *value = @"value1";
    NSDictionary *JSON = @{JivePropertyAttributes.value: value,
                           JivePropertyAttributes.name: name};
    JiveProperty *newProperty = [JiveProperty objectFromJSON:JSON withInstance:self.instance];
    
    STAssertNil(newProperty, @"Property created without a valid type");
}

@end
