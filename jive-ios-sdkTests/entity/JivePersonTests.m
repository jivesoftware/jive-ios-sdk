//
//  JivePersonTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/14/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
//

#import "JivePersonTests.h"
#import "JiveAddress.h"
#import "JivePersonJive.h"
#import "JiveName.h"
#import "JiveEmail.h"
#import "JivePhoneNumber.h"
#import "JiveResourceEntry.h"

@implementation JivePersonTests

- (void)testToJSON {
    JivePerson *person = [[JivePerson alloc] init];
    JiveAddress *address = [[JiveAddress alloc] init];
    JivePersonJive *personJive = [[JivePersonJive alloc] init];
    JiveName *name = [[JiveName alloc] init];
    NSString *tag = @"First";
    JiveEmail *email = [[JiveEmail alloc] init];
    JivePhoneNumber *phoneNumber = [[JivePhoneNumber alloc] init];
    NSString *photoURI = @"http://dummy.com/photo.png";
    id JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    personJive.username = @"Address 1";
    name.familyName = @"family name";
    person.displayName = @"testName";
    person.jiveId = @"1234";
    person.location = @"USA";
    person.status = @"Status update";
    person.thumbnailUrl = @"http://dummy.com/thumbnail.png";
    person.type = @"person";
    [person setValue:[NSNumber numberWithInt:4] forKey:@"followerCount"];
    [person setValue:[NSNumber numberWithInt:6] forKey:@"followingCount"];
    [person setValue:name forKey:@"name"];
    [person setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"published"];
    [person setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"updated"];
    [person setValue:[NSArray arrayWithObject:address] forKey:@"addresses"];
    [person setValue:personJive forKey:@"jive"];
    [person setValue:[NSArray arrayWithObject:tag] forKey:@"tags"];
    [person setValue:[NSArray arrayWithObject:email] forKey:@"emails"];
    [person setValue:[NSArray arrayWithObject:phoneNumber] forKey:@"phoneNumbers"];
    [person setValue:[NSArray arrayWithObject:photoURI] forKey:@"photos"];

//    person.resources;
    
    JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)17, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"displayName"], person.displayName, @"Wrong display name.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"id"], person.jiveId, @"Wrong id.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"location"], person.location, @"Wrong location");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"status"], person.status, @"Wrong status update");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"thumbnailUrl"], person.thumbnailUrl, @"Wrong thumbnail url");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"type"], person.type, @"Wrong type");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"followerCount"], person.followerCount, @"Wrong followerCount.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"followingCount"], person.followingCount, @"Wrong followingCount");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"published"], @"1970-01-01T00:00:00.000+0000", @"Wrong published date");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"updated"], @"1970-01-01T00:16:40.123+0000", @"Wrong updated date");
    
    id nameJSON = [(NSDictionary *)JSON objectForKey:@"name"];
    
    STAssertTrue([[nameJSON class] isSubclassOfClass:[NSDictionary class]], @"Name not converted");
    STAssertEquals([(NSDictionary *)nameJSON count], (NSUInteger)1, @"Name dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)nameJSON objectForKey:@"familyName"], name.familyName, @"Wrong family name");
    
    NSArray *addressJSON = [(NSDictionary *)JSON objectForKey:@"addresses"];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Address array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[[addressJSON objectAtIndex:0] class] isSubclassOfClass:[NSDictionary class]], @"Address object not converted");
    
    NSArray *jiveJSON = [(NSDictionary *)JSON objectForKey:@"jive"];
    
    STAssertTrue([[jiveJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([(NSDictionary *)jiveJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([(NSDictionary *)jiveJSON objectForKey:@"username"], personJive.username, @"Wrong user name");
    
    NSArray *tagsJSON = [(NSDictionary *)JSON objectForKey:@"tags"];
    
    STAssertTrue([[tagsJSON class] isSubclassOfClass:[NSArray class]], @"Tags array not converted");
    STAssertEquals([tagsJSON count], (NSUInteger)1, @"Wrong number of elements in the tags array");
    STAssertEqualObjects([tagsJSON objectAtIndex:0], tag, @"Tag object not converted");
    
    NSArray *emailsJSON = [(NSDictionary *)JSON objectForKey:@"emails"];
    
    STAssertTrue([[emailsJSON class] isSubclassOfClass:[NSArray class]], @"Emails array not converted");
    STAssertEquals([emailsJSON count], (NSUInteger)1, @"Wrong number of elements in the emails array");
    STAssertTrue([[[emailsJSON objectAtIndex:0] class] isSubclassOfClass:[NSDictionary class]], @"Emails object not converted");
    
    NSArray *phoneNumbersJSON = [(NSDictionary *)JSON objectForKey:@"phoneNumbers"];
    
    STAssertTrue([[phoneNumbersJSON class] isSubclassOfClass:[NSArray class]], @"Phone numbers array not converted");
    STAssertEquals([phoneNumbersJSON count], (NSUInteger)1, @"Wrong number of elements in the phone numbers array");
    STAssertTrue([[[phoneNumbersJSON objectAtIndex:0] class] isSubclassOfClass:[NSDictionary class]], @"Phone numbers object not converted");
    
    NSArray *photosJSON = [(NSDictionary *)JSON objectForKey:@"photos"];
    
    STAssertTrue([[photosJSON class] isSubclassOfClass:[NSArray class]], @"Photos array not converted");
    STAssertEquals([photosJSON count], (NSUInteger)1, @"Wrong number of elements in the photos array");
    STAssertEqualObjects([photosJSON objectAtIndex:0], photoURI, @"Photos object not converted");
}

- (void)testToJSON_alternate {
    JivePerson *person = [[JivePerson alloc] init];
    id JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    person.displayName = @"Alternate";
    person.jiveId = @"87654";
    person.location = @"Foxtrot";
    person.status = @"Working for the man";
    person.thumbnailUrl = @"http://dummy.com/bland.jpg";
    [person setValue:[NSNumber numberWithInt:6] forKey:@"followerCount"];
    [person setValue:[NSNumber numberWithInt:4] forKey:@"followingCount"];
    [person setValue:[NSDate dateWithTimeIntervalSince1970:1000.123] forKey:@"published"];
    [person setValue:[NSDate dateWithTimeIntervalSince1970:0] forKey:@"updated"];
    
    JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)9, @"Initial dictionary is not empty");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"displayName"], person.displayName, @"Wrong display name.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"id"], person.jiveId, @"Wrong id.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"location"], person.location, @"Wrong location");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"status"], person.status, @"Wrong status update");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"thumbnailUrl"], person.thumbnailUrl, @"Wrong thumbnail url");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"followerCount"], person.followerCount, @"Wrong followerCount.");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"followingCount"], person.followingCount, @"Wrong followingCount");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"published"], @"1970-01-01T00:16:40.123+0000", @"Wrong published date");
    STAssertEqualObjects([(NSDictionary *)JSON objectForKey:@"updated"], @"1970-01-01T00:00:00.000+0000", @"Wrong updated date");
}

