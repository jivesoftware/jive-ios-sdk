//
//  Jiveself.attachmentTests.m
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

#import "JiveAttachmentTests.h"
#import "JiveAttachment.h"
#import "JiveResourceEntry.h"
#import "Jive_internal.h"

@implementation JiveAttachmentTests

- (void)setUp {
    [super setUp];
    self.object = [JiveAttachment new];
}

- (JiveAttachment *)attachment {
    return (JiveAttachment *)self.object;
}

- (void)testToJSON {
    NSDictionary *JSON = [self.attachment toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    self.attachment.contentType = @"parent";
    self.attachment.name = @"Subject";
    self.attachment.url = [NSURL URLWithString:@"http://dummy.com/item.txt"];
    self.attachment.doUpload = [NSNumber numberWithBool:YES];
    [self.attachment setValue:@"1234" forKey:@"jiveId"];
    [self.attachment setValue:[NSNumber numberWithInt:50] forKey:@"size"];
    
    JSON = [self.attachment toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)6, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"id"], self.attachment.jiveId, @"Wrong id");
    STAssertEqualObjects([JSON objectForKey:@"contentType"], self.attachment.contentType, @"Wrong contentType");
    STAssertEqualObjects([JSON objectForKey:@"name"], self.attachment.name, @"Wrong name");
    STAssertEqualObjects([JSON objectForKey:@"url"], [self.attachment.url absoluteString], @"Wrong url");
    STAssertEqualObjects([JSON objectForKey:@"size"], self.attachment.size, @"Wrong size");
    STAssertEqualObjects([JSON objectForKey:@"doUpload"], self.attachment.doUpload, @"Wrong doUpload");
}

- (void)testToJSON_alternate {
    NSDictionary *JSON = [self.attachment toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    self.attachment.contentType = @"dummy";
    self.attachment.name = @"Required";
    self.attachment.url = [NSURL URLWithString:@"http://super.com/item.html"];
    [self.attachment setValue:@"5432" forKey:@"jiveId"];
    [self.attachment setValue:[NSNumber numberWithInt:500] forKey:@"size"];
    
    JSON = [self.attachment toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"id"], self.attachment.jiveId, @"Wrong id");
    STAssertEqualObjects([JSON objectForKey:@"contentType"], self.attachment.contentType, @"Wrong contentType");
    STAssertEqualObjects([JSON objectForKey:@"name"], self.attachment.name, @"Wrong name");
    STAssertEqualObjects([JSON objectForKey:@"url"], [self.attachment.url absoluteString], @"Wrong url");
    STAssertEqualObjects([JSON objectForKey:@"size"], self.attachment.size, @"Wrong size");
}

