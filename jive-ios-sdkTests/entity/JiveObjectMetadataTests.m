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

@synthesize objectMetadata;

- (void)setUp {
    objectMetadata = [[JiveObjectMetadata alloc] init];
}

- (void)tearDown {
    objectMetadata = nil;
}

- (void)testToJSON {
    JiveField *field = [[JiveField alloc] init];
    JiveResource *resourceLink = [[JiveResource alloc] init];
    NSDictionary *JSON = [objectMetadata toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [field setValue:@"displayName" forKey:@"displayName"];
    [resourceLink setValue:@"name" forKey:@"name"];
    [objectMetadata setValue:[NSNumber numberWithBool:YES] forKey:@"associatable"];
    [objectMetadata setValue:[NSArray arrayWithObject:field] forKey:@"fields"];
    [objectMetadata setValue:[NSArray arrayWithObject:resourceLink] forKey:@"resourceLinks"];
    [objectMetadata setValue:@"availability" forKey:@"availability"];
    [objectMetadata setValue:@"description" forKey:@"description"];
    [objectMetadata setValue:@"example" forKey:@"example"];
    [objectMetadata setValue:@"name" forKey:@"name"];
    [objectMetadata setValue:@"plural" forKey:@"plural"];
    [objectMetadata setValue:@"since" forKey:@"since"];
    
    JSON = [objectMetadata toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)9, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"associatable"], objectMetadata.associatable, @"Wrong associatable.");
    STAssertEqualObjects([JSON objectForKey:@"availability"], objectMetadata.availability, @"Wrong availability.");
    STAssertEqualObjects([JSON objectForKey:@"description"], objectMetadata.description, @"Wrong description");
    STAssertEqualObjects([JSON objectForKey:@"example"], objectMetadata.example, @"Wrong example");
    STAssertEqualObjects([JSON objectForKey:@"name"], objectMetadata.name, @"Wrong name");
    STAssertEqualObjects([JSON objectForKey:@"plural"], objectMetadata.plural, @"Wrong plural");
    STAssertEqualObjects([JSON objectForKey:@"since"], objectMetadata.since, @"Wrong since.");
    
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
    [objectMetadata setValue:@"wrong" forKey:@"availability"];
    [objectMetadata setValue:@"title" forKey:@"description"];
    [objectMetadata setValue:@"big" forKey:@"example"];
    [objectMetadata setValue:@"Whippersnapper" forKey:@"name"];
    [objectMetadata setValue:@"singular" forKey:@"plural"];
    [objectMetadata setValue:@"until" forKey:@"since"];
    [objectMetadata setValue:[NSNumber numberWithBool:YES] forKey:@"commentable"];
    
    NSDictionary *JSON = [objectMetadata toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)7, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"availability"], objectMetadata.availability, @"Wrong availability.");
    STAssertEqualObjects([JSON objectForKey:@"description"], objectMetadata.description, @"Wrong description");
    STAssertEqualObjects([JSON objectForKey:@"example"], objectMetadata.example, @"Wrong example");
    STAssertEqualObjects([JSON objectForKey:@"name"], objectMetadata.name, @"Wrong name");
    STAssertEqualObjects([JSON objectForKey:@"plural"], objectMetadata.plural, @"Wrong plural");
    STAssertEqualObjects([JSON objectForKey:@"since"], objectMetadata.since, @"Wrong since.");
    STAssertEqualObjects([JSON objectForKey:@"commentable"], objectMetadata.commentable, @"Wrong commentable.");
}

- (void)testToJSON_content {
    [objectMetadata setValue:[NSNumber numberWithBool:YES] forKey:@"content"];
    
    NSDictionary *JSON = [objectMetadata toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"content"], objectMetadata.content, @"Wrong content.");
}

- (void)testToJSON_place {
    [objectMetadata setValue:[NSNumber numberWithBool:YES] forKey:@"place"];
    
    NSDictionary *JSON = [objectMetadata toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"place"], objectMetadata.place, @"Wrong place.");
}

- (void)testToJSON_allFlags {
    [objectMetadata setValue:[NSNumber numberWithBool:YES] forKey:@"associatable"];
    [objectMetadata setValue:[NSNumber numberWithBool:YES] forKey:@"commentable"];
    [objectMetadata setValue:[NSNumber numberWithBool:YES] forKey:@"content"];
    [objectMetadata setValue:[NSNumber numberWithBool:YES] forKey:@"place"];
    
    NSDictionary *JSON = [objectMetadata toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)4, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"associatable"], objectMetadata.associatable, @"Wrong associatable.");
    STAssertEqualObjects([JSON objectForKey:@"commentable"], objectMetadata.commentable, @"Wrong commentable.");
    STAssertEqualObjects([JSON objectForKey:@"content"], objectMetadata.content, @"Wrong content.");
    STAssertEqualObjects([JSON objectForKey:@"place"], objectMetadata.place, @"Wrong place.");
}

