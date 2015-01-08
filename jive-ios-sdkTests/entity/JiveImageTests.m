//
//  JiveImageTests.m
//  jive-ios-sdk
//
//  Created by Paola Sandrinelli on 8/20/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "JiveObjectTests.h"
#import "JiveImage.h"

@interface JiveImageTests : JiveObjectTests

@property (nonatomic, readonly) JiveImage *image;

@end


@implementation JiveImageTests

- (void)setUp {
    [super setUp];
    self.object = [JiveImage new];
}

- (JiveImage *)image {
    return (JiveImage *)self.object;
}

- (void)testToJSON {
    
    NSDictionary *JSON = [self.image toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self initializeImage];
    
    JSON = [self.image toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveImageAttributes.jiveId], self.image.jiveId, @"Wrong id.");
    
    NSArray *tagsJSON = [JSON objectForKey:JiveImageAttributes.tags];
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(tagsJSON[0], self.image.tags[0], @"Wrong value");
}

- (void)testAlternateToJSON {
    
    NSDictionary *JSON = [self.image toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self initializeAlternateImage];
    
    JSON = [self.image toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveImageAttributes.jiveId], self.image.jiveId, @"Wrong id.");
    
    NSArray *tagsJSON = [JSON objectForKey:JiveImageAttributes.tags];
    STAssertNil(tagsJSON, @"There should be no tags");
}

- (void)testPersistentJSON {
    
    NSDictionary *JSON = [self.image toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self initializeImage];
    
    JSON = [self.image persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)8, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveImageAttributes.jiveId], self.image.jiveId, @"Wrong id.");
    STAssertEqualObjects(JSON[JiveImageAttributes.width], self.image.width, @"Wrong width.");
    STAssertEqualObjects(JSON[JiveImageAttributes.height], self.image.height, @"Wrong height.");
    STAssertEqualObjects(JSON[JiveImageAttributes.ref], [self.image.ref absoluteString], @"Wrong name.");
    STAssertEqualObjects(JSON[JiveImageAttributes.size], self.image.size, @"Wrong size.");
    STAssertEqualObjects(JSON[JiveImageAttributes.name], self.image.name, @"Wrong ref.");
    STAssertEqualObjects(JSON[JiveImageAttributes.contentType], self.image.contentType, @"Wrong type.");

    NSArray *tagsJSON = [JSON objectForKey:JiveImageAttributes.tags];
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects(tagsJSON[0], self.image.tags[0], @"Wrong value");
    STAssertEqualObjects(tagsJSON[1], self.image.tags[1], @"Wrong value");
}

- (void)testAlternatePersistentJSON {
    
    NSDictionary *JSON = [self.image toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self initializeAlternateImage];
    
    JSON = [self.image persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveImageAttributes.jiveId], self.image.jiveId, @"Wrong id.");
    STAssertEqualObjects(JSON[JiveImageAttributes.width], self.image.width, @"Wrong width.");
    STAssertEqualObjects(JSON[JiveImageAttributes.height], self.image.height, @"Wrong height.");
    STAssertEqualObjects(JSON[JiveImageAttributes.ref], [self.image.ref absoluteString], @"Wrong ref.");
    STAssertEqualObjects(JSON[JiveImageAttributes.size], self.image.size, @"Wrong size.");
    STAssertEqualObjects(JSON[JiveImageAttributes.name], self.image.name, @"Wrong name.");
    STAssertEqualObjects(JSON[JiveImageAttributes.contentType], self.image.contentType, @"Wrong type.");
    
    NSArray *tagsJSON = [JSON objectForKey:JiveImageAttributes.tags];
    STAssertNil(tagsJSON, @"There should be no tags");
}

- (void)testImageParsing {
    
    [self initializeImage];
    
    id JSON = [self.image persistentJSON];
    JiveImage *newImage = [JiveImage objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newImage class] isSubclassOfClass:[self.image class]], @"Wrong item class");
    STAssertEqualObjects(newImage.type, self.image.type, @"Wrong type");
    STAssertEqualObjects(newImage.jiveId, self.image.jiveId, @"Wrong id.");
    STAssertEqualObjects(newImage.width, self.image.width, @"Wrong width.");
    STAssertEqualObjects(newImage.height, self.image.height, @"Wrong height.");
    STAssertEqualObjects([newImage.ref absoluteString], [self.image.ref absoluteString], @"Wrong ref.");
    STAssertEqualObjects(newImage.size, self.image.size, @"Wrong size.");
    STAssertEqualObjects(newImage.name, self.image.name, @"Wrong name.");
    STAssertEqualObjects(newImage.contentType, self.image.contentType, @"Wrong type.");
    STAssertEquals([newImage.tags count], [self.image.tags count], @"Wrong number of tags");
    STAssertEquals(newImage.tags[0], self.image.tags[0], @"Wrong number of tags");
}

- (void)testAlternateImageParsing {
    
    [self initializeAlternateImage];
    
    id JSON = [self.image persistentJSON];
    JiveImage *newImage = [JiveImage objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newImage class] isSubclassOfClass:[self.image class]], @"Wrong item class");
    STAssertEqualObjects(newImage.type, self.image.type, @"Wrong type");
    STAssertEqualObjects(newImage.jiveId, self.image.jiveId, @"Wrong id.");
    STAssertEqualObjects(newImage.width, self.image.width, @"Wrong width.");
    STAssertEqualObjects(newImage.height, self.image.height, @"Wrong height.");
    STAssertEqualObjects([newImage.ref absoluteString], [self.image.ref absoluteString], @"Wrong ref.");
    STAssertEqualObjects(newImage.size, self.image.size, @"Wrong size.");
    STAssertEqualObjects(newImage.name, self.image.name, @"Wrong name.");
    STAssertEqualObjects(newImage.contentType, self.image.contentType, @"Wrong type.");
    STAssertEquals([newImage.tags count], [self.image.tags count], @"Wrong number of tags");
    STAssertNil(newImage.tags, @"There should be no tags");
}


#pragma mark - Private

- (void)initializeImage {
    [self.image setValue:@"1234" forKey:JiveImageAttributes.jiveId];
    [self.image setValue:@320 forKey:JiveImageAttributes.width];
    [self.image setValue:@100 forKey:JiveImageAttributes.height];
    [self.image setValue:[NSURL URLWithString:@"http://dummy.com/wacky.jpg"] forKey:JiveImageAttributes.ref];
    [self.image setValue:@[@"qwerty", @"asdf"] forKey:JiveImageAttributes.tags];
    [self.image setValue:@888 forKey:JiveImageAttributes.size];
    [self.image setValue:@"imagename1" forKey:JiveImageAttributes.name];
    [self.image setValue:@"image" forKey:JiveImageAttributes.contentType];
}

- (void)initializeAlternateImage {
    [self.image setValue:@"567" forKey:JiveImageAttributes.jiveId];
    [self.image setValue:@3120 forKey:JiveImageAttributes.width];
    [self.image setValue:@2000 forKey:JiveImageAttributes.height];
    [self.image setValue:[NSURL URLWithString:@"http://dummy.com/wacky2.jpg"] forKey:JiveImageAttributes.ref];
    [self.image setValue:@999 forKey:JiveImageAttributes.size];
    [self.image setValue:@"imagename2" forKey:JiveImageAttributes.name];
    [self.image setValue:@"image" forKey:JiveImageAttributes.contentType];
}

@end
