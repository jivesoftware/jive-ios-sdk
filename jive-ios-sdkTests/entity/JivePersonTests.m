//
//  JivePersonTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/14/12.
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

#import "JivePersonTests.h"
#import "JiveAddress.h"
#import "JivePersonJive.h"
#import "JiveName.h"
#import "JiveEmail.h"
#import "JivePhoneNumber.h"
#import "JiveResourceEntry.h"
#import "JiveProfileEntry.h"
#import "JiveSortedRequestOptions.h"

#import "Jive_internal.h"
#import <OCMock/OCMock.h>
#import "OCMockObject+MockJiveURLResponseDelegate.h"
#import "JiveHTTPBasicAuthCredentials.h"
#import "JiveMobileAnalyticsHeader.h"
#import "MockJiveURLProtocol.h"
#import "JiveObject_internal.h"
#import "NSError+Jive.h"

@interface JivePersonTests (){
    id mockJiveURLResponseDelegate;
    id mockJiveURLResponseDelegate2;
    id mockAuthDelegate;
}

@property (nonatomic, strong) NSString *instanceURL;

@end

@implementation JivePersonTests

- (NSString *)instanceURL {
    if (!_instanceURL) {
        _instanceURL = @"https://brewspace.jiveland.com";
    }
    
    return _instanceURL;
}

- (void) mockJiveURLDelegate:(NSURL*) url returningContentsOfFile:(NSString*) path {
    
    mockJiveURLResponseDelegate = [OCMockObject mockForProtocol:@protocol(MockJiveURLResponseDelegate)];
    
    // No error
    [[[mockJiveURLResponseDelegate stub] andReturn:nil] errorForRequest];
    
    // Mock Response
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:url
                                                              statusCode:200
                                                             HTTPVersion:@"1.0"
                                                            headerFields:@{@"Content-Type":@"application/json"}];
    
    [[[mockJiveURLResponseDelegate expect] andReturn:response] responseForRequest];
    
    // Mock data
    NSData *mockResponseData = [NSData dataWithContentsOfFile:path];
    
    [[[mockJiveURLResponseDelegate expect] andReturn:mockResponseData] responseBodyForRequest];
}

// Create the Jive API object, using mock auth delegate
- (void)createJiveAPIObjectWithResponsePath:(NSString *)contentPath andAuthDelegate:(id)authDelegate {
    
    // This can be anything. The mock objects will return local data
    NSURL* url = [NSURL URLWithString:self.instanceURL];
    
    // Mock response delegate
    [self mockJiveURLDelegate:url returningContentsOfFile:contentPath];
    
    // Set the response mock delegate for this request
    [MockJiveURLProtocol setMockJiveURLResponseDelegate:mockJiveURLResponseDelegate];
    
    // Create the Jive API object, using mock auth delegate
    self.instance = [[Jive alloc] initWithJiveInstance:url authorizationDelegate:authDelegate];
    self.person.jiveInstance = self.instance;
}

- (void)createJiveAPIObjectWithErrorCode:(NSInteger)errorCode
                 andAuthDelegateURLCheck:(NSString *)mockAuthURLCheck {
    assert(mockAuthURLCheck);
    BOOL (^URLCheckBlock)(id value) = ^(id value){
        BOOL same = [mockAuthURLCheck isEqualToString:[value absoluteString]];
        return same;
    };
    JiveHTTPBasicAuthCredentials *credentials = [[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar"
                                                                                              password:@"foo"];
    JiveMobileAnalyticsHeader *analytics = [[JiveMobileAnalyticsHeader alloc] initWithAppID:@"app id"
                                                                                 appVersion:@"1.1"
                                                                             connectionType:@"local"
                                                                             devicePlatform:@"iPad"
                                                                              deviceVersion:@"2.2"];
    
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:credentials] credentialsForJiveInstance:[OCMArg checkWithBlock:URLCheckBlock]];
    [[[mockAuthDelegate expect] andReturn:analytics] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:URLCheckBlock]];
    
    // This can be anything. The mock objects will return local data
    NSURL* url = [NSURL URLWithString:self.instanceURL];
    
    mockJiveURLResponseDelegate = [OCMockObject mockForProtocol:@protocol(MockJiveURLResponseDelegate)];
    
    // No error
    [[[mockJiveURLResponseDelegate stub] andReturn:nil] errorForRequest];
    
    // Mock Response
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:url
                                                              statusCode:errorCode
                                                             HTTPVersion:@"1.0"
                                                            headerFields:@{@"Content-Type":@"application/json"}];
    
    [[[mockJiveURLResponseDelegate expect] andReturn:response] responseForRequest];
    [[[mockJiveURLResponseDelegate expect] andReturn:nil] responseBodyForRequest];
    
    // Set the response mock delegate for this request
    [MockJiveURLProtocol setMockJiveURLResponseDelegate:mockJiveURLResponseDelegate];
    
    // Create the Jive API object, using mock auth delegate
    self.instance = [[Jive alloc] initWithJiveInstance:url authorizationDelegate:mockAuthDelegate];
    self.person.jiveInstance = self.instance;
}

- (void)createJiveAPIObjectWithTermsAndConditionsFailureAndAuthDelegateURLCheck:(NSString *)mockAuthURLCheck {
    assert(mockAuthURLCheck);
    BOOL (^URLCheckBlock)(id value) = ^(id value){
        BOOL same = [mockAuthURLCheck isEqualToString:[value absoluteString]];
        return same;
    };
    JiveHTTPBasicAuthCredentials *credentials = [[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar"
                                                                                              password:@"foo"];
    JiveMobileAnalyticsHeader *analytics = [[JiveMobileAnalyticsHeader alloc] initWithAppID:@"app id"
                                                                                 appVersion:@"1.1"
                                                                             connectionType:@"local"
                                                                             devicePlatform:@"iPad"
                                                                              deviceVersion:@"2.2"];
    
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:credentials] credentialsForJiveInstance:[OCMArg checkWithBlock:URLCheckBlock]];
    [[[mockAuthDelegate expect] andReturn:analytics] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:URLCheckBlock]];
    
    // This can be anything. The mock objects will return local data
    NSURL* url = [NSURL URLWithString:self.instanceURL];
    
    mockJiveURLResponseDelegate = [OCMockObject mockForProtocol:@protocol(MockJiveURLResponseDelegate)];
    
    // No error
    [[[mockJiveURLResponseDelegate stub] andReturn:nil] errorForRequest];
    
    // Mock Response
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:url
                                                              statusCode:500
                                                             HTTPVersion:@"1.0"
                                                            headerFields:@{@"Content-Type":@"application/json",
                                                                           @"X-JIVE-TC":@"/api/core/v3/people/@me/termsAndConditions"}];
    NSString *responseText = @"<html><head><title>Apache Tomcat - Error report</title><style><!--H1 {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;font-size:22px;} H2 {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;font-size:16px;} H3 {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;font-size:14px;} BODY {font-family:Tahoma,Arial,sans-serif;color:black;background-color:white;} B {font-family:Tahoma,Arial,sans-serif;color:white;background-color:#525D76;} P {font-family:Tahoma,Arial,sans-serif;background:white;color:black;font-size:12px;}A {color : black;}A.name {color : black;}HR {color : #525D76;}--></style> </head><body><h1>HTTP Status 451 - Unavailable For Legal Reasons</h1><HR size=\"1\" noshade=\"noshade\"><p><b>type</b> Status report</p><p><b>message</b> <u>Unavailable For Legal Reasons</u></p><p><b>description</b> <u>No description available</u></p><HR size=\"1\" noshade=\"noshade\"><h3>Apache Tomcat</h3></body></html>";
    NSData *responseBody = [responseText dataUsingEncoding:NSUTF8StringEncoding];
    [[[mockJiveURLResponseDelegate expect] andReturn:response] responseForRequest];
    [[[mockJiveURLResponseDelegate expect] andReturn:responseBody] responseBodyForRequest];
    
    // Set the response mock delegate for this request
    [MockJiveURLProtocol setMockJiveURLResponseDelegate:mockJiveURLResponseDelegate];
    
    // Create the Jive API object, using mock auth delegate
    self.instance = [[Jive alloc] initWithJiveInstance:url authorizationDelegate:mockAuthDelegate];
    self.person.jiveInstance = self.instance;
}

- (void)createJiveAPIObject_ExpectingNoCalls {
    JiveHTTPBasicAuthCredentials *credentials = [[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar"
                                                                                              password:@"foo"];
    JiveMobileAnalyticsHeader *analytics = [[JiveMobileAnalyticsHeader alloc] initWithAppID:@"app id"
                                                                                 appVersion:@"1.1"
                                                                             connectionType:@"local"
                                                                             devicePlatform:@"iPad"
                                                                              deviceVersion:@"2.2"];
    BOOL (^URLCheckBlock)(id value) = ^(id value){
        return NO;
    };
    
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:credentials] credentialsForJiveInstance:[OCMArg checkWithBlock:URLCheckBlock]];
    [[[mockAuthDelegate expect] andReturn:analytics] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:URLCheckBlock]];
    
    mockJiveURLResponseDelegate = [OCMockObject mockForProtocol:@protocol(MockJiveURLResponseDelegate)];
    
    // No error
    [[[mockJiveURLResponseDelegate stub] andReturn:nil] errorForRequest];
    
    [MockJiveURLProtocol setMockJiveURLResponseDelegate:mockJiveURLResponseDelegate];
    
    self.instance = [[Jive alloc] initWithJiveInstance:[NSURL URLWithString:self.instanceURL]
                                 authorizationDelegate:mockAuthDelegate];
    self.person.jiveInstance = self.instance;
}

- (void)createJiveAPIObjectWithResponse:(NSString *)resourceName
                andAuthDelegateURLCheck:(NSString *)mockAuthURLCheck {
    assert(mockAuthURLCheck);
    BOOL (^URLCheckBlock)(id value) = ^(id value){
        BOOL same = [mockAuthURLCheck isEqualToString:[value absoluteString]];
        return same;
    };
    JiveHTTPBasicAuthCredentials *credentials = [[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar"
                                                                                              password:@"foo"];
    JiveMobileAnalyticsHeader *analytics = [[JiveMobileAnalyticsHeader alloc] initWithAppID:@"app id"
                                                                                 appVersion:@"1.1"
                                                                             connectionType:@"local"
                                                                             devicePlatform:@"iPad"
                                                                              deviceVersion:@"2.2"];
    
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:credentials] credentialsForJiveInstance:[OCMArg checkWithBlock:URLCheckBlock]];
    [[[mockAuthDelegate expect] andReturn:analytics] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:URLCheckBlock]];
    
    // Reponse file containing data from JIVE My request
    NSString* contentPath = [[NSBundle bundleForClass:[self class]] pathForResource:resourceName
                                                                             ofType:@"json"];
    
    [self createJiveAPIObjectWithResponsePath:contentPath andAuthDelegate:mockAuthDelegate];
}

