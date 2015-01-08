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
#import "JiveObject_internal.h"

@implementation JiveObjectMetadataTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveObjectMetadata alloc] init];
}

- (JiveObjectMetadata *)objectMetadata {
    return (JiveObjectMetadata *)self.object;
}

- (void)initializeObjectMetadata {
    JiveField *field = [[JiveField alloc] init];
    JiveResource *resourceLink = [[JiveResource alloc] init];
    
    [field setValue:@"displayName" forKey:@"displayName"];
    [resourceLink setValue:@"name" forKey:@"name"];
    [self.objectMetadata setValue:@YES forKey:JiveObjectMetadataAttributes.associatable];
    [self.objectMetadata setValue:@[field] forKey:JiveObjectMetadataAttributes.fields];
    [self.objectMetadata setValue:@[resourceLink] forKey:JiveObjectMetadataAttributes.resourceLinks];
    [self.objectMetadata setValue:@"availability" forKey:JiveObjectMetadataAttributes.availability];
    [self.objectMetadata setValue:@"description" forKey:JiveObjectAttributes.jiveDescription];
    [self.objectMetadata setValue:@"example" forKey:JiveObjectMetadataAttributes.example];
    [self.objectMetadata setValue:@"name" forKey:JiveObjectMetadataAttributes.name];
    [self.objectMetadata setValue:@"plural" forKey:JiveObjectMetadataAttributes.plural];
    [self.objectMetadata setValue:@"since" forKey:JiveObjectMetadataAttributes.since];
}

- (void)initializeAlternateObjectMetadata {
    JiveField *field = [[JiveField alloc] init];
    JiveResource *resourceLink = [[JiveResource alloc] init];
    
    [field setValue:@"Reginald" forKey:@"displayName"];
    [resourceLink setValue:@"Resource" forKey:@"name"];
    [self.objectMetadata setValue:@[field] forKey:JiveObjectMetadataAttributes.fields];
    [self.objectMetadata setValue:@[resourceLink] forKey:JiveObjectMetadataAttributes.resourceLinks];
    [self.objectMetadata setValue:@"wrong" forKey:JiveObjectMetadataAttributes.availability];
    [self.objectMetadata setValue:@"title" forKey:JiveObjectAttributes.jiveDescription];
    [self.objectMetadata setValue:@"big" forKey:JiveObjectMetadataAttributes.example];
    [self.objectMetadata setValue:@"Whippersnapper" forKey:JiveObjectMetadataAttributes.name];
    [self.objectMetadata setValue:@"singular" forKey:JiveObjectMetadataAttributes.plural];
    [self.objectMetadata setValue:@"until" forKey:JiveObjectMetadataAttributes.since];
    [self.objectMetadata setValue:@YES forKey:JiveObjectMetadataAttributes.commentable];
    [self.objectMetadata setValue:@YES forKey:JiveObjectMetadataAttributes.content];
    [self.objectMetadata setValue:@YES forKey:JiveObjectMetadataAttributes.place];
}

