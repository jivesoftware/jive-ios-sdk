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
    NSDictionary *JSON = @{TestJiveObjectAttributes.testURL:[[self.instance.jiveInstanceURL absoluteString] stringByAppendingString:contentPath]};
    
    self.instance.jiveInstanceURL = [NSURL URLWithString:proxyURLString];
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects([self.testObject.testURL absoluteString],
                         [proxyURLString stringByAppendingString:contentPath],
                         @"Wrong URL reported");
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
    NSString *stringFormat = @"<body><a class=\"jiveTT-hover-user jive-link-profile-small\" data-containerId=\"-1\" data-containerType=\"-1\" data-objectId=\"2024\" data-objectType=\"3\" href=\"%@%@\">Stuff to look at</a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:[NSString stringWithFormat:stringFormat,
                                                                  @"https://proxy.com/",
                                                                  @"people/user1"]};
    NSString *expectedValue = [NSString stringWithFormat:stringFormat,
                               [self.serverURL absoluteString],
                               @"api/core/v3/people/2024"];
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Failed to change instance url");
}

- (void)testURLStringDeserialization_bodyContentWith2InstanceLinks {
    NSString *user2ID = @"1024";
    NSString *user3ID = @"512";
    NSString *proxyURLString = @"https://proxy.com/";
    NSString *proxyPath = @"people/user";
    NSString *serverPath = [NSString stringWithFormat:@"%@%@", self.instance.baseURI, @"/people/"];
    NSString *stringFormat = @"<body><a class=\"jiveTT-hover-user jive-link-profile-small\" data-containerId=\"-1\" data-containerType=\"-1\" data-objectId=\"%@\" data-objectType=\"3\" href=\"%@%@%@\">Stuff to look at</a><br><a class=\"jiveTT-hover-user jive-link-profile-small\" data-containerId=\"-1\" data-containerType=\"-1\" data-objectId=\"%@\" data-objectType=\"3\" href=\"%@%@%@\">More stuff to look at</a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:[NSString stringWithFormat:stringFormat,
                                                                  user3ID,
                                                                  proxyURLString,
                                                                  proxyPath,
                                                                  @"3",
                                                                  user2ID,
                                                                  proxyURLString,
                                                                  proxyPath,
                                                                  @"2"]};
    NSString *expectedValue = [NSString stringWithFormat:stringFormat,
                               user3ID,
                               [self.serverURL absoluteString],
                               serverPath,
                               user3ID,
                               user2ID,
                               [self.serverURL absoluteString],
                               serverPath,
                               user2ID];
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Failed to change instance url");
}

- (void)testURLStringDeserialization_bodyContentWithSpaceLink {
    NSString *objectType = @"14";
    NSString *objectID = @"57";
    NSString *stringFormat = @"<body><a class=\"jiveTT-hover-user jive-link-profile-small\" data-containerId=\"-1\" data-containerType=\"-1\" data-objectId=\"%@\" data-objectType=\"%@\" href=\"%@%@%@\">Stuff to look at</a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:[NSString stringWithFormat:stringFormat,
                                                                  objectID,
                                                                  objectType,
                                                                  @"https://proxy.com/",
                                                                  @"place/",
                                                                  @"space"]};
    NSString *expectedValue = [NSString stringWithFormat:stringFormat,
                               objectID,
                               objectType,
                               [self.serverURL absoluteString],
                               @"api/core/v3/places/",
                               objectID];
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Failed to change instance url");
}

- (void)testURLStringDeserialization_bodyContentWithBlogLink {
    NSString *objectType = @"37";
    NSString *objectID = @"105";
    NSString *stringFormat = @"<body><a class=\"jiveTT-hover-user jive-link-profile-small\" data-containerId=\"-1\" data-containerType=\"-1\" data-objectId=\"%@\" data-objectType=\"%@\" href=\"%@%@%@\">Stuff to look at</a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:[NSString stringWithFormat:stringFormat,
                                                                  objectID,
                                                                  objectType,
                                                                  @"https://proxy.com/",
                                                                  @"place/",
                                                                  @"space"]};
    NSString *expectedValue = [NSString stringWithFormat:stringFormat,
                               objectID,
                               objectType,
                               [self.serverURL absoluteString],
                               @"api/core/v3/places/",
                               objectID];
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Failed to change instance url");
}

