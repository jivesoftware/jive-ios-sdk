//
//  JiveObjectMetadataTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/2/13.
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

#import "JiveObjectMetadataTests.h"
#import "JiveField.h"
#import "JiveResource.h"

@implementation JiveObjectMetadataTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveObjectMetadata alloc] init];
}

- (JiveObjectMetadata *)objectMetadata {
    return (JiveObjectMetadata *)self.object;
}

- (void)testToJSON {
    JiveField *field = [[JiveField alloc] init];
    JiveResource *resourceLink = [[JiveResource alloc] init];
    NSDictionary *JSON = [self.objectMetadata toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [field setValue:@"displayName" forKey:@"displayName"];
    [resourceLink setValue:@"name" forKey:@"name"];
    [self.objectMetadata setValue:[NSNumber numberWithBool:YES] forKey:@"associatable"];
    [self.objectMetadata setValue:[NSArray arrayWithObject:field] forKey:@"fields"];
    [self.objectMetadata setValue:[NSArray arrayWithObject:resourceLink] forKey:@"resourceLinks"];
    [self.objectMetadata setValue:@"availability" forKey:@"availability"];
    [self.objectMetadata setValue:@"description" forKey:@"jiveDescription"];
    [self.objectMetadata setValue:@"example" forKey:@"example"];
    [self.objectMetadata setValue:@"name" forKey:@"name"];
    [self.objectMetadata setValue:@"plural" forKey:@"plural"];
    [self.objectMetadata setValue:@"since" forKey:@"since"];
    
    JSON = [self.objectMetadata toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)9, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"associatable"], self.objectMetadata.associatable, @"Wrong associatable.");
    STAssertEqualObjects([JSON objectForKey:@"availability"], self.objectMetadata.availability, @"Wrong availability.");
    STAssertEqualObjects([JSON objectForKey:@"description"], self.objectMetadata.jiveDescription, @"Wrong description");
    STAssertEqualObjects([JSON objectForKey:@"example"], self.objectMetadata.example, @"Wrong example");
    STAssertEqualObjects([JSON objectForKey:@"name"], self.objectMetadata.name, @"Wrong name");
    STAssertEqualObjects([JSON objectForKey:@"plural"], self.objectMetadata.plural, @"Wrong plural");
    STAssertEqualObjects([JSON objectForKey:@"since"], self.objectMetadata.since, @"Wrong since.");
    
    NSArray *addressJSON = [JSON objectForKey:@"fields"];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"fields array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[[addressJSON objectAtIndex:0] class] isSubclassOfClass:[NSDictionary class]], @"fields object not converted");
    
    NSArray *emailsJSON = [JSON objectForKey:@"resourceLinks"];
    
    STAssertTrue([[emailsJSON class] isSubclassOfClass:[NSArray class]], @"resourceLinks array not converted");
    STAssertEquals([emailsJSON count], (NSUInteger)1, @"Wrong number of elements in the emails array");
    STAssertTrue([[[emailsJSON objectAtIndex:0] class] isSubclassOfClass:[NSDictionary class]], @"resourceLinks object not converted");
}

- (void)testToJSON_alternate {
    [self.objectMetadata setValue:@"wrong" forKey:@"availability"];
    [self.objectMetadata setValue:@"title" forKey:@"jiveDescription"];
    [self.objectMetadata setValue:@"big" forKey:@"example"];
    [self.objectMetadata setValue:@"Whippersnapper" forKey:@"name"];
    [self.objectMetadata setValue:@"singular" forKey:@"plural"];
    [self.objectMetadata setValue:@"until" forKey:@"since"];
    [self.objectMetadata setValue:[NSNumber numberWithBool:YES] forKey:@"commentable"];
    
    NSDictionary *JSON = [self.objectMetadata toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)7, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"availability"], self.objectMetadata.availability, @"Wrong availability.");
    STAssertEqualObjects([JSON objectForKey:@"description"], self.objectMetadata.jiveDescription, @"Wrong description");
    STAssertEqualObjects([JSON objectForKey:@"example"], self.objectMetadata.example, @"Wrong example");
    STAssertEqualObjects([JSON objectForKey:@"name"], self.objectMetadata.name, @"Wrong name");
    STAssertEqualObjects([JSON objectForKey:@"plural"], self.objectMetadata.plural, @"Wrong plural");
    STAssertEqualObjects([JSON objectForKey:@"since"], self.objectMetadata.since, @"Wrong since.");
    STAssertEqualObjects([JSON objectForKey:@"commentable"], self.objectMetadata.commentable, @"Wrong commentable.");
}

