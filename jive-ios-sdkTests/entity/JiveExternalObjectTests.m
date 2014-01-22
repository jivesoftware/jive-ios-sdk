//
//  JiveExternalObjectTests.m
//  jive-ios-sdk
//
//  Created by Janeen Neri on 1/21/14.
//
//    Copyright 2014 Jive Software Inc.
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

#import "JiveExternalObject.h"
#import "JiveContentTests.h"

@interface JiveExternalObjectTests : JiveContentTests

@end

@implementation JiveExternalObjectTests

- (void)setUp {
    [super setUp];
    self.object = [[JiveExternalObject alloc] init];
}

- (JiveExternalObject *)externalObject {
    return (JiveExternalObject *)self.content;
}

- (void)testType {
    STAssertEqualObjects(self.externalObject.type, @"extStreamActivity", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.externalObject.type forKey:@"type"];
    
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.externalObject class], @"External object class not registered with JiveTypedObject.");
    STAssertEqualObjects([JiveContent entityClass:typeSpecifier], [self.externalObject class], @"External object class not registered with JiveContent.");
}

- (void)testExternalPersistentJSON {
    NSDictionary *JSON = [self.externalObject persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"extStreamActivity", @"Wrong type");
    
    JiveAttachment *attachment = [[JiveAttachment alloc] init];
    [attachment setValue:[NSNumber numberWithInteger:2] forKey:JiveAttachmentAttributes.size];
    JiveActivityObject *object = [[JiveActivityObject alloc] init];
    [object setValue:@"testId" forKey:@"jiveId"];
    NSURL *productIcon = [NSURL URLWithString:@"extObjTestURL"];
    JiveGenericPerson *onBehalfOf = [[JiveGenericPerson alloc] init];
    [onBehalfOf setValue:@"extObjTestPerson@email.com" forKey:JiveGenericPersonAttributes.email];
    
    [self.externalObject setValue:[NSArray arrayWithObject:attachment] forKey:JiveExternalObjectAttributes.attachments];
    
    [self.externalObject setValue:object forKey:JiveExternalObjectAttributes.object];
    [self.externalObject setValue:onBehalfOf forKey:JiveExternalObjectAttributes.onBehalfOf];
    [self.externalObject setValue:productIcon forKey:JiveExternalObjectAttributes.productIcon];
    [self.externalObject setValue:@"extObjTestProductName" forKey:JiveExternalObjectAttributes.productName];
    
    JSON = [self.externalObject persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)6, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"type"], self.externalObject.type, @"Wrong type");
    
    STAssertEqualObjects([[JSON objectForKey:JiveExternalObjectAttributes.object] objectForKey:@"id"], self.externalObject.object.jiveId, @"Wrong object");
    STAssertEqualObjects([[JSON objectForKey:JiveExternalObjectAttributes.onBehalfOf] objectForKey:JiveGenericPersonAttributes.email], self.externalObject.onBehalfOf.email, @"Wrong onBehalfOf");
    STAssertEqualObjects([JSON objectForKey:JiveExternalObjectAttributes.productIcon], [self.externalObject.productIcon absoluteString], @"Wrong productIcon");
    STAssertEqualObjects([JSON objectForKey:JiveExternalObjectAttributes.productName], self.externalObject.productName, @"Wrong productName");
    
    NSArray *attachmentsJSON = [JSON objectForKey:JiveExternalObjectAttributes.attachments];
    
    STAssertTrue([[attachmentsJSON class] isSubclassOfClass:[NSArray class]], @"Wrong object type for attachments");
    STAssertEquals([attachmentsJSON count], (NSUInteger)1, @"Attachments dictionary had the wrong number of entries");
    STAssertEqualObjects([[attachmentsJSON objectAtIndex:0] objectForKey:JiveAttachmentAttributes.size], attachment.size, @"Wrong value");
}

@end