- (void)testURLStringDeserialization_bodyContentWithProjectLink {
    NSString *objectType = @"600";
    NSString *objectID = @"157";
    NSString *stringFormat = @"<body><a class=\"jiveTT-hover-user jive-link-profile-small\" data-containerId=\"-1\" data-containerType=\"-1\" data-objectId=\"%@\" data-objectType=\"%@\" href=\"%@%@%@\">Stuff to look at</a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:[NSString stringWithFormat:stringFormat,
                                                                  objectID,
                                                                  objectType,
                                                                  @"https://proxy.com/",
                                                                  @"place/",
                                                                  @"space"]};
    NSString *expectedValue = [NSString stringWithFormat:stringFormat,
                               objectID,
                               objectType,
                               [self.serverURL absoluteString],
                               @"api/core/v3/places/",
                               objectID];
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Failed to change instance url");
}

- (void)testURLStringDeserialization_bodyContentWithGroupLink {
    NSString *objectType = @"700";
    NSString *objectID = @"5";
    NSString *stringFormat = @"<body><a class=\"jiveTT-hover-user jive-link-profile-small\" data-containerId=\"-1\" data-containerType=\"-1\" data-objectId=\"%@\" data-objectType=\"%@\" href=\"%@%@%@\">Stuff to look at</a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:[NSString stringWithFormat:stringFormat,
                                                                  objectID,
                                                                  objectType,
                                                                  @"https://proxy.com/",
                                                                  @"place/",
                                                                  @"space"]};
    NSString *expectedValue = [NSString stringWithFormat:stringFormat,
                               objectID,
                               objectType,
                               [self.serverURL absoluteString],
                               @"api/core/v3/places/",
                               objectID];
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Failed to change instance url");
}

- (void)testURLStringDeserialization_bodyContentWithDiscussionLink {
    NSString *objectType = @"1";
    NSString *objectID = @"25";
    NSString *stringFormat = @"<body><a class=\"jiveTT-hover-user jive-link-profile-small\" data-containerId=\"-1\" data-containerType=\"-1\" data-objectId=\"%@\" data-objectType=\"%@\" href=\"%@%@%@\">Stuff to look at</a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:[NSString stringWithFormat:stringFormat,
                                                                  objectID,
                                                                  objectType,
                                                                  @"https://proxy.com/",
                                                                  @"content/",
                                                                  @"discussion"]};
    NSString *expectedValue = [NSString stringWithFormat:stringFormat,
                               objectID,
                               objectType,
                               [self.serverURL absoluteString],
                               @"api/core/v3/contents/",
                               objectID];
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Failed to change instance url");
}

- (void)testURLStringDeserialization_bodyContentWithMessageLink {
    NSString *objectType = @"2";
    NSString *objectID = @"1572";
    NSString *stringFormat = @"<body><a class=\"jiveTT-hover-user jive-link-profile-small\" data-containerId=\"-1\" data-containerType=\"-1\" data-objectId=\"%@\" data-objectType=\"%@\" href=\"%@%@%@\">Stuff to look at</a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:[NSString stringWithFormat:stringFormat,
                                                                  objectID,
                                                                  objectType,
                                                                  @"https://proxy.com/",
                                                                  @"content/",
                                                                  @"message"]};
    NSString *expectedValue = [NSString stringWithFormat:stringFormat,
                               objectID,
                               objectType,
                               [self.serverURL absoluteString],
                               @"api/core/v3/contents/",
                               objectID];
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Failed to change instance url");
}

- (void)testURLStringDeserialization_bodyContentWithDocumentLink {
    NSString *objectType = @"102";
    NSString *objectID = @"17";
    NSString *stringFormat = @"<body><a class=\"jiveTT-hover-user jive-link-profile-small\" data-containerId=\"-1\" data-containerType=\"-1\" data-objectId=\"%@\" data-objectType=\"%@\" href=\"%@%@%@\">Stuff to look at</a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:[NSString stringWithFormat:stringFormat,
                                                                  objectID,
                                                                  objectType,
                                                                  @"https://proxy.com/",
                                                                  @"content/",
                                                                  @"document"]};
    NSString *expectedValue = [NSString stringWithFormat:stringFormat,
                               objectID,
                               objectType,
                               [self.serverURL absoluteString],
                               @"api/core/v3/contents/",
                               objectID];
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Failed to change instance url");
}