- (void)createJiveAPIObjectWithImageResponse:(NSString *)resourceName
                     andAuthDelegateURLCheck:(NSString *)mockAuthURLCheck {
    assert(mockAuthURLCheck);
    BOOL (^URLCheckBlock)(id value) = ^(id value){
        BOOL same = [mockAuthURLCheck isEqualToString:[value absoluteString]];
        return same;
    };
    JiveHTTPBasicAuthCredentials *credentials = [[JiveHTTPBasicAuthCredentials alloc] initWithUsername:@"bar"
                                                                                              password:@"foo"];
    JiveMobileAnalyticsHeader *analytics = [[JiveMobileAnalyticsHeader alloc] initWithAppID:@"app id"
                                                                                 appVersion:@"1.1"
                                                                             connectionType:@"local"
                                                                             devicePlatform:@"iPad"
                                                                              deviceVersion:@"2.2"];
    
    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
    [[[mockAuthDelegate expect] andReturn:credentials] credentialsForJiveInstance:[OCMArg checkWithBlock:URLCheckBlock]];
    [[[mockAuthDelegate expect] andReturn:analytics] mobileAnalyticsHeaderForJiveInstance:[OCMArg checkWithBlock:URLCheckBlock]];
    
    // Reponse file containing data from JIVE My request
    NSString* contentPath = [[NSBundle bundleForClass:[self class]] pathForResource:resourceName
                                                                             ofType:@"png"];
    
    [self createJiveAPIObjectWithResponsePath:contentPath andAuthDelegate:mockAuthDelegate];
}

- (void)waitForTimeout:(void (^)(dispatch_block_t finishedBlock))asynchBlock {
    __block BOOL finished = NO;
    void (^finishedBlock)(void) = [^{
        finished = YES;
    } copy];
    
    asynchBlock(finishedBlock);
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:5.0];
    NSDate *dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    
    while (!finished && ([loopUntil timeIntervalSinceNow] > 0)) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:dt];
        dt = [NSDate dateWithTimeIntervalSinceNow:0.1];
    }
    
    STAssertTrue(finished, @"Asynchronous call never finished.");
}

- (void)loadPerson:(JivePerson *)target fromJSONNamed:(NSString *)jsonName {
    NSString *jsonPath = [[NSBundle bundleForClass:[self class]] pathForResource:jsonName
                                                                          ofType:@"json"];
    NSData *rawJson = [NSData dataWithContentsOfFile:jsonPath];
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:rawJson
                                                         options:0
                                                           error:NULL];
    [target deserialize:JSON fromInstance:self.instance];
}

- (void)setUp {
    [super setUp];
    self.object = [[JivePerson alloc] init];
    [NSURLProtocol registerClass:[MockJiveURLProtocol class]];
}

- (void)tearDown {
    mockAuthDelegate = nil;
    mockJiveURLResponseDelegate = nil;
    mockJiveURLResponseDelegate2 = nil;
    
    [MockJiveURLProtocol setMockJiveURLResponseDelegate:nil];
    [MockJiveURLProtocol setMockJiveURLResponseDelegate2:nil];
    [NSURLProtocol unregisterClass:[MockJiveURLProtocol class]];

    [super tearDown];
}

- (JivePerson *)person {
    return (JivePerson *)self.typedObject;
}

- (void)testType {
    STAssertEqualObjects(self.person.type, @"person", @"Wrong type.");
}

- (void)testClassRegistration {
    NSMutableDictionary *typeSpecifier = [NSMutableDictionary dictionaryWithObject:self.person.type forKey:@"type"];
    
    STAssertEqualObjects([JiveTypedObject entityClass:typeSpecifier], [self.person class], @"Person class not registered with JiveTypedObject.");
}

- (void)testToJSON {
    JivePerson *person = [[JivePerson alloc] init];
    JiveAddress *address = [[JiveAddress alloc] init];
    JivePersonJive *personJive = [[JivePersonJive alloc] init];
    JiveName *name = [[JiveName alloc] init];
    NSString *tag = @"First";
    JiveEmail *email = [[JiveEmail alloc] init];
    JivePhoneNumber *phoneNumber = [[JivePhoneNumber alloc] init];
    NSString *photoURI = @"http://dummy.com/photo.png";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSDictionary *JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"person", @"Wrong type");
    
    personJive.username = @"Philip";
    address.value = @{@"postalCode": @"80215"};
    name.familyName = @"family name";
    email.value = @"email@jive.com";
    phoneNumber.value = @"555-5555";
    [resource setValue:[NSURL URLWithString:photoURI] forKey:@"ref"];
    person.addresses = [NSArray arrayWithObject:address];
    [person setValue:@"testName" forKey:@"displayName"];
    person.emails = [NSArray arrayWithObject:email];
    [person setValue:[NSNumber numberWithInt:4] forKey:@"followerCount"];
    [person setValue:[NSNumber numberWithInt:6] forKey:@"followingCount"];
    [person setValue:@"1234" forKey:@"jiveId"];
    person.jive = personJive;
    person.location = @"USA";
    person.name = name;
    person.phoneNumbers = [NSArray arrayWithObject:phoneNumber];
    [person setValue:[NSArray arrayWithObject:photoURI] forKey:@"photos"];
    [person setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [person setValue:[NSDictionary dictionaryWithObject:resource forKey:@"manager"] forKey:@"resources"];
    person.status = @"Status update";
    person.tags = [NSArray arrayWithObject:tag];
    [person setValue:@"http://dummy.com/thumbnail.png" forKey:@"thumbnailUrl"];
    [person setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    
    JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)10, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"id"], person.jiveId, @"Wrong id.");
    STAssertEqualObjects([JSON objectForKey:@"location"], person.location, @"Wrong location");
    STAssertEqualObjects([JSON objectForKey:@"status"], person.status, @"Wrong status update");
    STAssertEqualObjects([JSON objectForKey:@"type"], person.type, @"Wrong type");
    
    NSDictionary *nameJSON = [JSON objectForKey:@"name"];
    
    STAssertTrue([[nameJSON class] isSubclassOfClass:[NSDictionary class]], @"Name not converted");
    STAssertEquals([nameJSON count], (NSUInteger)1, @"Name dictionary had the wrong number of entries");
    STAssertEqualObjects([nameJSON objectForKey:@"familyName"], name.familyName, @"Wrong family name");
    
    NSArray *addressJSON = [JSON objectForKey:@"addresses"];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Address array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[[addressJSON objectAtIndex:0] class] isSubclassOfClass:[NSDictionary class]], @"Address object not converted");
    
    NSDictionary *jiveJSON = [JSON objectForKey:@"jive"];
    
    STAssertTrue([[jiveJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([jiveJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([jiveJSON objectForKey:@"username"], personJive.username, @"Wrong user name");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Tags array not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Wrong number of elements in the tags array");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Tag object not converted");
    
    NSArray *emailsJSON = [JSON objectForKey:@"emails"];
    NSDictionary *emailJSON = [emailsJSON objectAtIndex:0];
    
    STAssertTrue([[emailsJSON class] isSubclassOfClass:[NSArray class]], @"Emails array not converted");
    STAssertEquals([emailsJSON count], (NSUInteger)1, @"Wrong number of elements in the emails array");
    STAssertTrue([[emailJSON class] isSubclassOfClass:[NSDictionary class]], @"Emails object not converted");
    STAssertEqualObjects([emailJSON objectForKey:@"value"], email.value, @"Wrong email");
    
    NSArray *phoneNumbersJSON = [JSON objectForKey:@"phoneNumbers"];
    NSDictionary *numberJSON = [phoneNumbersJSON objectAtIndex:0];
    
    STAssertTrue([[phoneNumbersJSON class] isSubclassOfClass:[NSArray class]], @"Phone numbers array not converted");
    STAssertEquals([phoneNumbersJSON count], (NSUInteger)1, @"Wrong number of elements in the phone numbers array");
    STAssertTrue([[numberJSON class] isSubclassOfClass:[NSDictionary class]], @"Phone numbers object not converted");
    STAssertEqualObjects([numberJSON objectForKey:@"value"], phoneNumber.value, @"Wrong phone number");
}

- (void)testToJSON_alternate {
    JivePerson *person = [[JivePerson alloc] init];
    JiveName *name = [[JiveName alloc] init];
    JivePersonJive *personJive = [[JivePersonJive alloc] init];
    NSString *tag = @"Giant";
    
    personJive.username = @"Reginald";
    name.familyName = @"Bushnell";
    person.jive = personJive;
    person.name = name;
    person.tags = [NSArray arrayWithObject:tag];
    person.location = @"Foxtrot";
    person.status = @"Working for the man";
    
    NSDictionary *JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)6, @"Initial dictionary is not empty");
    STAssertEqualObjects([JSON objectForKey:@"type"], @"person", @"Wrong type");
    STAssertEqualObjects([JSON objectForKey:@"location"], person.location, @"Wrong location");
    STAssertEqualObjects([JSON objectForKey:@"status"], person.status, @"Wrong status update");
    
    id nameJSON = [JSON objectForKey:@"name"];
    
    STAssertTrue([[nameJSON class] isSubclassOfClass:[NSDictionary class]], @"Name not converted");
    STAssertEquals([nameJSON count], (NSUInteger)1, @"Name dictionary had the wrong number of entries");
    STAssertEqualObjects([nameJSON objectForKey:@"familyName"], name.familyName, @"Wrong family name");
    
    NSDictionary *jiveJSON = [JSON objectForKey:@"jive"];
    
    STAssertTrue([[jiveJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([jiveJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([jiveJSON objectForKey:@"username"], personJive.username, @"Wrong user name");
    
    NSArray *tagsJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Tags array not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Wrong number of elements in the tags array");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Tag object not converted");
}

- (void)testToJSON_address {
    JivePerson *person = [[JivePerson alloc] init];
    JiveAddress *address1 = [[JiveAddress alloc] init];
    JiveAddress *address2 = [[JiveAddress alloc] init];
    
    address1.value = @{@"postalCode": @"80215"};
    address2.value = @{@"postalCode": @"80303"};
    [person setValue:[NSArray arrayWithObject:address1] forKey:@"addresses"];
    
    NSDictionary *JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    
    NSArray *addressJSON = [JSON objectForKey:@"addresses"];
    NSDictionary *object1 = [addressJSON objectAtIndex:0];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Address array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"Address object not converted");
    STAssertEqualObjects([object1 objectForKey:@"value"], address1.value, @"Wrong address label");

    [person setValue:[person.addresses arrayByAddingObject:address2] forKey:@"addresses"];
    
    JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    
    addressJSON = [JSON objectForKey:@"addresses"];
    object1 = [addressJSON objectAtIndex:0];
    
    NSDictionary *object2 = [addressJSON objectAtIndex:1];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Address array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)2, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"Address 1 object not converted");
    STAssertEqualObjects([object1 objectForKey:@"value"], address1.value, @"Wrong address 1 label");
    STAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"Address 2 object not converted");
    STAssertEqualObjects([object2 objectForKey:@"value"], address2.value, @"Wrong address 2 label");
}

- (void)testToJSON_email {
    JivePerson *person = [[JivePerson alloc] init];
    JiveEmail *email1 = [[JiveEmail alloc] init];
    JiveEmail *email2 = [[JiveEmail alloc] init];
    
    email1.value = @"Address 1";
    email2.value = @"Address 2";
    [person setValue:[NSArray arrayWithObject:email1] forKey:@"emails"];
    
    NSDictionary *JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    
    NSArray *addressJSON = [JSON objectForKey:@"emails"];
    NSDictionary *object1 = [addressJSON objectAtIndex:0];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Email array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the email array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"Email object not converted");
    STAssertEqualObjects([object1 objectForKey:@"value"], email1.value, @"Wrong email label");
    
    [person setValue:[person.emails arrayByAddingObject:email2] forKey:@"emails"];
    
    JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    
    addressJSON = [JSON objectForKey:@"emails"];
    object1 = [addressJSON objectAtIndex:0];
    
    NSDictionary *object2 = [addressJSON objectAtIndex:1];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Email array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)2, @"Wrong number of elements in the email array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"Email 1 object not converted");
    STAssertEqualObjects([object1 objectForKey:@"value"], email1.value, @"Wrong email 1 label");
    STAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"Email 2 object not converted");
    STAssertEqualObjects([object2 objectForKey:@"value"], email2.value, @"Wrong email 2 label");
}