- (void)testObjectMetadataToJSON {
    [self initializeObjectMetadata];
    
    NSDictionary *JSON = [self.objectMetadata toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
}

- (void)testObjectMetadataPersistentJSON {
    NSDictionary *JSON = [self.objectMetadata persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self initializeObjectMetadata];
    
    JSON = [self.objectMetadata persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)9, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.associatable],
                         self.objectMetadata.associatable, @"Wrong associatable.");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.availability],
                         self.objectMetadata.availability, @"Wrong availability.");
    STAssertEqualObjects(JSON[JiveObjectConstants.description], self.objectMetadata.jiveDescription, @"Wrong description");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.example], self.objectMetadata.example, @"Wrong example");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.name], self.objectMetadata.name, @"Wrong name");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.plural], self.objectMetadata.plural, @"Wrong plural");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.since], self.objectMetadata.since, @"Wrong since.");
    
    NSArray *fieldsJSON = JSON[JiveObjectMetadataAttributes.fields];
    NSDictionary *fieldJSON = [fieldsJSON lastObject];
    
    STAssertTrue([[fieldsJSON class] isSubclassOfClass:[NSArray class]], @"fields array not converted");
    STAssertEquals([fieldsJSON count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[[fieldsJSON objectAtIndex:0] class] isSubclassOfClass:[NSDictionary class]], @"fields object not converted");
    STAssertTrue([[fieldJSON class] isSubclassOfClass:[NSDictionary class]], @"Generated Field JSON has the wrong class");
    STAssertEquals([fieldJSON count], (NSUInteger)1, @"Fields dictionary had the wrong number of entries");
    STAssertEqualObjects(fieldJSON[@"displayName"],
                         ((JiveField *)self.objectMetadata.fields[0]).displayName, @"Wrong field object.");
    
    NSArray *resourceLinksJSON = JSON[JiveObjectMetadataAttributes.resourceLinks];
    NSDictionary *resourceJSON = [resourceLinksJSON lastObject];
    
    STAssertTrue([[resourceLinksJSON class] isSubclassOfClass:[NSArray class]], @"resourceLinks array not converted");
    STAssertEquals([resourceLinksJSON count], (NSUInteger)1, @"Wrong number of elements in the emails array");
    STAssertTrue([[[resourceLinksJSON objectAtIndex:0] class] isSubclassOfClass:[NSDictionary class]], @"resourceLinks object not converted");
    STAssertTrue([[resourceJSON class] isSubclassOfClass:[NSDictionary class]], @"Generated Resource link JSON has the wrong class");
    STAssertEquals([resourceJSON count], (NSUInteger)1, @"Resource link dictionary had the wrong number of entries");
    STAssertEqualObjects(resourceJSON[@"name"],
                         ((JiveResource *)self.objectMetadata.resourceLinks[0]).name, @"Wrong resource object.");
}

- (void)testObjectMetadataPersistentJSON_alternate {
    [self initializeAlternateObjectMetadata];
    
    NSDictionary *JSON = [self.objectMetadata persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)11, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.availability],
                         self.objectMetadata.availability, @"Wrong availability.");
    STAssertEqualObjects(JSON[JiveObjectConstants.description], self.objectMetadata.jiveDescription, @"Wrong description");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.example], self.objectMetadata.example, @"Wrong example");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.name], self.objectMetadata.name, @"Wrong name");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.plural], self.objectMetadata.plural, @"Wrong plural");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.since], self.objectMetadata.since, @"Wrong since.");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.commentable],
                         self.objectMetadata.commentable, @"Wrong commentable.");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.content], self.objectMetadata.content, @"Wrong content.");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.place], self.objectMetadata.place, @"Wrong place.");
    
    NSArray *fieldsJSON = JSON[JiveObjectMetadataAttributes.fields];
    NSDictionary *fieldJSON = [fieldsJSON lastObject];
    
    STAssertTrue([[fieldsJSON class] isSubclassOfClass:[NSArray class]], @"fields array not converted");
    STAssertEquals([fieldsJSON count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[[fieldsJSON objectAtIndex:0] class] isSubclassOfClass:[NSDictionary class]], @"fields object not converted");
    STAssertTrue([[fieldJSON class] isSubclassOfClass:[NSDictionary class]], @"Generated Field JSON has the wrong class");
    STAssertEquals([fieldJSON count], (NSUInteger)1, @"Fields dictionary had the wrong number of entries");
    STAssertEqualObjects(fieldJSON[@"displayName"],
                         ((JiveField *)self.objectMetadata.fields[0]).displayName, @"Wrong field object.");
    
    NSArray *resourceLinksJSON = JSON[JiveObjectMetadataAttributes.resourceLinks];
    NSDictionary *resourceJSON = [resourceLinksJSON lastObject];
    
    STAssertTrue([[resourceLinksJSON class] isSubclassOfClass:[NSArray class]], @"resourceLinks array not converted");
    STAssertEquals([resourceLinksJSON count], (NSUInteger)1, @"Wrong number of elements in the emails array");
    STAssertTrue([[[resourceLinksJSON objectAtIndex:0] class] isSubclassOfClass:[NSDictionary class]], @"resourceLinks object not converted");
    STAssertTrue([[resourceJSON class] isSubclassOfClass:[NSDictionary class]], @"Generated Resource link JSON has the wrong class");
    STAssertEquals([resourceJSON count], (NSUInteger)1, @"Resource link dictionary had the wrong number of entries");
    STAssertEqualObjects(resourceJSON[@"name"],
                         ((JiveResource *)self.objectMetadata.resourceLinks[0]).name, @"Wrong resource object.");
}

