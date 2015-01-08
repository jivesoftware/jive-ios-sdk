//
//  JiveNewsStreamTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/26/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "JiveNewsStream.h"
#import "NSDateFormatter+JiveISO8601DateFormatter.h"

#import "JiveObjectTests.h"


@interface JiveNewsStreamTests : JiveObjectTests

@property (nonatomic, readonly) JiveNewsStream *newsStream;

@end


@implementation JiveNewsStreamTests

- (void)setUp {
    [super setUp];
    self.object = [JiveNewsStream new];
}

- (JiveNewsStream *)newsStream {
    return (JiveNewsStream *)self.object;
}

- (void)testType {
    STAssertEqualObjects(self.newsStream.type, @"newsStream", @"Wrong type.");
}

- (void)initializeDocument {
    JiveStream *stream = [JiveStream new];
    JiveActivity *activity = [JiveActivity new];
    
    [stream setValue:@5 forKey:JiveStreamAttributes.count];
    [activity setValue:[NSDate dateWithTimeIntervalSince1970:1000]
                forKey:JiveActivityAttributes.published];
    [self.newsStream setValue:stream forKey:JiveNewsStreamAttributes.stream];
    [self.newsStream setValue:@[activity] forKey:JiveNewsStreamAttributes.activities];
}

- (void)initializeAlternateDocument {
    JiveStream *stream = [JiveStream new];
    JiveActivity *activity = [JiveActivity new];
    
    [stream setValue:@8 forKey:JiveStreamAttributes.count];
    [activity setValue:[NSDate dateWithTimeIntervalSince1970:1000000]
                forKey:JiveActivityAttributes.published];
    [self.newsStream setValue:stream forKey:JiveNewsStreamAttributes.stream];
    [self.newsStream setValue:@[activity] forKey:JiveNewsStreamAttributes.activities];
}

- (void)testNewsStreamToJSON {
    NSDictionary *JSON = [self.newsStream toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:JiveNewsStreamAttributes.type], @"newsStream", @"Wrong type");
    
    [self initializeDocument];
    
    JSON = [self.newsStream toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:JiveNewsStreamAttributes.type], self.newsStream.type, @"Wrong type");
}

- (void)testPersistentJSON_activities {
    JiveActivity *activity1 = [[JiveActivity alloc] init];
    JiveActivity *activity2 = [[JiveActivity alloc] init];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];

    [activity1 setValue:[NSDate dateWithTimeIntervalSince1970:10000]
                 forKey:JiveActivityAttributes.published];
    [activity2 setValue:[NSDate dateWithTimeIntervalSince1970:1000000]
                 forKey:JiveActivityAttributes.published];
    [self.newsStream setValue:@[activity1] forKey:JiveNewsStreamAttributes.activities];

    NSDictionary *JSON = [self.newsStream persistentJSON];

    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:JiveNewsStreamAttributes.type], self.newsStream.type, @"Wrong type");

    NSArray *array = [JSON objectForKey:JiveNewsStreamAttributes.activities];
    id object1 = [array objectAtIndex:0];

    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"activities array not converted");
    STAssertEquals([array count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"activity object not converted");
    STAssertEqualObjects([object1 objectForKey:JiveActivityAttributes.published],
                         [dateFormatter stringFromDate:activity1.published], @"Wrong value");

    [self.newsStream setValue:[self.newsStream.activities arrayByAddingObject:activity2]
                     forKey:JiveNewsStreamAttributes.activities];

    JSON = [self.newsStream persistentJSON];

    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:JiveNewsStreamAttributes.type], self.newsStream.type, @"Wrong type");

    array = [JSON objectForKey:JiveNewsStreamAttributes.activities];
    object1 = [array objectAtIndex:0];

    id object2 = [array objectAtIndex:1];

    STAssertTrue([[array class] isSubclassOfClass:[NSArray class]], @"activities array not converted");
    STAssertEquals([array count], (NSUInteger)2, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"activity 1 object not converted");
    STAssertEqualObjects([object1 objectForKey:JiveActivityAttributes.published],
                         [dateFormatter stringFromDate:activity1.published], @"Wrong value 1");
    STAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"activity 2 object not converted");
    STAssertEqualObjects([object2 objectForKey:JiveActivityAttributes.published],
                         [dateFormatter stringFromDate:activity2.published], @"Wrong value 2");
}