- (void)testToJSON_phoneNumbers {
    JivePerson *person = [[JivePerson alloc] init];
    JivePhoneNumber *phoneNumber1 = [[JivePhoneNumber alloc] init];
    JivePhoneNumber *phoneNumber2 = [[JivePhoneNumber alloc] init];
    
    phoneNumber1.value = @"Address 1";
    phoneNumber2.value = @"Address 2";
    [person setValue:[NSArray arrayWithObject:phoneNumber1] forKey:@"phoneNumbers"];
    
    NSDictionary *JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    
    NSArray *addressJSON = [JSON objectForKey:@"phoneNumbers"];
    NSDictionary *object1 = [addressJSON objectAtIndex:0];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Phone number array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the phone number array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"Phone number object not converted");
    STAssertEqualObjects([object1 objectForKey:@"value"], phoneNumber1.value, @"Wrong phone number label");
    
    [person setValue:[person.phoneNumbers arrayByAddingObject:phoneNumber2] forKey:@"phoneNumbers"];
    
    JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    
    addressJSON = [JSON objectForKey:@"phoneNumbers"];
    object1 = [addressJSON objectAtIndex:0];
    
    NSDictionary *object2 = [addressJSON objectAtIndex:1];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Phone number array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)2, @"Wrong number of elements in the phone number array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"Phone number 1 object not converted");
    STAssertEqualObjects([object1 objectForKey:@"value"], phoneNumber1.value, @"Wrong phone number 1 label");
    STAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"Phone number 2 object not converted");
    STAssertEqualObjects([object2 objectForKey:@"value"], phoneNumber2.value, @"Wrong phone number 2 label");
}

- (void)testToJSON_tags {
    JivePerson *person = [[JivePerson alloc] init];
    NSString *tag1 = @"First";
    NSString *tag2 = @"Last";
    
    [person setValue:[NSArray arrayWithObject:tag1] forKey:@"tags"];
    
    NSDictionary *JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    
    NSArray *addressJSON = [JSON objectForKey:@"tags"];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Tags array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the tags array");
    STAssertEqualObjects([addressJSON objectAtIndex:0], tag1, @"Wrong tag value");
    
    [person setValue:[person.tags arrayByAddingObject:tag2] forKey:@"tags"];
    
    JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    
    addressJSON = [JSON objectForKey:@"tags"];
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Tags array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)2, @"Wrong number of elements in the tags array");
    STAssertEqualObjects([addressJSON objectAtIndex:0], tag1, @"Wrong tag 1 value");
    STAssertEqualObjects([addressJSON objectAtIndex:1], tag2, @"Wrong tag 2 value");
}