- (void)testToJSON_fields {
    JiveField *field1 = [[JiveField alloc] init];
    JiveField *field2 = [[JiveField alloc] init];
    
    [field1 setValue:@"displayName" forKey:@"displayName"];
    [field2 setValue:@"alternate" forKey:@"displayName"];
    [objectMetadata setValue:[NSArray arrayWithObject:field1] forKey:@"fields"];
    
    NSDictionary *JSON = [objectMetadata toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    NSArray *addressJSON = [JSON objectForKey:@"fields"];
    NSDictionary *object1 = [addressJSON objectAtIndex:0];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"field array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the field array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"field object not converted");
    STAssertEqualObjects([object1 objectForKey:@"displayName"], field1.displayName, @"Wrong field displayName");
    
    [objectMetadata setValue:[objectMetadata.fields arrayByAddingObject:field2] forKey:@"fields"];
    
    JSON = [objectMetadata toJSONDictionary];
    
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
    [objectMetadata setValue:[NSArray arrayWithObject:resourceLink1] forKey:@"resourceLinks"];
    
    NSDictionary *JSON = [objectMetadata toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    NSArray *addressJSON = [JSON objectForKey:@"resourceLinks"];
    NSDictionary *object1 = [addressJSON objectAtIndex:0];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"resourceLink array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the resourceLink array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"resourceLink object not converted");
    STAssertEqualObjects([object1 objectForKey:@"name"], resourceLink1.name, @"Wrong resourceLink name");
    
    [objectMetadata setValue:[objectMetadata.resourceLinks arrayByAddingObject:resourceLink2] forKey:@"resourceLinks"];
    
    JSON = [objectMetadata toJSONDictionary];
    
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

- (void)testPersonParsing {
    JiveField *field = [[JiveField alloc] init];
    JiveResource *resourceLink = [[JiveResource alloc] init];
    
    [field setValue:@"displayName" forKey:@"displayName"];
    [resourceLink setValue:@"name" forKey:@"name"];
    [objectMetadata setValue:[NSNumber numberWithBool:YES] forKey:@"associatable"];
    [objectMetadata setValue:[NSArray arrayWithObject:field] forKey:@"fields"];
    [objectMetadata setValue:[NSArray arrayWithObject:resourceLink] forKey:@"resourceLinks"];
    [objectMetadata setValue:@"availability" forKey:@"availability"];
    [objectMetadata setValue:@"description" forKey:@"description"];
    [objectMetadata setValue:@"example" forKey:@"example"];
    [objectMetadata setValue:@"name" forKey:@"name"];
    [objectMetadata setValue:@"plural" forKey:@"plural"];
    [objectMetadata setValue:@"since" forKey:@"since"];
    
    NSDictionary *JSON = [objectMetadata toJSONDictionary];
    JiveObjectMetadata *metadata = [JiveObjectMetadata instanceFromJSON:JSON];
    
    STAssertEquals([metadata class], [JiveObjectMetadata class], @"Wrong item class");
    STAssertEqualObjects(metadata.availability, objectMetadata.availability, @"Wrong availability");
    STAssertEqualObjects(metadata.description, objectMetadata.description, @"Wrong description");
    STAssertEqualObjects(metadata.example, objectMetadata.example, @"Wrong example");
    STAssertEqualObjects(metadata.name, objectMetadata.name, @"Wrong name");
    STAssertEqualObjects(metadata.plural, objectMetadata.plural, @"Wrong plural");
    STAssertEqualObjects(metadata.since, objectMetadata.since, @"Wrong since");
    STAssertEqualObjects(metadata.associatable, objectMetadata.associatable, @"Wrong associatable");
    STAssertEqualObjects(metadata.commentable, objectMetadata.commentable, @"Wrong commentable");
    STAssertEqualObjects(metadata.content, objectMetadata.content, @"Wrong content");
    STAssertEqualObjects(metadata.place, objectMetadata.place, @"Wrong place");
    STAssertEquals([metadata.fields count], [objectMetadata.fields count], @"Wrong number of field objects");
    if ([metadata.fields count] > 0) {
        id convertedField = [metadata.fields objectAtIndex:0];
        STAssertEquals([convertedField class], [JiveField class], @"Wrong field object class");
        if ([[convertedField class] isSubclassOfClass:[JiveField class]])
            STAssertEqualObjects([(JiveField *)convertedField displayName], field.displayName, @"Wrong field object");
    }
    
    STAssertEquals([metadata.resourceLinks count], [objectMetadata.resourceLinks count], @"Wrong number of resourceLink objects");
    if ([metadata.resourceLinks count] > 0) {
        id convertedResourceLink = [metadata.resourceLinks objectAtIndex:0];
        STAssertEquals([convertedResourceLink class], [JiveResource class], @"Wrong resourceLink object class");
        if ([[convertedResourceLink class] isSubclassOfClass:[JiveResource class]])
            STAssertEqualObjects([(JiveResource *)convertedResourceLink name], resourceLink.name, @"Wrong resourceLink object");
    }
}

- (void)testPersonParsingAlternate {
    JiveField *field = [[JiveField alloc] init];
    JiveResource *resourceLink = [[JiveResource alloc] init];
    
    [field setValue:@"Reginald" forKey:@"displayName"];
    [resourceLink setValue:@"Resource" forKey:@"name"];
    [objectMetadata setValue:[NSArray arrayWithObject:field] forKey:@"fields"];
    [objectMetadata setValue:[NSArray arrayWithObject:resourceLink] forKey:@"resourceLinks"];
    [objectMetadata setValue:@"wrong" forKey:@"availability"];
    [objectMetadata setValue:@"title" forKey:@"description"];
    [objectMetadata setValue:@"big" forKey:@"example"];
    [objectMetadata setValue:@"Whippersnapper" forKey:@"name"];
    [objectMetadata setValue:@"singular" forKey:@"plural"];
    [objectMetadata setValue:@"until" forKey:@"since"];
    [objectMetadata setValue:[NSNumber numberWithBool:YES] forKey:@"commentable"];
    [objectMetadata setValue:[NSNumber numberWithBool:YES] forKey:@"content"];
    [objectMetadata setValue:[NSNumber numberWithBool:YES] forKey:@"place"];
    
    NSDictionary *JSON = [objectMetadata toJSONDictionary];
    JiveObjectMetadata *metadata = [JiveObjectMetadata instanceFromJSON:JSON];
    
    STAssertEquals([metadata class], [JiveObjectMetadata class], @"Wrong item class");
    STAssertEqualObjects(metadata.availability, objectMetadata.availability, @"Wrong availability");
    STAssertEqualObjects(metadata.description, objectMetadata.description, @"Wrong description");
    STAssertEqualObjects(metadata.example, objectMetadata.example, @"Wrong example");
    STAssertEqualObjects(metadata.name, objectMetadata.name, @"Wrong name");
    STAssertEqualObjects(metadata.plural, objectMetadata.plural, @"Wrong plural");
    STAssertEqualObjects(metadata.since, objectMetadata.since, @"Wrong since");
    STAssertEqualObjects(metadata.associatable, objectMetadata.associatable, @"Wrong associatable");
    STAssertEqualObjects(metadata.commentable, objectMetadata.commentable, @"Wrong commentable");
    STAssertEqualObjects(metadata.content, objectMetadata.content, @"Wrong content");
    STAssertEqualObjects(metadata.place, objectMetadata.place, @"Wrong place");
    STAssertEquals([metadata.fields count], [objectMetadata.fields count], @"Wrong number of field objects");
    if ([metadata.fields count] > 0) {
        id convertedField = [metadata.fields objectAtIndex:0];
        STAssertEquals([convertedField class], [JiveField class], @"Wrong field object class");
        if ([[convertedField class] isSubclassOfClass:[JiveField class]])
            STAssertEqualObjects([(JiveField *)convertedField displayName], field.displayName, @"Wrong field object");
    }
    
    STAssertEquals([metadata.resourceLinks count], [objectMetadata.resourceLinks count], @"Wrong number of resourceLink objects");
    if ([metadata.resourceLinks count] > 0) {
        id convertedResourceLink = [metadata.resourceLinks objectAtIndex:0];
        STAssertEquals([convertedResourceLink class], [JiveResource class], @"Wrong resourceLink object class");
        if ([[convertedResourceLink class] isSubclassOfClass:[JiveResource class]])
            STAssertEqualObjects([(JiveResource *)convertedResourceLink name], resourceLink.name, @"Wrong resourceLink object");
    }
}

@end
