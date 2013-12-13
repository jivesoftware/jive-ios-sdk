//
//  TestJiveObjectTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 11/13/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveObjectTests.h"
#import "Jive_internal.h"

struct TestJiveObjectAttributes {
    __unsafe_unretained NSString *testProperty;
    __unsafe_unretained NSString *testURL;
} const TestJiveObjectAttributes;

@interface TestJiveObject : JiveObject

@property (nonatomic, strong) NSString *testProperty;
@property (nonatomic, strong) NSURL *testURL;

@end

@interface TestJiveObjectTests : JiveObjectTests

@property (nonatomic, readonly) TestJiveObject *testObject;

@end

struct TestJiveObjectAttributes const TestJiveObjectAttributes = {
    .testProperty = @"testProperty",
    .testURL = @"testURL"
};

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
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:testValue};
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
    NSDictionary *JSON = @{TestJiveObjectAttributes.testURL:[self.serverURL absoluteString]};
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testURL, self.serverURL, @"Wrong URL reported");
}

- (void)testURLDeserialization_contentURL {
    NSString *contentURLString = [[self.serverURL absoluteString] stringByAppendingString:@"/api/core/v3/content/1234"];
    NSDictionary *JSON = @{TestJiveObjectAttributes.testURL:contentURLString};
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects([self.testObject.testURL absoluteString], contentURLString,
                         @"Wrong URL reported");
}

- (void)testURLDeserialization_contentURLThroughProxy {
    NSString *contentPath = @"api/core/v3/content/1234";
    NSString *proxyURLString = @"https://proxy.com/";
    NSString *badInstanceURL = self.instance.jiveInstanceURL.absoluteString;
    NSDictionary *JSON = @{TestJiveObjectAttributes.testURL:[badInstanceURL stringByAppendingString:contentPath]};
    
    self.instance.jiveInstanceURL = [NSURL URLWithString:proxyURLString];
    STAssertNil(self.instance.badInstanceURL, @"PRECONDITION: There should be no badInstanceURL to start");
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects([self.testObject.testURL absoluteString],
                         [proxyURLString stringByAppendingString:contentPath],
                         @"Wrong URL reported");
    STAssertEqualObjects(self.instance.badInstanceURL, badInstanceURL, @"Bad instance url not saved.");
}

- (void)testURLDeserialization_nonInstanceURL {
    NSString *contentPath = @"data/content/1234";
    NSString *proxyURLString = [@"https://alternate.net/" stringByAppendingString:contentPath];
    NSDictionary *JSON = @{TestJiveObjectAttributes.testURL:proxyURLString};
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects([self.testObject.testURL absoluteString], proxyURLString,
                         @"Should not change URLs for other instances");
}

- (void)testURLStringDeserialization_baseURL {
    NSString *serverURLString = [self.serverURL absoluteString];
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:serverURLString};
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, serverURLString, @"Wrong URL reported");
}

- (void)testURLStringDeserialization_contentURL {
    NSString *contentURLString = [[self.serverURL absoluteString] stringByAppendingString:@"/api/core/v3/content/1234"];
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:contentURLString};
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, contentURLString,
                         @"Wrong URL reported");
}

- (void)testURLStringDeserialization_contentURLThroughProxy {
    NSString *contentPath = @"api/core/v3/content/1234";
    NSString *proxyURLString = @"http://proxy.com/";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:[[self.instance.jiveInstanceURL absoluteString] stringByAppendingString:contentPath]};
    
    self.instance.jiveInstanceURL = [NSURL URLWithString:proxyURLString];
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty,
                         [proxyURLString stringByAppendingString:contentPath],
                         @"Wrong URL reported");
}

- (void)testURLStringDeserialization_nonInstanceURL {
    NSString *contentPath = @"data/content/1234";
    NSString *proxyURLString = [@"https://alternate.net/" stringByAppendingString:contentPath];
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:proxyURLString};
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, proxyURLString,
                         @"Should not change URLs for other instances");
}

- (void)testURLStringDeserialization_bodyContent {
    NSString *proxyString = @"<body>Stuff to look at</body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:proxyString};
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, proxyString,
                         @"Should not change simple html");
}

- (void)testURLStringDeserialization_bodyContentWithExternalLink {
    NSString *proxyString = @"<body><a href='https://link.com/stuff>Stuff to look at</a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:proxyString};
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, proxyString,
                         @"Should not change simple html");
}

- (void)testURLStringDeserialization_bodyContentWithInstanceLink {
    self.instance.badInstanceURL = @"https://proxy.com/";
    
    NSString *stringFormat = @"<body><a class=\"jiveTT-hover-user jive-link-profile-small\" data-containerId=\"-1\" data-containerType=\"-1\" data-objectId=\"2024\" data-objectType=\"3\" href=\"%@people/user1\">Stuff to look at</a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:[NSString stringWithFormat:stringFormat,
                                                                  self.instance.badInstanceURL]};
    NSString *expectedValue = [NSString stringWithFormat:stringFormat,
                               [self.serverURL absoluteString]];
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Failed to change instance url");
}

