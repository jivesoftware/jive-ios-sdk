//
//  JiveAttachmentTests.m
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

@implementation JiveAttachmentTests

- (void)testToJSON {
    JiveAttachment *attachment = [[JiveAttachment alloc] init];
    NSDictionary *JSON = [attachment toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    attachment.contentType = @"parent";
    attachment.name = @"Subject";
    attachment.url = [NSURL URLWithString:@"http://dummy.com/item.txt"];
    attachment.doUpload = [NSNumber numberWithBool:YES];
    [attachment setValue:@"1234" forKey:@"jiveId"];
    [attachment setValue:[NSNumber numberWithInt:50] forKey:@"size"];
    
    JSON = [attachment toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)6, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"id"], attachment.jiveId, @"Wrong id");
    STAssertEqualObjects([JSON objectForKey:@"contentType"], attachment.contentType, @"Wrong contentType");
    STAssertEqualObjects([JSON objectForKey:@"name"], attachment.name, @"Wrong name");
    STAssertEqualObjects([JSON objectForKey:@"url"], [attachment.url absoluteString], @"Wrong url");
    STAssertEqualObjects([JSON objectForKey:@"size"], attachment.size, @"Wrong size");
    STAssertEqualObjects([JSON objectForKey:@"doUpload"], attachment.doUpload, @"Wrong doUpload");
}

- (void)testToJSON_alternate {
    JiveAttachment *attachment = [[JiveAttachment alloc] init];
    NSDictionary *JSON = [attachment toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    attachment.contentType = @"dummy";
    attachment.name = @"Required";
    attachment.url = [NSURL URLWithString:@"http://super.com/item.html"];
    [attachment setValue:@"5432" forKey:@"jiveId"];
    [attachment setValue:[NSNumber numberWithInt:500] forKey:@"size"];
    
    JSON = [attachment toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"id"], attachment.jiveId, @"Wrong id");
    STAssertEqualObjects([JSON objectForKey:@"contentType"], attachment.contentType, @"Wrong contentType");
    STAssertEqualObjects([JSON objectForKey:@"name"], attachment.name, @"Wrong name");
    STAssertEqualObjects([JSON objectForKey:@"url"], [attachment.url absoluteString], @"Wrong url");
    STAssertEqualObjects([JSON objectForKey:@"size"], attachment.size, @"Wrong size");
}

- (void)testContentParsing {
    JiveAttachment *attachment = [[JiveAttachment alloc] init];
    NSString *contentType = @"First";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"manager";
    NSDictionary *resourceJSON = [NSDictionary dictionaryWithObject:contentType forKey:@"ref"];
    NSDictionary *resourcesJSON = [NSDictionary dictionaryWithObject:resourceJSON forKey:resourceKey];
    
    [resource setValue:[NSURL URLWithString:contentType] forKey:@"ref"];
    attachment.contentType = @"parent";
    attachment.name = @"Subject";
    attachment.url = [NSURL URLWithString:@"http://dummy.com/item.txt"];
    attachment.doUpload = [NSNumber numberWithBool:YES];
    [attachment setValue:@"1234" forKey:@"jiveId"];
    [attachment setValue:[NSNumber numberWithInt:50] forKey:@"size"];
    [attachment setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    
    id JSON = [attachment toJSONDictionary];
    
    [(NSMutableDictionary *)JSON setValue:resourcesJSON forKey:@"resources"];
    
    JiveAttachment *newAttachment = [JiveAttachment instanceFromJSON:JSON];
    
    STAssertTrue([[newAttachment class] isSubclassOfClass:[attachment class]], @"Wrong item class");
    STAssertEqualObjects(newAttachment.jiveId, attachment.jiveId, @"Wrong id");
    STAssertEqualObjects(newAttachment.contentType, attachment.contentType, @"Wrong contentType");
    STAssertEqualObjects(newAttachment.name, attachment.name, @"Wrong name");
    STAssertEqualObjects(newAttachment.url, attachment.url, @"Wrong url");
    STAssertEqualObjects(newAttachment.size, attachment.size, @"Wrong size");
    STAssertEqualObjects(newAttachment.doUpload, attachment.doUpload, @"Wrong doUpload");
    STAssertEquals([newAttachment.resources count], [attachment.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[newAttachment.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
}

- (void)testContentParsingAlternate {
    JiveAttachment *attachment = [[JiveAttachment alloc] init];
    NSString *contentType = @"Gigantic";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"followers";
    NSDictionary *resourceJSON = [NSDictionary dictionaryWithObject:contentType forKey:@"ref"];
    NSDictionary *resourcesJSON = [NSDictionary dictionaryWithObject:resourceJSON forKey:resourceKey];
    
    [resource setValue:[NSURL URLWithString:contentType] forKey:@"ref"];
    attachment.contentType = @"dummy";
    attachment.name = @"Required";
    attachment.url = [NSURL URLWithString:@"http://super.com/item.html"];
    [attachment setValue:@"5432" forKey:@"jiveId"];
    [attachment setValue:[NSNumber numberWithInt:500] forKey:@"size"];
    [attachment setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    
    id JSON = [attachment toJSONDictionary];
    
    [(NSMutableDictionary *)JSON setValue:resourcesJSON forKey:@"resources"];
    
    JiveAttachment *newAttachment = [JiveAttachment instanceFromJSON:JSON];
    
    STAssertTrue([[newAttachment class] isSubclassOfClass:[attachment class]], @"Wrong item class");
    STAssertEqualObjects(newAttachment.jiveId, attachment.jiveId, @"Wrong id");
    STAssertEqualObjects(newAttachment.contentType, attachment.contentType, @"Wrong contentType");
    STAssertEqualObjects(newAttachment.name, attachment.name, @"Wrong name");
    STAssertEqualObjects(newAttachment.url, attachment.url, @"Wrong url");
    STAssertEqualObjects(newAttachment.size, attachment.size, @"Wrong size");
    STAssertEqualObjects(newAttachment.doUpload, attachment.doUpload, @"Wrong doUpload");
    STAssertEquals([newAttachment.resources count], [attachment.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[newAttachment.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
}

@end
