//
//  JiveOpenSocialTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/26/12.
//  Copyright (c) 2012 Jive Software. All rights reserved.
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

@end