- (void)testNewsStreamPersistentJSON {
    NSDictionary *JSON = [self.newsStream persistentJSON];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:JiveNewsStreamAttributes.type], @"newsStream", @"Wrong type");
    
    [self initializeDocument];
    
    JSON = [self.newsStream persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:JiveNewsStreamAttributes.type], self.newsStream.type, @"Wrong type");
    
    NSDictionary *streamJSON = [JSON objectForKey:JiveNewsStreamAttributes.stream];
    
    STAssertTrue([[streamJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([streamJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([streamJSON objectForKey:JiveTypedObjectAttributes.type], self.newsStream.stream.type, @"Wrong type");
    STAssertEqualObjects([streamJSON objectForKey:JiveStreamAttributes.count],
                         self.newsStream.stream.count,
                         @"Wrong value");
    
    NSArray *activitiesJSON = [JSON objectForKey:JiveNewsStreamAttributes.activities];
    NSDictionary *activityJSON = [activitiesJSON objectAtIndex:0];
    
    STAssertTrue([[activitiesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([activitiesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([activityJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([activityJSON objectForKey:JiveActivityAttributes.published],
                         [dateFormatter stringFromDate:((JiveActivity *)self.newsStream.activities[0]).published], @"Wrong value");
}

- (void)testNewsStreamPersistentJSON_alternate {
    [self initializeAlternateDocument];
    
    NSDictionary *JSON = [self.newsStream persistentJSON];
    NSDateFormatter *dateFormatter = [NSDateFormatter jive_threadLocalISO8601DateFormatter];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:JiveNewsStreamAttributes.type], self.newsStream.type, @"Wrong type");
    
    NSDictionary *streamJSON = [JSON objectForKey:JiveNewsStreamAttributes.stream];
    
    STAssertTrue([[streamJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([streamJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([streamJSON objectForKey:JiveTypedObjectAttributes.type], self.newsStream.stream.type, @"Wrong type");
    STAssertEqualObjects([streamJSON objectForKey:JiveStreamAttributes.count],
                         self.newsStream.stream.count,
                         @"Wrong value");
    
    NSArray *activitiesJSON = [JSON objectForKey:JiveNewsStreamAttributes.activities];
    NSDictionary *activityJSON = [activitiesJSON objectAtIndex:0];
    
    STAssertTrue([[activitiesJSON class] isSubclassOfClass:[NSArray class]], @"Jive not converted");
    STAssertEquals([activitiesJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEquals([activityJSON count], (NSUInteger)2, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([activityJSON objectForKey:JiveActivityAttributes.published],
                         [dateFormatter stringFromDate:((JiveActivity *)self.newsStream.activities[0]).published], @"Wrong value");
}

- (void)testNewsStreamParsing {
    [self initializeDocument];
    
    id JSON = [self.newsStream persistentJSON];
    JiveNewsStream *newNewsStream = [JiveNewsStream objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newNewsStream class] isSubclassOfClass:[self.newsStream class]], @"Wrong item class");
    STAssertEqualObjects(newNewsStream.type, self.newsStream.type, @"Wrong type");
    STAssertEqualObjects(newNewsStream.stream.count,
                         self.newsStream.stream.count, @"Wrong stream count");
    
    if ([newNewsStream.activities count] > 0) {
        id convertedObject = newNewsStream.activities[0];

        STAssertEquals([convertedObject class], [JiveActivity class], @"Wrong activity object class");
        if ([[convertedObject class] isSubclassOfClass:[JiveActivity class]])
            STAssertEqualObjects([(JiveActivity *)convertedObject published],
                                 ((JiveActivity *)self.newsStream.activities[0]).published, @"Wrong activity object");
    }
}

- (void)testNewsStreamParsingAlternate {
    [self initializeAlternateDocument];
    
    id JSON = [self.newsStream persistentJSON];
    JiveNewsStream *newNewsStream = [JiveNewsStream objectFromJSON:JSON withInstance:self.instance];
    
    STAssertTrue([[newNewsStream class] isSubclassOfClass:[self.newsStream class]], @"Wrong item class");
    STAssertEqualObjects(newNewsStream.type, self.newsStream.type, @"Wrong type");
    STAssertEqualObjects(newNewsStream.stream.count,
                         self.newsStream.stream.count, @"Wrong stream count");
    
    if ([newNewsStream.activities count] > 0) {
        id convertedObject = newNewsStream.activities[0];
        
        STAssertEquals([convertedObject class], [JiveActivity class], @"Wrong activity object class");
        if ([[convertedObject class] isSubclassOfClass:[JiveActivity class]])
            STAssertEqualObjects([(JiveActivity *)convertedObject published],
                                 ((JiveActivity *)self.newsStream.activities[0]).published, @"Wrong activity object");
    }
}

@end