- (void)testObjectMetadataPersistentJSON_allFlags {
    STAssertFalse([self.objectMetadata isAssociatable], nil);
    STAssertFalse([self.objectMetadata isCommentable], nil);
    STAssertFalse([self.objectMetadata isContent], nil);
    STAssertFalse([self.objectMetadata isAPlace], nil);
    
    [self.objectMetadata setValue:@YES forKey:JiveObjectMetadataAttributes.associatable];
    
    NSDictionary *JSON = [self.objectMetadata persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.associatable],
                         self.objectMetadata.associatable, @"Wrong associatable.");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.commentable],
                         self.objectMetadata.commentable, @"Wrong commentable.");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.content], self.objectMetadata.content, @"Wrong content.");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.place], self.objectMetadata.place, @"Wrong place.");
    STAssertTrue([self.objectMetadata isAssociatable], nil);
    STAssertFalse([self.objectMetadata isCommentable], nil);
    STAssertFalse([self.objectMetadata isContent], nil);
    STAssertFalse([self.objectMetadata isAPlace], nil);
    
    [self.objectMetadata setValue:@YES forKey:JiveObjectMetadataAttributes.commentable];
    
    JSON = [self.objectMetadata persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.associatable],
                         self.objectMetadata.associatable, @"Wrong associatable.");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.commentable],
                         self.objectMetadata.commentable, @"Wrong commentable.");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.content], self.objectMetadata.content, @"Wrong content.");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.place], self.objectMetadata.place, @"Wrong place.");
    STAssertTrue([self.objectMetadata isAssociatable], nil);
    STAssertTrue([self.objectMetadata isCommentable], nil);
    STAssertFalse([self.objectMetadata isContent], nil);
    STAssertFalse([self.objectMetadata isAPlace], nil);
    
    [self.objectMetadata setValue:@YES forKey:JiveObjectMetadataAttributes.content];
    
    JSON = [self.objectMetadata persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.associatable],
                         self.objectMetadata.associatable, @"Wrong associatable.");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.commentable],
                         self.objectMetadata.commentable, @"Wrong commentable.");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.content], self.objectMetadata.content, @"Wrong content.");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.place], self.objectMetadata.place, @"Wrong place.");
    STAssertTrue([self.objectMetadata isAssociatable], nil);
    STAssertTrue([self.objectMetadata isCommentable], nil);
    STAssertTrue([self.objectMetadata isContent], nil);
    STAssertFalse([self.objectMetadata isAPlace], nil);
    
    [self.objectMetadata setValue:@YES forKey:JiveObjectMetadataAttributes.place];
    
    JSON = [self.objectMetadata persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)4, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.associatable],
                         self.objectMetadata.associatable, @"Wrong associatable.");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.commentable],
                         self.objectMetadata.commentable, @"Wrong commentable.");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.content], self.objectMetadata.content, @"Wrong content.");
    STAssertEqualObjects(JSON[JiveObjectMetadataAttributes.place], self.objectMetadata.place, @"Wrong place.");
    STAssertTrue([self.objectMetadata isAssociatable], nil);
    STAssertTrue([self.objectMetadata isCommentable], nil);
    STAssertTrue([self.objectMetadata isContent], nil);
    STAssertTrue([self.objectMetadata isAPlace], nil);
}