- (void)testURLStringDeserialization_bodyContentWithStatusUpdateLink {
    NSString *objectType = @"1464927464";
    NSString *objectID = @"65";
    NSString *stringFormat = @"<body><a class=\"jiveTT-hover-user jive-link-profile-small\" data-containerId=\"-1\" data-containerType=\"-1\" data-objectId=\"%@\" data-objectType=\"%@\" href=\"%@%@%@\">Stuff to look at</a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:[NSString stringWithFormat:stringFormat,
                                                                  objectID,
                                                                  objectType,
                                                                  @"https://proxy.com/",
                                                                  @"content/",
                                                                  @"update"]};
    NSString *expectedValue = [NSString stringWithFormat:stringFormat,
                               objectID,
                               objectType,
                               [self.serverURL absoluteString],
                               @"api/core/v3/contents/",
                               objectID];
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Failed to change instance url");
}

- (void)testURLStringDeserialization_bodyContentWithBlogPostLink {
    NSString *objectType = @"38";
    NSString *objectID = @"15";
    NSString *stringFormat = @"<body><a class=\"jiveTT-hover-user jive-link-profile-small\" data-containerId=\"-1\" data-containerType=\"-1\" data-objectId=\"%@\" data-objectType=\"%@\" href=\"%@%@%@\">Stuff to look at</a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:[NSString stringWithFormat:stringFormat,
                                                                  objectID,
                                                                  objectType,
                                                                  @"https://proxy.com/",
                                                                  @"content/",
                                                                  @"post"]};
    NSString *expectedValue = [NSString stringWithFormat:stringFormat,
                               objectID,
                               objectType,
                               [self.serverURL absoluteString],
                               @"api/core/v3/contents/",
                               objectID];
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Failed to change instance url");
}

- (void)testURLStringDeserialization_bodyContentWithVideoLink {
    NSString *objectType = @"1100";
    NSString *objectID = @"55";
    NSString *stringFormat = @"<body><a class=\"jiveTT-hover-user jive-link-profile-small\" data-containerId=\"-1\" data-containerType=\"-1\" data-objectId=\"%@\" data-objectType=\"%@\" href=\"%@%@%@\">Stuff to look at</a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:[NSString stringWithFormat:stringFormat,
                                                                  objectID,
                                                                  objectType,
                                                                  @"https://proxy.com/",
                                                                  @"content/",
                                                                  @"video"]};
    NSString *expectedValue = [NSString stringWithFormat:stringFormat,
                               objectID,
                               objectType,
                               [self.serverURL absoluteString],
                               @"api/core/v3/contents/",
                               objectID];
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Failed to change instance url");
}

- (void)testURLStringDeserialization_bodyContentWithEmbeddedImage {
    NSString *imageID = @"4100434";
    NSString *serverURL = @"https://proxy.com/";
    NSString *stringFormat = @"<body><a href=\"%@servlet/JiveServlet/showImage/%@/image.jpeg\"><img height=\"156\" src=\"%@servlet/JiveServlet/downloadImage/%@/image.jpeg\" width=\"208\"/></a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:[NSString stringWithFormat:stringFormat,
                                                                  serverURL,
                                                                  imageID,
                                                                  serverURL,
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
    NSString *expectedValue = @"<body><a href=\"http://lorempixel.com/400/200/\"><img alt=\"http://lorempixel.com/400/200/\" class=\"jive-image image-1\" src=\"http://lorempixel.com/400/200/\" style=\"height: auto;\"/></a></body>";
    NSDictionary *JSON = @{TestJiveObjectAttributes.testProperty:expectedValue};
    
    STAssertTrue([self.object deserialize:JSON fromInstance:self.instance],
                 @"Reported invalid deserialize with valid JSON");
    STAssertEqualObjects(self.testObject.testProperty, expectedValue,
                         @"Failed to change instance url");
}