- (void)testToJSON_content {
    [self.objectMetadata setValue:[NSNumber numberWithBool:YES] forKey:@"content"];
    
    NSDictionary *JSON = [self.objectMetadata toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"content"], self.objectMetadata.content, @"Wrong content.");
}

- (void)testToJSON_place {
    [self.objectMetadata setValue:[NSNumber numberWithBool:YES] forKey:@"place"];
    
    NSDictionary *JSON = [self.objectMetadata toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"place"], self.objectMetadata.place, @"Wrong place.");
}

- (void)testToJSON_allFlags {
    [self.objectMetadata setValue:[NSNumber numberWithBool:YES] forKey:@"associatable"];
    [self.objectMetadata setValue:[NSNumber numberWithBool:YES] forKey:@"commentable"];
    [self.objectMetadata setValue:[NSNumber numberWithBool:YES] forKey:@"content"];
    [self.objectMetadata setValue:[NSNumber numberWithBool:YES] forKey:@"place"];
    
    NSDictionary *JSON = [self.objectMetadata toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)4, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"associatable"], self.objectMetadata.associatable, @"Wrong associatable.");
    STAssertEqualObjects([JSON objectForKey:@"commentable"], self.objectMetadata.commentable, @"Wrong commentable.");
    STAssertEqualObjects([JSON objectForKey:@"content"], self.objectMetadata.content, @"Wrong content.");
    STAssertEqualObjects([JSON objectForKey:@"place"], self.objectMetadata.place, @"Wrong place.");
}

- (void)testToJSON_fields {
    JiveField *field1 = [[JiveField alloc] init];
    JiveField *field2 = [[JiveField alloc] init];
    
    [field1 setValue:@"displayName" forKey:@"displayName"];
    [field2 setValue:@"alternate" forKey:@"displayName"];
    [self.objectMetadata setValue:[NSArray arrayWithObject:field1] forKey:@"fields"];
    
    NSDictionary *JSON = [self.objectMetadata toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    NSArray *addressJSON = [JSON objectForKey:@"fields"];
    NSDictionary *object1 = [addressJSON objectAtIndex:0];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"field array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the field array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"field object not converted");
    STAssertEqualObjects([object1 objectForKey:@"displayName"], field1.displayName, @"Wrong field displayName");
    
    [self.objectMetadata setValue:[self.objectMetadata.fields arrayByAddingObject:field2] forKey:@"fields"];
    
    JSON = [self.objectMetadata toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    addressJSON = [JSON objectForKey:@"fields"];
    object1 = [addressJSON objectAtIndex:0];
    
    NSDictionary *object2 = [addressJSON objectAtIndex:1];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"field array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)2, @"Wrong number of elements in the field array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"field 1 object not converted");
    STAssertEqualObjects([object1 objectForKey:@"displayName"], field1.displayName, @"Wrong field 1 displayName");
    STAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"field 2 object not converted");
    STAssertEqualObjects([object2 objectForKey:@"displayName"], field2.displayName, @"Wrong field 2 displayName");
}

