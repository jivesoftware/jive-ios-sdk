//
//  JiveExtensionTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/26/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JiveExtensionTests.h"
#import "JiveExtension.h"
#import "JiveActivityObject.h"

@implementation JiveExtensionTests

- (void)testToJSON {
    JiveExtension *activity = [[JiveExtension alloc] init];
    JiveActivityObject *parent = [[JiveActivityObject alloc] init];
    NSDictionary *JSON = [activity toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    parent.jiveId = @"3456";
    activity.collection = @"text";
    activity.display = @"1234";
    activity.state = @"state";
    [activity setValue:[NSNumber numberWithBool:YES] forKey:@"read"];
    [activity setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"collectionUpdated"];
    [activity setValue:[NSURL URLWithString:@"http://dummy.com"] forKey:@"update"];
    [activity setValue:parent forKey:@"parent"];
    
    JSON = [activity toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
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
}

- (void)testToJSON_alternate {
    JiveExtension *activity = [[JiveExtension alloc] init];
    JiveActivityObject *parent = [[JiveActivityObject alloc] init];
    NSDictionary *JSON = [activity toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    parent.jiveId = @"9874";
    activity.collection = @"html";
    activity.display = @"6541";
    activity.state = @"loco";
    [activity setValue:[NSNumber numberWithBool:NO] forKey:@"read"];
    [activity setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"collectionUpdated"];
    [activity setValue:[NSURL URLWithString:@"http://super.com"] forKey:@"update"];
    [activity setValue:parent forKey:@"parent"];
    
    JSON = [activity toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)7, @"Initial dictionary had the wrong number of entries");
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
}

@end