- (void)testToJSON_address {
    JivePerson *person = [[JivePerson alloc] init];
    JiveAddress *address1 = [[JiveAddress alloc] init];
    JiveAddress *address2 = [[JiveAddress alloc] init];
    id JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    address1.value = @"Address 1";
    address2.value = @"Address 2";
    [person setValue:[NSArray arrayWithObject:address1] forKey:@"addresses"];
    
    //    person.resources;
    
    JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    NSArray *addressJSON = [(NSDictionary *)JSON objectForKey:@"addresses"];
    id object1 = [addressJSON objectAtIndex:0];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Address array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"Address object not converted");
    STAssertEqualObjects([(NSDictionary *)object1 objectForKey:@"value"], address1.value, @"Wrong address label");

    [person setValue:[person.addresses arrayByAddingObject:address2] forKey:@"addresses"];
    
    JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    addressJSON = [(NSDictionary *)JSON objectForKey:@"addresses"];
    object1 = [addressJSON objectAtIndex:0];
    
    id object2 = [addressJSON objectAtIndex:1];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Address array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)2, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"Address 1 object not converted");
    STAssertEqualObjects([(NSDictionary *)object1 objectForKey:@"value"], address1.value, @"Wrong address 1 label");
    STAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"Address 2 object not converted");
    STAssertEqualObjects([(NSDictionary *)object2 objectForKey:@"value"], address2.value, @"Wrong address 2 label");
}