- (void)testPersonParsing {
    JivePerson *basePerson = [[JivePerson alloc] init];
    JiveAddress *address = [[JiveAddress alloc] init];
    JivePersonJive *personJive = [[JivePersonJive alloc] init];
    JiveName *name = [[JiveName alloc] init];
    NSString *tag = @"First";
    JiveEmail *email = [[JiveEmail alloc] init];
    JivePhoneNumber *phoneNumber = [[JivePhoneNumber alloc] init];
    NSString *photoURI = @"http://dummy.com/photo.png";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"manager";
    NSDictionary *resourceJSON = [NSDictionary dictionaryWithObject:photoURI forKey:@"ref"];
    NSDictionary *resourcesJSON = [NSDictionary dictionaryWithObject:resourceJSON forKey:resourceKey];
    
    address.value = @{@"postalCode": @"80215"};
    personJive.username = @"Address 1";
    name.familyName = @"family name";
    phoneNumber.value = @"555-5555";
    email.value = @"email";
    [resource setValue:[NSURL URLWithString:photoURI] forKey:@"ref"];
    [basePerson setValue:@"testName" forKey:@"displayName"];
    [basePerson setValue:@"1234" forKey:@"jiveId"];
    basePerson.location = @"USA";
    basePerson.status = @"Status update";
    [basePerson setValue:@"http://dummy.com/thumbnail.png" forKey:@"thumbnailUrl"];
    [basePerson setValue:[NSNumber numberWithInt:4] forKey:@"followerCount"];
    [basePerson setValue:[NSNumber numberWithInt:6] forKey:@"followingCount"];
    [basePerson setValue:name forKey:@"name"];
    [basePerson setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [basePerson setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    [basePerson setValue:[NSArray arrayWithObject:address] forKey:@"addresses"];
    [basePerson setValue:personJive forKey:@"jive"];
    [basePerson setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [basePerson setValue:[NSArray arrayWithObject:email] forKey:@"emails"];
    [basePerson setValue:[NSArray arrayWithObject:phoneNumber] forKey:@"phoneNumbers"];
    [basePerson setValue:[NSArray arrayWithObject:photoURI] forKey:@"photos"];
    [basePerson setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    
    NSMutableDictionary *JSON = (NSMutableDictionary *)[basePerson toJSONDictionary];
    
    [JSON setValue:resourcesJSON forKey:@"resources"];
    [JSON setValue:@"testName" forKey:@"displayName"];
    [JSON setValue:[NSNumber numberWithInt:4] forKey:@"followerCount"];
    [JSON setValue:[NSNumber numberWithInt:6] forKey:@"followingCount"];
    [JSON setValue:@"1234" forKey:@"jiveId"];
    [JSON setValue:[personJive toJSONDictionary] forKey:@"jive"];
//    [JSON setValue:[NSArray arrayWithObject:photoURI] forKey:@"photos"];
    [JSON setValue:@"1970-01-01T00:00:00.000+0000" forKey:@"published"];
    [JSON setValue:@"http://dummy.com/thumbnail.png" forKey:@"thumbnailUrl"];
    [JSON setValue:@"1970-01-01T00:16:40.123+0000" forKey:@"updated"];
    
    JivePerson *newPerson = [JivePerson objectFromJSON:JSON withInstance:self.instance];
    
    STAssertEquals([newPerson class], [JivePerson class], @"Wrong item class");
    STAssertEqualObjects(newPerson.displayName, basePerson.displayName, @"Wrong display name");
    STAssertEqualObjects(newPerson.followerCount, basePerson.followerCount, @"Wrong follower count");
    STAssertEqualObjects(newPerson.followingCount, basePerson.followingCount, @"Wrong following count");
    STAssertEqualObjects(newPerson.jiveId, basePerson.jiveId, @"Wrong id");
    STAssertEqualObjects(newPerson.jive.username, basePerson.jive.username, @"Wrong Jive Person");
    STAssertEqualObjects(newPerson.location, basePerson.location, @"Wrong location");
    STAssertEqualObjects(newPerson.name.familyName, basePerson.name.familyName, @"Wrong name");
    STAssertEqualObjects(newPerson.published, basePerson.published, @"Wrong published date");
    STAssertEqualObjects(newPerson.status, basePerson.status, @"Wrong status");
    STAssertEqualObjects(newPerson.thumbnailUrl, basePerson.thumbnailUrl, @"Wrong thumbnailUrl");
    STAssertEqualObjects(newPerson.type, @"person", @"Wrong type");
    STAssertEqualObjects(newPerson.updated, basePerson.updated, @"Wrong updated date");
    STAssertEquals([newPerson.addresses count], [basePerson.addresses count], @"Wrong number of address objects");
    if ([newPerson.addresses count] > 0) {
        id convertedAddress = [newPerson.addresses objectAtIndex:0];
        STAssertEquals([convertedAddress class], [JiveAddress class], @"Wrong address object class");
        if ([[convertedAddress class] isSubclassOfClass:[JiveAddress class]])
            STAssertEqualObjects([(JiveAddress *)convertedAddress value],
                                 [(JiveAddress *)[basePerson.addresses objectAtIndex:0] value],
                                 @"Wrong Address object");
    }
    STAssertEquals([newPerson.emails count], [basePerson.emails count], @"Wrong number of email objects");
    if ([newPerson.emails count] > 0) {
        id convertedEmail = [newPerson.emails objectAtIndex:0];
        STAssertEquals([convertedEmail class], [JiveEmail class], @"Wrong email object class");
        if ([[convertedEmail class] isSubclassOfClass:[JiveEmail class]])
            STAssertEqualObjects([(JiveEmail *)convertedEmail value],
                                 [(JiveEmail *)[basePerson.emails objectAtIndex:0] value],
                                 @"Wrong email object");
    }
    STAssertEquals([newPerson.phoneNumbers count], [basePerson.phoneNumbers count], @"Wrong number of phone number objects");
    if ([newPerson.phoneNumbers count] > 0) {
        id convertedPhoneNumber = [newPerson.phoneNumbers objectAtIndex:0];
        STAssertEquals([convertedPhoneNumber class], [JivePhoneNumber class], @"Wrong phone number object class");
        if ([[convertedPhoneNumber class] isSubclassOfClass:[JivePhoneNumber class]])
            STAssertEqualObjects([(JivePhoneNumber *)convertedPhoneNumber value],
                                 [(JivePhoneNumber *)[basePerson.phoneNumbers objectAtIndex:0] value],
                                 @"Wrong phone number object");
    }
//    STAssertEquals([newPerson.photos count], [basePerson.photos count], @"Wrong number of photo objects");
//    STAssertEqualObjects([newPerson.photos objectAtIndex:0], [basePerson.photos objectAtIndex:0], @"Wrong photo object class");
    STAssertEquals([newPerson.tags count], [basePerson.tags count], @"Wrong number of tag objects");
    STAssertEqualObjects([newPerson.tags objectAtIndex:0], [basePerson.tags objectAtIndex:0], @"Wrong tag object class");
    STAssertEquals([newPerson.resources count], [basePerson.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[newPerson.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
}

- (void)testPersonParsingAlternate {
    JivePerson *basePerson = [[JivePerson alloc] init];
    JiveAddress *address = [[JiveAddress alloc] init];
    JivePersonJive *personJive = [[JivePersonJive alloc] init];
    JiveName *name = [[JiveName alloc] init];
    NSString *tag = @"Gigantic";
    JiveEmail *email = [[JiveEmail alloc] init];
    JivePhoneNumber *phoneNumber = [[JivePhoneNumber alloc] init];
    NSString *photoURI = @"http://com.dummy/png.photo";
    JiveResourceEntry *resource = [[JiveResourceEntry alloc] init];
    NSString *resourceKey = @"followers";
    NSDictionary *resourceJSON = [NSDictionary dictionaryWithObject:photoURI forKey:@"ref"];
    NSDictionary *resourcesJSON = [NSDictionary dictionaryWithObject:resourceJSON forKey:resourceKey];
    
    address.value = @{@"postalCode": @"80303"};
    personJive.username = @"name";
    name.familyName = @"Bushnell";
    phoneNumber.value = @"777-7777";
    email.value = @"something.com";
    [resource setValue:[NSURL URLWithString:photoURI] forKey:@"ref"];
    [basePerson setValue:@"display name" forKey:@"displayName"];
    [basePerson setValue:@"87654" forKey:@"jiveId"];
    basePerson.location = @"New Mexico";
    basePerson.status = @"No status";
    [basePerson setValue:@"http://com.dummy/png.thumbnail" forKey:@"thumbnailUrl"];
    [basePerson setValue:[NSNumber numberWithInt:6] forKey:@"followerCount"];
    [basePerson setValue:[NSNumber numberWithInt:4] forKey:@"followingCount"];
    [basePerson setValue:name forKey:@"name"];
    [basePerson setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [basePerson setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    [basePerson setValue:[NSArray arrayWithObject:address] forKey:@"addresses"];
    [basePerson setValue:personJive forKey:@"jive"];
    [basePerson setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [basePerson setValue:[NSArray arrayWithObject:email] forKey:@"emails"];
    [basePerson setValue:[NSArray arrayWithObject:phoneNumber] forKey:@"phoneNumbers"];
    [basePerson setValue:[NSArray arrayWithObject:photoURI] forKey:@"photos"];
    [basePerson setValue:[NSDictionary dictionaryWithObject:resource forKey:resourceKey] forKey:@"resources"];
    
    NSMutableDictionary *JSON = (NSMutableDictionary *)[basePerson toJSONDictionary];
    NSMutableDictionary *personJiveJSON = (NSMutableDictionary *)[personJive toJSONDictionary];
    NSDictionary *profileJSON = [NSDictionary dictionaryWithObject:@"department" forKey:@"jive_label"];
    
    [personJiveJSON setValue:[NSArray arrayWithObject:profileJSON] forKey:@"profile"];
    [JSON setValue:resourcesJSON forKey:@"resources"];
    [JSON setValue:@"display name" forKey:@"displayName"];
    [JSON setValue:[NSNumber numberWithInt:6] forKey:@"followerCount"];
    [JSON setValue:[NSNumber numberWithInt:4] forKey:@"followingCount"];
    [JSON setValue:@"87654" forKey:@"jiveId"];
    [JSON setValue:personJiveJSON forKey:@"jive"];
//    [JSON setValue:[NSArray arrayWithObject:photoURI] forKey:@"photos"];
    [JSON setValue:@"1970-01-01T00:16:40.123+0000" forKey:@"published"];
    [JSON setValue:@"http://com.dummy/png.thumbnail" forKey:@"thumbnailUrl"];
    [JSON setValue:@"1970-01-01T00:00:00.000+0000" forKey:@"updated"];
    
    JivePerson *newPerson = [JivePerson objectFromJSON:JSON withInstance:self.instance];
    
    STAssertEquals([newPerson class], [JivePerson class], @"Wrong item class");
    STAssertEqualObjects(newPerson.displayName, basePerson.displayName, @"Wrong display name");
    STAssertEqualObjects(newPerson.followerCount, basePerson.followerCount, @"Wrong follower count");
    STAssertEqualObjects(newPerson.followingCount, basePerson.followingCount, @"Wrong following count");
    STAssertEqualObjects(newPerson.jiveId, basePerson.jiveId, @"Wrong id");
    STAssertEqualObjects(newPerson.jive.username, basePerson.jive.username, @"Wrong Jive Person");
    STAssertEqualObjects(newPerson.location, basePerson.location, @"Wrong location");
    STAssertEqualObjects(newPerson.name.familyName, basePerson.name.familyName, @"Wrong name");
    STAssertEqualObjects(newPerson.published, basePerson.published, @"Wrong published date");
    STAssertEqualObjects(newPerson.status, basePerson.status, @"Wrong status");
    STAssertEqualObjects(newPerson.thumbnailUrl, basePerson.thumbnailUrl, @"Wrong thumbnailUrl");
    STAssertEqualObjects(newPerson.type, @"person", @"Wrong type");
    STAssertEqualObjects(newPerson.updated, basePerson.updated, @"Wrong updated date");
    STAssertEquals([newPerson.addresses count], [basePerson.addresses count], @"Wrong number of address objects");
    if ([newPerson.addresses count] > 0) {
        id convertedAddress = [newPerson.addresses objectAtIndex:0];
        STAssertEquals([convertedAddress class], [JiveAddress class], @"Wrong address object class");
        if ([[convertedAddress class] isSubclassOfClass:[JiveAddress class]])
            STAssertEqualObjects([(JiveAddress *)convertedAddress value],
                                 [(JiveAddress *)[basePerson.addresses objectAtIndex:0] value],
                                 @"Wrong Address object");
    }
    STAssertEquals([newPerson.emails count], [basePerson.emails count], @"Wrong number of email objects");
    if ([newPerson.emails count] > 0) {
        id convertedEmail = [newPerson.emails objectAtIndex:0];
        STAssertEquals([convertedEmail class], [JiveEmail class], @"Wrong email object class");
        if ([[convertedEmail class] isSubclassOfClass:[JiveEmail class]])
            STAssertEqualObjects([(JiveEmail *)convertedEmail value],
                                 [(JiveEmail *)[basePerson.emails objectAtIndex:0] value],
                                 @"Wrong email object");
    }
    STAssertEquals([newPerson.phoneNumbers count], [basePerson.phoneNumbers count], @"Wrong number of phone number objects");
    if ([newPerson.phoneNumbers count] > 0) {
        id convertedPhoneNumber = [newPerson.phoneNumbers objectAtIndex:0];
        STAssertEquals([convertedPhoneNumber class], [JivePhoneNumber class], @"Wrong phone number object class");
        if ([[convertedPhoneNumber class] isSubclassOfClass:[JivePhoneNumber class]])
            STAssertEqualObjects([(JivePhoneNumber *)convertedPhoneNumber value],
                                 [(JivePhoneNumber *)[basePerson.phoneNumbers objectAtIndex:0] value],
                                 @"Wrong phone number object");
    }
//    STAssertEquals([person.photos count], [basePerson.photos count], @"Wrong number of photo objects");
//    STAssertEqualObjects([person.photos objectAtIndex:0], [basePerson.photos objectAtIndex:0], @"Wrong photo object class");
    STAssertEquals([newPerson.tags count], [basePerson.tags count], @"Wrong number of tag objects");
    STAssertEqualObjects([newPerson.tags objectAtIndex:0], [basePerson.tags objectAtIndex:0], @"Wrong tag object class");
    STAssertEquals([newPerson.resources count], [basePerson.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[newPerson.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
    STAssertEquals([newPerson.jive.profile count], (NSUInteger)1, @"Wrong number of profile objects");
    if ([newPerson.jive.profile count] > 0) {
        JiveProfileEntry *convertedProfile = [newPerson.jive.profile objectAtIndex:0];
        STAssertEquals([convertedProfile class], [JiveProfileEntry class], @"Wrong profile object class");
        if ([[convertedProfile class] isSubclassOfClass:[JiveProfileEntry class]])
            STAssertEqualObjects(convertedProfile.jive_label, @"department", @"Wrong profile object");
    }
}

- (void) testRefreshOperation {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    
    [options addField:@"id"];
    
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [self.person refreshOperationWithOptions:options
                                             onComplete:^(JivePerson *person) {
                                                 STAssertEquals(person, self.person, @"Person object not updated");
                                                 STAssertEqualObjects(self.person.jiveId, @"5316", @"Wrong jiveId");
                                                 completionBlock(person);
                                             }
                                                onError:errorBlock];
    }
                  withResponse:@"person_response"
                         setup:^{
                             [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
                             STAssertEqualObjects(self.person.jiveId, @"3550", @"PRECONDITION: Wrong jiveId");
                         }
                           URL:@"https://brewspace.jiveland.com/api/core/v3/people/3550?fields=id"
                 expectedClass:[JivePerson class]];
}

- (void) testRefreshServiceCall {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"alt_person_response"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/5316?fields=name,id"];
    
    STAssertEqualObjects(self.person.jiveId, @"5316", @"PRECONDITION: Wrong jiveId");
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [self.person refreshWithOptions:options
                             onComplete:^(JivePerson *person) {
                                 STAssertEquals([person class], [JivePerson class], @"Wrong item class");
                                 STAssertEqualObjects(self.person.jiveId, @"3550", @"Wrong jiveId");
                                 
                                 // Check that delegates where actually called
                                 [mockAuthDelegate verify];
                                 [mockJiveURLResponseDelegate verify];
                                 finishedBlock();
                             } onError:^(NSError *error) {
                                 STFail([error localizedDescription]);
                                 finishedBlock();
                             }];
    }];
}

- (void) testRefreshServiceCall_wrongClassResponse {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"task"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/5316?fields=name,id"];
    
    STAssertEqualObjects(self.person.jiveId, @"5316", @"PRECONDITION: Wrong jiveId");
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [self.person refreshWithOptions:options
                             onComplete:^(JivePerson *person) {
                                 STFail(@"The person object should not be updated with a task response");
                                 finishedBlock();
                             } onError:^(NSError *error) {
                                 STAssertEqualObjects([error domain], JiveErrorDomain, nil);
                                 STAssertEquals([error code], JiveErrorCodeInvalidJSON, nil);
                                 finishedBlock();
                             }];
    }];
}

- (void) testDeletePersonOperation {
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    
    [self createJiveAPIObjectWithResponse:@"person_response"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/3550"];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [self.person deleteOperationOnComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(JiveHTTPMethodTypes.DELETE, operation.request.HTTPMethod, @"Wrong http method used");
        [operation start];
    }];
}

- (void) testDeletePersonServiceCall {
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"alt_person_response"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/5316"];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [self.person deleteOnComplete:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testUpdatePersonOperation {
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        NSDictionary *JSON = [self.person toJSONDictionary];
        NSData *body = [NSJSONSerialization dataWithJSONObject:JSON options:0 error:nil];
        AFURLConnectionOperation *operation = [self.person updateOperationOnComplete:^(JivePerson *person) {
            STAssertEquals(person, self.person, @"Person object not updated");
            STAssertEqualObjects(self.person.jiveId, @"5316", @"Wrong jiveId");
            STAssertEqualObjects(self.person.location, @"home on the range", @"New object not created");
            completionBlock(person);
        }
                                                                             onError:errorBlock];

        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.PUT, @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        return operation;
    }
                  withResponse:@"person_response"
                         setup:^{
                             [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
                             self.person.location = @"alternate";
                             STAssertEqualObjects(self.person.jiveId, @"3550", @"PRECONDITION: Wrong jiveId");
                         }
                           URL:@"https://brewspace.jiveland.com/api/core/v3/people/3550"
                 expectedClass:[JivePerson class]];
}

- (void) testUpdatePerson {
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"alt_person_response"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/5316"];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [self.person updateOnComplete:^(JivePerson *person) {
            STAssertEquals(person, self.person, @"Person object not updated");
            STAssertEqualObjects(self.person.jiveId, @"3550", @"Wrong jiveId");
            STAssertEqualObjects(person.location, @"Portland", @"New object not created");

            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testGetBlogOperation {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [self.person blogOperationWithOptions:options
                                          onComplete:completionBlock
                                             onError:errorBlock];
    }
                  withResponse:@"blog"
                           URL:@"https://brewspace.jiveland.com/api/core/v3/people/3550/blog?fields=id"
                 expectedClass:[JiveBlog class]];
}

- (void) testGetBlog {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"blog"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/5316/blog?fields=name,id"];

    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [self.person blogWithOptions:options
                          onComplete:^(JiveBlog *blog) {
                              STAssertEquals([blog class], [JiveBlog class], @"Wrong item class");
                              
                              // Check that delegates where actually called
                              [mockAuthDelegate verify];
                              [mockJiveURLResponseDelegate verify];
                              finishedBlock();
                          } onError:^(NSError *error) {
                              STFail([error localizedDescription]);
                              finishedBlock();
                          }];
    }];
}

- (void) testGetManagerOperation {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [self.person managerOperationWithOptions:options
                                             onComplete:^(JivePerson *person) {
                                                 STAssertFalse(person == self.person, @"Failed to create a new JivePerson object");
                                                 STAssertFalse(person.jiveId == self.person.jiveId, @"Failed to create the correct JiveObject");
                                                 STAssertEqualObjects(person.jiveInstance, self.person.jiveInstance, @"New person is missing the jiveInstance");
                                                 completionBlock(person);
                                             }
                                                onError:errorBlock];
    }
                  withResponse:@"person_response"
                           URL:@"https://brewspace.jiveland.com/api/core/v3/people/3550/@manager?fields=id"
                 expectedClass:[JivePerson class]];
}

- (void) testGetManager {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"alt_person_response"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/5316/@manager?fields=name,id"];

    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [self.person managerWithOptions:options
                             onComplete:^(JivePerson *person) {
                                 STAssertEquals([person class], [JivePerson class], @"Wrong item class");
                                 STAssertFalse(person == self.person, @"Failed to create a new JivePerson object");
                                 STAssertFalse(person.jiveId == self.person.jiveId, @"Failed to create the correct JiveObject");
                                 STAssertEqualObjects(person.jiveInstance, self.person.jiveInstance, @"New person is missing the jiveInstance");
                                 
                                 // Check that delegates where actually called
                                 [mockAuthDelegate verify];
                                 [mockJiveURLResponseDelegate verify];
                                 finishedBlock();
                             } onError:^(NSError *error) {
                                 STFail([error localizedDescription]);
                                 finishedBlock();
                             }];
    }];
}

