//
//  JiveOpenSocialTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/26/12.
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

#import "JiveOpenSocialTests.h"
#import "JiveOpenSocial.h"
#import "JiveEmbedded.h"
#import "JiveActionLink.h"

@implementation JiveOpenSocialTests

- (void)testToJSON {
    JiveOpenSocial *openSocial = [[JiveOpenSocial alloc] init];
    JiveEmbedded *embed = [[JiveEmbedded alloc] init];
    JiveActionLink *actionLink = [[JiveActionLink alloc] init];
    NSString *deliverTo = @"/person/1234";
    NSDictionary *JSON = [openSocial toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    actionLink.httpVerb = @"GET";
    [embed setValue:[NSURL URLWithString:@"http://embed.com"] forKey:@"url"];
    [openSocial setValue:[NSArray arrayWithObject:actionLink] forKey:@"actionLinks"];
    [openSocial setValue:[NSArray arrayWithObject:deliverTo] forKey:@"deliverTo"];
    [openSocial setValue:embed forKey:@"embed"];
    
    JSON = [openSocial toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"deliverTo"], openSocial.deliverTo, @"Wrong deliverTo.");
    
    NSDictionary *embedJSON = [JSON objectForKey:@"embed"];
    
    STAssertTrue([[embedJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([embedJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([embedJSON objectForKey:@"url"], [embed.url absoluteString], @"Wrong value");
    
    NSArray *deliverToJSON = [(NSDictionary *)JSON objectForKey:@"deliverTo"];
    
    STAssertTrue([[deliverToJSON class] isSubclassOfClass:[NSArray class]], @"deliverTo array not converted");
    STAssertEquals([deliverToJSON count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[[deliverToJSON objectAtIndex:0] class] isSubclassOfClass:[NSString class]], @"deliverTo object not converted");
    STAssertEqualObjects([deliverToJSON objectAtIndex:0], deliverTo, @"Wrong value");
    
    NSArray *addressJSON = [(NSDictionary *)JSON objectForKey:@"actionLinks"];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"actionLink array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[[addressJSON objectAtIndex:0] class] isSubclassOfClass:[NSDictionary class]], @"actionLink object not converted");
}

- (void)testToJSON_alternate {
    JiveOpenSocial *openSocial = [[JiveOpenSocial alloc] init];
    JiveEmbedded *embed = [[JiveEmbedded alloc] init];
    JiveActionLink *actionLink = [[JiveActionLink alloc] init];
    NSString *deliverTo = @"/person/5432";
    NSDictionary *JSON = [openSocial toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    actionLink.httpVerb = @"PUT";
    [embed setValue:[NSURL URLWithString:@"http://super.com"] forKey:@"url"];
    [openSocial setValue:[NSArray arrayWithObject:actionLink] forKey:@"actionLinks"];
    [openSocial setValue:[NSArray arrayWithObject:deliverTo] forKey:@"deliverTo"];
    [openSocial setValue:embed forKey:@"embed"];
    
    JSON = [openSocial toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)3, @"Initial dictionary had the wrong number of entries");
    STAssertEqualObjects([JSON objectForKey:@"deliverTo"], openSocial.deliverTo, @"Wrong deliverTo.");
    
    NSDictionary *embedJSON = [JSON objectForKey:@"embed"];
    
    STAssertTrue([[embedJSON class] isSubclassOfClass:[NSDictionary class]], @"Jive not converted");
    STAssertEquals([embedJSON count], (NSUInteger)1, @"Jive dictionary had the wrong number of entries");
    STAssertEqualObjects([embedJSON objectForKey:@"url"], [embed.url absoluteString], @"Wrong value");
    
    NSArray *deliverToJSON = [(NSDictionary *)JSON objectForKey:@"deliverTo"];
    
    STAssertTrue([[deliverToJSON class] isSubclassOfClass:[NSArray class]], @"deliverTo array not converted");
    STAssertEquals([deliverToJSON count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[[deliverToJSON objectAtIndex:0] class] isSubclassOfClass:[NSString class]], @"deliverTo object not converted");
    STAssertEqualObjects([deliverToJSON objectAtIndex:0], deliverTo, @"Wrong value");
    
    NSArray *addressJSON = [(NSDictionary *)JSON objectForKey:@"actionLinks"];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"actionLink array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[[addressJSON objectAtIndex:0] class] isSubclassOfClass:[NSDictionary class]], @"actionLink object not converted");
}

- (void)testToJSON_actionLinks {
    JiveOpenSocial *openSocial = [[JiveOpenSocial alloc] init];
    JiveActionLink *actionLink1 = [[JiveActionLink alloc] init];
    JiveActionLink *actionLink2 = [[JiveActionLink alloc] init];
    id JSON = [openSocial toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    actionLink1.httpVerb = @"GET";
    actionLink2.httpVerb = @"PUT";
    [openSocial setValue:[NSArray arrayWithObject:actionLink1] forKey:@"actionLinks"];
    
    JSON = [openSocial toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    NSArray *addressJSON = [(NSDictionary *)JSON objectForKey:@"actionLinks"];
    id object1 = [addressJSON objectAtIndex:0];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"actionLink array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)1, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"actionLink object not converted");
    STAssertEqualObjects([(NSDictionary *)object1 objectForKey:@"httpVerb"], actionLink1.httpVerb, @"Wrong http verb");
    
    [openSocial setValue:[openSocial.actionLinks arrayByAddingObject:actionLink2] forKey:@"actionLinks"];
    
    JSON = [openSocial toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([(NSDictionary *)JSON count], (NSUInteger)1, @"Initial dictionary is not empty");
    
    addressJSON = [(NSDictionary *)JSON objectForKey:@"actionLinks"];
    object1 = [addressJSON objectAtIndex:0];
    
    id object2 = [addressJSON objectAtIndex:1];
    
    STAssertTrue([[addressJSON class] isSubclassOfClass:[NSArray class]], @"actionLink array not converted");
    STAssertEquals([addressJSON count], (NSUInteger)2, @"Wrong number of elements in the address array");
    STAssertTrue([[object1 class] isSubclassOfClass:[NSDictionary class]], @"actionLink 1 object not converted");
    STAssertEqualObjects([(NSDictionary *)object1 objectForKey:@"httpVerb"], actionLink1.httpVerb, @"Wrong http verb 1");
    STAssertTrue([[object2 class] isSubclassOfClass:[NSDictionary class]], @"actionLink 2 object not converted");
    STAssertEqualObjects([(NSDictionary *)object2 objectForKey:@"httpVerb"], actionLink2.httpVerb, @"Wrong http verb 2");
}

- (void)testOpenSocialParsing {
    JiveOpenSocial *baseOpenSocial = [[JiveOpenSocial alloc] init];
    JiveEmbedded *embed = [[JiveEmbedded alloc] init];
    JiveActionLink *actionLink = [[JiveActionLink alloc] init];
    NSString *deliverTo = @"/person/1234";
    
    actionLink.httpVerb = @"GET";
    [embed setValue:[NSURL URLWithString:@"http://embed.com"] forKey:@"url"];
    [baseOpenSocial setValue:[NSArray arrayWithObject:actionLink] forKey:@"actionLinks"];
    [baseOpenSocial setValue:[NSArray arrayWithObject:deliverTo] forKey:@"deliverTo"];
    [baseOpenSocial setValue:embed forKey:@"embed"];
    
    id JSON = [baseOpenSocial toJSONDictionary];
    JiveOpenSocial *openSocial = [JiveOpenSocial instanceFromJSON:JSON];
    
    STAssertEquals([openSocial class], [JiveOpenSocial class], @"Wrong item class");
    STAssertEqualObjects(openSocial.embed.url, baseOpenSocial.embed.url, @"Wrong embed");
    STAssertEquals([openSocial.actionLinks count], [baseOpenSocial.actionLinks count], @"Wrong number of actionLink objects");
    if ([openSocial.actionLinks count] > 0) {
        id convertedAddress = [openSocial.actionLinks objectAtIndex:0];
        STAssertEquals([convertedAddress class], [JiveActionLink class], @"Wrong address object class");
        if ([[convertedAddress class] isSubclassOfClass:[JiveActionLink class]])
            STAssertEqualObjects([(JiveActionLink *)convertedAddress httpVerb], actionLink.httpVerb, @"Wrong actionLink object");
    }
    STAssertEquals([openSocial.deliverTo count], [baseOpenSocial.deliverTo count], @"Wrong number of deliverTo objects");
    if ([openSocial.deliverTo count] > 0) {
        STAssertEqualObjects((NSString *)[openSocial.deliverTo objectAtIndex:0], deliverTo, @"Wrong deliverTo object");
    }
}

- (void)testOpenSocialParsingAlternate {
    JiveOpenSocial *baseOpenSocial = [[JiveOpenSocial alloc] init];
    JiveEmbedded *embed = [[JiveEmbedded alloc] init];
    JiveActionLink *actionLink = [[JiveActionLink alloc] init];
    NSString *deliverTo = @"/person/5432";
    
    actionLink.httpVerb = @"PUT";
    [embed setValue:[NSURL URLWithString:@"http://super.com"] forKey:@"url"];
    [baseOpenSocial setValue:[NSArray arrayWithObject:actionLink] forKey:@"actionLinks"];
    [baseOpenSocial setValue:[NSArray arrayWithObject:deliverTo] forKey:@"deliverTo"];
    [baseOpenSocial setValue:embed forKey:@"embed"];
    
    id JSON = [baseOpenSocial toJSONDictionary];
    JiveOpenSocial *openSocial = [JiveOpenSocial instanceFromJSON:JSON];
    
    STAssertEquals([openSocial class], [JiveOpenSocial class], @"Wrong item class");
    STAssertEqualObjects(openSocial.embed.url, baseOpenSocial.embed.url, @"Wrong embed");
    STAssertEquals([openSocial.actionLinks count], [baseOpenSocial.actionLinks count], @"Wrong number of actionLink objects");
    if ([openSocial.actionLinks count] > 0) {
        id convertedAddress = [openSocial.actionLinks objectAtIndex:0];
        STAssertEquals([convertedAddress class], [JiveActionLink class], @"Wrong address object class");
        if ([[convertedAddress class] isSubclassOfClass:[JiveActionLink class]])
            STAssertEqualObjects([(JiveActionLink *)convertedAddress httpVerb], actionLink.httpVerb, @"Wrong actionLink object");
    }
    STAssertEquals([openSocial.deliverTo count], [baseOpenSocial.deliverTo count], @"Wrong number of deliverTo objects");
    if ([openSocial.deliverTo count] > 0) {
        STAssertEqualObjects((NSString *)[openSocial.deliverTo objectAtIndex:0], deliverTo, @"Wrong deliverTo object");
    }
}

@end