- (void)testURLStringDeserialization_bodyContentWithInstanceLink_noBadInstanceURL {
    NSString *stringFormat = @"<body><a class=\"jiveTT-hover-user jive-link-profile-small\" data-containerId=\"-1\" data-containerType=\"-1\" data-objectId=\"2024\" data-objectType=\"3\" href=\"%@people/user1\">Stuff to look at</a></body>";
    NSString *expectedValue = [NSString stringWithFormat:stringFormat,
                               @"http://proxy.com/"];
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:expectedValue};
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Changed instance url without a badInstanceURL");
}

- (void)testURLStringDeserialization_bodyContentWith2InstanceLinks {
    self.instance.badInstanceURL = @"https://proxy.com/";
    
    NSString *user2ID = @"1024";
    NSString *user3ID = @"512";
    NSString *stringFormat = @"<body><a class=\"jiveTT-hover-user jive-link-profile-small\" data-containerId=\"-1\" data-containerType=\"-1\" data-objectId=\"%@\" data-objectType=\"3\" href=\"%@people/user%@\">Stuff to look at</a><br><a class=\"jiveTT-hover-user jive-link-profile-small\" data-containerId=\"-1\" data-containerType=\"-1\" data-objectId=\"%@\" data-objectType=\"3\" href=\"%@people/user%@\">More stuff to look at</a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:[NSString stringWithFormat:stringFormat,
                                                                  user3ID,
                                                                  self.instance.badInstanceURL,
                                                                  @"3",
                                                                  user2ID,
                                                                  self.instance.badInstanceURL,
                                                                  @"2"]};
    NSString *expectedValue = [NSString stringWithFormat:stringFormat,
                               user3ID,
                               [self.serverURL absoluteString],
                               @"3",
                               user2ID,
                               [self.serverURL absoluteString],
                               @"2"];
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Failed to change instance url");
}

- (void)testURLStringDeserialization_bodyContentWithSpaceLink {
    self.instance.badInstanceURL = @"https://proxy.com/";
    
    NSString *stringFormat = @"<body><a class=\"jiveTT-hover-user jive-link-profile-small\" data-containerId=\"-1\" data-containerType=\"-1\" data-objectId=\"57\" data-objectType=\"14\" href=\"%@place/space\">Stuff to look at</a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:[NSString stringWithFormat:stringFormat,
                                                                  self.instance.badInstanceURL]};
    NSString *expectedValue = [NSString stringWithFormat:stringFormat,
                               [self.serverURL absoluteString]];
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Failed to change instance url");
}

- (void)testURLStringDeserialization_bodyContentWithBlogLink {
    self.instance.badInstanceURL = @"https://proxy.com/";
    
    NSString *stringFormat = @"<body><a class=\"jiveTT-hover-user jive-link-profile-small\" data-containerId=\"-1\" data-containerType=\"-1\" data-objectId=\"105\" data-objectType=\"37\" href=\"%@place/space\">Stuff to look at</a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:[NSString stringWithFormat:stringFormat,
                                                                  self.instance.badInstanceURL]};
    NSString *expectedValue = [NSString stringWithFormat:stringFormat,
                               [self.serverURL absoluteString]];
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Failed to change instance url");
}

- (void)testURLStringDeserialization_bodyContentWithProjectLink {
    self.instance.badInstanceURL = @"https://proxy.com/";
    
    NSString *stringFormat = @"<body><a class=\"jiveTT-hover-user jive-link-profile-small\" data-containerId=\"-1\" data-containerType=\"-1\" data-objectId=\"157\" data-objectType=\"600\" href=\"%@place/space\">Stuff to look at</a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:[NSString stringWithFormat:stringFormat,
                                                                  self.instance.badInstanceURL]};
    NSString *expectedValue = [NSString stringWithFormat:stringFormat,
                               [self.serverURL absoluteString]];
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Failed to change instance url");
}

- (void)testURLStringDeserialization_bodyContentWithGroupLink {
    self.instance.badInstanceURL = @"https://proxy.com/";
    
    NSString *stringFormat = @"<body><a class=\"jiveTT-hover-user jive-link-profile-small\" data-containerId=\"-1\" data-containerType=\"-1\" data-objectId=\"5\" data-objectType=\"700\" href=\"%@place/space\">Stuff to look at</a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:[NSString stringWithFormat:stringFormat,
                                                                  self.instance.badInstanceURL]};
    NSString *expectedValue = [NSString stringWithFormat:stringFormat,
                               [self.serverURL absoluteString]];
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Failed to change instance url");
}

- (void)testURLStringDeserialization_bodyContentWithDiscussionLink {
    self.instance.badInstanceURL = @"https://proxy.com/";
    
    NSString *stringFormat = @"<body><a class=\"jiveTT-hover-user jive-link-profile-small\" data-containerId=\"-1\" data-containerType=\"-1\" data-objectId=\"25\" data-objectType=\"1\" href=\"%@content/discussion\">Stuff to look at</a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:[NSString stringWithFormat:stringFormat,
                                                                  self.instance.badInstanceURL]};
    NSString *expectedValue = [NSString stringWithFormat:stringFormat,
                               [self.serverURL absoluteString]];
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Failed to change instance url");
}