- (void) testColleguesOperation {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 5;
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self checkPersonListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [self.person colleguesOperationWithOptions:options
                                               onComplete:completionBlock
                                                  onError:errorBlock];
    }
                      withResponse:@"collegues_response"
                               URL:@"https://brewspace.jiveland.com/api/core/v3/people/3550/@colleagues?startIndex=5"
                     expectedCount:9];
}

- (void) testColleguesServiceCall {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 10;
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"collegues_response"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/5316/@colleagues?startIndex=10"];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [self.person colleguesWithOptions:options
                               onComplete:^(NSArray *people) {
                                   STAssertEquals([people count], (NSUInteger)9, @"Wrong number of items parsed");
                                   STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
                                   for (JivePerson *person in people) {
                                       STAssertFalse(person.jiveId == self.person.jiveId, @"Duplicate person found: %@", person);
                                       STAssertEqualObjects(person.jiveInstance, self.person.jiveInstance, @"New person is missing the jiveInstance");
                                   }
                                   
                                   // Check that delegates where actually called
                                   [mockAuthDelegate verify];
                                   [mockJiveURLResponseDelegate verify];
                                   finishedBlock();
                               } onError:^(NSError *error) {
                                   STFail([error localizedDescription]);
                                   finishedBlock();
                               }];
    }];
}

- (void) testGetReportsOperation {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.count = 10;
    self.instanceURL = @"http://gigi-eae03.eng.jiveland.com/";
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self checkPersonListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [self.person reportsOperationWithOptions:options
                                             onComplete:completionBlock
                                                onError:errorBlock];
    }
                      withResponse:@"people_response"
                               URL:@"http://gigi-eae03.eng.jiveland.com/api/core/v3/people/3550/@reports?count=10"
                     expectedCount:20];
}

- (void) testGetReports {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.count = 3;
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"people_response"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/5316/@reports?count=3"];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [self.person reportsWithOptions:options
                             onComplete:^(NSArray *people) {
                                 STAssertEquals([people count], (NSUInteger)20, @"Wrong number of items parsed");
                                 STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
                                 for (JivePerson *person in people) {
                                     STAssertFalse(person.jiveId == self.person.jiveId, @"Duplicate person found: %@", person);
                                     STAssertEqualObjects(person.jiveInstance, self.person.jiveInstance, @"New person is missing the jiveInstance");
                                 }
                                 
                                 // Check that delegates where actually called
                                 [mockAuthDelegate verify];
                                 [mockJiveURLResponseDelegate verify];
                                 finishedBlock();
                             } onError:^(NSError *error) {
                                 STFail([error localizedDescription]);
                                 finishedBlock();
                             }];
    }];
}

- (void) testFollowersOperationWithOptions {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 10;
    options.count = 10;
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self checkPersonListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [self.person followersOperationWithOptions:options
                                               onComplete:completionBlock
                                                  onError:errorBlock];
    }
                      withResponse:@"followers_response"
                               URL:@"https://brewspace.jiveland.com/api/core/v3/people/3550/@followers?count=10&startIndex=10"
                     expectedCount:23];
}

- (void) testFollowersServiceCallWithOptions {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 0;
    options.count = 5;
    [options addField:@"dummy"];
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"followers_response"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/5316/@followers?fields=dummy&count=5"];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [self.person followersWithOptions:options
                               onComplete:^(NSArray *people) {
                                   STAssertEquals([people count], (NSUInteger)23, @"Wrong number of items parsed");
                                   STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
                                   for (JivePerson *person in people) {
                                       STAssertFalse(person.jiveId == self.person.jiveId, @"Duplicate person found: %@", person);
                                       STAssertEqualObjects(person.jiveInstance, self.person.jiveInstance, @"New person is missing the jiveInstance");
                                   }
                                   
                                   // Check that delegates where actually called
                                   [mockAuthDelegate verify];
                                   [mockJiveURLResponseDelegate verify];
                                   finishedBlock();
                               } onError:^(NSError *error) {
                                   STFail([error localizedDescription]);
                                   finishedBlock();
                               }];
    }];
}