@end
/*
<body>
    <!-- [DocumentBodyStart:c5261edf-d044-4d88-b90c-34d293b65a1b] -->
        <div class="jive-rendered-content">
            <p>Here is an external image:</p>
            <p>
                <a href="http://lorempixel.com/400/200/">
                    <img alt="http://lorempixel.com/400/200/" class="jive-image image-1" src="http://lorempixel.com/400/200/" style="height: auto;"/>
                </a>
            </p>
            <p style="min-height: 8pt; padding: 0px;">&nbsp;</p>
            <p>After the image.</p>
        </div>
    <!-- [DocumentBodyEnd:c5261edf-d044-4d88-b90c-34d293b65a1b] -->
</body>

<body>
    <!-- [DocumentBodyStart:79d2bf51-d942-4094-94e6-f131efa82e00] -->
        <div class="jive-rendered-content">
            <span>Embedded image here:</span>
            <p class="">
                <a href="https://hopback.eng.jiveland.com/servlet/JiveServlet/showImage/4100434/image.jpeg">
                    <img height="156" src="https://hopback.eng.jiveland.com/servlet/JiveServlet/downloadImage/4100434/image.jpeg" width="208"/>
                </a>
                <br/>
            </p>
            <p class="">
                <br/>
            </p>
            <p class="">After the image.</p>
        </div>
    <!-- [DocumentBodyEnd:79d2bf51-d942-4094-94e6-f131efa82e00] -->
</body>

<body>
    <!-- [DocumentBodyStart:e5968878-502c-4c1f-9591-1056713d8248] -->
        <div class="jive-rendered-content">
            <p>Here is an embedded image created on the web interface:</p>
            <p>
                <a href="https://hopback.eng.jiveland.com/servlet/JiveServlet/showImage/102-145156-1-4100509/JIVE_AB37E07A-BED3-4112-9D08-0EFDE5F64D00-390-0000004761572746.jpeg">
                    <img alt="JIVE_AB37E07A-BED3-4112-9D08-0EFDE5F64D00-390-0000004761572746.jpeg" class="jive-image image-1" height="900" src="https://hopback.eng.jiveland.com/servlet/JiveServlet/downloadImage/102-145156-1-4100509/507-900/JIVE_AB37E07A-BED3-4112-9D08-0EFDE5F64D00-390-0000004761572746.jpeg" style="height: 1101px; width: 620px;" width="507"/>
                </a>
            </p>
            <p style="min-height: 8pt; padding: 0px;">&nbsp;</p>
            <p>After the image.</p>
        </div>
    <!-- [DocumentBodyEnd:e5968878-502c-4c1f-9591-1056713d8248] -->
</body>

        processLinks: function( $root ) {
                var $links, suffix;
                $root = $root || $.mobile.activePage;
                $links = $root.find( "a.jive-link-resolver" ).each( function( index, value ) {
                        var $this = $( this ),
                            href = "",
                            type = "",
                            objectType = this.getAttribute( "data-objecttype" ),
                            objectId = this.getAttribute( "data-objectid" );
        
                        if ( !objectType || !objectId ) {
                                // Don't you just love how these change from Jive version to Jive version?
                                var jiveId = this.getAttribute("jiveid");
                                var objectData = jiveId && jiveId.split("-");
                                objectType = objectData && objectData[0];
                                objectId = objectData && objectData[1];
                            }
        
                        if ( objectType && objectId ) {
                                switch( objectType ) {
                                            // FIXME: get objectId / type association from the Manager in spring
                                            case "1": // Discussion
                                            case "2": // Message
                                            case "102": // Document
                                            case "1464927464": // Status Update
                                            case "38": // Blog Post
                                            case "1100": // Video
                                                href = "#jive-content";
                                                type = "contents";
                                                break;
                                            case "14": // Space
                                            case "37": // Blog
                                            case "600": // Project
                                            case "700": // Group
                                                href = "#jive-place";
                                                type = "places";
                                                break;
                    
                                            case "3": // People
                                                // people
                                                href = "#jive-user-profile";
                                                type = "people";
                                                suffix = "/" + objectId;
                                                break;
                                    }
            
                                if ( objectType == "111" ) {
                                        // Handle images a special way as we rewrite also the src of the img tag
                                        href = util.ensureStartsWith( "/api/core/v3/images/" + objectId, util.getPrefix( "mobile" ) );
                                        $this.attr( "href", href )
                                             .addClass( "jive-link-resolved" )
                                             .removeClass( "jive-link-resolver" );
                
                                        $this.find( "img" ).attr( "src", href );
                                    } else {
                                            if ( type === "contents" || type === "places" ) {
                                                    suffix = "?filter=entityDescriptor(" + objectType + "," + objectId + ")";
                                                }
                                            if ( href ) {
                                                    href += "?content=" + encodeURIComponent( "/api/core/v3/" + type + suffix );
                                                    $this.attr( "href", href );
                                                    $this.addClass( "jive-link-resolved" );
                                                }
                                        }
                            }
                    });
    
                this._bindClickHandler( $links.not( ".jive-link-resolved") );
            },
*/