- (void)testToJSON_email {
    JivePerson *person = [[JivePerson alloc] init];
    JiveEmail *email1 = [[JiveEmail alloc] init];
    JiveEmail *email2 = [[JiveEmail alloc] init];
    id JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    email1.value = @"Address 1";
    email2.value = @"Address 2";
    [person setValue:[NSArray arrayWithObject:email1] forKey:@"emails"];
    
    //    person.resources;
    
    JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    NSArray *addressJSON = [(NSDictionary *)JSON objectForKey:@"emails"];
    id object1 = [addressJSON objectAtIndex:0];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Email array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the email array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"Email object not converted");
    STAssertEqualObjects([(NSDictionary *)object1 objectForKey:@"value"], email1.value, @"Wrong email label");
    
    [person setValue:[person.emails arrayByAddingObject:email2] forKey:@"emails"];
    
    JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    addressJSON = [(NSDictionary *)JSON objectForKey:@"emails"];
    object1 = [addressJSON objectAtIndex:0];
    
    id object2 = [addressJSON objectAtIndex:1];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Email array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)2, @"Wrong number of elements in the email array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"Email 1 object not converted");
    STAssertEqualObjects([(NSDictionary *)object1 objectForKey:@"value"], email1.value, @"Wrong email 1 label");
    STAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"Email 2 object not converted");
    STAssertEqualObjects([(NSDictionary *)object2 objectForKey:@"value"], email2.value, @"Wrong email 2 label");
}

- (void)testToJSON_phoneNumbers {
    JivePerson *person = [[JivePerson alloc] init];
    JivePhoneNumber *phoneNumber1 = [[JivePhoneNumber alloc] init];
    JivePhoneNumber *phoneNumber2 = [[JivePhoneNumber alloc] init];
    id JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    phoneNumber1.value = @"Address 1";
    phoneNumber2.value = @"Address 2";
    [person setValue:[NSArray arrayWithObject:phoneNumber1] forKey:@"phoneNumbers"];
    
    //    person.resources;
    
    JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    NSArray *addressJSON = [(NSDictionary *)JSON objectForKey:@"phoneNumbers"];
    id object1 = [addressJSON objectAtIndex:0];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Phone number array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the phone number array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"Phone number object not converted");
    STAssertEqualObjects([(NSDictionary *)object1 objectForKey:@"value"], phoneNumber1.value, @"Wrong phone number label");
    
    [person setValue:[person.phoneNumbers arrayByAddingObject:phoneNumber2] forKey:@"phoneNumbers"];
    
    JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    addressJSON = [(NSDictionary *)JSON objectForKey:@"phoneNumbers"];
    object1 = [addressJSON objectAtIndex:0];
    
    id object2 = [addressJSON objectAtIndex:1];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Phone number array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)2, @"Wrong number of elements in the phone number array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"Phone number 1 object not converted");
    STAssertEqualObjects([(NSDictionary *)object1 objectForKey:@"value"], phoneNumber1.value, @"Wrong phone number 1 label");
    STAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"Phone number 2 object not converted");
    STAssertEqualObjects([(NSDictionary *)object2 objectForKey:@"value"], phoneNumber2.value, @"Wrong phone number 2 label");
}

- (void)testToJSON_tags {
    JivePerson *person = [[JivePerson alloc] init];
    NSString *tag1 = @"First";
    NSString *tag2 = @"Last";
    id JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [person setValue:[NSArray arrayWithObject:tag1] forKey:@"tags"];
    
    //    person.resources;
    
    JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    NSArray *addressJSON = [(NSDictionary *)JSON objectForKey:@"tags"];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Tags array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the tags array");
    STAssertEqualObjects([addressJSON objectAtIndex:0], tag1, @"Wrong tag value");
    
    [person setValue:[person.tags arrayByAddingObject:tag2] forKey:@"tags"];
    
    JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    addressJSON = [(NSDictionary *)JSON objectForKey:@"tags"];
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Tags array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)2, @"Wrong number of elements in the tags array");
    STAssertEqualObjects([addressJSON objectAtIndex:0], tag1, @"Wrong tag 1 value");
    STAssertEqualObjects([addressJSON objectAtIndex:1], tag2, @"Wrong tag 2 value");
}

