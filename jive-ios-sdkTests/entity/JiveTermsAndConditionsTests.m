//
//  JiveTermsAndConditionsTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 12/20/13.
//  Copyright (c) 2013 Jive Software. All rights reserved.
//

#import "JiveTermsAndConditionsTests.h"
#import "JiveTermsAndConditions.h"

@implementation JiveTermsAndConditionsTests

- (void)setUp {
    [super setUp];
    self.object = [JiveTermsAndConditions new];
}

- (JiveTermsAndConditions *)termsAndConditions {
    return (JiveTermsAndConditions *)self.object;
}

- (void)testPersistentJSON {
    [self.termsAndConditions setValue:@YES forKey:JiveTermsAndConditionsAttributes.acceptanceRequired];
    [self.termsAndConditions setValue:@"html goes here" forKey:JiveTermsAndConditionsAttributes.text];
    
    NSDictionary *JSON = [self.termsAndConditions persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals(JSON.count, (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JiveTermsAndConditionsAttributes.acceptanceRequired],
                         self.termsAndConditions.acceptanceRequired, @"Wrong acceptanceRequired.");
    STAssertEqualObjects(JSON[JiveTermsAndConditionsAttributes.text], self.termsAndConditions.text,
                         @"Wrong text.");
}

- (void)testPersistentJSON_alternate {
    [self.termsAndConditions setValue:@NO forKey:JiveTermsAndConditionsAttributes.acceptanceRequired];
    [self.termsAndConditions setValue:[NSURL URLWithString:@"http://dummy.com"]
                               forKey:JiveTermsAndConditionsAttributes.url];
    
    NSDictionary *JSON = [self.termsAndConditions persistentJSON];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals(JSON.count, (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JiveTermsAndConditionsAttributes.acceptanceRequired],
                         self.termsAndConditions.acceptanceRequired, @"Wrong acceptanceRequired.");
    STAssertEqualObjects(JSON[JiveTermsAndConditionsAttributes.url],
                         self.termsAndConditions.url.absoluteString, @"Wrong url.");
}

- (void)testJiveTermsAndConditionsParsing {
    [self.termsAndConditions setValue:@YES forKey:JiveTermsAndConditionsAttributes.acceptanceRequired];
    [self.termsAndConditions setValue:@"html goes here, really" forKey:JiveTermsAndConditionsAttributes.text];
    
    NSDictionary *JSON = [self.termsAndConditions persistentJSON];
    JiveTermsAndConditions *newTsAndCs = [JiveTermsAndConditions objectFromJSON:JSON
                                                                   withInstance:self.instance];
    
    STAssertEquals([newTsAndCs class], [JiveTermsAndConditions class], @"Wrong item class");
    STAssertEqualObjects(newTsAndCs.acceptanceRequired, self.termsAndConditions.acceptanceRequired,
                         @"Wrong acceptanceRequired");
    STAssertEqualObjects(newTsAndCs.text, self.termsAndConditions.text, @"Wrong text");
}

- (void)testJiveTermsAndConditionsParsingAlternate {
    [self.termsAndConditions setValue:@NO forKey:JiveTermsAndConditionsAttributes.acceptanceRequired];
    [self.termsAndConditions setValue:[NSURL URLWithString:@"http://situation.com"]
                               forKey:JiveTermsAndConditionsAttributes.url];
    
    NSDictionary *JSON = [self.termsAndConditions persistentJSON];
    JiveTermsAndConditions *newTsAndCs = [JiveTermsAndConditions objectFromJSON:JSON
                                                                   withInstance:self.instance];
    
    STAssertEquals([newTsAndCs class], [JiveTermsAndConditions class], @"Wrong item class");
    STAssertEqualObjects(newTsAndCs.acceptanceRequired, self.termsAndConditions.acceptanceRequired,
                         @"Wrong acceptanceRequired");
    STAssertEqualObjects(newTsAndCs.url, self.termsAndConditions.url, @"Wrong url");
}

@end
