//
//  TestJiveObjectTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/13/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveObjectTests.h"
#import "Jive_internal.h"

@interface TestJiveObject : JiveObject

@property (nonatomic, strong) NSString *testProperty;
@property (nonatomic, strong) NSURL *testURL;

@end

@interface TestJiveObjectTests : JiveObjectTests

@property (nonatomic, readonly) TestJiveObject *testObject;

@end

@implementation TestJiveObject

@synthesize testProperty, testURL;

- (NSDictionary *)toJSONDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    dictionary[@"testProperty"] = self.testProperty;
    
    return dictionary;
}

@end

@implementation TestJiveObjectTests

- (void)setUp {
    [super setUp];
    self.object = [TestJiveObject new];
}

- (TestJiveObject *)testObject {
    return (TestJiveObject *)self.object;
}

- (void)testDeserialize_validJSON {
    NSString *testValue = @"test value";
    NSString *propertyID = @"testProperty";
    NSDictionary *JSON = @{propertyID:testValue};
    NSDate *testDate = [NSDate date];
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance], @"Reported invalid deserialize with valid JSON");
    STAssertFalse(self.object.extraFieldsDetected, @"Extra fields reported with valid JSON");
    STAssertNotNil(self.object.refreshDate, @"A refresh date is reqired with valid JSON");
    STAssertEqualsWithAccuracy([testDate timeIntervalSinceDate:self.object.refreshDate],
                               (NSTimeInterval)0,
                               (NSTimeInterval)0.1,
                               @"An invalid refresh date was specified");
}

- (void)testURLDeserialization_baseURL {
    NSString *propertyID = @"testURL";
    NSDictionary *JSON = @{propertyID:[self.serverURL absoluteString]};
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testURL, self.serverURL, @"Wrong URL reported");
}

- (void)testURLDeserialization_contentURL {
    NSString *propertyID = @"testURL";
    NSString *contentURLString = [[self.serverURL absoluteString] stringByAppendingString:@"/api/core/v3/content/1234"];
    NSDictionary *JSON = @{propertyID:contentURLString};
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects([self.testObject.testURL absoluteString], contentURLString,
                         @"Wrong URL reported");
}

- (void)testURLDeserialization_contentURLThroughProxy {
    NSString *propertyID = @"testURL";
    NSString *contentPath = @"api/core/v3/content/1234";
    NSString *proxyURLString = @"https://proxy.com/";
    NSDictionary *JSON = @{propertyID:[[self.instance.jiveInstanceURL absoluteString] stringByAppendingString:contentPath]};
    
    self.instance.jiveInstanceURL = [NSURL URLWithString:proxyURLString];
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects([self.testObject.testURL absoluteString],
                         [proxyURLString stringByAppendingString:contentPath],
                         @"Wrong URL reported");
}

- (void)testURLDeserialization_nonInstanceURL {
    NSString *propertyID = @"testURL";
    NSString *contentPath = @"data/content/1234";
    NSString *proxyURLString = [@"https://alternate.net/" stringByAppendingString:contentPath];
    NSDictionary *JSON = @{propertyID:proxyURLString};
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects([self.testObject.testURL absoluteString], proxyURLString,
                         @"Should not change URLs for other instances");
}

@end
