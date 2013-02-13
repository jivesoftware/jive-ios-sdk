//
//  JiveEmbeddedTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/27/12.
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

#import "JiveEmbeddedTests.h"
#import "JiveEmbedded.h"

@implementation JiveEmbeddedTests

- (void)testToJSON {
    JiveEmbedded *embedded = [[JiveEmbedded alloc] init];
    NSDictionary *context = [NSDictionary dictionaryWithObject:@"context" forKey:@"key"];
    NSDictionary *preferredExperience = [NSDictionary dictionaryWithObject:@"preferredExperience" forKey:@"key"];
    NSDictionary *JSON = [embedded toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [embedded setValue:[NSURL URLWithString:@"http://dummy.com"] forKey:@"gadget"];
    [embedded setValue:@"image data" forKey:@"previewImage"];
    [embedded setValue:[NSURL URLWithString:@"http://super.com"] forKey:@"url"];
    [embedded setValue:context forKey:@"context"];
    [embedded setValue:preferredExperience forKey:@"preferredExperience"];
    
    JSON = [embedded toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"previewImage"], embedded.previewImage, @"Wrong previewImage.");
    STAssertEqualObjects([JSON objectForKey:@"context"], embedded.context, @"Wrong context.");
    STAssertEqualObjects([JSON objectForKey:@"preferredExperience"], embedded.preferredExperience, @"Wrong preferredExperience.");
    STAssertEqualObjects([JSON objectForKey:@"gadget"], [embedded.gadget absoluteString], @"Wrong gadget.");
    STAssertEqualObjects([JSON objectForKey:@"url"], [embedded.url absoluteString], @"Wrong url.");
}

- (void)testToJSON_alternate {
    JiveEmbedded *embedded = [[JiveEmbedded alloc] init];
    NSDictionary *context = [NSDictionary dictionaryWithObject:@"wrong" forKey:@"key"];
    NSDictionary *preferredExperience = [NSDictionary dictionaryWithObject:@"not preferred" forKey:@"key"];
    NSDictionary *JSON = [embedded toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [embedded setValue:[NSURL URLWithString:@"http://super.com"] forKey:@"gadget"];
    [embedded setValue:@"http://preview.com/image.png" forKey:@"previewImage"];
    [embedded setValue:[NSURL URLWithString:@"http://dummy.com"] forKey:@"url"];
    [embedded setValue:context forKey:@"context"];
    [embedded setValue:preferredExperience forKey:@"preferredExperience"];
    
    JSON = [embedded toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"previewImage"], embedded.previewImage, @"Wrong previewImage.");
    STAssertEqualObjects([JSON objectForKey:@"context"], embedded.context, @"Wrong context.");
    STAssertEqualObjects([JSON objectForKey:@"preferredExperience"], embedded.preferredExperience, @"Wrong preferredExperience.");
    STAssertEqualObjects([JSON objectForKey:@"gadget"], [embedded.gadget absoluteString], @"Wrong gadget.");
    STAssertEqualObjects([JSON objectForKey:@"url"], [embedded.url absoluteString], @"Wrong url.");
}

- (void)testEmbeddedParsing {
    JiveEmbedded *baseEmbedded = [[JiveEmbedded alloc] init];
    NSDictionary *context = [NSDictionary dictionaryWithObject:@"context" forKey:@"key"];
    NSDictionary *preferredExperience = [NSDictionary dictionaryWithObject:@"preferredExperience" forKey:@"key"];
    
    [baseEmbedded setValue:[NSURL URLWithString:@"http://dummy.com"] forKey:@"gadget"];
    [baseEmbedded setValue:@"image data" forKey:@"previewImage"];
    [baseEmbedded setValue:[NSURL URLWithString:@"http://super.com"] forKey:@"url"];
    [baseEmbedded setValue:context forKey:@"context"];
    [baseEmbedded setValue:preferredExperience forKey:@"preferredExperience"];
    
    id JSON = [baseEmbedded toJSONDictionary];
    JiveEmbedded *embedded = [JiveEmbedded instanceFromJSON:JSON];
    
    STAssertEquals([embedded class], [JiveEmbedded class], @"Wrong item class");
    STAssertEqualObjects(embedded.gadget, baseEmbedded.gadget, @"Wrong gadget");
    STAssertEqualObjects(embedded.previewImage, baseEmbedded.previewImage, @"Wrong previewImage");
    STAssertEqualObjects(embedded.url, baseEmbedded.url, @"Wrong url");
    STAssertEqualObjects(embedded.context, baseEmbedded.context, @"Wrong context");
    STAssertEqualObjects(embedded.preferredExperience, baseEmbedded.preferredExperience, @"Wrong preferredExperience");
}

- (void)testEmbeddedParsingAlternate {
    JiveEmbedded *baseEmbedded = [[JiveEmbedded alloc] init];
    NSDictionary *context = [NSDictionary dictionaryWithObject:@"wrong" forKey:@"key"];
    NSDictionary *preferredExperience = [NSDictionary dictionaryWithObject:@"not preferred" forKey:@"key"];
    
    [baseEmbedded setValue:[NSURL URLWithString:@"http://super.com"] forKey:@"gadget"];
    [baseEmbedded setValue:@"http://preview.com/image.png" forKey:@"previewImage"];
    [baseEmbedded setValue:[NSURL URLWithString:@"http://dummy.com"] forKey:@"url"];
    [baseEmbedded setValue:context forKey:@"context"];
    [baseEmbedded setValue:preferredExperience forKey:@"preferredExperience"];
    
    id JSON = [baseEmbedded toJSONDictionary];
    JiveEmbedded *embedded = [JiveEmbedded instanceFromJSON:JSON];
    
    STAssertEquals([embedded class], [JiveEmbedded class], @"Wrong item class");
    STAssertEqualObjects(embedded.gadget, baseEmbedded.gadget, @"Wrong gadget");
    STAssertEqualObjects(embedded.previewImage, baseEmbedded.previewImage, @"Wrong previewImage");
    STAssertEqualObjects(embedded.url, baseEmbedded.url, @"Wrong url");
    STAssertEqualObjects(embedded.context, baseEmbedded.context, @"Wrong context");
    STAssertEqualObjects(embedded.preferredExperience, baseEmbedded.preferredExperience, @"Wrong preferredExperience");
}

@end