- (void)testToJSON_resourceLinks {
    JiveResource *resourceLink1 = [[JiveResource alloc] init];
    JiveResource *resourceLink2 = [[JiveResource alloc] init];
    
    [resourceLink1 setValue:@"name" forKey:@"name"];
    [resourceLink2 setValue:@"alternate" forKey:@"name"];
    [self.objectMetadata setValue:[NSArray arrayWithObject:resourceLink1] forKey:@"resourceLinks"];
    
    NSDictionary *JSON = [self.objectMetadata toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    NSArray *addressJSON = [JSON objectForKey:@"resourceLinks"];
    NSDictionary *object1 = [addressJSON objectAtIndex:0];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"resourceLink array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the resourceLink array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"resourceLink object not converted");
    STAssertEqualObjects([object1 objectForKey:@"name"], resourceLink1.name, @"Wrong resourceLink name");
    
    [self.objectMetadata setValue:[self.objectMetadata.resourceLinks arrayByAddingObject:resourceLink2] forKey:@"resourceLinks"];
    
    JSON = [self.objectMetadata toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    addressJSON = [JSON objectForKey:@"resourceLinks"];
    object1 = [addressJSON objectAtIndex:0];
    
    NSDictionary *object2 = [addressJSON objectAtIndex:1];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"resourceLink array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)2, @"Wrong number of elements in the resourceLink array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"resourceLink 1 object not converted");
    STAssertEqualObjects([object1 objectForKey:@"name"], resourceLink1.name, @"Wrong resourceLink 1 name");
    STAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"resourceLink 2 object not converted");
    STAssertEqualObjects([object2 objectForKey:@"name"], resourceLink2.name, @"Wrong resourceLink 2 name");
}

- (void)testParsing {
    JiveField *field = [[JiveField alloc] init];
    JiveResource *resourceLink = [[JiveResource alloc] init];
    
    [field setValue:@"displayName" forKey:@"displayName"];
    [resourceLink setValue:@"name" forKey:@"name"];
    [self.objectMetadata setValue:[NSNumber numberWithBool:YES] forKey:@"associatable"];
    [self.objectMetadata setValue:[NSArray arrayWithObject:field] forKey:@"fields"];
    [self.objectMetadata setValue:[NSArray arrayWithObject:resourceLink] forKey:@"resourceLinks"];
    [self.objectMetadata setValue:@"availability" forKey:@"availability"];
    [self.objectMetadata setValue:@"description" forKey:@"jiveDescription"];
    [self.objectMetadata setValue:@"example" forKey:@"example"];
    [self.objectMetadata setValue:@"name" forKey:@"name"];
    [self.objectMetadata setValue:@"plural" forKey:@"plural"];
    [self.objectMetadata setValue:@"since" forKey:@"since"];
    
    NSDictionary *JSON = [self.objectMetadata toJSONDictionary];
    JiveObjectMetadata *metadata = [JiveObjectMetadata objectFromJSON:JSON withInstance:self.instance];
    
    STAssertEquals([metadata class], [JiveObjectMetadata class], @"Wrong item class");
    STAssertEqualObjects(metadata.availability, self.objectMetadata.availability, @"Wrong availability");
    STAssertEqualObjects(metadata.jiveDescription, self.objectMetadata.jiveDescription, @"Wrong description");
    STAssertEqualObjects(metadata.example, self.objectMetadata.example, @"Wrong example");
    STAssertEqualObjects(metadata.name, self.objectMetadata.name, @"Wrong name");
    STAssertEqualObjects(metadata.plural, self.objectMetadata.plural, @"Wrong plural");
    STAssertEqualObjects(metadata.since, self.objectMetadata.since, @"Wrong since");
    STAssertEqualObjects(metadata.associatable, self.objectMetadata.associatable, @"Wrong associatable");
    STAssertEqualObjects(metadata.commentable, self.objectMetadata.commentable, @"Wrong commentable");
    STAssertEqualObjects(metadata.content, self.objectMetadata.content, @"Wrong content");
    STAssertEqualObjects(metadata.place, self.objectMetadata.place, @"Wrong place");
    STAssertEquals([metadata.fields count], [self.objectMetadata.fields count], @"Wrong number of field objects");
    if ([metadata.fields count] > 0) {
        id convertedField = [metadata.fields objectAtIndex:0];
        STAssertEquals([convertedField class], [JiveField class], @"Wrong field object class");
        if ([[convertedField class] isSubclassOfClass:[JiveField class]])
            STAssertEqualObjects([(JiveField *)convertedField displayName], field.displayName, @"Wrong field object");
    }
    
    STAssertEquals([metadata.resourceLinks count], [self.objectMetadata.resourceLinks count], @"Wrong number of resourceLink objects");
    if ([metadata.resourceLinks count] > 0) {
        id convertedResourceLink = [metadata.resourceLinks objectAtIndex:0];
        STAssertEquals([convertedResourceLink class], [JiveResource class], @"Wrong resourceLink object class");
        if ([[convertedResourceLink class] isSubclassOfClass:[JiveResource class]])
            STAssertEqualObjects([(JiveResource *)convertedResourceLink name], resourceLink.name, @"Wrong resourceLink object");
    }
}