- (void)testObjectMetadataPersistentJSON_fields {
    JiveField *field1 = [[JiveField alloc] init];
    JiveField *field2 = [[JiveField alloc] init];
    
    [field1 setValue:@"displayName" forKey:@"displayName"];
    [field2 setValue:@"alternate" forKey:@"displayName"];
    [self.objectMetadata setValue:@[field1] forKey:JiveObjectMetadataAttributes.fields];
    
    NSDictionary *JSON = [self.objectMetadata persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    NSArray *addressJSON = JSON[JiveObjectMetadataAttributes.fields];
    NSDictionary *object1 = [addressJSON objectAtIndex:0];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"field array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the field array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"field object not converted");
    STAssertEqualObjects([object1 objectForKey:@"displayName"], field1.displayName, @"Wrong field displayName");
    
    [self.objectMetadata setValue:@[field1, field2] forKey:JiveObjectMetadataAttributes.fields];
    
    JSON = [self.objectMetadata persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    addressJSON = JSON[JiveObjectMetadataAttributes.fields];
    object1 = [addressJSON objectAtIndex:0];
    
    NSDictionary *object2 = [addressJSON objectAtIndex:1];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"field array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)2, @"Wrong number of elements in the field array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"field 1 object not converted");
    STAssertEqualObjects([object1 objectForKey:@"displayName"], field1.displayName, @"Wrong field 1 displayName");
    STAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"field 2 object not converted");
    STAssertEqualObjects([object2 objectForKey:@"displayName"], field2.displayName, @"Wrong field 2 displayName");
}

- (void)testObjectMetadataPersistentJSON_resourceLinks {
    JiveResource *resourceLink1 = [[JiveResource alloc] init];
    JiveResource *resourceLink2 = [[JiveResource alloc] init];
    
    [resourceLink1 setValue:@"name" forKey:@"name"];
    [resourceLink2 setValue:@"alternate" forKey:@"name"];
    [self.objectMetadata setValue:@[resourceLink1]
                           forKey:JiveObjectMetadataAttributes.resourceLinks];
    
    NSDictionary *JSON = [self.objectMetadata persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    NSArray *addressJSON = JSON[JiveObjectMetadataAttributes.resourceLinks];
    NSDictionary *object1 = [addressJSON objectAtIndex:0];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"resourceLink array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the resourceLink array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"resourceLink object not converted");
    STAssertEqualObjects([object1 objectForKey:@"name"], resourceLink1.name, @"Wrong resourceLink name");
    
    [self.objectMetadata setValue:@[resourceLink1, resourceLink2]
                           forKey:JiveObjectMetadataAttributes.resourceLinks];
    
    JSON = [self.objectMetadata persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    addressJSON = JSON[JiveObjectMetadataAttributes.resourceLinks];
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
    [self initializeObjectMetadata];
    
    NSDictionary *JSON = [self.objectMetadata persistentJSON];
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
            STAssertEqualObjects([(JiveField *)convertedField displayName],
                                 ((JiveField *)self.objectMetadata.fields[0]).displayName, @"Wrong field object");
    }
    
    STAssertEquals([metadata.resourceLinks count], [self.objectMetadata.resourceLinks count], @"Wrong number of resourceLink objects");
    if ([metadata.resourceLinks count] > 0) {
        id convertedResourceLink = [metadata.resourceLinks objectAtIndex:0];
        STAssertEquals([convertedResourceLink class], [JiveResource class], @"Wrong resourceLink object class");
        if ([[convertedResourceLink class] isSubclassOfClass:[JiveResource class]])
            STAssertEqualObjects([(JiveResource *)convertedResourceLink name],
                                 ((JiveResource *)self.objectMetadata.resourceLinks[0]).name, @"Wrong resourceLink object");
    }
}

- (void)testParsingAlternate {
    [self initializeAlternateObjectMetadata];
    
    NSDictionary *JSON = [self.objectMetadata persistentJSON];
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
            STAssertEqualObjects([(JiveField *)convertedField displayName],
                                 ((JiveField *)self.objectMetadata.fields[0]).displayName, @"Wrong field object");
    }
    
    STAssertEquals([metadata.resourceLinks count], [self.objectMetadata.resourceLinks count], @"Wrong number of resourceLink objects");
    if ([metadata.resourceLinks count] > 0) {
        id convertedResourceLink = [metadata.resourceLinks objectAtIndex:0];
        STAssertEquals([convertedResourceLink class], [JiveResource class], @"Wrong resourceLink object class");
        if ([[convertedResourceLink class] isSubclassOfClass:[JiveResource class]])
            STAssertEqualObjects([(JiveResource *)convertedResourceLink name],
                                 ((JiveResource *)self.objectMetadata.resourceLinks[0]).name, @"Wrong resourceLink object");
    }
}

@end