- (void) testFollowersServiceCallWithDifferentOptions {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.startIndex = 6;
    options.count = 3;
    [options addField:@"dummy"];
    [options addField:@"second"];
    [options addField:@"third"];
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"followers_response"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/5316/@followers?fields=dummy,second,third&count=3&startIndex=6"];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [self.person followersWithOptions:options
                               onComplete:^(NSArray *people) {
                                   STAssertEquals([people count], (NSUInteger)23, @"Wrong number of items parsed");
                                   STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
                                   for (JivePerson *person in people) {
                                       STAssertFalse(person.jiveId == self.person.jiveId, @"Duplicate person found: %@", person);
                                       STAssertEqualObjects(person.jiveInstance, self.person.jiveInstance, @"New person is missing the jiveInstance");
                                   }
                                   
                                   // Check that delegates where actually called
                                   [mockAuthDelegate verify];
                                   [mockJiveURLResponseDelegate verify];
                                   finishedBlock();
                               } onError:^(NSError *error) {
                                   STFail([error localizedDescription]);
                                   finishedBlock();
                               }];
    }];
}

- (void) testGetFollowingOperation {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.count = 10;
    self.instanceURL = @"http://gigi-eae03.eng.jiveland.com/";
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self checkPersonListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [self.person followingOperationWithOptions:options
                                               onComplete:completionBlock
                                                  onError:errorBlock];
    }
                      withResponse:@"people_response"
                               URL:@"http://gigi-eae03.eng.jiveland.com/api/core/v3/people/3550/@following?count=10"
                     expectedCount:20];
}

- (void) testGetFollowing {
    JivePagedRequestOptions *options = [[JivePagedRequestOptions alloc] init];
    options.count = 3;
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"people_response"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/5316/@following?count=3"];

    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [self.person followingWithOptions:options
                               onComplete:^(NSArray *people) {
                                   STAssertEquals([people count], (NSUInteger)20, @"Wrong number of items parsed");
                                   STAssertEquals([[people objectAtIndex:0] class], [JivePerson class], @"Wrong item class");
                                   for (JivePerson *person in people) {
                                       STAssertFalse(person.jiveId == self.person.jiveId, @"Duplicate person found: %@", person);
                                       STAssertEqualObjects(person.jiveInstance, self.person.jiveInstance, @"New person is missing the jiveInstance");
                                   }
                                   
                                   // Check that delegates where actually called
                                   [mockAuthDelegate verify];
                                   [mockJiveURLResponseDelegate verify];
                                   finishedBlock();
                               } onError:^(NSError *error) {
                                   STFail([error localizedDescription]);
                                   finishedBlock();
                               }];
    }];
}

- (void)checkListOperation:(NSOperation *(^)(JiveArrayCompleteBlock completionBlock,
                                             JiveErrorBlock errorBlock))createOperation
              withResponse:(NSString *)response
                     setup:(void (^)())setupBlock
                       URL:(NSString *)url
             expectedCount:(NSUInteger)expectedCount
             expectedClass:(Class)clazz {
    
    JiveArrayCompleteBlock completeBlock = ^(NSArray *collection) {
        STAssertEquals([collection count], expectedCount, @"Wrong number of items parsed");
        for (id collectionObject in collection) {
            STAssertTrue([collectionObject isKindOfClass:clazz], @"Item %@ is not of class %@",
                         collectionObject, clazz);
        }
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    };
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        [self createJiveAPIObjectWithResponse:response andAuthDelegateURLCheck:url];
        setupBlock();
        NSOperation* operation = createOperation(^(NSArray *streams) {
            completeBlock(streams);
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     STFail([error localizedDescription]);
                                                     finishedBlock();
                                                 });
        
        STAssertNotNil(operation, @"Missing operation object");
        [operation start];
    }];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        [self createJiveAPIObjectWithResponse:response andAuthDelegateURLCheck:url];
        setupBlock();
        self.person.jiveInstance.badInstanceURL = @"brewspace";
        NSOperation* operation = createOperation(^(NSArray *streams) {
            STAssertNil(self.person.jiveInstance.badInstanceURL,
                        @"badInstanceURL was not cleared: %@",
                        self.person.jiveInstance.badInstanceURL);
            completeBlock(streams);
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     STFail([error localizedDescription]);
                                                     finishedBlock();
                                                 });
        
        STAssertNotNil(operation, @"Missing clear bad instance check operation object");
        [operation start];
    }];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSInteger error_code = 404;
        [self createJiveAPIObjectWithErrorCode:error_code andAuthDelegateURLCheck:url];
        setupBlock();
        NSOperation *operation = createOperation(^(NSArray *streams) {
            STFail(@"404 errors should be reported");
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     STAssertEquals([error.userInfo[JiveErrorKeyHTTPStatusCode] integerValue],
                                                                    error_code,
                                                                    @"Wrong error reported");
                                                     [mockAuthDelegate verify];
                                                     [mockJiveURLResponseDelegate verify];
                                                     finishedBlock();
                                                 });
        
        STAssertNotNil(operation, @"Missing error operation object");
        [operation start];
    }];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        [self createJiveAPIObjectWithTermsAndConditionsFailureAndAuthDelegateURLCheck:url];
        setupBlock();
        NSOperation *operation = createOperation(^(NSArray *streams) {
            STFail(@"Terms and Conditions errors should be reported");
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     STAssertEquals([error.userInfo[JiveErrorKeyHTTPStatusCode] integerValue],
                                                                    0,
                                                                    @"Wrong error reported");
                                                     STAssertEqualObjects(error.userInfo[JiveErrorKeyTermsAndConditionsAPI],
                                                                          @"/api/core/v3/people/@me/termsAndConditions",
                                                                          @"Wrong terms and conditions api");
                                                     [mockAuthDelegate verify];
                                                     [mockJiveURLResponseDelegate verify];
                                                     finishedBlock();
                                                 });
        
        STAssertNotNil(operation, @"Missing error operation object");
        [operation start];
    }];

    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSString *proxyInstanceURL = ([self.instanceURL hasSuffix:@"/"] ?
                                      @"http://brewspace.com/" :
                                      @"http://brewspace.com");
        NSString *testURL = [url stringByReplacingOccurrencesOfString:self.instanceURL
                                                           withString:proxyInstanceURL];
        
        self.instanceURL = proxyInstanceURL;
        self.person.jiveInstance.jiveInstanceURL = [NSURL URLWithString:proxyInstanceURL];
        
        [self createJiveAPIObjectWithResponse:response andAuthDelegateURLCheck:testURL];
        setupBlock();
        self.person.jiveInstance.badInstanceURL = nil;
        NSOperation* operation = createOperation(^(NSArray *streams) {
            STAssertNotNil(self.person.jiveInstance.badInstanceURL, @"badInstanceURL not updated.");
            completeBlock(streams);
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     STFail([error localizedDescription]);
                                                     finishedBlock();
                                                 });
        
        STAssertNotNil(operation, @"Missing bad instance check operation object");
        [operation start];
    }];
}

- (void)checkListOperation:(NSOperation *(^)(JiveArrayCompleteBlock completionBlock,
                                             JiveErrorBlock errorBlock))createOperation
              withResponse:(NSString *)response
                       URL:(NSString *)url
             expectedCount:(NSUInteger)expectedCount
             expectedClass:(Class)clazz {
    [self checkListOperation:createOperation
                withResponse:response
                       setup:^{ }
                         URL:url
               expectedCount:expectedCount
               expectedClass:clazz];
}

- (void)checkPersonListOperation:(NSOperation *(^)(JiveArrayCompleteBlock completionBlock,
                                                   JiveErrorBlock errorBlock))createOperation
                    withResponse:(NSString *)response
                           setup:(void (^)())setupBlock
                             URL:(NSString *)url
                   expectedCount:(NSUInteger)expectedCount {
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return createOperation(^(NSArray *people) {
            for (JivePerson *person in people) {
                STAssertFalse(person.jiveId == self.person.jiveId, @"Duplicate person found: %@", person);
                STAssertEqualObjects(person.jiveInstance, self.person.jiveInstance, @"New person is missing the jiveInstance");
            }
            completionBlock(people);
        }, errorBlock);
    }
                withResponse:response
                       setup:setupBlock
                         URL:url
               expectedCount:expectedCount
               expectedClass:[JivePerson class]];
}

- (void)checkPersonListOperation:(NSOperation *(^)(JiveArrayCompleteBlock completionBlock,
                                                   JiveErrorBlock errorBlock))createOperation
                    withResponse:(NSString *)response
                             URL:(NSString *)url
                   expectedCount:(NSUInteger)expectedCount {
    [self checkPersonListOperation:createOperation
                      withResponse:response
                             setup:^{ }
                               URL:url
                     expectedCount:expectedCount];
}