- (void)testURLStringDeserialization_bodyContentWithMessageLink {
    self.instance.badInstanceURL = @"https://proxy.com/";
    
    NSString *stringFormat = @"<body><a class=\"jiveTT-hover-user jive-link-profile-small\" data-containerId=\"-1\" data-containerType=\"-1\" data-objectId=\"1572\" data-objectType=\"2\" href=\"%@content/message\">Stuff to look at</a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:[NSString stringWithFormat:stringFormat,
                                                                  self.instance.badInstanceURL]};
    NSString *expectedValue = [NSString stringWithFormat:stringFormat,
                               [self.serverURL absoluteString]];
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Failed to change instance url");
}

- (void)testURLStringDeserialization_bodyContentWithDocumentLink {
    self.instance.badInstanceURL = @"https://proxy.com/";
    
    NSString *stringFormat = @"<body><a class=\"jiveTT-hover-user jive-link-profile-small\" data-containerId=\"-1\" data-containerType=\"-1\" data-objectId=\"17\" data-objectType=\"102\" href=\"%@content/document\">Stuff to look at</a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:[NSString stringWithFormat:stringFormat,
                                                                  self.instance.badInstanceURL]};
    NSString *expectedValue = [NSString stringWithFormat:stringFormat,
                               [self.serverURL absoluteString]];
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Failed to change instance url");
}

- (void)testURLStringDeserialization_bodyContentWithStatusUpdateLink {
    self.instance.badInstanceURL = @"https://proxy.com/";
    
    NSString *stringFormat = @"<body><a class=\"jiveTT-hover-user jive-link-profile-small\" data-containerId=\"-1\" data-containerType=\"-1\" data-objectId=\"65\" data-objectType=\"1464927464\" href=\"%@content/update\">Stuff to look at</a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:[NSString stringWithFormat:stringFormat,
                                                                  self.instance.badInstanceURL]};
    NSString *expectedValue = [NSString stringWithFormat:stringFormat,
                               [self.serverURL absoluteString]];
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Failed to change instance url");
}

- (void)testURLStringDeserialization_bodyContentWithBlogPostLink {
    self.instance.badInstanceURL = @"https://proxy.com/";
    
    NSString *stringFormat = @"<body><a class=\"jiveTT-hover-user jive-link-profile-small\" data-containerId=\"-1\" data-containerType=\"-1\" data-objectId=\"15\" data-objectType=\"38\" href=\"%@content/post\">Stuff to look at</a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:[NSString stringWithFormat:stringFormat,
                                                                  self.instance.badInstanceURL]};
    NSString *expectedValue = [NSString stringWithFormat:stringFormat,
                               [self.serverURL absoluteString]];
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Failed to change instance url");
}

- (void)testURLStringDeserialization_bodyContentWithVideoLink {
    self.instance.badInstanceURL = @"https://proxy.com/";
    
    NSString *stringFormat = @"<body><a class=\"jiveTT-hover-user jive-link-profile-small\" data-containerId=\"-1\" data-containerType=\"-1\" data-objectId=\"55\" data-objectType=\"1100\" href=\"%@content/video\">Stuff to look at</a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:[NSString stringWithFormat:stringFormat,
                                                                  self.instance.badInstanceURL]};
    NSString *expectedValue = [NSString stringWithFormat:stringFormat,
                               [self.serverURL absoluteString]];
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Failed to change instance url");
}

- (void)testURLStringDeserialization_bodyContentWithEmbeddedImage {
    self.instance.badInstanceURL = @"https://proxy.com/";
    
    NSString *imageID = @"4100434";
    NSString *stringFormat = @"<body><a href=\"%@servlet/JiveServlet/showImage/%@/image.jpeg\"><img height=\"156\" src=\"%@servlet/JiveServlet/downloadImage/%@/image.jpeg\" width=\"208\"/></a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:[NSString stringWithFormat:stringFormat,
                                                                  self.instance.badInstanceURL,
                                                                  imageID,
                                                                  self.instance.badInstanceURL,
                                                                  imageID]};
    NSString *expectedValue = [NSString stringWithFormat:stringFormat,
                               [self.serverURL absoluteString],
                               imageID,
                               [self.serverURL absoluteString],
                               imageID];
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Failed to change instance url");
}

- (void)testURLStringDeserialization_bodyContentWithExternalEmbeddedImage {
    self.instance.badInstanceURL = @"https://proxy.com/";
    
    NSString *expectedValue = @"<body><a href=\"http://lorempixel.com/400/200/\"><img alt=\"http://lorempixel.com/400/200/\" class=\"jive-image image-1\" src=\"http://lorempixel.com/400/200/\" style=\"height: auto;\"/></a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:expectedValue};
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Failed to change instance url");
}

@end
