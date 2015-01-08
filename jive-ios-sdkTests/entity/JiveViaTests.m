//
//  JiveViaTests.m
//  jive-ios-sdk
//
//  Created by Orson Bushnell on 5/16/14.
//  Copyright (c) 2014 Jive Software. All rights reserved.
//

#import "JiveObjectTests.h"
#import "JiveVia.h"


@interface JiveViaTests : JiveObjectTests

@property (nonatomic, readonly) JiveVia *via;

@end

@implementation JiveViaTests

- (JiveVia *)via {
    return (JiveVia *)self.object;
}

- (void)setUp
{
    [super setUp];
    self.object = [JiveVia new];
}

- (void)initializeVia {
    self.via.displayName = @"Frank";
    self.via.url = [NSURL URLWithString:@"http://google.com"];
}

- (void)initializeAlternateVia {
    self.via.displayName = @"Herbert";
    self.via.url = [NSURL URLWithString:@"help.php"
                          relativeToURL:[NSURL URLWithString:@"http://wakkawikki.org"]];
}

- (void)testViaToJSON {
    NSDictionary *JSON = [self.via toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self initializeVia];
    
    JSON = [self.via toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JiveViaAttributes.displayName], self.via.displayName, @"Wrong displayName");
    STAssertEqualObjects(JSON[JiveViaAttributes.url], [self.via.url absoluteString], @"Wrong url");
}

- (void)testViaToJSON_alternate {
    NSDictionary *JSON = [self.via toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)0, @"Initial dictionary is not empty");
    
    [self initializeAlternateVia];
    
    JSON = [self.via toJSONDictionary];
    
    STAssertTrue([[JSON class] isSubclassOfClass:[NSDictionary class]], @"Generated JSON has the wrong class");
    STAssertEquals([JSON count], (NSUInteger)2, @"Initial dictionary is not empty");
    STAssertEqualObjects(JSON[JiveViaAttributes.displayName], self.via.displayName, @"Wrong displayName");
    STAssertEqualObjects(JSON[JiveViaAttributes.url], [self.via.url absoluteString], @"Wrong url");
}

- (void)testViaParsing {
    [self initializeVia];
    
    id JSON = [self.via persistentJSON];
    JiveVia *newVia = [JiveVia objectFromJSON:JSON withInstance:self.instance];
    
    STAssertEqualObjects(newVia.displayName, self.via.displayName, @"Wrong displayName");
    STAssertEqualObjects([newVia.url absoluteString], [self.via.url absoluteString], @"Wrong url");
}

- (void)testViaParsing_alternate {
    [self initializeAlternateVia];
    
    id JSON = [self.via persistentJSON];
    JiveVia *newVia = [JiveVia objectFromJSON:JSON withInstance:self.instance];

    STAssertEqualObjects(newVia.displayName, self.via.displayName, @"Wrong displayName");
    STAssertEqualObjects([newVia.url absoluteString], [self.via.url absoluteString], @"Wrong url");
}

@end