- (void)checkObjectOperation:(NSOperation *(^)(JiveObjectCompleteBlock completionBlock,
                                               JiveErrorBlock errorBlock))createOperation
                withResponse:(NSString *)response
                       setup:(void (^)())setupBlock
                         URL:(NSString *)url
               expectedClass:(Class)clazz {
    
    JiveObjectCompleteBlock completeBlock = ^(id object) {
        STAssertEquals([object class], clazz, @"Wrong item class");
        
        // Check that delegates where actually called
        [mockAuthDelegate verify];
        [mockJiveURLResponseDelegate verify];
    };
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        [self createJiveAPIObjectWithResponse:response andAuthDelegateURLCheck:url];
        setupBlock();
        NSOperation* operation = createOperation(^(id object) {
            completeBlock(object);
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     STFail([error localizedDescription]);
                                                     finishedBlock();
                                                 });
        
        STAssertNotNil(operation, @"Missing operation object");
        [operation start];
    }];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        [self createJiveAPIObjectWithResponse:response andAuthDelegateURLCheck:url];
        setupBlock();
        self.person.jiveInstance.badInstanceURL = @"brewspace";
        NSOperation* operation = createOperation(^(id object) {
            STAssertNil(self.person.jiveInstance.badInstanceURL,
                        @"badInstanceURL was not cleared: %@",
                        self.person.jiveInstance.badInstanceURL);
            completeBlock(object);
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     STFail([error localizedDescription]);
                                                     finishedBlock();
                                                 });
        
        STAssertNotNil(operation, @"Missing clear bad instance check operation object");
        [operation start];
    }];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSInteger error_code = 404;
        [self createJiveAPIObjectWithErrorCode:error_code andAuthDelegateURLCheck:url];
        setupBlock();
        NSOperation *operation = createOperation(^(id object) {
            STFail(@"404 errors should be reported");
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     STAssertEquals([error.userInfo[JiveErrorKeyHTTPStatusCode] integerValue],
                                                                    error_code,
                                                                    @"Wrong error reported");
                                                     [mockAuthDelegate verify];
                                                     [mockJiveURLResponseDelegate verify];
                                                     finishedBlock();
                                                 });
        
        STAssertNotNil(operation, @"Missing error operation object");
        [operation start];
    }];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        [self createJiveAPIObjectWithTermsAndConditionsFailureAndAuthDelegateURLCheck:url];
        setupBlock();
        NSOperation *operation = createOperation(^(id object) {
            STFail(@"Terms and Conditions errors should be reported");
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     STAssertEquals([error.userInfo[JiveErrorKeyHTTPStatusCode] integerValue],
                                                                    0,
                                                                    @"Wrong error reported");
                                                     STAssertEqualObjects(error.userInfo[JiveErrorKeyTermsAndConditionsAPI],
                                                                          @"/api/core/v3/people/@me/termsAndConditions",
                                                                          @"Wrong terms and conditions api");
                                                     [mockAuthDelegate verify];
                                                     [mockJiveURLResponseDelegate verify];
                                                     finishedBlock();
                                                 });
        
        STAssertNotNil(operation, @"Missing error operation object");
        [operation start];
    }];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        NSString *canonicalProxyInstanceURL = @"http://brewspace.com/";
        NSString *proxyInstanceURL = ([self.instanceURL hasSuffix:@"/"] ?
                                      canonicalProxyInstanceURL :
                                      @"http://brewspace.com");
        NSString *instanceURLString = [url stringByReplacingOccurrencesOfString:self.instance.jiveInstanceURL.absoluteString
                                                                     withString:proxyInstanceURL];
        
        self.instanceURL = canonicalProxyInstanceURL;
        
        [self createJiveAPIObjectWithResponse:response andAuthDelegateURLCheck:instanceURLString];
        setupBlock();
        self.person.jiveInstance.badInstanceURL = nil;
        NSOperation* operation = createOperation(^(id object) {
            STAssertNotNil(self.person.jiveInstance.badInstanceURL,
                           @"badInstanceURL not updated: %@",
                           self.person.jiveInstance.badInstanceURL);
            completeBlock(object);
            finishedBlock();
        },
                                                 ^(NSError *error) {
                                                     STFail([error localizedDescription]);
                                                     finishedBlock();
                                                 });
        
        STAssertNotNil(operation, @"Missing bad instance check operation object");
        [operation start];
    }];
}

- (void)checkObjectOperation:(NSOperation *(^)(JiveObjectCompleteBlock completionBlock,
                                               JiveErrorBlock errorBlock))createOperation
                withResponse:(NSString *)response
                         URL:(NSString *)url
               expectedClass:(Class)clazz {
    [self checkObjectOperation:createOperation
                  withResponse:response
                         setup:^{ }
                           URL:url
                 expectedClass:clazz];
}

- (void) testFollowingInOperation {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [self.person followingInOperationWithOptions:options
                                                 onComplete:completionBlock
                                                    onError:errorBlock];
    }
                withResponse:@"followingIn_streams"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/people/3550/followingIn?fields=id"
               expectedCount:1
               expectedClass:[JiveStream class]];
}

- (void) testFollowingIn {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"followingIn_streams"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/5316/followingIn?fields=name,id"];

    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [self.person followingInWithOptions:options
                                 onComplete:^(NSArray *streams) {
                                     STAssertEquals([streams count], (NSUInteger)1, @"Wrong number of items parsed");
                                     STAssertTrue([[streams objectAtIndex:0] isKindOfClass:[JiveStream class]], @"Wrong item class");
                                     
                                     // Check that delegates where actually called
                                     [mockAuthDelegate verify];
                                     [mockJiveURLResponseDelegate verify];
                                     finishedBlock();
                                 } onError:^(NSError *error) {
                                     STFail([error localizedDescription]);
                                     finishedBlock();
                                 }];
    }];
}

- (void) testStreamsOperation {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [self.person streamsOperationWithOptions:options
                                             onComplete:completionBlock
                                                onError:errorBlock];
    }
                withResponse:@"person_streams"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/people/3550/streams?fields=name,id"
               expectedCount:5
               expectedClass:[JiveStream class]];
}

- (void) testStreams {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"person_streams"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/5316/streams?fields=id"];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [self.person streamsWithOptions:options
                             onComplete:^(NSArray *streams) {
                                 STAssertEquals([streams count], (NSUInteger)5, @"Wrong number of items parsed");
                                 STAssertEquals([[streams objectAtIndex:0] class], [JiveStream class], @"Wrong item class");
                                 
                                 // Check that delegates where actually called
                                 [mockAuthDelegate verify];
                                 [mockJiveURLResponseDelegate verify];
                                 finishedBlock();
                             } onError:^(NSError *error) {
                                 STFail([error localizedDescription]);
                                 finishedBlock();
                             }];
    }];
}

- (void) testActivitiesOperation {
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:0.123];
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [self.person activitiesOperationWithOptions:options
                                                onComplete:completionBlock
                                                   onError:errorBlock];
    }
                withResponse:@"person_activities"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/people/3550/activities?after=1970-01-01T00%3A00%3A00.123%2B0000"
               expectedCount:23
               expectedClass:[JiveActivity class]];
}

- (void) testActivities {
    JiveDateLimitedRequestOptions *options = [[JiveDateLimitedRequestOptions alloc] init];
    options.after = [NSDate dateWithTimeIntervalSince1970:0];
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"person_activities"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/5316/activities?after=1970-01-01T00%3A00%3A00.000%2B0000"];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [self.person activitiesWithOptions:options
                                onComplete:^(NSArray *activities) {
                                    STAssertEquals([activities count], (NSUInteger)23, @"Wrong number of items parsed");
                                    STAssertEquals([[activities objectAtIndex:0] class], [JiveActivity class], @"Wrong item class");
                                    
                                    // Check that delegates where actually called
                                    [mockAuthDelegate verify];
                                    [mockJiveURLResponseDelegate verify];
                                    finishedBlock();
                                } onError:^(NSError *error) {
                                    STFail([error localizedDescription]);
                                    finishedBlock();
                                }];
    }];
}

- (void) testTasksOperation {
    JiveSortedRequestOptions *options = [[JiveSortedRequestOptions alloc] init];
    options.sort = JiveSortOrderTitleAsc;
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        return [self.person tasksOperationWithOptions:options
                                           onComplete:completionBlock
                                              onError:errorBlock];
    }
                withResponse:@"person_tasks"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/people/3550/tasks?sort=titleAsc"
               expectedCount:1
               expectedClass:[JiveTask class]];
}

- (void) testTasks {
    JiveSortedRequestOptions *options = [[JiveSortedRequestOptions alloc] init];
    options.sort = JiveSortOrderLatestActivityDesc;
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"person_tasks"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/5316/tasks?sort=latestActivityDesc"];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [self.person tasksWithOptions:options
                           onComplete:^(NSArray *tasks) {
                               // Called 3rd
                               STAssertEquals([tasks count], (NSUInteger)1, @"Wrong number of items parsed");
                               STAssertEquals([[tasks objectAtIndex:0] class], [JiveTask class], @"Wrong item class");
                               
                               // Check that delegates where actually called
                               [mockAuthDelegate verify];
                               [mockJiveURLResponseDelegate verify];
                               finishedBlock();
                           } onError:^(NSError *error) {
                               STFail([error localizedDescription]);
                               finishedBlock();
                           }];
    }];
}

- (void) testFollowOperation {
    JivePerson *target = [JivePerson new];
    
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self loadPerson:target fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"person_response"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/3550/@following/5316"];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [self.person followOperation:target
                                                                onComplete:^() {
                                                                    // Check that delegates where actually called
                                                                    [mockAuthDelegate verify];
                                                                    [mockJiveURLResponseDelegate verify];
                                                                    finishedBlock();
                                                                } onError:^(NSError *error) {
                                                                    STFail([error localizedDescription]);
                                                                    finishedBlock();
                                                                }];

        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.PUT, @"Wrong http method used");
        [operation start];
    }];
}

- (void) testFollow {
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"person_response"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/5316/@following/3550"];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JivePerson *target = [JivePerson new];
        
        [self loadPerson:target fromJSONNamed:@"alt_person_response"];
        [self.person follow:target
                 onComplete:^() {
                     // Check that delegates where actually called
                     [mockAuthDelegate verify];
                     [mockJiveURLResponseDelegate verify];
                     finishedBlock();
                 } onError:^(NSError *error) {
                     STFail([error localizedDescription]);
                     finishedBlock();
                 }];
    }];
}

- (id) entityForClass:(Class) entityClass
        fromJSONNamed:(NSString *)jsonName {
    NSString *jsonPath = [[NSBundle bundleForClass:[self class]] pathForResource:jsonName
                                                                          ofType:@"json"];
    NSData *rawJson = [NSData dataWithContentsOfFile:jsonPath];
    NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:rawJson
                                                         options:0
                                                           error:NULL];
    id entity = [entityClass objectFromJSON:JSON withInstance:self.instance];
    return entity;
}

- (void) test_updateFollowingInOperation {
    JiveStream *stream = [self entityForClass:[JiveStream class] fromJSONNamed:@"stream"];
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    NSData *body = [NSJSONSerialization dataWithJSONObject:@[[stream.selfRef absoluteString]] options:0 error:nil];
    
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self checkListOperation:^NSOperation *(JiveArrayCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        AFURLConnectionOperation* operation = [self.person updateFollowingInOperation:@[stream]
                                                                          withOptions:options
                                                                           onComplete:completionBlock
                                                                              onError:errorBlock];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.POST, @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        return operation;
    }
                withResponse:@"followingIn_streams"
                         URL:@"https://brewspace.jiveland.com/api/core/v3/people/3550/followingIn?fields=id"
               expectedCount:1
               expectedClass:[JiveStream class]];
}