- (void)testParsingAlternate {
    JiveField *field = [[JiveField alloc] init];
    JiveResource *resourceLink = [[JiveResource alloc] init];
    
    [field setValue:@"Reginald" forKey:@"displayName"];
    [resourceLink setValue:@"Resource" forKey:@"name"];
    [self.objectMetadata setValue:[NSArray arrayWithObject:field] forKey:@"fields"];
    [self.objectMetadata setValue:[NSArray arrayWithObject:resourceLink] forKey:@"resourceLinks"];
    [self.objectMetadata setValue:@"wrong" forKey:@"availability"];
    [self.objectMetadata setValue:@"title" forKey:@"jiveDescription"];
    [self.objectMetadata setValue:@"big" forKey:@"example"];
    [self.objectMetadata setValue:@"Whippersnapper" forKey:@"name"];
    [self.objectMetadata setValue:@"singular" forKey:@"plural"];
    [self.objectMetadata setValue:@"until" forKey:@"since"];
    [self.objectMetadata setValue:[NSNumber numberWithBool:YES] forKey:@"commentable"];
    [self.objectMetadata setValue:[NSNumber numberWithBool:YES] forKey:@"content"];
    [self.objectMetadata setValue:[NSNumber numberWithBool:YES] forKey:@"place"];
    
    NSDictionary *JSON = [self.objectMetadata toJSONDictionary];
    JiveObjectMetadata *metadata = [JiveObjectMetadata objectFromJSON:JSON withInstance:self.instance];
    
    STAssertEquals([metadata class], [JiveObjectMetadata class], @"Wrong item class");
    STAssertEqualObjects(metadata.availability, self.objectMetadata.availability, @"Wrong availability");
    STAssertEqualObjects(metadata.jiveDescription, self.objectMetadata.jiveDescription, @"Wrong description");
    STAssertEqualObjects(metadata.example, self.objectMetadata.example, @"Wrong example");
    STAssertEqualObjects(metadata.name, self.objectMetadata.name, @"Wrong name");
    STAssertEqualObjects(metadata.plural, self.objectMetadata.plural, @"Wrong plural");
    STAssertEqualObjects(metadata.since, self.objectMetadata.since, @"Wrong since");
    STAssertEqualObjects(metadata.associatable, self.objectMetadata.associatable, @"Wrong associatable");
    STAssertEqualObjects(metadata.commentable, self.objectMetadata.commentable, @"Wrong commentable");
    STAssertEqualObjects(metadata.content, self.objectMetadata.content, @"Wrong content");
    STAssertEqualObjects(metadata.place, self.objectMetadata.place, @"Wrong place");
    STAssertEquals([metadata.fields count], [self.objectMetadata.fields count], @"Wrong number of field objects");
    if ([metadata.fields count] > 0) {
        id convertedField = [metadata.fields objectAtIndex:0];
        STAssertEquals([convertedField class], [JiveField class], @"Wrong field object class");
        if ([[convertedField class] isSubclassOfClass:[JiveField class]])
            STAssertEqualObjects([(JiveField *)convertedField displayName], field.displayName, @"Wrong field object");
    }
    
    STAssertEquals([metadata.resourceLinks count], [self.objectMetadata.resourceLinks count], @"Wrong number of resourceLink objects");
    if ([metadata.resourceLinks count] > 0) {
        id convertedResourceLink = [metadata.resourceLinks objectAtIndex:0];
        STAssertEquals([convertedResourceLink class], [JiveResource class], @"Wrong resourceLink object class");
        if ([[convertedResourceLink class] isSubclassOfClass:[JiveResource class]])
            STAssertEqualObjects([(JiveResource *)convertedResourceLink name], resourceLink.name, @"Wrong resourceLink object");
    }
}

@end
