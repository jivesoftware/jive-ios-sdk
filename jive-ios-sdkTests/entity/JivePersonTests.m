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

@implementation JivePersonTests

- (void)setUp {
    self.typedObject = [[JivePerson alloc] init];
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
    address.value = @"address";
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
    
    address1.value = @"Address 1";
    address2.value = @"Address 2";
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
    
    address.value = @"Address";
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
    
    JivePerson *newPerson = [JivePerson instanceFromJSON:JSON];
    
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
    
    address.value = @"house";
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
    
    JivePerson *newPerson = [JivePerson instanceFromJSON:JSON];
    
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

- (void)test_isEqualToJivePerson_nilPerson {
    JivePerson *jivePerson = [[JivePerson alloc] init];
    JivePerson *otherPerson = nil;
    
    STAssertFalse([jivePerson isEqualToJivePerson:otherPerson], @"Compared instance is nil");
}

- (void)test_isEqualToJivePerson_sameInstances {
    JivePerson *jivePerson = [[JivePerson alloc] init];
    
    STAssertTrue([jivePerson isEqualToJivePerson:jivePerson], @"Instances are the same");
}

- (void)test_isEqualToJivePerson_sameJiveIds {
    NSString *jiveId = @"TEST_ID";
    JivePerson *jivePerson = [[JivePerson alloc] init];
    JivePerson *otherPerson = [[JivePerson alloc] init];
    
    [jivePerson setValue:jiveId forKey:JivePersonAttributes.jiveId];
    [otherPerson setValue:jiveId forKey:JivePersonAttributes.jiveId];
    
    STAssertTrue([jivePerson isEqualToJivePerson:otherPerson], @"Instances have matching jiveIds");
}

- (void)test_isEqualToJivePerson_differentJiveIds {
    NSString *jiveId = @"TEST_ID";
    JivePerson *jivePerson = [[JivePerson alloc] init];
    JivePerson *otherPerson = [[JivePerson alloc] init];
    
    [jivePerson setValue:jiveId forKey:JivePersonAttributes.jiveId];
    [otherPerson setValue:[jiveId stringByAppendingString:jiveId] forKey:JivePersonAttributes.jiveId];
    
    STAssertFalse([jivePerson isEqualToJivePerson:otherPerson], @"Instances have different jiveIds");
}

- (void)test_hash {
    NSString *jiveId = @"TEST_ID";
    JivePerson *jivePerson = [[JivePerson alloc] init];
    JivePerson *otherPerson = [[JivePerson alloc] init];
    
    [jivePerson setValue:jiveId forKey:JivePersonAttributes.jiveId];
    [otherPerson setValue:jiveId forKey:JivePersonAttributes.jiveId];
    
    STAssertTrue([jivePerson isEqualToJivePerson:otherPerson], @"Instances have matching jiveIds");
    STAssertEquals([jivePerson hash], [otherPerson hash], @"Instances are equal and should have matching hash values");
}

@end