- (void)testContentParsing {
    NSString *contentType = @"First";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"manager";
    NSDictionary *resourceJSON = [NSDictionary dictionaryWithObject:contentType forKey:@"ref"];
    NSDictionary *resourcesJSON = [NSDictionary dictionaryWithObject:resourceJSON forKey:resourceKey];
    
    [resource setValue:[NSURL URLWithString:contentType] forKey:@"ref"];
    self.attachment.contentType = @"parent";
    self.attachment.name = @"Subject";
    self.attachment.url = [NSURL URLWithString:@"http://dummy.com/item.txt"];
    self.attachment.doUpload = [NSNumber numberWithBool:YES];
    [self.attachment setValue:@"1234" forKey:@"jiveId"];
    [self.attachment setValue:[NSNumber numberWithInt:50] forKey:@"size"];
    [self.attachment setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    
    id JSON = [self.attachment toJSONDictionary];
    
    [(NSMutableDictionary *)JSON setValue:resourcesJSON forKey:@"resources"];
    
    JiveAttachment *newAttachment = [JiveAttachment objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newAttachment class] isSubclassOfClass:[self.attachment class]], @"Wrong item class");
    STAssertEqualObjects(newAttachment.jiveId, self.attachment.jiveId, @"Wrong id");
    STAssertEqualObjects(newAttachment.contentType, self.attachment.contentType, @"Wrong contentType");
    STAssertEqualObjects(newAttachment.name, self.attachment.name, @"Wrong name");
    STAssertEqualObjects(newAttachment.url, self.attachment.url, @"Wrong url");
    STAssertEqualObjects(newAttachment.size, self.attachment.size, @"Wrong size");
    STAssertEqualObjects(newAttachment.doUpload, self.attachment.doUpload, @"Wrong doUpload");
    STAssertEquals([newAttachment.resources count], [self.attachment.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[newAttachment.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
}

- (void)testContentParsingAlternate {
    NSString *contentType = @"Gigantic";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"followers";
    NSDictionary *resourceJSON = [NSDictionary dictionaryWithObject:contentType forKey:@"ref"];
    NSDictionary *resourcesJSON = [NSDictionary dictionaryWithObject:resourceJSON forKey:resourceKey];
    
    [resource setValue:[NSURL URLWithString:contentType] forKey:@"ref"];
    self.attachment.contentType = @"dummy";
    self.attachment.name = @"Required";
    self.attachment.url = [NSURL URLWithString:@"http://super.com/item.html"];
    [self.attachment setValue:@"5432" forKey:@"jiveId"];
    [self.attachment setValue:[NSNumber numberWithInt:500] forKey:@"size"];
    [self.attachment setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    
    id JSON = [self.attachment toJSONDictionary];
    
    [(NSMutableDictionary *)JSON setValue:resourcesJSON forKey:@"resources"];
    
    JiveAttachment *newAttachment = [JiveAttachment objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newAttachment class] isSubclassOfClass:[self.attachment class]], @"Wrong item class");
    STAssertEqualObjects(newAttachment.jiveId, self.attachment.jiveId, @"Wrong id");
    STAssertEqualObjects(newAttachment.contentType, self.attachment.contentType, @"Wrong contentType");
    STAssertEqualObjects(newAttachment.name, self.attachment.name, @"Wrong name");
    STAssertEqualObjects(newAttachment.url, self.attachment.url, @"Wrong url");
    STAssertEqualObjects(newAttachment.size, self.attachment.size, @"Wrong size");
    STAssertEqualObjects(newAttachment.doUpload, self.attachment.doUpload, @"Wrong doUpload");
    STAssertEquals([newAttachment.resources count], [self.attachment.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[newAttachment.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
}

- (void)testSelfReferenceParsedBeforeAnythingElse {
    JiveResourceEntry *selfResource = [JiveResourceEntry new];
    JiveResourceEntry *altResource = [JiveResourceEntry new];
    NSString *expectedURL = @"https://hopback.eng.jiveland.com/";
    
    [selfResource setValue:[NSURL URLWithString:[expectedURL stringByAppendingString:@"api/core/v3/person/321"]]
                    forKey:JiveResourceEntryAttributes.ref];
    [selfResource setValue:@[@"GET", @"PUT"]
                    forKey:JiveResourceEntryAttributes.allowed];
    [altResource setValue:[NSURL URLWithString:@"http://brewspace.com/api/core/v3/person/321"]
                   forKey:JiveResourceEntryAttributes.ref];
    [altResource setValue:@[@"GET", @"DELETE"]
                   forKey:JiveResourceEntryAttributes.allowed];
    self.instance.badInstanceURL = nil;
    
    id selfJSON = selfResource.persistentJSON;
    id altJSON = altResource.persistentJSON;
    NSDictionary *firstResourceJSON = @{@"self":selfJSON,
                                        @"alt":altJSON};
    NSDictionary *firstJSON = @{@"resources":firstResourceJSON};
    
    [[self.object class] objectFromJSON:firstJSON withInstance:self.instance];
    STAssertEqualObjects(self.instance.badInstanceURL, expectedURL, @"SelfRef was not parsed first.");
    
    self.instance.badInstanceURL = nil;
    
    NSDictionary *secondResourceJSON = @{@"alt":altJSON,
                                         @"self":selfJSON};
    NSDictionary *secondJSON = @{@"resources":secondResourceJSON};
    
    [[self.object class] objectFromJSON:secondJSON withInstance:self.instance];
    STAssertEqualObjects(self.instance.badInstanceURL, expectedURL, @"SelfRef was not parsed first.");
}

@end