- (void)testToJSON_photos {
    JivePerson *person = [[JivePerson alloc] init];
    NSString *photo1 = @"First";
    NSString *photo2 = @"Last";
    id JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [person setValue:[NSArray arrayWithObject:photo1] forKey:@"photos"];
    
    //    person.resources;
    
    JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    NSArray *addressJSON = [(NSDictionary *)JSON objectForKey:@"photos"];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Photos array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the photos array");
    STAssertEqualObjects([addressJSON objectAtIndex:0], photo1, @"Wrong photo url");
    
    [person setValue:[person.photos arrayByAddingObject:photo2] forKey:@"photos"];
    
    JSON = [person toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    addressJSON = [(NSDictionary *)JSON objectForKey:@"photos"];
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"Photos array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)2, @"Wrong number of elements in the photos array");
    STAssertEqualObjects([addressJSON objectAtIndex:0], photo1, @"Wrong photo 1 url");
    STAssertEqualObjects([addressJSON objectAtIndex:1], photo2, @"Wrong photo 2 url");
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
    
    address.value = @"Address";
    personJive.username = @"Address 1";
    name.familyName = @"family name";
    phoneNumber.value = @"555-5555";
    email.value = @"email";
    [resource setValue:[NSURL URLWithString:photoURI] forKey:@"ref"];
    basePerson.displayName = @"testName";
    basePerson.jiveId = @"1234";
    basePerson.location = @"USA";
    basePerson.status = @"Status update";
    basePerson.thumbnailUrl = @"http://dummy.com/thumbnail.png";
    basePerson.type = @"person";
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
    
    id JSON = [basePerson toJSONDictionary];
    
    [(NSMutableDictionary *)JSON setValue:resourcesJSON forKey:@"resources"];
    
    JivePerson *person = [JivePerson instanceFromJSON:JSON];
    
    STAssertEquals([person class], [JivePerson class], @"Wrong item class");
    STAssertEqualObjects(person.displayName, basePerson.displayName, @"Wrong display name");
    STAssertEqualObjects(person.followerCount, basePerson.followerCount, @"Wrong follower count");
    STAssertEqualObjects(person.followingCount, basePerson.followingCount, @"Wrong following count");
    STAssertEqualObjects(person.jiveId, basePerson.jiveId, @"Wrong id");
    STAssertEqualObjects(person.jive.username, basePerson.jive.username, @"Wrong Jive Person");
    STAssertEqualObjects(person.location, basePerson.location, @"Wrong location");
    STAssertEqualObjects(person.name.familyName, basePerson.name.familyName, @"Wrong name");
    STAssertEqualObjects(person.published, basePerson.published, @"Wrong published date");
    STAssertEqualObjects(person.status, basePerson.status, @"Wrong status");
    STAssertEqualObjects(person.thumbnailUrl, basePerson.thumbnailUrl, @"Wrong thumbnailUrl");
    STAssertEqualObjects(person.type, basePerson.type, @"Wrong type");
    STAssertEqualObjects(person.updated, basePerson.updated, @"Wrong updated date");
    STAssertEquals([person.addresses count], [basePerson.addresses count], @"Wrong number of address objects");
    STAssertEqualObjects([(JiveAddress *)[person.addresses objectAtIndex:0] value],
                         [(JiveAddress *)[basePerson.addresses objectAtIndex:0] value],
                         @"Wrong Address object class");
    STAssertEquals([person.emails count], [basePerson.emails count], @"Wrong number of email objects");
    STAssertEqualObjects([(JiveEmail *)[person.emails objectAtIndex:0] value],
                         [(JiveEmail *)[basePerson.emails objectAtIndex:0] value],
                         @"Wrong email object class");
    STAssertEquals([person.phoneNumbers count], [basePerson.phoneNumbers count], @"Wrong number of phone number objects");
    STAssertEqualObjects([(JivePhoneNumber *)[person.phoneNumbers objectAtIndex:0] value],
                         [(JivePhoneNumber *)[basePerson.phoneNumbers objectAtIndex:0] value],
                         @"Wrong phone number object class");
    STAssertEquals([person.photos count], [basePerson.photos count], @"Wrong number of photo objects");
    STAssertEqualObjects([person.photos objectAtIndex:0], [basePerson.photos objectAtIndex:0], @"Wrong photo object class");
    STAssertEquals([person.tags count], [basePerson.tags count], @"Wrong number of tag objects");
    STAssertEqualObjects([person.tags objectAtIndex:0], [basePerson.tags objectAtIndex:0], @"Wrong tag object class");
    STAssertEquals([person.resources count], [basePerson.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[person.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
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
    
    address.value = @"house";
    personJive.username = @"name";
    name.familyName = @"Bushnell";
    phoneNumber.value = @"777-7777";
    email.value = @"something.com";
    [resource setValue:[NSURL URLWithString:photoURI] forKey:@"ref"];
    basePerson.displayName = @"display name";
    basePerson.jiveId = @"87654";
    basePerson.location = @"New Mexico";
    basePerson.status = @"No status";
    basePerson.thumbnailUrl = @"http://com.dummy/png.thumbnail";
    basePerson.type = @"walaby";
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
    
    id JSON = [basePerson toJSONDictionary];
    
    [(NSMutableDictionary *)JSON setValue:resourcesJSON forKey:@"resources"];
    
    JivePerson *person = [JivePerson instanceFromJSON:JSON];
    
    STAssertEquals([person class], [JivePerson class], @"Wrong item class");
    STAssertEqualObjects(person.displayName, basePerson.displayName, @"Wrong display name");
    STAssertEqualObjects(person.followerCount, basePerson.followerCount, @"Wrong follower count");
    STAssertEqualObjects(person.followingCount, basePerson.followingCount, @"Wrong following count");
    STAssertEqualObjects(person.jiveId, basePerson.jiveId, @"Wrong id");
    STAssertEqualObjects(person.jive.username, basePerson.jive.username, @"Wrong Jive Person");
    STAssertEqualObjects(person.location, basePerson.location, @"Wrong location");
    STAssertEqualObjects(person.name.familyName, basePerson.name.familyName, @"Wrong name");
    STAssertEqualObjects(person.published, basePerson.published, @"Wrong published date");
    STAssertEqualObjects(person.status, basePerson.status, @"Wrong status");
    STAssertEqualObjects(person.thumbnailUrl, basePerson.thumbnailUrl, @"Wrong thumbnailUrl");
    STAssertEqualObjects(person.type, basePerson.type, @"Wrong type");
    STAssertEqualObjects(person.updated, basePerson.updated, @"Wrong updated date");
    STAssertEquals([person.addresses count], [basePerson.addresses count], @"Wrong number of address objects");
    STAssertEqualObjects([(JiveAddress *)[person.addresses objectAtIndex:0] value],
                         [(JiveAddress *)[basePerson.addresses objectAtIndex:0] value],
                         @"Wrong Address object class");
    STAssertEquals([person.emails count], [basePerson.emails count], @"Wrong number of email objects");
    STAssertEqualObjects([(JiveEmail *)[person.emails objectAtIndex:0] value],
                         [(JiveEmail *)[basePerson.emails objectAtIndex:0] value],
                         @"Wrong email object class");
    STAssertEquals([person.phoneNumbers count], [basePerson.phoneNumbers count], @"Wrong number of phone number objects");
    STAssertEqualObjects([(JivePhoneNumber *)[person.phoneNumbers objectAtIndex:0] value],
                         [(JivePhoneNumber *)[basePerson.phoneNumbers objectAtIndex:0] value],
                         @"Wrong phone number object class");
    STAssertEquals([person.photos count], [basePerson.photos count], @"Wrong number of photo objects");
    STAssertEqualObjects([person.photos objectAtIndex:0], [basePerson.photos objectAtIndex:0], @"Wrong photo object class");
    STAssertEquals([person.tags count], [basePerson.tags count], @"Wrong number of tag objects");
    STAssertEqualObjects([person.tags objectAtIndex:0], [basePerson.tags objectAtIndex:0], @"Wrong tag object class");
    STAssertEquals([person.resources count], [basePerson.resources count], @"Wrong number of resource objects");
    STAssertEqualObjects([(JiveResourceEntry *)[person.resources objectForKey:resourceKey] ref], resource.ref, @"Wrong resource object");
}

@end
