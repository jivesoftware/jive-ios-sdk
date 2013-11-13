//
//  JiveObjectTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 1/2/13.
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

@implementation JiveObjectTests

- (NSURL *)testURL {
    if (!_testURL) {
        _testURL = [NSURL URLWithString:@"http://dummy.com"];
    }
    
    return _testURL;
}

- (NSString *)apiPath {
    if (!_apiPath) {
        _apiPath = @"/api/core/v3";
    }
    
    return _apiPath;
}

- (void)setUp {
    JivePlatformVersion *platformVersion = [JivePlatformVersion new];
    JiveCoreVersion *coreVersion = [JiveCoreVersion new];
    
    self.instance = [[Jive alloc] initWithJiveInstance:self.testURL
                                 authorizationDelegate:self];
    self.object = [JiveObject new];
    
    [coreVersion setValue:self.apiPath forKey:JiveCoreVersionAttributes.uri];
    [coreVersion setValue:@3 forKey:JiveCoreVersionAttributes.version];
    [platformVersion setValue:@[coreVersion] forKey:JivePlatformVersionAttributes.coreURI];
    self.instance.platformVersion = platformVersion;
}

- (void)tearDown {
    self.object = nil;
    self.instance = nil;
}

- (id<JiveCredentials>)credentialsForJiveInstance:(NSURL *)url {
    return nil;
}

- (JiveMobileAnalyticsHeader *)mobileAnalyticsHeaderForJiveInstance:(NSURL *)url {
    return nil;
}

- (void)testDeserialize_emptyJSON {
    NSDictionary *JSON = @{};
    
    STAssertFalse([self.object deserialize:JSON fromInstance:self.instance], @"Reported valid deserialize with empty JSON");
    STAssertFalse(self.object.extraFieldsDetected, @"Reported extra fields with empty JSON");
    STAssertNil(self.object.refreshDate, @"Invalid refresh date entered for empty JSON");
}

- (void)testDeserialize_invalidJSON {
    NSDictionary *JSON = @{@"dummy key":@"bad value"};
    
    STAssertFalse([self.object deserialize:JSON fromInstance:self.instance], @"Reported valid deserialize with wrong JSON");
    STAssertTrue(self.object.extraFieldsDetected, @"No extra fields reported with wrong JSON");
    STAssertNil(self.object.refreshDate, @"Invalid refresh date entered for empty JSON");
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
    NSDictionary *JSON = @{propertyID:[self.testURL absoluteString]};
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testURL, self.testURL, @"Wrong URL reported");
}

- (void)testURLDeserialization_contentURL {
    NSString *propertyID = @"testURL";
    NSString *contentURLString = [[self.testURL absoluteString] stringByAppendingString:@"/api/core/v3/content/1234"];
    NSDictionary *JSON = @{propertyID:contentURLString};
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects([self.testObject.testURL absoluteString], contentURLString,
                         @"Wrong URL reported");
}

- (void)testURLDeserialization_contentURLThroughProxy {
    NSString *propertyID = @"testURL";
    NSString *contentPath = @"/api/core/v3/content/1234";
    NSDictionary *JSON = @{propertyID:[@"https://proxy.com" stringByAppendingString:contentPath]};
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects([self.testObject.testURL absoluteString],
                         [[self.testURL URLByAppendingPathComponent:contentPath] absoluteString],
                         @"Wrong URL reported");
}

@end
