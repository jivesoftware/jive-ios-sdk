//
//  JivePersonTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePersonTests.h"

@implementation JivePersonTests

- (void)testToJSON {
    JivePerson *person = [[JivePerson alloc] init];
    id JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    person.displayName = @"testName";
    person.jiveId = @"1234";
    
    JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEquals([(NSDictionary *)JSON objectForKey:@"displayName"], person.displayName, @"Wrong display name.");
    STAssertEquals([(NSDictionary *)JSON objectForKey:@"id"], person.jiveId, @"Wrong id.");
}

//- (void)testPersonParsing {
//    mockAuthDelegate = [OCMockObject mockForProtocol:@protocol(JiveAuthorizationDelegate)];
//    [[[mockAuthDelegate expect] andReturn:[[JiveCredentials alloc] initWithUserName:@"bar"
//                                                                           password:@"foo"]] credentialsForJiveInstance:[OCMArg any]];
//    [self createJiveAPIObjectWithResponse:@"person_response"
//                          andAuthDelegate:mockAuthDelegate];
//    
//    // Make the call
//    [self waitForTimeout:^(void (^finishedBlock)(void)) {
//        [jive me:^(JivePerson *person) {
//            // Called 3rd
//            STAssertEquals([person class], [JivePerson class], @"Wrong item class");
//            STAssertEqualObjects(person.displayName, @"", @"Wrong display name");
//            STAssertEqualObjects(person.followerCount, @"", @"Wrong follower count");
//            STAssertEqualObjects(person.followingCount, @"", @"Wrong following count");
//            STAssertEqualObjects(person.jiveId, @"", @"Wrong id");
//            STAssertEqualObjects(person.jive, [[JivePersonJive alloc] init], @"Wrong Jive Person");
//            STAssertEqualObjects(person.location, @"", @"Wrong location");
//            STAssertEqualObjects(person.name, [[JiveName alloc] init], @"Wrong name");
//            STAssertEqualObjects(person.published, [NSDate date], @"Wrong published date");
//            STAssertEqualObjects(person.status, @"", @"Wrong status");
//            STAssertEqualObjects(person.thumbnailUrl, @"", @"Wrong thumbnailUrl");
//            STAssertEqualObjects(person.type, @"", @"Wrong type");
//            STAssertEqualObjects(person.updated, [NSDate date], @"Wrong updated date");
//            STAssertEquals([person.addresses count], 1000, @"Wrong number of address objects");
//            STAssertEquals([person.addresses objectAtIndex:0], [JiveAddress class], @"Wrong Address object class");
//            STAssertEquals([person.emails count], 1000, @"Wrong number of email objects");
//            STAssertEquals([person.emails objectAtIndex:0], [JivePhoneNumber class], @"Wrong email object class");
//            STAssertEquals([person.phoneNumbers count], 1000, @"Wrong number of phone number objects");
//            STAssertEquals([person.phoneNumbers objectAtIndex:0], [JiveAddress class], @"Wrong phone number object class");
//            STAssertEquals([person.photos count], 1000, @"Wrong number of photo objects");
//            STAssertEquals([person.photos objectAtIndex:0], [JiveAddress class], @"Wrong photo object class");
//            STAssertEquals([person.tags count], 1000, @"Wrong number of tag objects");
//            STAssertEquals([person.tags objectAtIndex:0], [NSString class], @"Wrong tag object class");
//            STAssertEquals([person.resources count], 1000, @"Wrong number of resource objects");
//            for (id object in person.resources) {
//                STAssertEquals([object class], [JiveResource class], @"Wrong resource object class");
//            }
//            
//            finishedBlock();
//        } onError:^(NSError *error) {
//            STFail([error localizedDescription]);
//        }];
//    }];
//}

@end
