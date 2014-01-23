//
//  JiveExtensionTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/26/12.
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

#import "JiveExtensionTests.h"
#import "JiveExtension.h"
#import "JiveActivityObject.h"

@implementation JiveExtensionTests

- (void)testPersistentJSON {
    JiveExtension *activity = [[JiveExtension alloc] init];
    JiveActivityObject *parent = [[JiveActivityObject alloc] init];
    NSDictionary *JSON = [activity persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    
    JiveGenericPerson *onBehalfOf = [[JiveGenericPerson alloc] init];
    JiveGenericPerson *parentOnBehalfOf = [[JiveGenericPerson alloc] init];
    
    [onBehalfOf setValue:@"behalf@email.com" forKey:JiveGenericPersonAttributes.email];
    [parentOnBehalfOf setValue:@"parentBehalf@email.com" forKey:JiveGenericPersonAttributes.email];
    
    parent.jiveId = @"3456";
    activity.collection = @"text";
    activity.display = @"1234";
    activity.state = @"state";
    [activity setValue:[NSNumber numberWithBool:YES] forKey:@"read"];
    [activity setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"collectionUpdated"];
    [activity setValue:[NSURL URLWithString:@"http://dummy.com"] forKey:@"update"];
    [activity setValue:parent forKey:@"parent"];
    [activity setValue:onBehalfOf forKey:@"onBehalfOf"];
    [activity setValue:parentOnBehalfOf forKey:@"parentOnBehalfOf"];
    
    JSON = [activity persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)11, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"collection"], activity.collection, @"Wrong collection.");
    STAssertEqualObjects([JSON objectForKey:@"display"], activity.display, @"Wrong display.");
    STAssertEqualObjects([JSON objectForKey:@"state"], activity.state, @"Wrong state.");
    STAssertEqualObjects([JSON objectForKey:@"read"], activity.read, @"Wrong read.");
    STAssertEqualObjects([JSON objectForKey:@"collectionUpdated"], @"1970-01-01T00:16:40.123+0000", @"Wrong collectionUpdated");
    STAssertEqualObjects([JSON objectForKey:@"update"], [activity.update absoluteString], @"Wrong update.");
    
    NSDictionary *parentJSON = [JSON objectForKey:@"parent"];
    
    STAssertTrue([[parentJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([parentJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([parentJSON objectForKey:@"id"], parent.jiveId, @"Wrong value");
    
    NSDictionary *onBehalfOfJSON = [JSON objectForKey:@"onBehalfOf"];
    STAssertTrue([[onBehalfOfJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([onBehalfOfJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([onBehalfOfJSON objectForKey:@"email"], onBehalfOf.email, @"Wrong value");
    
    NSDictionary *parentOnBehalfOfJSON = [JSON objectForKey:@"parentOnBehalfOf"];
    STAssertTrue([[parentOnBehalfOfJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([parentOnBehalfOfJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([parentOnBehalfOfJSON objectForKey:@"email"], parentOnBehalfOf.email, @"Wrong value");
}

- (void)testPersistentJSON_alternate {
    JiveExtension *activity = [[JiveExtension alloc] init];
    JiveActivityObject *parent = [[JiveActivityObject alloc] init];
    NSDictionary *JSON = [activity persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    
    JiveGenericPerson *onBehalfOf = [[JiveGenericPerson alloc] init];
    JiveGenericPerson *parentOnBehalfOf = [[JiveGenericPerson alloc] init];
    
    [onBehalfOf setValue:@"oboe@email.com" forKey:JiveGenericPersonAttributes.email];
    [parentOnBehalfOf setValue:@"trombone@email.com" forKey:JiveGenericPersonAttributes.email];
    
    parent.jiveId = @"9874";
    activity.collection = @"html";
    activity.display = @"6541";
    activity.state = @"loco";
    [activity setValue:[NSNumber numberWithBool:NO] forKey:@"read"];
    [activity setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"collectionUpdated"];
    [activity setValue:[NSURL URLWithString:@"http://super.com"] forKey:@"update"];
    [activity setValue:parent forKey:@"parent"];
    [activity setValue:onBehalfOf forKey:@"onBehalfOf"];
    [activity setValue:parentOnBehalfOf forKey:@"parentOnBehalfOf"];
    
    JSON = [activity persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)11, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"collection"], activity.collection, @"Wrong collection.");
    STAssertEqualObjects([JSON objectForKey:@"display"], activity.display, @"Wrong display.");
    STAssertEqualObjects([JSON objectForKey:@"state"], activity.state, @"Wrong state.");
    STAssertEqualObjects([JSON objectForKey:@"read"], activity.read, @"Wrong read.");
    STAssertEqualObjects([JSON objectForKey:@"collectionUpdated"], @"1970-01-01T00:00:00.000+0000", @"Wrong collectionUpdated");
    STAssertEqualObjects([JSON objectForKey:@"update"], [activity.update absoluteString], @"Wrong update.");
    
    NSDictionary *parentJSON = [JSON objectForKey:@"parent"];
    
    STAssertTrue([[parentJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([parentJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([parentJSON objectForKey:@"id"], parent.jiveId, @"Wrong value");
    
    NSDictionary *onBehalfOfJSON = [JSON objectForKey:@"onBehalfOf"];
    STAssertTrue([[onBehalfOfJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([onBehalfOfJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([onBehalfOfJSON objectForKey:@"email"], onBehalfOf.email, @"Wrong value");
    
    NSDictionary *parentOnBehalfOfJSON = [JSON objectForKey:@"parentOnBehalfOf"];
    STAssertTrue([[parentOnBehalfOfJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([parentOnBehalfOfJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([parentOnBehalfOfJSON objectForKey:@"email"], parentOnBehalfOf.email, @"Wrong value");
}

- (void)testToJSON {
    JiveExtension *activity = [[JiveExtension alloc] init];
    NSDictionary *JSON = [activity toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    
    activity.collection = @"text";
    activity.display = @"1234";
    activity.state = @"state";
    
    JSON = [activity toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)5, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"collection"], activity.collection, @"Wrong collection.");
    STAssertEqualObjects([JSON objectForKey:@"display"], activity.display, @"Wrong display.");
    STAssertEqualObjects([JSON objectForKey:@"state"], activity.state, @"Wrong state.");

}

@end
