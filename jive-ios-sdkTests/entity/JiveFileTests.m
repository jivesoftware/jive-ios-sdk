//
//  JiveFileTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/28/12.
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

#import "JiveFileTests.h"
#import "JivePerson.h"

@implementation JiveFileTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveFile alloc] init];
}

- (JiveFile *)file {
    return (JiveFile *)self.authorableContent;
}

- (void)testType {
    STAssertEqualObjects(self.file.type, @"file", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.file.type
                                                                            forKey:JiveTypedObjectAttributes.type];
    
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.file class], @"File class not registered with JiveTypedObject.");
    STAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.file class], @"File class not registered with JiveContent.");
}

- (void)initializeFile {
    [self.file setValue:[NSURL URLWithString:@"http://dummy.com/text.txt"] forKey:JiveFileAttributes.binaryURL];
    [self.file setValue:@"text/html" forKeyPath:JiveFileAttributes.contentType];
    [self.file setValue:@"name" forKeyPath:JiveFileAttributes.name];
    self.file.restrictComments = @YES;
    [self.file setValue:@42 forKey:JiveFileAttributes.size];
}

- (void)initializeAlternateFile {
    [self.file setValue:[NSURL URLWithString:@"http://super.com/mos.png"] forKey:JiveFileAttributes.binaryURL];
    [self.file setValue:@"application/dummy" forKeyPath:JiveFileAttributes.contentType];
    [self.file setValue:@"toby" forKeyPath:JiveFileAttributes.name];
    [self.file setValue:@777291 forKey:JiveFileAttributes.size];
}

- (void)testFileToJSON {
    NSDictionary *JSON = [self.file toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], @"file", @"Wrong type");
    
    [self initializeFile];
    
    JSON = [self.file toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.file.type, @"Wrong type");
    if ([self.file commentsNotAllowed])
        STAssertTrue([JSON[JiveFileAttributes.restrictComments] boolValue], @"Wrong restrictComments");
    else
        STFail(@"Wrong restrictComments");
}

- (void)testFileToJSON_alternate {
    [self initializeAlternateFile];
    
    NSDictionary *JSON = [self.file toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.file.type, @"Wrong type");
    if (![self.file commentsNotAllowed])
        STAssertNil(JSON[JiveFileAttributes.restrictComments], @"Wrong restrictComments");
    else
        STFail(@"Wrong restrictComments");
}

- (void)testPersistentJSON {
    NSDictionary *JSON = [self.file toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], @"file", @"Wrong type");
    
    [self initializeFile];
    
    JSON = [self.file persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)6, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.file.type, @"Wrong type");
    STAssertEqualObjects(JSON[JiveFileAttributes.binaryURL], [self.file.binaryURL absoluteString], @"Wrong binaryURL");
    STAssertEqualObjects(JSON[JiveFileAttributes.size], self.file.size, @"Wrong size");
    STAssertEqualObjects(JSON[JiveFileAttributes.contentType], self.file.contentType, @"Wrong contentType");
    STAssertEqualObjects(JSON[JiveFileAttributes.name], self.file.name, @"Wrong name");
    if ([self.file commentsNotAllowed])
        STAssertTrue([JSON[JiveFileAttributes.restrictComments] boolValue], @"Wrong restrictComments");
    else
        STFail(@"Wrong restrictComments");
}

- (void)testPersistentJSON_alternate {
    [self initializeAlternateFile];
    
    NSDictionary *JSON = [self.file persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects(JSON[JiveTypedObjectAttributes.type], self.file.type, @"Wrong type");
    STAssertEqualObjects(JSON[JiveFileAttributes.binaryURL], [self.file.binaryURL absoluteString], @"Wrong binaryURL");
    STAssertEqualObjects(JSON[JiveFileAttributes.size], self.file.size, @"Wrong size");
    STAssertEqualObjects(JSON[JiveFileAttributes.contentType], self.file.contentType, @"Wrong contentType");
    STAssertEqualObjects(JSON[JiveFileAttributes.name], self.file.name, @"Wrong name");
    if (![self.file commentsNotAllowed])
        STAssertNil(JSON[JiveFileAttributes.restrictComments], @"Wrong restrictComments");
    else
        STFail(@"Wrong restrictComments");
}

- (void)testFileParsing {
    [self initializeFile];
    
    id JSON = [self.file persistentJSON];
    JiveFile *newContent = [JiveFile objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.file class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.file.type, @"Wrong type");
    STAssertEqualObjects(newContent.binaryURL, self.file.binaryURL, @"Wrong binaryURL");
    STAssertEqualObjects(newContent.contentType, self.file.contentType, @"Wrong contentType");
    STAssertEqualObjects(newContent.name, self.file.name, @"Wrong name");
    STAssertEqualObjects(newContent.restrictComments, self.file.restrictComments, @"Wrong restrictComments");
    STAssertEqualObjects(newContent.size, self.file.size, @"Wrong size");
}

- (void)testFileParsingAlternate {
    [self initializeAlternateFile];
    
    id JSON = [self.file persistentJSON];
    JiveFile *newContent = [JiveFile objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newContent class] isSubclassOfClass:[self.file class]], @"Wrong item class");
    STAssertEqualObjects(newContent.type, self.file.type, @"Wrong type");
    STAssertEqualObjects(newContent.binaryURL, self.file.binaryURL, @"Wrong binaryURL");
    STAssertEqualObjects(newContent.contentType, self.file.contentType, @"Wrong contentType");
    STAssertEqualObjects(newContent.name, self.file.name, @"Wrong name");
    STAssertEqualObjects(newContent.restrictComments, self.file.restrictComments, @"Wrong restrictComments");
    STAssertEqualObjects(newContent.size, self.file.size, @"Wrong size");
}

@end