- (void) test_updateFollowingIn {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"followingIn_streams"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/5316/followingIn?fields=name,id"];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveStream *stream = [self entityForClass:[JiveStream class] fromJSONNamed:@"stream"];
        [self.person updateFollowingIn:@[stream]
                           withOptions:options
                            onComplete:^(NSArray *streams) {
                                STAssertEquals([streams count], (NSUInteger) 1, @"Wrong number of items parsed");
                                STAssertTrue([[streams objectAtIndex:0] isKindOfClass:[JiveStream class]], @"Wrong item class");
                                
                                // Check that delegates where actually called
                                [mockAuthDelegate verify];
                                [mockJiveURLResponseDelegate verify];
                                finishedBlock();
                            } onError:^(NSError *error) {
                                STFail([error localizedDescription]);
                                finishedBlock();
                            }];
    }];
}

- (void) testCreateTaskOperation {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self checkObjectOperation:^NSOperation *(JiveObjectCompleteBlock completionBlock, JiveErrorBlock errorBlock) {
        JiveTask *testTask = [[JiveTask alloc] init];
        
        testTask.subject = @"subject";
        testTask.dueDate = [NSDate date];
        STAssertNil(testTask.jiveId, @"PRECONDITION: Task jiveId must be nil");
        
        NSData *body = [NSJSONSerialization dataWithJSONObject:[testTask toJSONDictionary] options:0 error:nil];
        
        AFURLConnectionOperation *operation = [self.person createTaskOperation:testTask
                                                                   withOptions:options
                                                                    onComplete:^(JiveTask *task) {
                                                                        STAssertEquals(task, testTask, @"Task object not updated");
                                                                        STAssertEqualObjects(task.jiveId, @"8991", @"Wrong jiveId");
                                                                        completionBlock(task);
                                                                    }
                                                                       onError:errorBlock];
        
        STAssertEqualObjects(operation.request.HTTPMethod, JiveHTTPMethodTypes.POST, @"Wrong http method used");
        STAssertEqualObjects(operation.request.HTTPBody, body, @"Wrong http body");
        STAssertEqualObjects([operation.request valueForHTTPHeaderField:@"Content-Type"], @"application/json; charset=UTF-8", @"Wrong content type");
        STAssertEquals([[operation.request valueForHTTPHeaderField:@"Content-Length"] integerValue], (NSInteger)body.length, @"Wrong content length");
        return operation;
    }
                  withResponse:@"task"
                           URL:@"https://brewspace.jiveland.com/api/core/v3/people/3550/tasks?fields=id"
                 expectedClass:[JiveTask class]];
}

- (void) testCreateTask {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"task"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/5316/tasks?fields=name,id"];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveTask *testTask = [[JiveTask alloc] init];
        testTask.subject = @"Supercalifragalisticexpialidotious - is that spelled right?";
        testTask.dueDate = [NSDate dateWithTimeIntervalSince1970:0];
        [self.person createTask:testTask
                    withOptions:options
                     onComplete:^(JiveTask *task) {
                         STAssertEquals(task, testTask, @"Task object not updated");
                         STAssertEqualObjects(task.jiveId, @"8991", @"Wrong jiveId");
                         
                         // Check that delegates where actually called
                         [mockAuthDelegate verify];
                         [mockJiveURLResponseDelegate verify];
                         finishedBlock();
                     } onError:^(NSError *error) {
                         STFail([error localizedDescription]);
                         finishedBlock();
                     }];
    }];
}

- (void) testCreateTask_wrongClassResponse {
    JiveReturnFieldsRequestOptions *options = [[JiveReturnFieldsRequestOptions alloc] init];
    [options addField:@"name"];
    [options addField:@"id"];
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"alt_person_response"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/5316/tasks?fields=name,id"];
    
    STAssertEqualObjects(self.person.jiveId, @"5316", @"PRECONDITION: Wrong jiveId");
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        JiveTask *testTask = [[JiveTask alloc] init];
        testTask.subject = @"Supercalifragalisticexpialidotious - is that spelled right?";
        testTask.dueDate = [NSDate dateWithTimeIntervalSince1970:0];
        [self.person createTask:testTask
                    withOptions:options
                     onComplete:^(JiveTask *task) {
                         STFail(@"The task object should not be updated with a person response");
                         finishedBlock();
                     } onError:^(NSError *error) {
                         STAssertEqualObjects([error domain], JiveErrorDomain, nil);
                         STAssertEquals([error code], JiveErrorCodeInvalidJSON, nil);
                         finishedBlock();
                     }];
    }];
}

- (void) testGetTermsAndConditionsOperation {
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    [self createJiveAPIObjectWithResponse:@"T_C_response"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/3550/termsAndConditions"];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [self.person termsAndConditionsOperation:^(JiveTermsAndConditions *termsAndConditions) {
            STAssertEquals([termsAndConditions class], [JiveTermsAndConditions class], @"Wrong item class");
            STAssertTrue(termsAndConditions.acceptanceRequired.boolValue, @"Acceptance should be required");
            STAssertNotNil(termsAndConditions.text, @"Missing text");
            STAssertNil(termsAndConditions.url, @"Unexpected URL");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertNotNil(operation, @"Missing operation");
        [operation start];
    }];
}

- (void) testGetTermsAndConditionsOperation_withURL {
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    [self createJiveAPIObjectWithResponse:@"T_C_response_w_URL"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/5316/termsAndConditions"];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [self.person termsAndConditionsOperation:^(JiveTermsAndConditions *termsAndConditions) {
            STAssertEquals([termsAndConditions class], [JiveTermsAndConditions class], @"Wrong item class");
            STAssertTrue(termsAndConditions.acceptanceRequired.boolValue, @"Acceptance should be required");
            STAssertNil(termsAndConditions.text, @"Unexpected text");
            STAssertNotNil(termsAndConditions.url, @"Missing URL");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertNotNil(operation, @"Missing operation");
        [operation start];
    }];
}

- (void) testGetTermsAndConditionsOperation_alreadyAccepted {
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    [self createJiveAPIObjectWithErrorCode:204
                   andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/5316/termsAndConditions"];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [self.person termsAndConditionsOperation:^(JiveTermsAndConditions *termsAndConditions) {
            STAssertEquals([termsAndConditions class], [JiveTermsAndConditions class], @"Wrong item class");
            STAssertFalse(termsAndConditions.acceptanceRequired.boolValue, @"Acceptance is not required");
            STAssertNil(termsAndConditions.text, @"Unexpected text");
            STAssertNil(termsAndConditions.url, @"Unexpected URL");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertNotNil(operation, @"Missing operation");
        [operation start];
    }];
}

- (void) testGetTermsAndConditions {
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    [self createJiveAPIObjectWithResponse:@"T_C_response"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/5316/termsAndConditions"];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [self.person termsAndConditions:^(JiveTermsAndConditions *termsAndConditions) {
            STAssertEquals([termsAndConditions class], [JiveTermsAndConditions class], @"Wrong item class");
            
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testGetTermsAndConditions_doesNotNeedToAccept {
    [self loadPerson:self.person fromJSONNamed:@"my_response"];
    [self createJiveAPIObject_ExpectingNoCalls];
    
    // Make the call
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [self.person termsAndConditions:^(JiveTermsAndConditions *termsAndConditions) {
            STAssertEquals([termsAndConditions class], [JiveTermsAndConditions class], @"Wrong item class");
            STAssertFalse(termsAndConditions.acceptanceRequired.boolValue, @"Acceptance is not required");
            STAssertNil(termsAndConditions.text, @"Unexpected text");
            STAssertNil(termsAndConditions.url, @"Unexpected URL");
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

- (void) testAcceptTermsAndConditionsOperation {
    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
    
    [self createJiveAPIObjectWithResponse:@"T_C_response"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/3550/acceptTermsAndConditions"];
    
    [self waitForTimeout:^(dispatch_block_t finishedBlock) {
        AFURLConnectionOperation *operation = [self.person acceptTermsAndConditionsOperation:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
        
        STAssertEqualObjects(JiveHTTPMethodTypes.POST, operation.request.HTTPMethod, @"Wrong http method used");
        [operation start];
    }];
}

- (void) testAcceptTermsAndConditions {
    [self loadPerson:self.person fromJSONNamed:@"person_response"];
    
    [self createJiveAPIObjectWithResponse:@"alt_person_response"
                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/5316/acceptTermsAndConditions"];
    
    [self waitForTimeout:^(void (^finishedBlock)(void)) {
        [self.person acceptTermsAndConditions:^() {
            // Check that delegates where actually called
            [mockAuthDelegate verify];
            [mockJiveURLResponseDelegate verify];
            finishedBlock();
        } onError:^(NSError *error) {
            STFail([error localizedDescription]);
            finishedBlock();
        }];
    }];
}

//- (void) testAvatarOperation {
//    [self loadPerson:self.person fromJSONNamed:@"alt_person_response"];
//
//    [self createJiveAPIObjectWithImageResponse:@"person_avatar"
//                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/3550/avatar"];
//    
//    [self waitForTimeout:^(void (^finishedBlock)(void)) {
//        NSOperation* operation = [self.person avatarOperationOnComplete:^(UIImage *avatarImage) {
//            UIImage *testImage = [UIImage imageNamed:@"avatar.png"];
//            STAssertEqualObjects(testImage, avatarImage, @"Wrong image returned");
//            // Check that delegates where actually called
//            [mockAuthDelegate verify];
//            [mockJiveURLResponseDelegate verify];
//        } onError:^(NSError *error) {
//            STFail([error localizedDescription]);
//        }];
//        
//        
//        STAssertNotNil(operation, @"Missing manager operation");
//        [operation start];
//    }];
//}

//- (void) testAvatarServiceCall {
//    [self loadPerson:self.person fromJSONNamed:@"person_response"];
//    
//    [self createJiveAPIObjectWithResponse:@"person_avatar"
//                  andAuthDelegateURLCheck:@"https://brewspace.jiveland.com/api/core/v3/people/5316/avatar"];
//    
//    [self waitForTimeout:^(void (^finishedBlock)(void)) {
//        [self.person avatarOnComplete:^(UIImage *avatarImage) {
//            UIImage *testImage = [UIImage imageNamed:@"avatar.png"];
//            STAssertEqualObjects(testImage, avatarImage, @"Wrong image returned");
//            // Check that delegates where actually called
//            [mockAuthDelegate verify];
//            [mockJiveURLResponseDelegate verify];
//            finishedBlock();
//        } onError:^(NSError *error) {
//            STFail([error localizedDescription]);
//        }];
//    }];
//}

@end
